#!/usr/bin/env python3
"""
英语高频词 n-gram 分析工具
分析 Google 10000 英语词频列表中最常见的 n 字母组合。
"""
import sys
import os
from collections import Counter

WORDLIST = os.path.expanduser("~/.dvorak_practice/wordlists/english_full.txt")

def load_words(path, max_words=5000):
    """加载词库，只保留纯字母词（小写）。"""
    words = []
    with open(path) as f:
        for i, line in enumerate(f):
            if i >= max_words:
                break
            word = line.strip().lower()
            if word and word.isalpha():
                words.append(word)
    return words

def get_ngrams(word, n):
    """提取一个词中所有连续的 n-gram。"""
    return [word[i:i+n] for i in range(len(word) - n + 1)]

def analyze(words, max_n=6, top_k=30):
    """
    分析最常见的 n-gram。
    词频越高权重越大（位置编号作为权重）。
    """
    results = {}
    for n in range(2, max_n + 1):
        counter = Counter()
        for rank, word in enumerate(words):
            weight = max(1, len(words) - rank)  # 高频词权重高
            for ng in get_ngrams(word, n):
                counter[ng] += weight

        total = sum(counter.values())
        most_common = counter.most_common(top_k)

        results[n] = {
            "total_ngrams": total,
            "unique_ngrams": len(counter),
            "top": most_common,
        }
    return results

def print_report(results):
    """打印分析报告。"""
    print("=" * 70)
    print("英语高频词 n-gram 分析报告")
    print("=" * 70)

    for n in sorted(results.keys()):
        r = results[n]
        print(f"\n{'─' * 70}")
        print(f"【{n}-gram】共 {r['unique_ngrams']} 种不同组合，总计 {r['total_ngrams']} 次出现")
        print(f"{'─' * 70}")
        print(f"{'排名':>4}  {'组合':>6}  {'出现次数':>10}  {'占比':>8}  {'累积占比':>8}")
        print(f"{'─' * 40}")
        cumulative = 0
        for i, (ng, count) in enumerate(r["top"]):
            pct = count / r["total_ngrams"] * 100
            cumulative += pct
            print(f"{i+1:>4}  '{ng:>4}'  {count:>10}  {pct:>7.2f}%  {cumulative:>7.2f}%")

def print_word_suggestions(words, results, n=3, top=10):
    """
    根据最常见的 n-gram 找出包含它们的示例词。
    """
    top_ngrams = [ng for ng, _ in results[n]["top"][:top]]
    print(f"\n{'=' * 70}")
    print(f"包含最常见 {n}-gram 的示例词")
    print(f"{'=' * 70}")

    # 对每个 top n-gram，找 3 个示例词
    for ng in top_ngrams:
        examples = [w for w in words if ng in w][:3]
        if examples:
            print(f"  '{ng}': {', '.join(examples)}")

    print(f"\n{'=' * 70}")
    print("建议：选中以上这些 n-gram 对应的字符集，用词库模式练习最常用组合")
    print("=" * 70)


if __name__ == "__main__":
    import os

    if not os.path.exists(WORDLIST):
        print(f"错误：找不到词库文件 {WORDLIST}")
        sys.exit(1)

    print(f"正在分析 {WORDLIST} ...")
    words = load_words(WORDLIST, max_words=5000)
    print(f"已加载 {len(words)} 个词")

    results = analyze(words, max_n=5, top_k=30)
    print_report(results)
    print_word_suggestions(words, results, n=3, top=10)
