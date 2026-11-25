param(
  [ValidateSet('status','list','wake','history','verify')]
  [string]$Action = 'status',
  [string]$Config = "$PSScriptRoot\bridge.local.json"
)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path $Config)) { throw "Nedostaje lokalna konfiguracija: $Config" }
$c = Get-Content $Config -Raw | ConvertFrom-Json
if (-not $c.host -or -not $c.user -or -not $c.key_path) { throw "Konfiguracija mora sadržavati host, user i key_path." }
$remote = "python3 ~/eva/eva_state.py $Action"
if ($Action -eq 'status') { $remote = 'python3 ~/eva/eva_state.py verify' }
& ssh -o BatchMode=yes -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no -o ConnectTimeout=8 -i $c.key_path -p ([int]$c.port) "$($c.user)@$($c.host)" $remote
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
