[CmdletBinding()]
param(
  [string]$Root = "$env:USERPROFILE\EVA-Automation",
  [switch]$DryRun
)
$ErrorActionPreference = 'Stop'
$Helper = Join-Path $Root 'EVA-ExternalMemory.ps1'
$PromptFile = Join-Path $Root 'EVA-Activation-Prompt.txt'
$LogFile = Join-Path $Root 'EVA-Activation-Log.md'
$NewChatUrl = 'https://chatgpt.com/'

New-Item -ItemType Directory -Force -Path $Root | Out-Null
if (-not (Test-Path $Helper)) { throw "Nedostaje helper: $Helper" }

function Write-EvaLog([string]$Message) {
  $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  Add-Content -LiteralPath $LogFile -Encoding UTF8 -Value "- $stamp | $Message"
}

& $Helper -Action Prepare -Root $Root
if (-not (Test-Path $PromptFile)) { throw 'Aktivacijska poruka nije stvorena.' }
$Prompt = [System.IO.File]::ReadAllText($PromptFile, [System.Text.Encoding]::UTF8).Trim()
if ([string]::IsNullOrWhiteSpace($Prompt) -or $Prompt.Length -gt 30000) {
  throw 'Aktivacijska poruka je prazna ili prelazi sigurnu granicu od 30000 znakova.'
}

if ($DryRun) {
  Write-Host 'EVA_DRY_RUN_OK'
  Write-Host "Prompt characters: $($Prompt.Length)"
  Write-Host "Destination: $NewChatUrl"
  Write-Host 'No browser was opened and no message was sent.'
  exit 0
}

# We deliberately ignore EVA-ChatGPT-URL.txt: it points to the exhausted legacy chat.
Set-Clipboard -Value $Prompt

# Use Win32 top-level window handles rather than Chrome process IDs.
# Chrome can host multiple browser windows in the same process, so AppActivate(PID)
# is not sufficient to identify the exact window just created.
Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

public static class EvaWin32 {
    public class WindowInfo {
        public IntPtr Handle;
        public uint ProcessId;
        public string Title;
    }

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public static WindowInfo[] GetChromeWindows(uint[] chromeProcessIds) {
        var allowed = new HashSet<uint>(chromeProcessIds);
        var result = new List<WindowInfo>();

        EnumWindows(delegate(IntPtr hWnd, IntPtr lParam) {
            if (!IsWindowVisible(hWnd)) return true;

            uint pid;
            GetWindowThreadProcessId(hWnd, out pid);
            if (!allowed.Contains(pid)) return true;

            var sb = new StringBuilder(512);
            GetWindowText(hWnd, sb, sb.Capacity);
            result.Add(new WindowInfo {
                Handle = hWnd,
                ProcessId = pid,
                Title = sb.ToString()
            });
            return true;
        }, IntPtr.Zero);

        return result.ToArray();
    }
}
'@

function Get-ChromeWindows {
  $Pids = @(Get-Process -Name chrome -ErrorAction SilentlyContinue | ForEach-Object { [uint32]$_.Id })
  if ($Pids.Count -eq 0) { return @() }
  return @([EvaWin32]::GetChromeWindows($Pids))
}

$Before = @(Get-ChromeWindows)
$BeforeHandles = @{}
foreach ($Window in $Before) {
  $BeforeHandles[$Window.Handle.ToInt64()] = $true
}
Write-EvaLog "Chrome windows before launch: $($Before.Count)"

$ChromeCandidates = @(
  (Get-Command chrome.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue),
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
) | Where-Object { $_ -and (Test-Path $_) }

$ChromeExe = $ChromeCandidates | Select-Object -First 1
if (-not $ChromeExe) {
  Write-EvaLog 'FAILED: Google Chrome executable was not found; no activation message sent.'
  throw 'Google Chrome nije pronadjen. Poruka nije poslana.'
}

