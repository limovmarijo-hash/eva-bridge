[CmdletBinding()]
param([string]$Root = "$env:USERPROFILE\EVA-Automation")
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$Pinned = @{
  'EVA-ExternalMemory.ps1' = '4f46bcfaeb560c2f254bf9f4491f38b0f4d236c9'
  'Start-Eva.ps1' = '3e7f88af89c9aaf6fa671f7ee84901ba51f42afb'
}
New-Item -ItemType Directory -Force -Path $Root | Out-Null

$Files = @(
  @{ Name = 'EVA-ExternalMemory.ps1'; Url = "https://raw.githubusercontent.com/$Repo/$($Pinned['EVA-ExternalMemory.ps1'])/EVA-ExternalMemory.ps1" },
  @{ Name = 'Start-Eva.ps1'; Url = "https://raw.githubusercontent.com/$Repo/$($Pinned['Start-Eva.ps1'])/Start-Eva.ps1" }
)
foreach ($File in $Files) {
  $Destination = Join-Path $Root $File.Name
  $Temp = "$Destination.download"
  Invoke-WebRequest -Uri $File.Url -UseBasicParsing -OutFile $Temp -TimeoutSec 30
  if (-not (Test-Path $Temp) -or (Get-Item $Temp).Length -lt 100) {
    Remove-Item $Temp -Force -ErrorAction SilentlyContinue
    throw "Preuzimanje nije valjano: $($File.Name)"
  }

  # Windows PowerShell 5.1 may parse UTF-8 scripts without a BOM as ANSI.
  # Decode downloaded GitHub files explicitly as UTF-8 and save every .ps1 with a UTF-8 BOM.
  $DownloadedText = [System.IO.File]::ReadAllText($Temp, [System.Text.Encoding]::UTF8)
  $Utf8Bom = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText($Temp, $DownloadedText, $Utf8Bom)

  if (Test-Path $Destination) {
    $Backup = "$Destination.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $Destination $Backup -Force
  }
  Move-Item $Temp $Destination -Force
  Write-Host "UPDATED $Destination"
}
$Launcher = Join-Path $Root 'Start-Eva.ps1'
& $Launcher -Root $Root
