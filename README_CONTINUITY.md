# EVA Continuity Store

`eva_state.py` is the local SQLite persistence/queue layer for EVA's task and cycle state. It does not call an AI provider and never executes task text as shell commands.

## 1. Android / Termux setup

In Termux:

```bash
pkg update
pkg install python openssh
```

Download or clone this repository into a folder, then from that folder run:

```bash
bash ./bootstrap_termux.sh
```

The bootstrap installs the store at `~/eva/eva_state.py`, creates its state directory and database, and runs an integrity check.

## 2. Create the Windows SSH key

In PowerShell, from the repository folder:

```powershell
.\setup_ssh.ps1
```

Copy the displayed **public** key line. Never copy or share the private key.

In Termux, paste the public key in this command (replace the placeholder with the complete key line):

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo 'ssh-ed25519 AAAA... eva-bridge-windows' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
sshd -p 8022
```

Keep Termux and the phone awake during the test. The phone and Windows PC must be on the same reachable network. Find the phone's current Wi-Fi IP in Android/Termux; do not assume an old IP is still valid.

## 3. Windows local config and test

Copy `bridge.local.example.json` to `bridge.local.json`. Set:
- `host`: current Android Wi-Fi IP
- `port`: `8022`
- `user`: output of `whoami` in Termux
- `key_path`: full Windows path to `eva_ed25519`

Then run:

```powershell
.\bridge_test.ps1
.\bridge.ps1 status
.\bridge.ps1 list
.\bridge.ps1 wake
.\bridge.ps1 history
```

A successful `bridge_test.ps1` ends with `EVA_END_TO_END_OK`. That is the proof of Windows -> SSH -> Termux -> Python -> SQLite.

## Local smoke test (without SSH)

```powershell
python .\eva_state.py init
python .\eva_state.py add "Test continuity" --priority 100 --next-action "Run verify"
python .\eva_state.py wake
python .\eva_state.py list
python .\eva_state.py verify
python .\eva_state.py history
```

Database default: `~/eva/state/eva_continuity.sqlite3`. Override with `EVA_STATE_DB` or `--db` before the subcommand.
