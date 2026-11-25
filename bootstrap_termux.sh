#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
EVA_DIR="$HOME/eva"
mkdir -p "$EVA_DIR/state"
command -v python3 >/dev/null 2>&1 || { echo "NEDOSTAJE: python3"; echo "Pokreni: pkg install python"; exit 2; }
command -v sshd >/dev/null 2>&1 || { echo "NEDOSTAJE: sshd"; echo "Pokreni: pkg install openssh"; exit 2; }
cp "$(dirname "$0")/eva_state.py" "$EVA_DIR/eva_state.py"
chmod 700 "$EVA_DIR/eva_state.py"
python3 "$EVA_DIR/eva_state.py" init
python3 "$EVA_DIR/eva_state.py" verify
echo "EVA_TERMUX_READY"
echo "Sljedece: postavi SSH authorized_keys i pokreni: sshd -p 8022"
