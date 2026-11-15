"""
E006 / W016 -- search the OEIS for every sequence computed in Part 1.
Saves raw JSON to references/raw/w016_search_*.json; prints a compact report.

Author: Kimi K3.1 Pro (AI, via Open Math OS), 2026-11-13. Not human-reviewed.
Rate: one request per 1.1 s. Generic User-Agent.
"""
import json
import time
from pathlib import Path
from fetch_oeis import fetch, results_of

# name -> comma-separated initial terms to search (as returned by run.py)
QUERIES = [
    # class counts
    ("classes_p2_k1", "1,1,2,3,6,11,23,46,98,207,451"),
    ("classes_p3_k1", "1,1,2,5,11,28,74,199"),
    ("classes_p5_k1", "1,1,3,9,30,107"),
    ("classes_p7_k1", "1,1,4,15,62"),
    ("classes_p2_k2", "1,1,3,6,17,44,129"),
    ("classes_p3_k2", "1,1,3,11,37"),
    ("classes_p2_k3", "1,1,4,10,36"),
    # minimal class counts (shifted: n=1..N)
    ("nmin_p2_k1", "1,1,1,1,1,3,1,1,1,3,1"),
    ("nmin_p3_k1", "1,1,1,1,1,2,1,10"),
    ("nmin_p5_k1", "1,1,2,2,1,1"),
    ("nmin_p7_k1", "1,1,3,5,5"),
    ("nmin_p3_k2", "1,1,1,1,2"),
    # triangles p=2 (read rows d=0,1,..,n-1) and columns
    ("tri_p2_flat", "1,1,1,1,1,1,1,1,1,2,3,1,1,1,2,2,3,2,1"),
    ("tri_p2_col2", "1,1,2,3,1,1,3,3,2"),
    # triangles p=3
    ("tri_p3_flat", "1,1,1,2,1,1,3,3,1,1,3,6,1"),
    ("tri_p3_col2", "1,3,3,2,6,10"),
    # labelled counts T(t) = (pt)!/(t! p^t)
    ("labelled_p2", "1,3,15,105,945,10395,135135,2027025"),
    ("labelled_p3", "2,40,2240,246400,44844800,12197785600"),
    ("labelled_p5", "24,72576,1743565824,162193467211776"),
    # unblocked classes by number of leaves
    ("byleaves_p2", "1,1,1,2,3,6,11,23,46,98,207"),
    ("byleaves_p3", "1,0,1,1,2,2,5,6,13"),
]

KEYWORDS = ("chem", "alkyl", "stereo", "phylogen", "evolut", "biolog", "physic",
            "computer", "molecul", "carbon", "wedderburn", "etherington", "tree",
            "necklace", "dendr")


def report(name, data):
    print(f"\n### {name}")
    if data is None:
        print("  fetch failed")
        return
    results = results_of(data)
    if not results:
        print("  NO HIT")
        return
    count = data.get("count") if isinstance(data, dict) else len(results)
    print(f"  {count} hit(s); showing up to 4")
    for r in results[:4]:
        print(f"  A{r['number']:06d}: {r['name']}")
        print(f"    data: {r['data'][:110]}")
        for key in ("comment", "reference", "link", "formula", "example"):
            for c in r.get(key) or []:
                if any(w in c.lower() for w in KEYWORDS):
                    print(f"    [{key}] {c}")


if __name__ == "__main__":
    for name, terms in QUERIES:
        data = fetch(terms, f"search_{name}")
        report(name, data)
    print("\nAll queries done.")
