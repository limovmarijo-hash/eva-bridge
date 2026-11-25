param([string]$Config = "$PSScriptRoot\bridge.local.json")
$ErrorActionPreference = "Stop"
if (-not (Test-Path $Config)) { throw "Nedostaje lokalna konfiguracija: $Config" }
$c = Get-Content $Config -Raw | ConvertFrom-Json
foreach ($k in @("host","user","key_path")) { if (-not $c.$k) { throw "Nedostaje konfiguracijsko polje: $k" } }
if (-not (Test-Path $c.key_path)) { throw "SSH privatni kljuc ne postoji: $($c.key_path)" }
if (-not $c.port) { $c | Add-Member -NotePropertyName port -NotePropertyValue 8022 }
Write-Host "CONFIG_OK"
Write-Host "TARGET: $($c.user)@$($c.host):$($c.port)"
Write-Host "KEY_OK: $($c.key_path)"
& ssh -o BatchMode=yes -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new -i $c.key_path -p ([int]$c.port) "$($c.user)@$($c.host)" "python3 ~/eva/eva_state.py verify"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "EVA_END_TO_END_OK"
