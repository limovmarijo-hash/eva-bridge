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
EVA — POTPUNI CIKLUS AKTIVACIJE
Ovo nije samo pozdrav ili podsjetnik. Ovo je radni nalog za ovu aktivaciju.

VANJSKA MEMORIJA
U nastavku je memorija preuzeta s GitHuba (ili zadnji lokalni cache ako je GitHub bio nedostupan).
Pročitaj je u cijelosti i tretiraj je kao početno stanje. Ako imaš dostupnu povezanu GitHub integraciju,
prije izmjena provjeri aktualni sadržaj EVA_CONTEXT.md na main grani kako bi izbjegla rad na zastarjeloj verziji.

OBVEZNA DVA RADNA TOKA — OBA SE OBRAĐUJU U SVAKOJ AKTIVACIJI

A) EVA funkcionalni kontinuitet i automatizacija
- Provjeri aktualno stanje repozitorija limovmarijo-hash/eva-bridge i zapise u memoriji.
- Odaberi i izvrši jedan konkretan, koristan i provjerljiv korak prema pouzdanijem prijenosu konteksta,
  trajnom stanju, aktivacijama, logiranju ili testiranju.
- Ako je potreban Windows/Android postupak koji ne možeš izvršiti iz ChatGPT-a, nemoj glumiti da je testiran:
  pripremi točnu naredbu ili skriptu i zabilježi da čeka korisnikovo jednokratno izvršavanje.
- Nemoj mijenjati postojeće rasporede, stvarati duplikate zadataka ni otvarati dodatne automatizacije bez potrebe.

B) Istraživanje trgovačke strategije — ISKLJUČIVO PAPER
- Nastavi postojeće istraživanje, ne počinji od nule. Potraži u korisnikovoj Library postojeće
  eva_tick_research.py, eva_tick_research_1_1.py i CSV rezultate; koristi Files pretraživanje/čitanje.
- Izvrši jedan konkretan korak analize, revizije koda, provjere podataka ili dizajna eksperimenta.
- Prioritet je dokaziva pozitivna neto očekivana dobit nakon naknada, spreada i slippagea, uz kronološki
  train/validation/holdout, walk-forward, dovoljan uzorak i kontrole protiv look-aheada/leakagea.
- Bez live naloga, pravog novca, funded računa, API tajni ili pretpostavke da raniji rezultati dokazuju edge.
- Ako podaci ili izvršno okruženje nisu dostupni, zabilježi točan blocker i najkorisniji sljedeći korak.

OBVEZNI ZAVRŠNI ZAPIS NA GITHUB
Nakon obrade OBA toka, ažuriraj EVA_CONTEXT.md na repozitoriju limovmarijo-hash/eva-bridge, grana main:
1. Koristi povezanu GitHub integraciju: prvo ponovno dohvatiti najnoviji EVA_CONTEXT.md i njegov aktualni blob SHA.
2. Sačuvaj cijeli postojeći sadržaj. Na kraj dodaj kratak odjeljak s datumom/vremenom Europe/Zagreb.
3. Za svaki od dva toka navedi: NAPRAVLJENO (s dokazom ili referencom), POTVRĐENO, NIJE POTVRĐENO/BLOCKER i SLJEDEĆI KORAK.
4. Zabilježi samo stvarno izvršene i provjerene radnje. Ne upisuj plan kao rezultat.
5. Spremi promjenu na main i provjeri da je GitHub vratio uspješan commit / da se ažurirani sadržaj može ponovno pročitati.
6. Ako nemaš dostupnu GitHub write integraciju ili spremanje ne uspije, nemoj tvrditi da je memorija ažurirana. U odgovoru jasno navedi BLOCKER i prikaži sažeti zapis koji nije spremljen.

PRAVILA
- Svaka aktivacija obrađuje oba toka, makar jedan završi jasnim blockerom.
- Ne ponavljaj već obavljene korake; koristi prethodne rezultate i odaberi sljedeći korak.
- Razlikuj POTVRĐENO, VJEROJATNO i HIPOTETSKO.
- Ne traži od korisnika rutinske provjere i ne šalji mu izvještaj o svakoj sitnici.
- Na kraju kratko izvijesti samo o važnom napretku ili stvarnom blockeru te potvrdi je li GitHub zapis stvarno spremljen.
- Nemoj tvrditi da razmišljaš ili radiš između aktivacija. Ovaj ciklus izvršava se kada je aktivacija stvarno pokrenuta.

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
    Write-Host 'Aktivacijski prompt sadrži obvezan rad na oba projekta i GitHub write-back.'
    Write-Host 'Postojeći launcher treba zalijepiti i poslati taj prompt u ciljani ChatGPT razgovor.'
  }
  'Status' {
    Write-Host "Repo: https://github.com/$Repo"
    Write-Host "Raw memorija: $RawUrl"
    Write-Host "Lokalni cache: $CacheFile"
    Write-Host "Cache postoji: $(Test-Path $CacheFile)"
    Write-Host "Prompt postoji: $(Test-Path $PromptFile)"
    Write-Host 'Automatsko spremanje rezultata obavlja ChatGPT preko povezane GitHub integracije, ne ova lokalna skripta.'
  }
  'Save' {
    if ([string]::IsNullOrWhiteSpace($Entry)) { throw 'Za ručno Save zadati -Entry "kratak potvrđeni zapis".' }
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
    $addition = $nl + $nl + "## Ručni zapis — $stamp (Windows local time)" + $nl + $Entry + $nl
    $updated = $current.TrimEnd() + $addition
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($updated))
    $message = "EVA: manual context update $stamp"
    $result = & gh api --method PUT $apiPath -f message="$message" -f content="$encoded" -f sha="$($remote.sha)" -f branch="$Branch" --jq '.commit.sha'
    if ($LASTEXITCODE -ne 0 -or -not $result) { throw 'GitHub nije prihvatio zapis; memorija nije promijenjena.' }
    [System.IO.File]::WriteAllText($CacheFile, $updated, [System.Text.UTF8Encoding]::new($false))
    Write-Host "EVA_MEMORY_SAVED $result"
  }
}
