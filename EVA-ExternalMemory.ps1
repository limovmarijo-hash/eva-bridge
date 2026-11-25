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
    if ([string]::IsNullOrWhiteSpace($response.Content)) { throw 'GitHub je vratio prazan sadržaj.' }
    [System.IO.File]::WriteAllText($CacheFile, $response.Content, [System.Text.UTF8Encoding]::new($false))
    return $response.Content
  }
  catch {
    if (Test-Path $CacheFile) {
      Write-Warning "GitHub nije dostupan; koristim zadnju lokalnu kopiju memorije."
      return [System.IO.File]::ReadAllText($CacheFile, [System.Text.Encoding]::UTF8)
    }
    throw "Ne mogu dohvatiti GitHub memoriju i nema lokalne kopije. $($_.Exception.Message)"
  }
}
function New-EvaActivationPrompt([string]$Memory) {
  @"
EVA AKTIVACIJA — OBAVEZNO PROČITAJ PRETHODNI KONTEKST

Ispod je aktualna vanjska radna memorija projekta EVA s GitHuba.
Koristi je kao početno stanje, ne tvrdi da si izvršila ono što u njoj nije potvrđeno.
Razdvoji potvrđeno, vjerojatno i hipotetsko. Nastavi najkorisniji sljedeći korak
pomoću stvarno dostupnih alata. Ne traži od korisnika rutinske provjere.
Nakon značajnog, provjerenog napretka pripremi kratak zapis za trajnu memoriju.
Ako nemaš mogućnost zapisivanja na GitHub, jasno navedi da zapis treba spremiti.

===== POČETAK VANJSKE EVA MEMORIJE =====
$Memory
===== KRAJ VANJSKE EVA MEMORIJE =====
"@
}
switch ($Action) {
  'Read' { Get-EvaMemory }
  'Prepare' {
    $memory = Get-EvaMemory
    $prompt = New-EvaActivationPrompt $memory
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    [System.IO.File]::WriteAllText($PromptFile, $prompt, [System.Text.UTF8Encoding]::new($false))
    Set-Clipboard -Value $prompt
    Write-Host 'EVA_MEMORY_OK'
    Write-Host "Memorija: GitHub (ili cache ako je GitHub nedostupan)"
    Write-Host "Prompt spremljen: $PromptFile"
    Write-Host 'Prompt je kopiran u međuspremnik. Zalijepi ga u već otvoreni ciljani ChatGPT razgovor.'
  }
  'Status' {
    Write-Host "Repo: https://github.com/$Repo"
    Write-Host "Raw memorija: $RawUrl"
    Write-Host "Lokalni cache: $CacheFile"
    Write-Host "GitHub CLI: $([bool](Get-Command gh -ErrorAction SilentlyContinue))"
    Write-Host "Cache postoji: $(Test-Path $CacheFile)"
  }
  'Save' {
    if ([string]::IsNullOrWhiteSpace($Entry)) { throw 'Za Save moraš zadati -Entry "kratak potvrđeni zapis".' }
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'Nedostaje GitHub CLI. Instaliraj ga i jednom pokreni: gh auth login' }
    & gh auth status 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI nije prijavljen. Jednom pokreni: gh auth login' }
    $apiPath = "repos/$Repo/contents/$MemoryPath"
    $remote = & gh api $apiPath --jq '{sha: .sha, content: .content}' | ConvertFrom-Json
    if (-not $remote.sha -or -not $remote.content) { throw 'Ne mogu dohvatiti trenutnu GitHub verziju memorije.' }
    $bytes = [Convert]::FromBase64String(($remote.content -replace '\s',''))
    $current = [System.Text.Encoding]::UTF8.GetString($bytes)
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $nl = [Environment]::NewLine
    $addition = $nl + $nl + "## Dated update — $stamp (Windows local time)" + $nl + $Entry + $nl
    $updated = $current.TrimEnd() + $addition
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($updated))
    $message = "EVA: update durable context $stamp"
    $result = & gh api --method PUT $apiPath -f message="$message" -f content="$encoded" -f sha="$($remote.sha)" -f branch="$Branch" --jq '.commit.sha'
    if ($LASTEXITCODE -ne 0 -or -not $result) { throw 'GitHub nije prihvatio zapis; memorija nije promijenjena.' }
    [System.IO.File]::WriteAllText($CacheFile, $updated, [System.Text.UTF8Encoding]::new($false))
    Write-Host "EVA_MEMORY_SAVED $result"
  }
}
