#!/usr/bin/env python3
"""
按词频创建多级英语词库。
Google 10000 已按频率排序，#1 是最常见词。
"""
import os

WORDLIST = os.path.expanduser("~/.dvorak_practice/wordlists/english_full.txt")
OUT_DIR  = os.path.expanduser("~/.dvorak_practice/wordlists")

# 梯队阈值：累计包含前N个高频词
TIERS = [
    ("english_tier_1.txt",  500,   "最常用 500 词"),
    ("english_tier_2.txt",  2000,  "最常用 2000 词"),
    ("english_tier_3.txt",  5000,  "最常用 5000 词"),
    ("english_tier_4.txt",  9894,  "全部 9894 词"),
]

def load_words(path):
    words = []
    with open(path) as f:
        for line in f:
            w = line.strip().lower()
            if w and w.isalpha():
                words.append(w)
    return words

def main():
    print("=" * 60)
    print("按词频分级的英语词库生成器")
    print("=" * 60)

    print("\n加载词库...")
    words = load_words(WORDLIST)
    print(f"  共 {len(words)} 个词")

    print("\nTop 20 英语高频词:")
    for i, w in enumerate(words[:20]):
        print(f"  {i+1:>3}. {w}")

    print(f"\n  ...")
    for i, w in enumerate(words[497:503]):
        print(f"  {i+498:>3}. {w}")

    print("\n生成多级词库...")
    for filename, count, desc in TIERS:
        path = os.path.join(OUT_DIR, filename)
        with open(path, "w") as f:
            for w in words[:count]:
                f.write(w + "\n")
        print(f"  {filename}: {count} 词 ({desc})")

    print("\n" + "=" * 60)
    print("每级包含上一级所有词，可用最小词库逐渐增加难度")
    print("=" * 60)

if __name__ == "__main__":
    main()
