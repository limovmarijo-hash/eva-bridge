$ErrorActionPreference = 'Stop'
$Root = "$env:USERPROFILE\EVA-Automation"
$MemoryHelper = Join-Path $Root 'EVA-ExternalMemory.ps1'
$Launcher = Join-Path $Root 'Start-Eva.ps1'
if (-not (Test-Path $MemoryHelper)) { throw "Nedostaje vanjska memorija: $MemoryHelper" }
if (-not (Test-Path $Launcher)) { throw "Nedostaje postojeći launcher: $Launcher" }
# Pripremi samo kratki okidac; ChatGPT cita vanjsku memoriju nakon aktivacije.
& $MemoryHelper -Action Prepare -Root $Root
# Postojeći launcher ostaje odgovoran za ciljani Chrome razgovor i slanje prompta.
& $Launcher
