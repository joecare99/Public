"""Wandelt die Shell-Skripte unter FPC/tools in Unix-Zeilenenden (LF).

Die Dateien wurden mit Windows-Zeilenenden gespeichert; unter Linux
bricht die Shell daran ab.
"""

import glob
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))

for path in glob.glob(os.path.join(ROOT, 'FPC', 'tools', '*.sh')):
    with open(path, 'rb') as fh:
        data = fh.read()
    new = data.replace(b'\r\n', b'\n')
    if new != data:
        with open(path, 'wb') as fh:
            fh.write(new)
        print('Unix-Zeilenenden:', os.path.basename(path))
