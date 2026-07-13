#!/usr/bin/env python3
"""
创建多级英语 n-gram 词库。
按 n-gram 组合的常见程度将词分为多个梯队，每个梯队包含上一梯队所有词。
"""
import os, sys
from collections import Counter, defaultdict

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
    """返回一个词中所有 n-gram (去重)。"""
    ngrams = set()
    for n in range(min_n, max_n + 1):
        for i in range(len(word) - n + 1):
            ngrams.add(word[i:i+n])
    return ngrams

def score_ngrams(words):
    """统计每个 n-gram 的出现次数（加权：高频词权重高）。"""
    counter = Counter()
    for rank, word in enumerate(words):
        weight = max(1, len(words) - rank)  # #1 词权重最高
        for ng in get_ngrams(word):
            counter[ng] += weight
    return counter

def word_score(word, ng_scores):
    """
    计算一个词的 n-gram 稀有度评分。
    分数越高 = 这个词包含的 n-gram 越罕见。
    """
    total = 0
    count = 0
    for ng in get_ngrams(word):
        if ng in ng_scores:
            # 用负对数转换：高频 n-gram 贡献小，低频贡献大
            total += 1.0 / ng_scores[ng]
            count += 1
    return total / max(count, 1)

def create_tiered_wordlists(words, ngram_counter, num_tiers=5):
    """
    创建多级词库。
    策略：将 n-gram 按频率排序后均分到 num_tiers 个梯队。
    Tier 1 = 最常见的 n-gram 对应的词
    Tier 2 = Tier 1 + 次常见 n-gram 对应的词
    ...
    """
    # 按频率排序所有 n-gram
    sorted_ngrams = [ng for ng, _ in ngram_counter.most_common()]

    # 均分到梯队
    tier_size = len(sorted_ngrams) // num_tiers + 1
    tier_ngrams = []
    for t in range(num_tiers):
        start = t * tier_size
        end   = min((t + 1) * tier_size, len(sorted_ngrams))
        tier_ngrams.append(set(sorted_ngrams[start:end]))

    # 每个梯队 = 包含该梯队或更高梯队中任意 n-gram 的词
    # Tier 1 只包含 Tier 1 的 n-gram
    # Tier 2 包含 Tier 1 + Tier 2 的 n-gram
    # 以此类推

    tiers = []
    cumulative_ngrams = set()
    for t in range(num_tiers):
        cumulative_ngrams |= tier_ngrams[t]
        # 找出包含 cumulative_ngrams 中任意 n-gram 的词
        matched = []
        for w in words:
            w_ngrams = get_ngrams(w)
            if w_ngrams & cumulative_ngrams:  # 有交集
                matched.append(w)
        tiers.append(matched)
        print(f"  Tier {t+1}: {len(matched)} 个词 ({len(tier_ngrams[t])} 种新 n-gram)")

    return tiers

def save_tiers(tiers, out_dir):
    """保存每个梯队为单独的文件。"""
    names = []
    for i, tier_words in enumerate(tiers):
        filename = f"ngram_tier_{i+1}.txt"
        path = os.path.join(out_dir, filename)
        with open(path, "w") as f:
            for w in tier_words:
                f.write(w + "\n")
        names.append(filename)
        print(f"  已保存: {filename} ({len(tier_words)} 词)")
    return names

def print_samples(tiers):
    """打印每个梯队的样本词。"""
    for i, tw in enumerate(tiers):
        print(f"\n  Tier {i+1} 样本 (前20):")
        for w in tw[:20]:
            print(f"    {w}")

def main():
    print("=" * 60)
    print("多级 n-gram 英语词库生成器")
    print("=" * 60)

    # 1. 加载词库
    print("\n[1/4] 加载词库...")
    words = load_words(WORDLIST)
    print(f"  已加载 {len(words)} 个词")

    # 2. 统计 n-gram 频率
    print("\n[2/4] 统计 n-gram 频率...")
    ngram_counter = score_ngrams(words)
    print(f"  共发现 {len(ngram_counter)} 种 n-gram 组合")

    # 打印 top 20
    print("\n  Top 20 n-gram:")
    for i, (ng, cnt) in enumerate(ngram_counter.most_common(20)):
        print(f"    {i+1:>3}. '{ng}' (x{cnt})")

    # 3. 创建多级词库
    print("\n[3/4] 创建多级词库...")
    num_tiers = 5
    tiers = create_tiered_wordlists(words, ngram_counter, num_tiers)

    # 4. 保存
    print("\n[4/4] 保存文件...")
    filenames = save_tiers(tiers, OUT_DIR)

    # 样本
    print("\n" + "=" * 60)
    print("各梯队样本:")
    print_samples(tiers)

    print("\n" + "=" * 60)
    print("使用建议:")
    print(f"  选择最小的梯队文件开始练习 (ngram_tier_1.txt)")
    print(f"  逐步升级到更大的梯队 (tier_2, tier_3, ...)")
    print(f"  Tier 1 的词包含最常见的组合，Tier 5 包含最冷门的组合")
    print("=" * 60)

if __name__ == "__main__":
    main()
