import pathlib
import re

root = pathlib.Path.home() / "eva"
pattern = re.compile(r"""(?i)(api[_-]?key|secret|token|password)\s*[:=]\s*(['"])(.{8,}?)\2""")

found = False
for f in root.rglob("*.py"):
    if "__pycache__" in str(f):
        continue
    for i, line in enumerate(f.read_text(errors="ignore").splitlines(), 1):
        if pattern.search(line):
            print(f"MOGUCA TAJNA: {f.name}, redak {i}")
            found = True

if not found:
    print("Nema pronadjenih ocitih tvrdokodiranih tajni.")
