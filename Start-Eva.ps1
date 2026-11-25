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

# Prepare a compact trigger on every run, including Task Scheduler runs.
& $Helper -Action Prepare -Root $Root
if (-not (Test-Path $PromptFile)) { throw 'Aktivacijska poruka nije stvorena.' }
$Prompt = [System.IO.File]::ReadAllText($PromptFile, [System.Text.Encoding]::UTF8).Trim()
if ([string]::IsNullOrWhiteSpace($Prompt) -or $Prompt.Length -gt 20000) {
  throw 'Aktivacijska poruka je prazna ili prelazi sigurnu granicu od 20000 znakova.'
}

if ($DryRun) {
  Write-Host 'EVA_DRY_RUN_OK'
  Write-Host "Prompt characters: $($Prompt.Length)"
  Write-Host "Destination: $NewChatUrl"
  Write-Host 'No browser was opened and no message was sent.'
  exit 0
}

# IMPORTANT: never read EVA-ChatGPT-URL.txt. It points to the exhausted legacy chat.
# Opening the ChatGPT root creates a fresh chat rather than reusing the old /c/<id> URL.
Set-Clipboard -Value $Prompt
Write-EvaLog 'Fresh-chat activation started; legacy conversation URL deliberately ignored.'
Start-Process -FilePath $NewChatUrl
Write-Host 'Otvaram NOVI ChatGPT razgovor...'
Start-Sleep -Seconds 20

$Shell = New-Object -ComObject WScript.Shell
$Activated = $false
$Candidates = @(Get-Process -Name msedge,chrome -ErrorAction SilentlyContinue |
  Where-Object { $_.MainWindowHandle -ne 0 } |
  Sort-Object StartTime -Descending)

foreach ($Process in $Candidates) {
  try {
    if ($Shell.AppActivate([int]$Process.Id)) {
      $Activated = $true
      break
    }
  } catch {}
}
if (-not $Activated) {
  Write-EvaLog 'FAILED: browser window could not be activated; no send attempted.'
  throw 'Nije pronađen aktivan prozor Edge/Chrome. Poruka nije poslana.'
}

Start-Sleep -Seconds 2
$Shell.SendKeys('^v')
Start-Sleep -Milliseconds 700
$Shell.SendKeys('{ENTER}')
Start-Sleep -Seconds 2
Write-EvaLog 'Fresh-chat message submission attempted via clipboard and Enter; assistant response not independently verified.'
Write-Host 'EVA_FRESH_CHAT_SUBMISSION_ATTEMPTED'
Write-Host 'Provjeri da se poruka pojavila u NOVOM razgovoru i da je Eva odgovorila.'
