# UTF-8 BOM is intentional: Windows PowerShell 5.1 must parse Croatian diacritics correctly.
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
  return 'EVA: Učitaj EVA_CONTEXT.md s GitHuba preko integracije: https://raw.githubusercontent.com/limovmarijo-hash/eva-bridge/main/EVA_CONTEXT.md. Ako integracija nije dostupna, otvori tu izravnu poveznicu i pročitaj datoteku. Ne učitavaj arhivu. Zatim nastavi oba projekta prema protokolu, provjeri činjenice, napravi jedan koristan korak i ažuriraj memoriju.'
}

switch ($Action) {
  'Read' { Get-EvaMemory }
  'Prepare' {
    # Activation gets a FRESH copy from GitHub. Do not silently use stale cache.
    $response = Invoke-WebRequest -Uri $RawUrl -UseBasicParsing -TimeoutSec 30
    $memory = [string]$response.Content
    if ([string]::IsNullOrWhiteSpace($memory) -or $memory.Length -lt 500) {
      throw 'GitHub memory is empty or unexpectedly short; activation cancelled.'
    }
    if ($memory -notmatch '(?m)^# EVA') {
      throw 'Fetched file does not look like EVA_CONTEXT.md; activation cancelled.'
    }
    New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null
    [System.IO.File]::WriteAllText($CacheFile, $memory, [System.Text.UTF8Encoding]::new($false))

    $instruction = @'
EVA: Probudi se. Ispod je aktualni EVA_CONTEXT.md preuzet iz GitHuba neposredno prije aktivacije. Pročitaj ga kao radni kontekst; ne učitavaj arhivu. Nastavi oba projekta prema protokolu: EVA kontinuitet/automatizacija i kripto PAPER istraživanje. Najprije utvrdi stanje i prepreke, zatim napravi jedan konkretan koristan korak. Ne tvrdi da je nešto izvršeno bez dokaza. Odgovori na hrvatskom.
--- BEGIN EVA_CONTEXT.md ---
'@
    $prompt = $instruction + "`r`n" + $memory.Trim() + "`r`n--- END EVA_CONTEXT.md ---"
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    if ($prompt.Length -gt 20000) { throw "Activation payload too large: $($prompt.Length) characters." }
    [System.IO.File]::WriteAllText($PromptFile, $prompt, [System.Text.UTF8Encoding]::new($false))
    Set-Clipboard -Value $prompt
    Write-Host 'EVA_CONTEXT_FETCHED_AND_EMBEDDED'
    Write-Host "Memory characters: $($memory.Length)"
    Write-Host "Prompt characters: $($prompt.Length)"
    Write-Host 'Archive was not fetched.'
  }
  'Status' {
    Write-Host "Repo: https://github.com/$Repo"
    Write-Host "Raw memory: $RawUrl"
    Write-Host "Local cache: $CacheFile"
    Write-Host "Prompt exists: $(Test-Path $PromptFile)"
    if (Test-Path $PromptFile) {
      $promptText = [System.IO.File]::ReadAllText($PromptFile, [System.Text.Encoding]::UTF8)
      Write-Host "Prompt characters: $($promptText.Length)"
    }
    Write-Host 'The scheduled launcher opens a NEW ChatGPT conversation; it does not use the legacy conversation URL.'
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
