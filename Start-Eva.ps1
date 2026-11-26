[CmdletBinding()]
param(
  [string]$Root = "$env:USERPROFILE\EVA-Automation",
  [switch]$DryRun
)
$ErrorActionPreference = 'Stop'
$Helper = Join-Path $Root 'EVA-ExternalMemory.ps1'
$PromptFile = Join-Path $Root 'EVA-Activation-Prompt.txt'
$LogFile = Join-Path $Root 'EVA-Activation-Log.md'
$WindowRegistryFile = Join-Path $Root 'EVA-Owned-Chrome-Windows.json'
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
# Clipboard is populated ONLY after the composer is positively identified and focused.

# Use Win32 top-level window handles rather than Chrome process IDs.
# Chrome can host multiple browser windows in the same process, so AppActivate(PID)
# is not sufficient to identify the exact window just created.
if (-not ([System.Management.Automation.PSTypeName]'EvaWin32').Type) {
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
    public static extern bool IsWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

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
}

function Get-ChromeWindows {
  $Pids = @(Get-Process -Name chrome -ErrorAction SilentlyContinue | ForEach-Object { [uint32]$_.Id })
  if ($Pids.Count -eq 0) { return @() }
  return @([EvaWin32]::GetChromeWindows($Pids))
}

function Save-EvaWindowRegistry([object[]]$Records) {
  $TempRegistry = "$WindowRegistryFile.tmp"
  $Json = ConvertTo-Json -InputObject @($Records) -Depth 5
  [System.IO.File]::WriteAllText($TempRegistry, $Json, [System.Text.UTF8Encoding]::new($false))
  Move-Item -LiteralPath $TempRegistry -Destination $WindowRegistryFile -Force
}

# Close only exact Chrome windows previously registered by this launcher.
# Never enumerate-and-close arbitrary Chrome windows or terminate Chrome processes.
$EvaManagedWindows = @()
if (Test-Path -LiteralPath $WindowRegistryFile) {
  try {
    $RegistryText = [System.IO.File]::ReadAllText($WindowRegistryFile, [System.Text.Encoding]::UTF8)
    if (-not [string]::IsNullOrWhiteSpace($RegistryText)) {
      $EvaManagedWindows = @(ConvertFrom-Json -InputObject $RegistryText -ErrorAction Stop)
    }
  } catch {
    Write-EvaLog "FAILED: EVA window registry is unreadable; refusing to launch another window. $($_.Exception.Message)"
    throw "EVA evidencija Chrome prozora nije citljiva. Ne otvaram novi prozor kako se ne bi gomilali."
  }
}

