"""
E006 / W016 -- fetch OEIS entries and searches, one request per second.
Saves raw JSON to references/raw/w016_oeis_*.json and prints a summary.

Author: Kimi K3.1 Pro (AI, via Open Math OS), 2026-11-13. Not human-reviewed.
Uses only public OEIS data, generic User-Agent, no personal information.
"""
import json
import subprocess
import time
from pathlib import Path

RAW = Path(__file__).resolve().parents[2] / "references" / "raw"
UA = "Mozilla/5.0 (compatible; research)"


def fetch(query, name):
    out = RAW / f"w016_oeis_{name}.json"
    if out.exists():
        print(f"[cached] {name}")
        return json.loads(out.read_text(encoding="utf-8"))
    url = f"https://oeis.org/search?q={query}&fmt=json"
    res = subprocess.run(["curl", "-s", "-A", UA, "--max-time", "45", url],
                         capture_output=True)
    txt = res.stdout.decode("utf-8", errors="replace").strip()
    time.sleep(1.1)
    if not txt:
        print(f"[EMPTY] {name}")
        return None
    try:
        data = json.loads(txt)
    except json.JSONDecodeError:
        print(f"[NOT JSON] {name}: {txt[:120]}")
        return None
    out.write_text(json.dumps(data, indent=1, ensure_ascii=False), encoding="utf-8")
    return data


def results_of(data):
    """OEIS returns a dict with 'results', or a bare list, or null for no hits."""
    if not data:
        return []
    if isinstance(data, list):
        return data
    return data.get("results") or []


def show(data, name, max_hits=5, full=False):
    if data is None:
        print(f"  {name}: fetch failed")
        return
    results = results_of(data)
    if not results:
        print(f"  {name}: NO HIT (empty result)")
        return
    print(f"  {name}: {len(results)} result(s) returned, showing {min(len(results), max_hits)}")
    for r in results[:max_hits]:
        print(f"    A{r['number']:06d}: {r['name']}")
        print(f"      data: {r['data'][:100]}")
        if full:
            for key in ("comment", "reference", "link", "formula"):
                for c in r.get(key, []) or []:
                    if any(w in c.lower() for w in
                           ("chem", "alkyl", "stereo", "phylogen", "evolution", "biology",
                            "physics", "computer", "wedderburn", "etherington", "tree")):
                        print(f"      [{key}] {c}")


if __name__ == "__main__":
    # direct entries
    for a in ("A000625", "A001190"):
        d = fetch(f"id:{a}", a)
        print(f"\n=== {a} ===")
        res = results_of(d)
        if res:
            print(json.dumps(res[0], indent=1, ensure_ascii=False)[:16000])
        else:
            print("no data")
