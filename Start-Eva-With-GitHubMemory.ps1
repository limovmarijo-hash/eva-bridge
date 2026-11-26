[CmdletBinding()]
param([string]$Root = "$env:USERPROFILE\EVA-Automation")
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$Pinned = @{
  'EVA-ExternalMemory.ps1' = '5906e848d104fa8639bfbd06f2e7a47e60863743'
  'Start-Eva.ps1' = '009ffb2c8c297adbceba9f162eef7cf27723831d'
  'Set-Eva-TwoHourSchedule.ps1' = '672894765f2378b82c86c15a0041b86832fdaa73'
}
New-Item -ItemType Directory -Force -Path $Root | Out-Null

$Files = @(
  @{ Name = 'EVA-ExternalMemory.ps1'; Url = "https://raw.githubusercontent.com/$Repo/$($Pinned['EVA-ExternalMemory.ps1'])/EVA-ExternalMemory.ps1" },
  @{ Name = 'Start-Eva.ps1'; Url = "https://raw.githubusercontent.com/$Repo/$($Pinned['Start-Eva.ps1'])/Start-Eva.ps1" },
  @{ Name = 'Set-Eva-TwoHourSchedule.ps1'; Url = "https://raw.githubusercontent.com/$Repo/$($Pinned['Set-Eva-TwoHourSchedule.ps1'])/Set-Eva-TwoHourSchedule.ps1" }
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
