# EVA external memory (Windows)

EVA_CONTEXT.md on the main branch is the canonical, portable project memory.

## Read / prepare an activation

From PowerShell:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\EVA-Automation\EVA-ExternalMemory.ps1" -Action Prepare

This downloads the latest public GitHub context, updates a local cache, writes
EVA-Activation-Prompt.txt, and copies the complete activation prompt to the
clipboard. If GitHub is temporarily unavailable, it uses the last cached copy.
Paste the clipboard into the already-open, intended ChatGPT conversation.
It does not open another browser window and does not pretend that pasting proves
ChatGPT accepted the message.

## Save a verified memory update

Install GitHub CLI (gh) and authenticate once on this Windows PC:

    winget install --id GitHub.cli
    gh auth login

Then save only a concise, verified change:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\EVA-Automation\EVA-ExternalMemory.ps1" -Action Save -Entry "Opis potvrđene promjene i dokaz/provjera."

The script fetches the latest file and its blob SHA immediately before appending,
then commits the update to main. It never stores a token in the script or memory.
Do not put passwords, API keys, private keys, personal secrets, or raw credentials
in the durable context.

## Install the helper

Copy EVA-ExternalMemory.ps1 into %USERPROFILE%\EVA-Automation\.
The helper is deliberately separate from the existing tested Start-Eva.ps1:
it does not replace the launcher, change Task Scheduler, or create duplicate tasks.
For the next integration step, call EVA-ExternalMemory.ps1 -Action Prepare
from the launcher before it pastes/sends the activation prompt.
