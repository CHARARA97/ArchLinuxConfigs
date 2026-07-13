#!/usr/bin/env python3
import sys, json, base64
data = json.load(sys.stdin)
raw = base64.b64decode(data["content"]).decode()
for line in raw.split("\n"):
    low = line.lower()
    if ("accura" in low) and ("correct" in low or "=" in low):
        print(line.strip())
print("---")
for line in raw.split("\n"):
    low = line.lower()
    if "calcresult" in low or "setresult" in low or "getresult" in low:
        print(line.strip())
