#!/usr/bin/env python3
import sys, json, base64
data = json.load(sys.stdin)
raw = base64.b64decode(data["content"]).decode()
results = []
for line in raw.split("\n"):
    low = line.lower()
    if "getlivecachedaccuracy" in low or 'getcachedaccuracy' in low:
        results.append("LIVE: " + line.strip())
    if "accura" in low and ("correct" in low or "incorrect" in low or "=" in low):
        results.append("ACC: " + line.strip())
    if "correctchars" in low or "incorrectchars" in low or "correctwords" in low:
        results.append("CHARS: " + line.strip())
    if low.strip().startswith("accuracy"):
        results.append("DEF: " + line.strip())
for r in results[:30]:
    print(r)
