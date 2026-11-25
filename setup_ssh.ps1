param(
  [string]$KeyPath = "$HOME\.ssh\eva_ed25519"
)
$ErrorActionPreference = "Stop"
$sshKeygen = Get-Command ssh-keygen -ErrorAction SilentlyContinue
if (-not $sshKeygen) { throw "Nedostaje OpenSSH Client. Instaliraj ga u Windows Optional Features." }
$dir = Split-Path -Parent $KeyPath
New-Item -ItemType Directory -Force -Path $dir | Out-Null
if (-not (Test-Path $KeyPath)) {
  & ssh-keygen -t ed25519 -N '""' -f $KeyPath -C "eva-bridge-windows"
  if ($LASTEXITCODE -ne 0) { throw "ssh-keygen nije uspio." }
}
$pub = Get-Content "$KeyPath.pub" -Raw
Write-Host ""
Write-Host "WINDOWS_SSH_KEY_READY"
Write-Host "Privatni kljuc ostaje na ovom Windows racunalu: $KeyPath"
Write-Host "JAVNI KLJUC (kopiraj cijeli red u Termux):"
Write-Host $pub
Write-Host ""
Write-Host "U Termuxu izvrsi (zamijeni PUBKEY stvarnim cijelim javnim kljucem):"
Write-Host 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
Write-Host 'echo "PUBKEY" >> ~/.ssh/authorized_keys'
Write-Host 'chmod 600 ~/.ssh/authorized_keys'
