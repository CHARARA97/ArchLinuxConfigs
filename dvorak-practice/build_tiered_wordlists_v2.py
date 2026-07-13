#!/usr/bin/env python3
"""
创建多级 n-gram 英语词库。
策略：每个词按它包含的 n-gram 常见程度评分，
得分越高的词越值得优先练。
"""
import os, sys
from collections import Counter

WORDLIST = os.path.expanduser("~/.dvorak_practice/wordlists/english_full.txt")
OUT_DIR  = os.path.expanduser("~/.dvorak_practice/wordlists")

def load_words(path, max_words=10000):
    words = []
    with open(path) as f:
        for i, line in enumerate(f):
            if i >= max_words: break
            w = line.strip().lower()
            if w and w.isalpha():
                words.append(w)
    return words

def get_ngrams(word, min_n=2, max_n=5):
    ngrams = set()
    for n in range(min_n, max_n + 1):
        for i in range(len(word) - n + 1):
            ngrams.add(word[i:i+n])
    return ngrams

def build_ngram_rank(words):
    """统计 n-gram 频率并排名。"""
    counter = Counter()
    for rank, word in enumerate(words):
        weight = max(1, len(words) - rank)
        for ng in get_ngrams(word):
            counter[ng] += weight
    # 排名表：n-gram → 频率排名 (1 = 最常见)
    sorted_ngs = [ng for ng, _ in counter.most_common()]
    return {ng: i+1 for i, ng in enumerate(sorted_ngs)}, len(sorted_ngs)

def score_word(word, ng_rank, total_ngrams, word_rank=5000):
    """
    词评分：n-gram 常见度 × 词的常见度。
    """
    seen = set()
    total = 0.0
    for ng in get_ngrams(word):
        if ng in seen: continue
        seen.add(ng)
        rank = ng_rank.get(ng, total_ngrams)
        total += 1.0 / rank
    ng_score = total / max(len(seen), 1)
    # 词频权重：高频词（rank 小）获得乘数加成
    freq_weight = max(0.1, 1.0 - word_rank / 10000)
    return ng_score * 10000 + freq_weight * 100

def main():
    print("=" * 60)
    print("多级 n-gram 英语词库生成器 v2")
    print("=" * 60)

    print("\n[1/4] 加载词库...")
    words = load_words(WORDLIST)
    print(f"  已加载 {len(words)} 个词")

    print("\n[2/4] 统计 n-gram 频率排名...")
    ng_rank, total_ng = build_ngram_rank(words)
    print(f"  共 {total_ng} 种 n-gram")

    print(f"\n  Top 15 n-gram:")
    for i, w in enumerate(["the", "of", "and", "to", "in"]):
        for ng in sorted(get_ngrams(w), key=lambda x: ng_rank.get(x, 99999))[:3]:
            print(f"    '{ng}' rank={ng_rank.get(ng,'?')}")
        if i < 4: print()

    print("\n[3/4] 评分所有词...")
    scored = [(score_word(w, ng_rank, total_ng, rank), w) for rank, w in enumerate(words)]
    scored.sort(key=lambda x: (-x[0], x[1]))  # 高分在前

    # 打印 Top 20 高分词
    print(f"\n  Top 20 高分词 (含最多常见 n-gram):")
    for s, w in scored[:20]:
        print(f"    {s:>8.2f}  {w}")

    print(f"\n  最低分 10 个词 (含最多稀有 n-gram):")
    for s, w in scored[-10:]:
        print(f"    {s:>8.2f}  {w}")

    # 按百分比分 5 个梯队
    print("\n[4/4] 创建多级词库...")
    num_tiers = 5
    tiers = []
    for t in range(num_tiers):
        cut = (t + 1) * len(scored) // num_tiers
        tier_words = [w for _, w in scored[:cut]]
        tiers.append(tier_words)

    for t, tw in enumerate(tiers):
        filename = f"ngram_tier_{t+1}.txt"
        path = os.path.join(OUT_DIR, filename)
        with open(path, "w") as f:
            for w in tw:
                f.write(w + "\n")
        print(f"  {filename}: {len(tw)} 词")

    # 打印各梯队样本
    for t, tw in enumerate(tiers):
        print(f"\n  Tier {t+1} (前15):")
        for w in tw[:15]:
            print(f"    {w}")

    print("\n" + "=" * 60)
    print("使用建议:")
    print(f"  Tier 1 = 最常见组合的词（最值得先练）")
    print(f"  Tier 5 = 包含许多罕见组合的词")
    print(f"  每个梯队都包含前面所有梯队的词")
    print("=" * 60)

if __name__ == "__main__":
    main()
