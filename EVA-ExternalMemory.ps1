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
    if ([string]::IsNullOrWhiteSpace($response.Content)) { throw 'GitHub je vratio prazan sadrzaj.' }
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
EVA - POTPUNI CIKLUS AKTIVACIJE
Ovo nije samo pozdrav ili podsjetnik. Ovo je radni nalog za ovu aktivaciju.

VANJSKA MEMORIJA
U nastavku je memorija preuzeta s GitHuba (ili zadnji lokalni cache ako je GitHub bio nedostupan).
Procitaj je u cijelosti i tretiraj je kao pocetno stanje. Ako imas dostupnu povezanu GitHub integraciju,
prije izmjena provjeri aktualni sadrzaj EVA_CONTEXT.md na main grani kako bi izbjegla rad na zastarjeloj verziji.

OBVEZNA DVA RADNA TOKA - OBA SE OBRADjUJU U SVAKOJ AKTIVACIJI

A) EVA funkcionalni kontinuitet i automatizacija
- Provjeri aktualno stanje repozitorija limovmarijo-hash/eva-bridge i zapise u memoriji.
- Odaberi i izvrsi jedan konkretan, koristan i provjerljiv korak prema pouzdanijem prijenosu konteksta,
  trajnom stanju, aktivacijama, logiranju ili testiranju.
- Ako je potreban Windows/Android postupak koji ne mozes izvrsiti iz ChatGPT-a, nemoj glumiti da je testiran:
  pripremi tocnu naredbu ili skriptu i zabiljezi da ceka korisnikovo jednokratno izvrsavanje.
- Nemoj mijenjati postojece rasporede, stvarati duplikate zadataka ni otvarati dodatne automatizacije bez potrebe.

B) Istrazivanje trgovacke strategije - ISKLJUCIVO PAPER
- Nastavi postojece istrazivanje, ne pocinji od nule. Potrazi u korisnikovoj Library postojece
  eva_tick_research.py, eva_tick_research_1_1.py i CSV rezultate; koristi Files pretrazivanje/citanje.
- Izvrsi jedan konkretan korak analize, revizije koda, provjere podataka ili dizajna eksperimenta.
- Prioritet je dokaziva pozitivna neto ocekivana dobit nakon naknada, spreada i slippagea, uz kronoloski
  train/validation/holdout, walk-forward, dovoljan uzorak i kontrole protiv look-aheada/leakagea.
- Bez live naloga, pravog novca, funded racuna, API tajni ili pretpostavke da raniji rezultati dokazuju edge.
- Ako podaci ili izvrsno okruzenje nisu dostupni, zabiljezi tocan blocker i najkorisniji sljedeci korak.

OBVEZNI ZAVRSNI ZAPIS NA GITHUB
Nakon obrade OBA toka, azuriraj EVA_CONTEXT.md na repozitoriju limovmarijo-hash/eva-bridge, grana main:
1. Koristi povezanu GitHub integraciju: prvo ponovno dohvatiti najnoviji EVA_CONTEXT.md i njegov aktualni blob SHA.
2. Sacuvaj cijeli postojeci sadrzaj. Na kraj dodaj kratak odjeljak s datumom/vremenom Europe/Zagreb.
3. Za svaki od dva toka navedi: NAPRAVLJENO (s dokazom ili referencom), POTVRDjENO, NIJE POTVRDjENO/BLOCKER i SLJEDECI KORAK.
4. Zabiljezi samo stvarno izvrsene i provjerene radnje. Ne upisuj plan kao rezultat.
5. Spremi promjenu na main i provjeri da je GitHub vratio uspjesan commit / da se azurirani sadrzaj moze ponovno procitati.
6. Ako nemas dostupnu GitHub write integraciju ili spremanje ne uspije, nemoj tvrditi da je memorija azurirana. U odgovoru jasno navedi BLOCKER i prikazi sazeti zapis koji nije spremljen.

PRAVILA
- Svaka aktivacija obradjuje oba toka, makar jedan zavrsi jasnim blockerom.
- Ne ponavljaj vec obavljene korake; koristi prethodne rezultate i odaberi sljedeci korak.
- Razlikuj POTVRDjENO, VJEROJATNO i HIPOTETSKO.
- Ne trazi od korisnika rutinske provjere i ne salji mu izvjestaj o svakoj sitnici.
- Na kraju kratko izvijesti samo o vaznom napretku ili stvarnom blockeru te potvrdi je li GitHub zapis stvarno spremljen.
- Nemoj tvrditi da razmisljas ili radis izmedju aktivacija. Ovaj ciklus izvrsava se kada je aktivacija stvarno pokrenuta.

===== POCETAK VANJSKE EVA MEMORIJE =====
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
    Write-Host 'Aktivacijski prompt sadrzi obvezan rad na oba projekta i GitHub write-back.'
    Write-Host 'Postojeci launcher treba zalijepiti i poslati taj prompt u ciljani ChatGPT razgovor.'
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
    if ([string]::IsNullOrWhiteSpace($Entry)) { throw 'Za rucno Save zadati -Entry "kratak potvrdjeni zapis".' }
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
    $addition = $nl + $nl + "## Rucni zapis - $stamp (Windows local time)" + $nl + $Entry + $nl
    $updated = $current.TrimEnd() + $addition
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($updated))
    $message = "EVA: manual context update $stamp"
    $result = & gh api --method PUT $apiPath -f message="$message" -f content="$encoded" -f sha="$($remote.sha)" -f branch="$Branch" --jq '.commit.sha'
    if ($LASTEXITCODE -ne 0 -or -not $result) { throw 'GitHub nije prihvatio zapis; memorija nije promijenjena.' }
    [System.IO.File]::WriteAllText($CacheFile, $updated, [System.Text.UTF8Encoding]::new($false))
    Write-Host "EVA_MEMORY_SAVED $result"
  }
}
