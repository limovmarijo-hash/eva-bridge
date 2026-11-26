[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [switch]$Close
)

$ErrorActionPreference = 'Stop'

# Keeps the topmost visible Chrome window whose title contains ChatGPT.
# Sends WM_CLOSE to every other visible Chrome browser window.
# Without -Close, this is preview-only.

if (-not ('EvaWindowCleanup' -as [type])) {
  Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

public static class EvaWindowCleanup {
    public class WindowInfo {
        public IntPtr Handle;
        public uint ProcessId;
        public string Title;
        public string ClassName;
    }

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc callback, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int maxCount);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder className, int maxCount);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool PostMessage(IntPtr hWnd, uint message, IntPtr wParam, IntPtr lParam);

    // EnumWindows returns top-level windows in Z order (topmost first).
    public static WindowInfo[] GetChromeWindows(uint[] processIds) {
        var allowed = new HashSet<uint>(processIds);
        var result = new List<WindowInfo>();

        EnumWindows(delegate(IntPtr hWnd, IntPtr lParam) {
            if (!IsWindowVisible(hWnd)) return true;

            uint pid;
            GetWindowThreadProcessId(hWnd, out pid);
            if (!allowed.Contains(pid)) return true;

            var title = new StringBuilder(1024);
            var className = new StringBuilder(256);
            GetWindowText(hWnd, title, title.Capacity);
            GetClassName(hWnd, className, className.Capacity);

            if (className.ToString() == "Chrome_WidgetWin_1") {
                result.Add(new WindowInfo {
                    Handle = hWnd,
                    ProcessId = pid,
                    Title = title.ToString(),
                    ClassName = className.ToString()
                });
            }
            return true;
        }, IntPtr.Zero);

        return result.ToArray();
    }
}
'@
}

$ChromePids = @(
  Get-Process -Name chrome -ErrorAction SilentlyContinue |
    ForEach-Object { [uint32]$_.Id }
)

if ($ChromePids.Count -eq 0) {
  Write-Host 'EVA_CLEANUP_NO_CHROME'
  exit 0
}

$Windows = @([EvaWindowCleanup]::GetChromeWindows($ChromePids))

# Preserve the topmost ChatGPT window. It is expected to be the EVA window
# left in front by Start-Eva.ps1. If none exists, abort without closing anything.
$EvaWindow = $Windows |
  Where-Object { $_.Title -match 'ChatGPT' } |
  Select-Object -First 1

if (-not $EvaWindow) {
  throw 'Sigurnosni prekid: nije pronađen nijedan Chrome prozor s naslovom ChatGPT. Nijedan prozor nije zatvoren.'
}

$Candidates = @($Windows | Where-Object {
  $_.Handle -ne $EvaWindow.Handle
})

Write-Host "EVA_WINDOW_PRESERVED handle=$($EvaWindow.Handle.ToInt64()) pid=$($EvaWindow.ProcessId) title='$($EvaWindow.Title)'"
Write-Host "OTHER_CHROME_WINDOWS_FOUND=$($Candidates.Count)"

foreach ($Window in $Candidates) {
  Write-Host ("CANDIDATE handle={0} pid={1} title='{2}'" -f
    $Window.Handle.ToInt64(), $Window.ProcessId, $Window.Title)
}

if (-not $Close) {
  Write-Host 'EVA_CLEANUP_PREVIEW_ONLY'
  Write-Host 'Pregledaj popis. Za zatvaranje pokreni: .\Close-Eva-OldChatGPTWindows.ps1 -Close'
  exit 0
}

$Closed = 0
$Failed = 0

foreach ($Window in $Candidates) {
  $Description = "Chrome window handle=$($Window.Handle.ToInt64()) title='$($Window.Title)'"
  if ($PSCmdlet.ShouldProcess($Description, 'Send graceful WM_CLOSE')) {
    $Sent = [EvaWindowCleanup]::PostMessage(
      $Window.Handle, [uint32]0x0010, [IntPtr]::Zero, [IntPtr]::Zero
    )
    if ($Sent) {
      $Closed++
    } else {
      $Failed++
      Write-Warning "WM_CLOSE nije poslan za handle $($Window.Handle.ToInt64())."
    }
  }
}

Start-Sleep -Seconds 2
$Remaining = @([EvaWindowCleanup]::GetChromeWindows($ChromePids) |
  Where-Object { $_.Handle -ne $EvaWindow.Handle })

Write-Host "EVA_CLOSE_MESSAGES_SENT=$Closed"
Write-Host "EVA_CLOSE_MESSAGES_FAILED=$Failed"
Write-Host "OTHER_CHROME_WINDOWS_REMAINING=$($Remaining.Count)"
Write-Host 'Napomena: WM_CLOSE je zahtjev za uredno zatvaranje; Chrome može tražiti potvrdu ako neki prozor ima nespremljen sadržaj.'
