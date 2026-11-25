[CmdletBinding()]
param([string]$Root = "$env:USERPROFILE\EVA-Automation")
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$RawBase = "https://raw.githubusercontent.com/$Repo/$Branch"
New-Item -ItemType Directory -Force -Path $Root | Out-Null

$Files = @(
  @{ Name = 'EVA-ExternalMemory.ps1'; Url = "$RawBase/EVA-ExternalMemory.ps1" },
  @{ Name = 'Start-Eva.ps1'; Url = "$RawBase/Start-Eva.ps1" },
  @{ Name = 'Set-Eva-TwoHourSchedule.ps1'; Url = "$RawBase/Set-Eva-TwoHourSchedule.ps1" }
)
foreach ($File in $Files) {
  $Destination = Join-Path $Root $File.Name
  $Temp = "$Destination.download"
  Invoke-WebRequest -Uri $File.Url -UseBasicParsing -OutFile $Temp -TimeoutSec 30
  if (-not (Test-Path $Temp) -or (Get-Item $Temp).Length -lt 100) {
    Remove-Item $Temp -Force -ErrorAction SilentlyContinue
    throw "Preuzimanje nije valjano: $($File.Name)"
  }
  if (Test-Path $Destination) {
    $Backup = "$Destination.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $Destination $Backup -Force
  }
  Move-Item $Temp $Destination -Force
  Write-Host "UPDATED $Destination"
}
# Update only the existing task recurrence; a failure is reported but does not block EVA activation.
$ScheduleUpdater = Join-Path $Root 'Set-Eva-TwoHourSchedule.ps1'
try {
  & $ScheduleUpdater -Root $Root
} catch {
  Write-Warning "Raspored nije promijenjen: $($_.Exception.Message)"
}
$Launcher = Join-Path $Root 'Start-Eva.ps1'
& $Launcher -Root $Root
