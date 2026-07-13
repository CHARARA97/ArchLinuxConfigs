#!/usr/bin/env python3
"""Generate word list files for DVP practice."""
import os

WORDLIST_DIR = os.path.expanduser("~/.dvorak_practice/wordlists")
os.makedirs(WORDLIST_DIR, exist_ok=True)


def write_list(filename, words):
    path = os.path.join(WORDLIST_DIR, filename)
    with open(path, "w") as f:
        for w in words:
            f.write(w + "\n")
    print(f"  {filename}: {len(words)} words")


# ── English high frequency (~500 words) ──
ENGLISH_500 = """the be to of and a in that have i it for not on with he as you do at this but his
by from they we her she or an will my one all would there their what so up out if about
who get which go me when make can like time no just him know take people into year your
good some could them see other than then now look only come its over think also back after
use two how our work first well way even new want because any these give day most us
great between need yet without those before may find here far long thing same many say
must until place world small under home read still should own page right big every man
never such last why ask woman hand much keep hold call down stand draw line left city
put close old night next run open case country walk turn few group state high show life
car done white sea hard began air body set around point power mean child real change
among woman course face young week door mind during end wide upon voice land side once
enough head yet system order plan product program business early money service meet
market company provide water food education health care system number name add even
land different size sentence follow community across road possible learn general top
across travel common poor simple past special free race fact note idea million develop
read allow level short class play area example teach letter talk book start best city
press hear music student study center hour game force bring close train fish stop process
deep party picture student form office community able early build center natural live
current ready stay real clear group design special base music color record section field
complete result heavy language sense surface age practice warm color draw cover sign
animal object rule step learn create strong hair foot material simple length subject
region total cell arm neck fight rest wear store page oil include list table animal""".split()

# ── Programming language keywords ──

C_CPP = """auto break case char const continue default do double else enum extern float for
goto if int long register return short signed sizeof static struct switch typedef union
unsigned void volatile while include define undef ifdef ifndef endif line error pragma
class namespace template friend virtual override public private protected this throw
catch try new delete operator bool true false nullptr string vector map set list pair
printf scanf malloc calloc realloc free sizeof typedef constexpr noexcept alignas
alignof decltype static_cast dynamic_cast const_cast reinterpret_cast""".split()

PYTHON = """False None True and as assert async await break class continue def del elif
else except finally for from global if import in is lambda nonlocal not or pass raise
return try while with yield print len range int str float list dict set tuple input
open write read append sort map filter zip enumerate reversed sorted any all min max
sum abs round isinstance hasattr getattr setattr str repr format join split replace
strip lower upper title capitalize count find index""".split()

JAVA = """abstract assert boolean break byte case catch char class const continue default
do double else enum extends final finally float for goto if implements import instanceof
int interface long native new package private protected public return short static
strictfp super switch synchronized this throw throws transient try void volatile while
true false null String System out println print printf Scanner ArrayList HashMap
Integer Double Math""".split()

JAVASCRIPT = """async await break case catch class const continue debugger default delete
do else export extends finally for function if import in instanceof let new of return
super switch this throw try typeof var void while with yield true false null undefined
NaN Infinity console log error warn array map filter reduce forEach find includes push
pop shift unshift splice slice split join length toString""".split()

RUST = """as async await break const continue crate dyn else enum extern fn for if impl
in let loop match mod move mut pub ref return self static struct super trait type
union unsafe use where while true false Some None Ok Err Box Vec String println
format macro cfg feature allow deny warn""".split()

GO = """break case chan const continue default defer else fallthrough for func go goto
if import interface map package range return select struct switch type var true false
nil string int float64 bool byte error make len cap append copy close delete panic
recover print println printf fmt""".split()

# Common Dvorak-friendly identifiers (lowercase, no symbols)
DVP_IDEAL = """the and for are not you all can had her was one but our out she has its how
get let set use try new run end big old did ago man men ask put got hot red sad top
bit box bus car cup day dog dry ear eye fat fun gas gun hat ice ink jar job key lap
law lay leg let lip log lot map mix net nod nor nut odd oil old one our out own pan
pat paw pen pet pie pig pin pit pot pup rag ram ran rat raw red rib rid rig rim rod
row rub rug run rut sad sat saw say sea set sew she sin sip sit six ski sky sly sob
son sow spy sun tab tag tan tap tar tax tea ten the tie tin tip toe ton too top tow
toy tub tug two urn use van vat vet vow wad wag war was wax way wet who why win wit
woe yak yam yap yaw yen yes yet zig zip zoo""".split()


def main():
    print("Generating wordlists...")
    write_list("english_500.txt", ENGLISH_500)
    write_list("c_cpp.txt", C_CPP)
    write_list("python.txt", PYTHON)
    write_list("java.txt", JAVA)
    write_list("javascript.txt", JAVASCRIPT)
    write_list("rust.txt", RUST)
    write_list("go.txt", GO)
    write_list("dvp_ideal.txt", DVP_IDEAL)
    print(f"\nAll files saved to {WORDLIST_DIR}/")
    print(f"Total unique words: {len(set(ENGLISH_500 + C_CPP + PYTHON + JAVA + JAVASCRIPT + RUST + GO + DVP_IDEAL))}")


if __name__ == "__main__":
    main()
