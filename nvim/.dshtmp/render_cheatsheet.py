#!/usr/bin/env python3
"""Render hl_dump.json (cheatsheet.cpp) into a PNG cheat sheet."""
import json

from PIL import Image, ImageDraw, ImageFont

DUMP = ".dshtmp/hl_dump.json"
OUT = ".dshtmp/comment_highlight_cheatsheet.png"
FDIR = "/usr/share/fonts/TTF/"
FONTS = {
    (False, False): ImageFont.truetype(FDIR + "JetBrainsMono-Regular.ttf", 15),
    (False, True): ImageFont.truetype(FDIR + "JetBrainsMono-Italic.ttf", 15),
    (True, False): ImageFont.truetype(FDIR + "JetBrainsMono-Bold.ttf", 15),
    (True, True): ImageFont.truetype(FDIR + "JetBrainsMono-BoldItalic.ttf", 15),
}
TITLE = ImageFont.truetype(FDIR + "JetBrainsMono-Bold.ttf", 17)
LEG = ImageFont.truetype(FDIR + "JetBrainsMono-Regular.ttf", 13)

data = json.load(open(DUMP))
BG, DFG = data["bg"], data["fg"]
LINE_H, PAD = 23, 24
CW = FONTS[(False, False)].getlength("M")

lines = [("".join(c["char"] for c in cells), cells) for cells in data["lines"]]
while lines and not lines[-1][0].strip():
    lines.pop()

LEGEND = [
    ("@comment.documentation", "#6A9955", "/** ... */ doc-comment body"),
    ("@comment", "#6A9955", "/*! ... */  ///  //!  //!<  and plain comments"),
    ("@keyword.doxygen", "#7DCFFF", "tag names: @brief @param @return @code ..."),
    ("@variable.parameter.doxygen", "#EFBD5D", "the name right after @param"),
    ("@keyword.modifier.doxygen", "#27A1B9", "[in] [out] [inout] of @param"),
    ("@label.doxygen", "#2AC3DE", "language of @code{.cpp}"),
    ("@tag.doxygen / @markup.italic.doxygen", "#BB9AF7 / #E0AF68", "\\a \\c escapes / \\a emphasis"),
    ("@comment.{todo,error,note,warning}.comment", "#7AA2F7 #F7768E #1ABC9C #E0AF68", "TODO FIXME NOTE WARNING in any comment"),
    ("@number.comment / @string.special.url", "#FF9E64 / #7DCFFF", "#42 issue refs / URLs"),
    ("@tag.html @tag.attribute.html", "#BB9AF7 #73DACA", "<a href=\"...\"> HTML link"),
    ("@function.call @module @type @number (cpp)", "#7AA2F7 #7DCFFF #2AC3DE #FF9E64", "@see foo() / @code block -> real C++"),
]

code_w = int(max(len(t) for t, _ in lines) * CW) + PAD * 2
W = max(code_w + PAD, 980)
H = PAD * 2 + 34 + len(lines) * LINE_H + 20 + len(LEGEND) * 21

img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)
d.text((PAD, PAD), "C/C++ comment highlighting @ tokyonight-night", font=TITLE, fill="#7AA2F7")

y = PAD + 34
for txt, cells in lines:
    x, run, run_key = PAD, "", None

    def flush(xpos, run, key):
        if not run:
            return xpos
        f = FONTS[(bool(key[1]), bool(key[2]))]
        d.text((xpos, y), run, font=f, fill=key[0] or DFG)
        return xpos + f.getlength(run)

    for c in cells:
        key = (c.get("fg") or DFG, bool(c.get("bold")), bool(c.get("italic")))
        if key != run_key:
            if run_key:
                x = flush(x, run, run_key)
            run, run_key = c["char"], key
        else:
            run += c["char"]
    if run:
        flush(x, run, run_key)
    y += LINE_H

y += 6
d.line([(PAD, y), (W - PAD, y)], fill="#2f334d", width=1)
y += 14
d.text((PAD, y), "resolved highlight groups", font=LEG, fill="#565f89")
y += 24
for grp, col, desc in LEGEND:
    d.rectangle([PAD, y + 3, PAD + 11, y + 14], fill=col.split()[0])
    d.text((PAD + 20, y), grp, font=LEG, fill="#c0caf5")
    d.text((PAD + 400, y), desc, font=LEG, fill="#565f89")
    y += 21

img.save(OUT)
print(f"wrote {OUT} ({W}x{H})")
