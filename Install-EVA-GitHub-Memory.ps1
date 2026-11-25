[CmdletBinding()]
param([string]$Root = "$env:USERPROFILE\EVA-Automation")
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$TaskName = 'EVA - ChatGPT automatic activation'
$Files = @('EVA-ExternalMemory.ps1','Start-Eva-With-GitHubMemory.ps1')
New-Item -ItemType Directory -Force -Path $Root | Out-Null

$launcher = Join-Path $Root 'Start-Eva.ps1'
if (-not (Test-Path $launcher)) {
  throw "Postojeći Chrome launcher nije pronađen: $launcher"
}
$launcherText = Get-Content -LiteralPath $launcher -Raw
if ($launcherText -notmatch 'EVA-Activation-Prompt\.txt') {
  throw 'Postojeći Start-Eva.ps1 ne čita EVA-Activation-Prompt.txt. Instalacija je zaustavljena da se ne bi aktivirao pogrešan ili nepotpun prompt.'
}

foreach ($name in $Files) {
  $url = "https://raw.githubusercontent.com/$Repo/$Branch/$name"
  $dest = Join-Path $Root $name
  if (Test-Path $dest) { Copy-Item $dest "$dest.before-github-memory.bak" -Force }
  Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30 -OutFile $dest
  if (-not (Test-Path $dest) -or (Get-Item $dest).Length -lt 100) {
    throw "Preuzimanje nije uspjelo ili je datoteka prazna: $name"
  }
  Write-Host "INSTALLED: $dest"
}

$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
$triggerCountBefore = @($task.Triggers).Count
$wrapper = Join-Path $Root 'Start-Eva-With-GitHubMemory.ps1'
$argsLine = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' + $wrapper + '"'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $argsLine
Set-ScheduledTask -TaskName $TaskName -Action $action | Out-Null

$verifiedTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
if (@($verifiedTask.Triggers).Count -ne $triggerCountBefore) {
  throw 'Broj postojećih okidača promijenio se. Provjeri zadatak u Task Scheduleru.'
}
if (-not $verifiedTask.Actions -or $verifiedTask.Actions[0].Arguments -notlike "*Start-Eva-With-GitHubMemory.ps1*") {
  throw 'Nova akcija zadatka nije potvrđena. Instalacija nije verificirana.'
}

Write-Host ''
Write-Host 'EVA_GITHUB_MEMORY_INSTALLED_AND_TASK_ACTION_VERIFIED'
Write-Host "Task: $TaskName"
Write-Host "Postojeći broj okidača sačuvan: $triggerCountBefore"
Write-Host 'Akcija sada pokreće wrapper koji osvježava GitHub memoriju prije Chrome launchera.'
Write-Host 'Napomena: ovaj installer ne dokazuje da je ChatGPT prihvatio prompt; to se potvrđuje smoke testom.'
Write-Host "Test: powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$wrapper`""
