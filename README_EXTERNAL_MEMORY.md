# EVA GitHub memory + short-trigger activation cycle

Canonical durable context: [EVA_CONTEXT.md](./EVA_CONTEXT.md) on branch `main`.

## One scheduled activation

1. The existing Windows wrapper calls `EVA-ExternalMemory.ps1 -Action Prepare`.
2. `Prepare` writes and copies ONLY a short wake-up instruction to `EVA-Activation-Prompt.txt`. It does not download, cache, or embed `EVA_CONTEXT.md`.
3. The existing `Start-Eva.ps1` launcher sends that short prompt to the already configured ChatGPT conversation. Keep the existing Chrome target and scheduled-task triggers; do not create a second task or browser target.
4. After receiving the wake-up instruction, ChatGPT must read the latest `EVA_CONTEXT.md` through the connected GitHub integration. If that integration is unavailable, report a blocker; never fall back to embedding the entire memory in the UI prompt.
5. ChatGPT continues BOTH work streams:
   - EVA functional continuity / automation.
   - Crypto strategy research in PAPER mode only, using existing Library scripts and CSV artifacts.
6. After work, ChatGPT re-fetches the latest context and writes a concise evidence-based update for both streams to `main`, then verifies the commit/read-back. If write-back fails, report a blocker.

## Architecture boundary

The Windows helper prepares only the short trigger. It does not transport external memory into the conversation and cannot know what ChatGPT accomplished. Context retrieval and factual write-back are assistant-side operations through the connected GitHub integration.

This workflow does not provide continuous thought between activations. Work happens only when ChatGPT actually receives and processes an activation.

## Update the local helper only

After a GitHub helper change, update only the helper file on the user's PC; do not rerun the installer merely to refresh this file, because the scheduled task and wrapper are already configured.

```powershell
$Root = "$env:USERPROFILE\EVA-Automation"
$Name = "EVA-ExternalMemory.ps1"
$Url = "https://raw.githubusercontent.com/limovmarijo-hash/eva-bridge/main/$Name"
$Dest = Join-Path $Root $Name
$Backup = "$Dest.before-short-prompt.bak"
New-Item -ItemType Directory -Force -Path $Root | Out-Null
if (Test-Path $Dest) { Copy-Item -LiteralPath $Dest -Destination $Backup -Force }
$Temp = Join-Path $env:TEMP $Name
Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 30 -OutFile $Temp
if (-not (Test-Path $Temp) -or (Get-Item $Temp).Length -lt 100) { throw "Download failed: $Temp" }
$Source = [System.IO.File]::ReadAllText($Temp, [System.Text.Encoding]::UTF8)
if ($Source -match '[^\x00-\x7F]') { throw "Helper source is not ASCII-only." }
Copy-Item -LiteralPath $Temp -Destination $Dest -Force
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Dest -Action Prepare -Root $Root
if ($LASTEXITCODE -ne 0) { throw "Prepare failed. Backup: $Backup" }
$Prompt = [System.IO.File]::ReadAllText((Join-Path $Root 'EVA-Activation-Prompt.txt'), [System.Text.Encoding]::UTF8)
if ($Prompt.Length -gt 5000) { throw "Prompt unexpectedly long: $($Prompt.Length)" }
if ($Prompt -match 'POCETAK VANJSKE EVA MEMORIJE') { throw "Full memory was embedded in the prompt." }
"LOCAL_HELPER_UPDATED_AND_SHORT_PROMPT_VERIFIED"
"Prompt characters: $($Prompt.Length)"
"Backup: $Backup"
```

This update does not modify `Start-Eva.ps1`, `EVA-ChatGPT-URL.txt`, the wrapper, or the Task Scheduler task/triggers.

## Optional diagnostics

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\EVA-Automation\EVA-ExternalMemory.ps1" -Action Status
```

The optional `-Action Save -Entry "..." ` remains a manual Windows-side fallback requiring GitHub CLI authentication. It is not the normal automatic write-back path.

## Safety and research constraints

- Never store passwords, tokens, API keys, private keys, or other credentials in the durable context.
- Trading research remains PAPER only: no live orders, funded account, or real-money execution.
- Do not record plans as completed work. Include evidence or an explicit blocker.
