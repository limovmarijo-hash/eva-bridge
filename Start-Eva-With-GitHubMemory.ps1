$ErrorActionPreference = 'Stop'
$Root = "$env:USERPROFILE\EVA-Automation"
$MemoryHelper = Join-Path $Root 'EVA-ExternalMemory.ps1'
$Launcher = Join-Path $Root 'Start-Eva.ps1'
if (-not (Test-Path $MemoryHelper)) { throw "Nedostaje vanjska memorija: $MemoryHelper" }
if (-not (Test-Path $Launcher)) { throw "Nedostaje postojeći launcher: $Launcher" }
& $MemoryHelper -Action Prepare -Root $Root
if ($LASTEXITCODE -ne 0) { throw 'Priprema GitHub memorije nije uspjela.' }
& $Launcher
if ($LASTEXITCODE -ne 0) { throw "Postojeći EVA launcher završio je s kodom $LASTEXITCODE." }
