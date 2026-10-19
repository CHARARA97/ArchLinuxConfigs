#!/usr/bin/env python3
"""Render the resolved treesitter highlight dump (hl_dump.json) into a PNG preview."""
import json

from PIL import Image, ImageDraw, ImageFont

DUMP = ".dshtmp/hl_dump.json"
OUT = ".dshtmp/doxygen_palette.png"

FDIR = "/usr/share/fonts/TTF/"
FONTS = {
    (False, False): ImageFont.truetype(FDIR + "JetBrainsMono-Regular.ttf", 15),
    (False, True): ImageFont.truetype(FDIR + "JetBrainsMono-Italic.ttf", 15),
    (True, False): ImageFont.truetype(FDIR + "JetBrainsMono-Bold.ttf", 15),
    (True, True): ImageFont.truetype(FDIR + "JetBrainsMono-BoldItalic.ttf", 15),
}
TITLE_FONT = ImageFont.truetype(FDIR + "JetBrainsMono-Bold.ttf", 17)
LEGEND_FONT = ImageFont.truetype(FDIR + "JetBrainsMono-Regular.ttf", 13)

data = json.load(open(DUMP))
BG = data["bg"]
DFG = data["fg"]
LINE_H = 23
PAD = 24
CHAR_W = FONTS[(False, False)].getlength("M")

lines = []
for cells in data["lines"]:
    txt = "".join(c["char"] for c in cells)
    lines.append((txt, cells))
# drop trailing empty lines
while lines and not lines[-1][0].strip():
    lines.pop()

LEGEND = [
    ("@keyword.doxygen", "#7DCFFF", "tag names: @brief @param @return @code ..."),
    ("@variable.parameter.doxygen", "#EFBD5D", "the name after @param"),
    ("@label.doxygen", "#2AC3DE", "code-block language: @code{.cpp}"),
    ("@tag.doxygen", "#BB9AF7", "escapes: \\a  \\c"),
    ("@markup.italic.doxygen", "#E0AF68", "emphasis: @em / <em>...</em>"),
    ("@keyword.modifier.doxygen", "#27A1B9", "@param[in] / [out] modifiers"),
    ("@punctuation.*.doxygen", "#6A9955", "punctuation inside the comment"),
    ("@operator.doxygen", "#6A9955", "operators inside the comment"),
    ("@comment.documentation", "#6A9955", "doc-comment body (unchanged)"),
]

code_w = int(max(len(t) for t, _ in lines) * CHAR_W) + PAD * 2
legend_w = 560
W = max(code_w + legend_w + PAD, 900)
H = PAD * 2 + 34 + len(lines) * LINE_H + PAD + len(LEGEND) * 20

img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)

d.text((PAD, PAD), "tokyonight-night  x  doxygen (C/C++ doc comments)", font=TITLE_FONT, fill="#7AA2F7")
y = PAD + 34
for txt, cells in lines:
    x = PAD
    run, run_key = "", None

    def flush(xpos, run, key):
        if not run:
            return xpos
        f = FONTS[(bool(key[1]), bool(key[2]))]
        d.text((xpos, y), run, font=f, fill=key[0] or DFG)
        return xpos + f.getlength(run)

    for c in cells:
        key = (c.get("fg") or DFG, bool(c.get("bold")), bool(c.get("italic")))
        if key != run_key:
            x = flush(x, run, run_key) if run_key else x
            run, run_key = c["char"], key
        else:
            run += c["char"]
    if run:
        flush(x, run, run_key)
    y += LINE_H

y += 8
d.line([(PAD, y), (W - PAD, y)], fill="#2f334d", width=1)
y += 14
d.text((PAD, y), "resolved highlight groups (fg from :hi @xxx.doxygen)", font=LEGEND_FONT, fill="#565f89")
y += 22
for grp, col, desc in LEGEND:
    d.rectangle([PAD, y + 3, PAD + 11, y + 14], fill=col)
    d.text((PAD + 20, y), grp, font=LEGEND_FONT, fill=col)
    d.text((PAD + 300, y), desc, font=LEGEND_FONT, fill="#565f89")
    y += 20

img.save(OUT)
print(f"wrote {OUT} ({W}x{H})")
