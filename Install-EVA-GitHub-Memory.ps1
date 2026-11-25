[CmdletBinding()]
param([string]$Root = "$env:USERPROFILE\EVA-Automation")
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$TaskName = 'EVA - ChatGPT automatic activation'
$Files = @('EVA-ExternalMemory.ps1','Start-Eva-With-GitHubMemory.ps1')
New-Item -ItemType Directory -Force -Path $Root | Out-Null
foreach ($name in $Files) {
  $url = "https://raw.githubusercontent.com/$Repo/$Branch/$name"
  $dest = Join-Path $Root $name
  if (Test-Path $dest) { Copy-Item $dest "$dest.before-github-memory.bak" -Force }
  Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30 -OutFile $dest
  if (-not (Test-Path $dest) -or (Get-Item $dest).Length -lt 100) { throw "Preuzimanje nije uspjelo ili je datoteka prazna: $name" }
  Write-Host "INSTALLED: $dest"
}
$launcher = Join-Path $Root 'Start-Eva.ps1'
if (-not (Test-Path $launcher)) { throw "Postojeći launcher nije pronađen: $launcher" }
$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
$argsLine = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' + (Join-Path $Root 'Start-Eva-With-GitHubMemory.ps1') + '"'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $argsLine
Set-ScheduledTask -TaskName $TaskName -Action $action | Out-Null
Write-Host ''
Write-Host 'EVA_GITHUB_MEMORY_INSTALLED'
Write-Host "Task: $TaskName"
Write-Host 'Postojeći okidači/raspored nisu mijenjani; promijenjena je samo akcija.'
Write-Host 'Test: powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' (Join-Path $Root 'Start-Eva-With-GitHubMemory.ps1') '"'
