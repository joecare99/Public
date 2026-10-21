import os
import sys
sys.path.insert(0, 'FPC/tools')
import gen_projects as g

folder = 'MEMOPAD'
d = os.path.join(g.SRC, folder)
print('SRC:', g.SRC)
print('dir:', d, 'isdir:', os.path.isdir(d))
try:
    print('listdir:', os.listdir(d))
except Exception as e:
    print('Fehler:', e)
for name in os.listdir(d) if os.path.isdir(d) else []:
    if name.lower().endswith('.pas'):
        p = os.path.join(folder, name)
        print('unit_name_of_file:', p, '->', g.unit_name_of_file(p))
