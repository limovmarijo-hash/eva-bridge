[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [switch]$Close
)

$ErrorActionPreference = 'Stop'

# Safety model:
# - Only visible Chrome top-level windows whose title contains "ChatGPT" are candidates.
# - The currently focused window must itself be a ChatGPT Chrome window.
# - The focused window is always preserved.
# - Without -Close, this script only previews the candidates.
# - Other Chrome windows and non-Chrome applications are never touched.

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
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int maxCount);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder className, int maxCount);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool PostMessage(IntPtr hWnd, uint message, IntPtr wParam, IntPtr lParam);

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

            result.Add(new WindowInfo {
                Handle = hWnd,
                ProcessId = pid,
                Title = title.ToString(),
                ClassName = className.ToString()
            });
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
$Foreground = [EvaWindowCleanup]::GetForegroundWindow()
$Active = $Windows |
  Where-Object { $_.Handle -eq $Foreground -and $_.Title -match 'ChatGPT' } |
  Select-Object -First 1

if (-not $Active) {
  throw 'Sigurnosni prekid: aktivni prozor nije prepoznat kao ChatGPT u Chromeu. Nijedan prozor nije zatvoren.'
}

$Candidates = @(
  $Windows | Where-Object {
    $_.Handle -ne $Active.Handle -and
    $_.ClassName -eq 'Chrome_WidgetWin_1' -and
    $_.Title -match 'ChatGPT'
  }
)

Write-Host "EVA_ACTIVE_WINDOW_PRESERVED handle=$($Active.Handle.ToInt64()) title='$($Active.Title)'"
Write-Host "EVA_OLD_CHATGPT_WINDOWS_FOUND=$($Candidates.Count)"

foreach ($Window in $Candidates) {
  Write-Host ("CANDIDATE handle={0} pid={1} title='{2}'" -f
    $Window.Handle.ToInt64(), $Window.ProcessId, $Window.Title)
}

if (-not $Close) {
  Write-Host 'EVA_CLEANUP_PREVIEW_ONLY'
  Write-Host 'Za stvarno zatvaranje pokreni: .\Close-Eva-OldChatGPTWindows.ps1 -Close'
  exit 0
}

$Closed = 0
$Failed = 0
foreach ($Window in $Candidates) {
  if ($PSCmdlet.ShouldProcess(
      ("Chrome ChatGPT window handle={0} title='{1}'" -f $Window.Handle.ToInt64(), $Window.Title),
      'Send graceful WM_CLOSE')) {
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
  Where-Object {
    $_.Handle -ne $Active.Handle -and
    $_.ClassName -eq 'Chrome_WidgetWin_1' -and
    $_.Title -match 'ChatGPT'
  })

Write-Host "EVA_CLOSE_MESSAGES_SENT=$Closed"
Write-Host "EVA_CLOSE_MESSAGES_FAILED=$Failed"
Write-Host "EVA_OLD_CHATGPT_WINDOWS_REMAINING=$($Remaining.Count)"
Write-Host 'Napomena: WM_CLOSE je zahtjev za uredno zatvaranje; Chrome može tražiti potvrdu ako neki prozor ima nespremljen sadržaj.'
