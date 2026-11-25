# EVA GitHub memory + two-project activation cycle

Canonical durable context: [EVA_CONTEXT.md](./EVA_CONTEXT.md) on branch `main`.

## What one scheduled activation is instructed to do

1. The Windows wrapper calls `EVA-ExternalMemory.ps1 -Action Prepare`.
2. The helper downloads the latest public `EVA_CONTEXT.md` (or uses the last local cache if GitHub is unavailable), writes `EVA-Activation-Prompt.txt`, and copies the prompt to the clipboard.
3. The existing `Start-Eva.ps1` launcher must paste and submit that prompt in the already configured ChatGPT conversation. It must not open a second browser or a different conversation.
4. The prompt directs ChatGPT to work on BOTH active streams during that activation:
   - EVA functional continuity / automation.
   - Crypto strategy research in PAPER mode only, using the existing Library scripts and CSV artifacts.
5. After doing the work, ChatGPT is instructed to fetch the latest `EVA_CONTEXT.md` through the connected GitHub integration, append a concise evidence-based entry, update the file on `main`, and verify the commit/read-back.
6. The response must distinguish completed work from blockers. A write-back is not considered successful unless GitHub confirms it.

## Important architecture boundary

The PowerShell helper can fetch and prepare the context. It cannot know what ChatGPT actually did, and it cannot truthfully write the model's work results by itself.

The automatic write-back is therefore an assistant-side operation through the connected GitHub integration. If that integration is unavailable in a scheduled ChatGPT session, the assistant must report the blocker and must not claim that memory was saved.

This workflow does not provide continuous thought between activations. Work happens only when ChatGPT actually receives and processes the activation prompt.

## Install / update on Windows

Run this once in PowerShell:

```powershell
$u = "https://raw.githubusercontent.com/limovmarijo-hash/eva-bridge/main/Install-EVA-GitHub-Memory.ps1"
$p = "$env:TEMP\Install-EVA-GitHub-Memory.ps1"
Invoke-WebRequest $u -OutFile $p
powershell.exe -NoProfile -ExecutionPolicy Bypass -File $p
```

The installer downloads the helper and wrapper and changes only the action of the existing scheduled task `EVA - ChatGPT automatic activation`; its existing triggers should remain unchanged.

## One-time manual smoke test

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\EVA-Automation\Start-Eva-With-GitHubMemory.ps1"
```

Verify that the intended ChatGPT conversation receives the complete activation prompt and that it is actually submitted. Merely opening Chrome, copying to clipboard, or pasting text is not proof of message delivery.

## Status commands

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\EVA-Automation\EVA-ExternalMemory.ps1" -Action Status
```

The optional `-Action Save -Entry "..."` is a manual Windows-side fallback requiring GitHub CLI authentication (`gh auth login`). It is NOT the normal automatic write-back path. The normal path is ChatGPT's connected GitHub integration after both work streams have been processed.

## Safety and research constraints

- Never store passwords, tokens, API keys, private keys, or other credentials in the durable context.
- Trading research remains PAPER only: no live orders, funded account, or real-money execution.
- Do not record plans as completed work. Include evidence or an explicit blocker.
