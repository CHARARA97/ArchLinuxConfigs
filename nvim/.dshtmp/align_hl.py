#!/usr/bin/env python3
# Re-align the trailing comments of the doxygen block in tokyonight.lua
import re

path = "lua/plugins/config/tokyonight.lua"
lines = open(path, encoding="utf-8").read().split("\n")

line_re = re.compile(r'^(?P<indent>\s*)hl\["(?P<grp>@[A-Za-z.]+\.doxygen)"\]\s*=\s*(?P<val>.*?)(?:\s+--\s*(?P<cmt>.*))?$')

targets = [(i, m) for i, l in enumerate(lines) if (m := line_re.match(l))]
if not targets:
    raise SystemExit("no doxygen lines found")

namew = max(len('hl["%s"]' % m.group("grp")) for _, m in targets)
valw = max(len(m.group("val")) for _, m in targets)

for i, m in targets:
    name = 'hl["%s"]' % m.group("grp")
    val = m.group("val")
    out = f'{m.group("indent")}{name.ljust(namew)} = {val.ljust(valw)}'
    if m.group("cmt"):
        out += f'  -- {m.group("cmt")}'
    lines[i] = out.rstrip()

open(path, "w", encoding="utf-8").write("\n".join(lines))
print(f"re-aligned {len(targets)} lines (namew={namew}, valw={valw})")
