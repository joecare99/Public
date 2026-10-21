import sys
sys.path.insert(0, 'FPC/tools')
import gen_projects as g

name = sys.argv[1]
with open('FPC/%s.dpr' % name, 'r', encoding='utf-8', errors='replace') as fh:
    text = fh.read()
uses = g.parse_uses(text)
print('uses:', uses)
folders = []
referenced = set()
for uname, upath in uses:
    if upath:
        f = g.folder_of_source_path(upath)
        f = g.resolve_folder(f) or f
        if f and f not in folders:
            folders.append(f)
        referenced.add(uname.lower())
print('Ordner:', folders, 'referenziert:', referenced)
for f in folders:
    units = g.collect_units(f, referenced)
    for u in units:
        print('  Unit:', u['name'], 'referenced=', u['referenced'], u['path'])
