#!/usr/bin/env python3
# Add "italic" to the doxygen language-specific highlight groups in tokyonight.lua
import re
import sys

path = "lua/plugins/config/tokyonight.lua"
src = open(path, encoding="utf-8").read()

# only lines that define a @xxx.doxygen group and do not already carry a style list
pat = re.compile(r'^(?P<head>\s*hl\["@[A-Za-z.]+\.doxygen"\]\s+= S\( C\.\w+)(?P<tail>\s*\)(\s*--.*)?)$', re.M)


def repl(m):
    return m.group("head") + ", italic" + m.group("tail")


new, n = pat.subn(repl, src)
print(f"patched {n} lines")
if n != 10:
    print("unexpected count, aborting", file=sys.stderr)
    sys.exit(1)
open(path, "w", encoding="utf-8").write(new)
