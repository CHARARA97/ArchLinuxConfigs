#!/usr/bin/env python3
"""Download and process wordlists from the internet, then generate programming keyword files."""
import os
import re
import shutil

WORDLIST_DIR = os.path.expanduser("~/.dvorak_practice/wordlists")
os.makedirs(WORDLIST_DIR, exist_ok=True)

def save_file(filename, text):
    path = os.path.join(WORDLIST_DIR, filename)
    with open(path, "w") as f:
        f.write(text)
    words = text.strip().split("\n")
    print(f"  {filename}: {len(words)} words")

# ── 1. English: use downloaded Google 10000 (short, no swears) ──
SRC = "/tmp/google-10000-english/google-10000-english-usa-no-swears-short.txt"
if os.path.exists(SRC):
    shutil.copy2(SRC, os.path.join(WORDLIST_DIR, "english_short.txt"))
    with open(SRC) as f:
        n = len(f.readlines())
    print(f"  english_short.txt: {n} words (from Google 10000)")
else:
    print("  WARN: Google 10000 not found, using fallback")

SRC2 = "/tmp/google-10000-english/google-10000-english-no-swears.txt"
if os.path.exists(SRC2):
    shutil.copy2(SRC2, os.path.join(WORDLIST_DIR, "english_full.txt"))
    with open(SRC2) as f:
        n = len(f.readlines())
    print(f"  english_full.txt: {n} words (from Google 10000)")

# Clean up downloaded repo
shutil.rmtree("/tmp/google-10000-english", ignore_errors=True)

# ── 2. Programming language keywords ──
# Generated from official language specifications

# C (C11/C17 standard keywords)
C_KEYWORDS = """auto break case char const continue default do double else enum extern float for goto if int long register return short signed sizeof static struct switch typedef union unsigned void volatile while _Alignas _Alignof _Atomic _Bool _Complex _Generic _Imaginary _Noreturn _Static_assert _Thread_local inline restrict""".split()

# C++ (C++17 keywords)
CPP_KEYWORDS = """alignas alignof and and_eq asm auto bitand bitor bool break case catch char char8_t char16_t char32_t class compl concept const consteval constexpr const_cast continue co_await co_return co_yield decltype default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new noexcept not not_eq nullptr operator or or_eq override private protected public register reinterpret_cast requires return short signed sizeof static static_assert static_cast struct switch template this thread_local throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while xor xor_eq""".split()

# Python 3 keywords
PYTHON_KEYWORDS = """False None True and as assert async await break class continue def del elif else except finally for from global if import in is lambda nonlocal not or pass raise return try while with yield""".split()

# Python built-in functions (commonly used)
PYTHON_BUILTINS = """abs all any ascii bin bool breakpoint bytearray bytes callable chr classmethod compile complex delattr dict dir divmod enumerate eval exec filter float format frozenset getattr globals hasattr hash hex id input int isinstance issubclass iter len list locals map max memoryview min next object oct open ord pow print property range repr reversed round set setattr slice sorted staticmethod str sum super tuple type vars zip""".split()

# Java keywords
JAVA_KEYWORDS = """abstract assert boolean break byte case catch char class const continue default do double else enum extends final finally float for goto if implements import instanceof int interface long native new package private protected public return short static strictfp super switch synchronized this throw throws transient try void volatile while true false null""".split()

# Java common built-in classes
JAVA_COMMON = """String System Object Integer Double Boolean Long Float Short Byte Character Math Arrays Collections List ArrayList LinkedList Set HashSet Map HashMap TreeMap LinkedHashMap StringBuffer StringBuilder Pattern Matcher""".split()

# JavaScript/TypeScript keywords
JS_KEYWORDS = """async await break case catch class const continue debugger default delete do else export extends finally for function if import in instanceof let new of return super switch this throw try typeof var void while with yield true false null undefined""".split()

# JS global objects
JS_GLOBALS = """Array BigInt Boolean Date Error Function Infinity JSON Map Math NaN Number Object Promise RegExp Set String Symbol TypeError console clearInterval clearTimeout setInterval setTimeout window document""".split()

# Rust keywords
RUST_KEYWORDS = """as async await break const continue crate dyn else enum extern false fn for if impl in let loop match mod move mut pub ref return self Self static struct super trait true type union unsafe use where while""".split()

# Go keywords
GO_KEYWORDS = """break case chan const continue default defer else fallthrough for func go goto if import interface map package range return select struct switch type var true false""".split()

# Go built-in types/functions
GO_BUILTINS = """append bool byte cap clear close complex copy delete error false float32 float64 imag int int8 int16 int32 int64 len make new panic print println real recover string true uint uint8 uint16 uint32 uint64 uintptr nil iota""".split()

# ── Save all ──
save_file("c_keywords.txt", "\n".join(sorted(set(C_KEYWORDS))))
save_file("cpp_keywords.txt", "\n".join(sorted(set(CPP_KEYWORDS))))
save_file("python_keywords.txt", "\n".join(sorted(set(PYTHON_KEYWORDS + PYTHON_BUILTINS))))
save_file("java_keywords.txt", "\n".join(sorted(set(JAVA_KEYWORDS + JAVA_COMMON))))
save_file("javascript_keywords.txt", "\n".join(sorted(set(JS_KEYWORDS + JS_GLOBALS))))
save_file("rust_keywords.txt", "\n".join(sorted(set(RUST_KEYWORDS))))
save_file("go_keywords.txt", "\n".join(sorted(set(GO_KEYWORDS + GO_BUILTINS))))

print("\nDone! All wordlists in ~/.dvorak_practice/wordlists/")