Start-Process -FilePath $ChromeExe -ArgumentList @('--new-window', $NewChatUrl)
Write-EvaLog "Google Chrome launched explicitly: $ChromeExe"
Write-Host 'Otvaram NOVI ChatGPT razgovor u Google Chromeu...'

$TargetWindow = $null
# Never fall back to an arbitrary new Chrome window: it may still be a blank/loading tab.
# Wait until the browser itself reports a ChatGPT page title before considering submission.
for ($i = 0; $i -lt 45 -and -not $TargetWindow; $i++) {
  Start-Sleep -Seconds 1
  $After = @(Get-ChromeWindows)
  $NewWindows = @($After | Where-Object {
    -not $BeforeHandles.ContainsKey($_.Handle.ToInt64())
  })

  $TargetWindow = $NewWindows |
    Where-Object { $_.Title -match 'ChatGPT' } |
    Select-Object -First 1
}

if (-not $TargetWindow) {
  Write-EvaLog 'FAILED: no newly created Chrome window with a ChatGPT title appeared within 45 seconds; no send attempted.'
  throw 'ChatGPT nije potvrđen u novom Chrome prozoru unutar 45 sekundi. Poruka nije poslana.'
}

# Allow the page to finish rendering, then confirm the same window still exists and is a ChatGPT page.
Start-Sleep -Seconds 5
$StableWindow = @(Get-ChromeWindows) |
  Where-Object { $_.Handle -eq $TargetWindow.Handle -and $_.Title -match 'ChatGPT' } |
  Select-Object -First 1
if (-not $StableWindow) {
  Write-EvaLog 'FAILED: ChatGPT window did not remain identifiable after stabilization; no send attempted.'
  throw 'ChatGPT prozor nije ostao potvrđen nakon učitavanja. Poruka nije poslana.'
}
$TargetWindow = $StableWindow

Write-EvaLog "Target ChatGPT window confirmed after stabilization: handle=$($TargetWindow.Handle.ToInt64()), pid=$($TargetWindow.ProcessId), title='$($TargetWindow.Title)'"
Write-Host "Potvrđen NOVI ChatGPT prozor: $($TargetWindow.Title)"

if ([EvaWin32]::IsIconic($TargetWindow.Handle)) {
  [EvaWin32]::ShowWindowAsync($TargetWindow.Handle, 9) | Out-Null
}
[void][EvaWin32]::SetForegroundWindow($TargetWindow.Handle)
Start-Sleep -Seconds 1

$Foreground = [EvaWin32]::GetForegroundWindow()
if ($Foreground -ne $TargetWindow.Handle) {
  Write-EvaLog "FAILED: target window could not be brought to foreground; foreground=$($Foreground.ToInt64()), target=$($TargetWindow.Handle.ToInt64()). No send attempted."
  throw 'Novi ChatGPT prozor nije mogao biti postavljen u prvi plan. Poruka nije poslana da se izbjegne slanje u pogrešan prozor.'
}

# Give the focused ChatGPT page an additional moment to finish initializing its composer.
Start-Sleep -Seconds 3
$Foreground = [EvaWin32]::GetForegroundWindow()
if ($Foreground -ne $TargetWindow.Handle) {
  Write-EvaLog 'FAILED: ChatGPT lost foreground during stabilization; no send attempted.'
  throw 'ChatGPT prozor je izgubio fokus prije slanja. Poruka nije poslana.'
}

Write-EvaLog 'ChatGPT window remained foreground after stabilization; sending clipboard paste.'
$Shell = New-Object -ComObject WScript.Shell
$Shell.SendKeys('^v')
Start-Sleep -Milliseconds 700
$Shell.SendKeys('{ENTER}')
Start-Sleep -Seconds 2

Write-EvaLog 'Fresh-chat message submitted to the newly identified foreground window; assistant response not independently verified.'
Write-Host 'EVA_FRESH_CHAT_SUBMISSION_ATTEMPTED'
Write-Host 'Poruka je poslana u novootvoreni prozor koji je skripta sama identificirala.'
