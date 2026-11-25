[CmdletBinding()]
param(
  [ValidateSet('Read','Prepare','Save','Status')]
  [string]$Action = 'Prepare',
  [string]$Entry,
  [string]$Root = "$env:USERPROFILE\EVA-Automation"
)
$ErrorActionPreference = 'Stop'
$Repo = 'limovmarijo-hash/eva-bridge'
$Branch = 'main'
$MemoryPath = 'EVA_CONTEXT.md'
$RawUrl = "https://raw.githubusercontent.com/$Repo/$Branch/$MemoryPath"
$CacheDir = Join-Path $Root 'memory'
$CacheFile = Join-Path $CacheDir $MemoryPath
$PromptFile = Join-Path $Root 'EVA-Activation-Prompt.txt'

function Get-EvaMemory {
  New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null
  try {
    $response = Invoke-WebRequest -Uri $RawUrl -UseBasicParsing -TimeoutSec 20
    if ([string]::IsNullOrWhiteSpace($response.Content)) { throw 'GitHub returned empty content.' }
    [System.IO.File]::WriteAllText($CacheFile, $response.Content, [System.Text.UTF8Encoding]::new($false))
    return $response.Content
  }
  catch {
    if (Test-Path $CacheFile) {
      Write-Warning 'GitHub unavailable; using the last local memory cache.'
      return [System.IO.File]::ReadAllText($CacheFile, [System.Text.Encoding]::UTF8)
    }
    throw "Cannot retrieve GitHub memory and no local cache exists. $($_.Exception.Message)"
  }
}

function New-EvaActivationPrompt {
  return 'EVA: Probudi se. Ucitaj EVA_CONTEXT.md s GitHuba i nastavi oba projekta prema protokolu.'
}

switch ($Action) {
  'Read' { Get-EvaMemory }
  'Prepare' {
    $prompt = New-EvaActivationPrompt
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    [System.IO.File]::WriteAllText($PromptFile, $prompt, [System.Text.UTF8Encoding]::new($false))
    Set-Clipboard -Value $prompt
    $length = (Get-Item -LiteralPath $PromptFile).Length
    if ($prompt -match 'POCETAK VANJSKE EVA MEMORIJE' -or $length -gt 5000) {
      throw 'Activation prompt validation failed: prompt is not short.'
    }
    Write-Host 'EVA_SHORT_WAKE_PROMPT_READY'
    Write-Host "Prompt file: $PromptFile"
    Write-Host "Prompt characters: $($prompt.Length)"
    Write-Host 'Full external memory is NOT embedded in the UI prompt.'
    Write-Host 'ChatGPT must retrieve EVA_CONTEXT.md after activation through the connected GitHub integration.'
  }
  'Status' {
    Write-Host "Repo: https://github.com/$Repo"
    Write-Host "Raw memory: $RawUrl"
    Write-Host "Local cache: $CacheFile"
    Write-Host "Cache exists: $(Test-Path $CacheFile)"
    Write-Host "Prompt exists: $(Test-Path $PromptFile)"
    if (Test-Path $PromptFile) {
      $promptText = [System.IO.File]::ReadAllText($PromptFile, [System.Text.Encoding]::UTF8)
      Write-Host "Prompt characters: $($promptText.Length)"
      Write-Host "Full memory embedded: $($promptText -match 'POCETAK VANJSKE EVA MEMORIJE')"
    }
    Write-Host 'Assistant-side GitHub integration performs the actual memory read and verified write-back.'
  }
  'Save' {
    if ([string]::IsNullOrWhiteSpace($Entry)) { throw 'For manual Save, provide -Entry with a short verified note.' }
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI is missing. Install it and run: gh auth login' }
    & gh auth status 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated. Run: gh auth login' }
    $apiPath = "repos/$Repo/contents/$MemoryPath"
    $remote = & gh api $apiPath --jq '{sha: .sha, content: .content}' | ConvertFrom-Json
    if (-not $remote.sha -or -not $remote.content) { throw 'Cannot retrieve current GitHub memory.' }
    $bytes = [Convert]::FromBase64String(($remote.content -replace '\s',''))
    $current = [System.Text.Encoding]::UTF8.GetString($bytes)
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $nl = [Environment]::NewLine
    $addition = $nl + $nl + "## Manual entry - $stamp (Windows local time)" + $nl + $Entry + $nl
    $updated = $current.TrimEnd() + $addition
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($updated))
    $message = "EVA: manual context update $stamp"
    $result = & gh api --method PUT $apiPath -f message="$message" -f content="$encoded" -f sha="$($remote.sha)" -f branch="$Branch" --jq '.commit.sha'
    if ($LASTEXITCODE -ne 0 -or -not $result) { throw 'GitHub rejected the update; memory was not changed.' }
    [System.IO.File]::WriteAllText($CacheFile, $updated, [System.Text.UTF8Encoding]::new($false))
    Write-Host "EVA_MEMORY_SAVED $result"
  }
}
