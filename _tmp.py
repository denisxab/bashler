import json
from pathlib import Path
import os

p_AUTORUN_BASHLER = Path(os.environ["AUTORUN_BASHLER"])

r = json.loads(p_AUTORUN_BASHLER.read_text())
res = ""
for script in r:
    res += '\"%s\" ' % script
print(res)