if ($EvaManagedWindows.Count -gt 0) {
  $WindowsNow = @(Get-ChromeWindows)
  $ForegroundNow = [EvaWin32]::GetForegroundWindow()
  $KeepRegistry = @()
  foreach ($Entry in $EvaManagedWindows) {
    $HandleValue = [Int64]0
    $PidValue = [Int32]0
    $StartTicks = [Int64]0
    if (-not [Int64]::TryParse([string]$Entry.Handle, [ref]$HandleValue) -or
        -not [Int32]::TryParse([string]$Entry.ProcessId, [ref]$PidValue) -or
        -not [Int64]::TryParse([string]$Entry.ProcessStartTimeUtcTicks, [ref]$StartTicks)) {
      Write-EvaLog 'WARNING: malformed EVA window registry entry discarded without closing any window.'
      continue
    }

    $Candidate = $WindowsNow |
      Where-Object { $_.Handle.ToInt64() -eq $HandleValue -and $_.ProcessId -eq [uint32]$PidValue } |
      Select-Object -First 1
    if (-not $Candidate) { continue }

    $Proc = Get-Process -Id $PidValue -ErrorAction SilentlyContinue
    if (-not $Proc) { continue }
    $ActualStartTicks = $Proc.StartTime.ToUniversalTime().Ticks

    # A reused HWND/PID or a window whose title no longer identifies ChatGPT is never closed.
    if ($ActualStartTicks -ne $StartTicks -or $Candidate.Title -notmatch 'ChatGPT') {
      Write-EvaLog "EVA registry entry no longer matches its original ChatGPT window; left untouched: handle=$HandleValue."
      continue
    }

    # Close the exact previously registered EVA window even when it is foreground.
    # Never start another activation window if this close cannot be verified.
    [void][EvaWin32]::PostMessage([IntPtr]$HandleValue, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    $StillOpen = $true
    for ($Wait = 0; $Wait -lt 50; $Wait++) {
      Start-Sleep -Milliseconds 100
      $StillOpen = @(
        Get-ChromeWindows | Where-Object {
          $_.Handle.ToInt64() -eq $HandleValue -and $_.ProcessId -eq [uint32]$PidValue
        }
      ).Count -gt 0
      if (-not $StillOpen) { break }
    }

    if ($StillOpen) {
      $KeepRegistry += $Entry
      Write-EvaLog "FAILED: previous EVA-managed ChatGPT window did not close within 5 seconds; refusing to launch another window: handle=$HandleValue."
    } else {
      Write-EvaLog "Closed previous EVA-managed ChatGPT window: handle=$HandleValue."
    }
  }
  $EvaManagedWindows = @($KeepRegistry)
  Save-EvaWindowRegistry -Records $EvaManagedWindows
  if ($EvaManagedWindows.Count -gt 0) {
    throw "Prethodni EVA ChatGPT prozor nije se zatvorio. Ne otvaram novi prozor kako bih sprijecila gomilanje. Provjeri EVA-Activation-Log.md."
  }
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
  throw 'ChatGPT nije potvrdjen u novom Chrome prozoru unutar 45 sekundi. Poruka nije poslana.'
}

# Allow the page to finish rendering, then confirm the same window still exists and is a ChatGPT page.
Start-Sleep -Seconds 5
$StableWindow = @(Get-ChromeWindows) |
  Where-Object { $_.Handle -eq $TargetWindow.Handle -and $_.Title -match 'ChatGPT' } |
  Select-Object -First 1
if (-not $StableWindow) {
  Write-EvaLog 'FAILED: ChatGPT window did not remain identifiable after stabilization; no send attempted.'
  throw 'ChatGPT prozor nije ostao potvrdjen nakon ucitavanja. Poruka nije poslana.'
}
$TargetWindow = $StableWindow

# Register the exact newly-created ChatGPT window so only this window can be
# considered for cleanup on a later activation.
$TargetProcess = Get-Process -Id ([int]$TargetWindow.ProcessId) -ErrorAction Stop
$EvaManagedWindows += [pscustomobject]@{
  Handle = [string]$TargetWindow.Handle.ToInt64()
  ProcessId = [int]$TargetWindow.ProcessId
  ProcessStartTimeUtcTicks = [string]$TargetProcess.StartTime.ToUniversalTime().Ticks
}
Save-EvaWindowRegistry -Records $EvaManagedWindows
Write-EvaLog "Registered EVA-managed ChatGPT window for next-run cleanup: handle=$($TargetWindow.Handle.ToInt64()), pid=$($TargetWindow.ProcessId)"

Write-EvaLog "Target ChatGPT window confirmed after stabilization: handle=$($TargetWindow.Handle.ToInt64()), pid=$($TargetWindow.ProcessId), title='$($TargetWindow.Title)'"
Write-Host "Potvrdjen NOVI ChatGPT prozor: $($TargetWindow.Title)"

if ([EvaWin32]::IsIconic($TargetWindow.Handle)) {
  [EvaWin32]::ShowWindowAsync($TargetWindow.Handle, 9) | Out-Null
}
[void][EvaWin32]::SetForegroundWindow($TargetWindow.Handle)
Start-Sleep -Seconds 1

$Foreground = [EvaWin32]::GetForegroundWindow()
if ($Foreground -ne $TargetWindow.Handle) {
  Write-EvaLog "FAILED: target window could not be brought to foreground; foreground=$($Foreground.ToInt64()), target=$($TargetWindow.Handle.ToInt64()). No send attempted."
  throw 'Novi ChatGPT prozor nije mogao biti postavljen u prvi plan. Poruka nije poslana da se izbjegne slanje u pogresan prozor.'
}

# Give the focused ChatGPT page an additional moment to finish initializing its composer.
Start-Sleep -Seconds 3
$Foreground = [EvaWin32]::GetForegroundWindow()
if ($Foreground -ne $TargetWindow.Handle) {
  Write-EvaLog 'FAILED: ChatGPT lost foreground during stabilization; no send attempted.'
  throw 'ChatGPT prozor je izgubio fokus prije slanja. Poruka nije poslana.'
}

# SAFETY: identify the actual ChatGPT composer through Windows UI Automation.
# If the composer cannot be positively identified and focused, abort without pasting.
try {
  Add-Type -AssemblyName UIAutomationClient
  Add-Type -AssemblyName UIAutomationTypes
} catch {
  Write-EvaLog "FAILED: Windows UI Automation assemblies unavailable; no paste or send. $($_.Exception.Message)"
  throw 'Windows ne moze potvrditi polje za poruku. Nista nije zalijepljeno niti poslano.'
}

function Get-EvaComposer {
  $RootElement = [System.Windows.Automation.AutomationElement]::FromHandle($TargetWindow.Handle)
  if (-not $RootElement) { return $null }
  $All = $RootElement.FindAll(
    [System.Windows.Automation.TreeScope]::Descendants,
    [System.Windows.Automation.Condition]::TrueCondition
  )
  foreach ($Element in $All) {
    try {
      $Name = [string]$Element.Current.Name
      $Type = $Element.Current.ControlType
      $Focusable = $Element.Current.IsKeyboardFocusable
      if ($Focusable -and
          ($Type -eq [System.Windows.Automation.ControlType]::Edit -or
           $Type -eq [System.Windows.Automation.ControlType]::Document) -and
          $Name -match '(?i)(message chatgpt|ask anything|send a message|message to chatgpt|posalji poruku|upisite poruku|unesite poruku)') {
        return $Element
      }
    } catch { }
  }
  return $null
}

function Test-EvaComposerFocused([System.Windows.Automation.AutomationElement]$Composer) {
  if (-not $Composer) { return $false }
  try {
    $Focused = [System.Windows.Automation.AutomationElement]::FocusedElement
    if (-not $Focused) { return $false }
    $ExpectedId = ($Composer.GetRuntimeId() -join ',')
    $FocusedId = ($Focused.GetRuntimeId() -join ',')
    return ($ExpectedId -eq $FocusedId)
  } catch { return $false }
}

if ([EvaWin32]::GetForegroundWindow() -ne $TargetWindow.Handle) {
  Write-EvaLog 'FAILED: ChatGPT window lost foreground before composer detection; no paste or send.'
  throw 'ChatGPT vise nije aktivni prozor. Nista nije zalijepljeno niti poslano.'
}

$Composer = Get-EvaComposer
if (-not $Composer) {
  Write-EvaLog 'FAILED: named ChatGPT composer not found by UI Automation; no paste or send.'
  throw 'Nisam mogla pouzdano pronaci polje za pisanje poruke. Nista nije zalijepljeno niti poslano.'
}

try { $Composer.SetFocus() } catch {
  Write-EvaLog "FAILED: composer SetFocus failed; no paste or send. $($_.Exception.Message)"
  throw 'Polje poruke nije prihvatilo fokus. Nista nije zalijepljeno niti poslano.'
}
Start-Sleep -Milliseconds 500

if ([EvaWin32]::GetForegroundWindow() -ne $TargetWindow.Handle -or
    -not (Test-EvaComposerFocused -Composer $Composer)) {
  Write-EvaLog 'FAILED: composer focus could not be independently verified; no paste or send.'
  throw 'Fokus polja poruke nije potvrdjen. Nista nije zalijepljeno niti poslano.'
}

# Only now is the short trigger copied and pasted. The address bar is never used as fallback.
Set-Clipboard -Value $Prompt
$Shell = New-Object -ComObject WScript.Shell
$Shell.SendKeys('^v')
Start-Sleep -Milliseconds 900

if ([EvaWin32]::GetForegroundWindow() -ne $TargetWindow.Handle -or
    -not (Test-EvaComposerFocused -Composer $Composer)) {
  Write-EvaLog 'FAILED: composer focus changed after paste; Enter suppressed to prevent accidental navigation/submission.'
  throw 'Nakon lijepljenja fokus vise nije potvrdjen. Enter nije pritisnut.'
}

$Shell.SendKeys('{ENTER}')
Start-Sleep -Seconds 2

Write-EvaLog 'Fresh-chat trigger submitted only after UI Automation positively identified and focused the ChatGPT composer; assistant response not independently verified.'
Write-Host 'EVA_FRESH_CHAT_SUBMISSION_ATTEMPTED'
Write-Host 'Polje za poruku potvrdjeno; kratka aktivacijska poruka poslana.'
