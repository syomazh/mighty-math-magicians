# Written by Claude Fable 5.2 (orchestrator), 2026-11-13. Looks up our sequences in the OEIS and
# a few literature leads in OpenAlex. Titles, abstracts and OEIS entries only; no PDFs.
# Sends no personal information. Run: uv run python experiments/E006_oeis/lookup.py
import json
import time
import urllib.parse
import urllib.request

UA = {"User-Agent": "math-sequence-lookup/1.0"}


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=40) as r:
        return json.loads(r.read().decode("utf-8"))


def oeis(name, terms):
    q = ",".join(str(t) for t in terms)
    try:
        d = get("https://oeis.org/search?fmt=json&q=" + urllib.parse.quote(q))
    except Exception as e:  # noqa: BLE001
        print(f"\n### {name}\nterms: {q}\nlookup failed: {e}")
        return
    if d is None:
        res = []
    else:
        res = d if isinstance(d, list) else (d.get("results") or [])
    print(f"\n### {name}\nterms: {q}\nhits: {len(res)}")
    for r in res[:3]:
        print(f"- A{r['number']:06d}: {r['name'][:230]}")
        for c in (r.get("comment") or [])[:40]:
            low = c.lower()
            if any(w in low for w in ("chem", "isomer", "phylogen", "biolog", "physic", "alkyl",
                                      "carbon", "evolution", "rotation", "cyclic")):
                print(f"    comment: {c[:260]}")
    time.sleep(1.2)


def abstract(inv):
    if not inv:
        return "no abstract available"
    pos = []
    for w, ps in inv.items():
        for p in ps:
            pos.append((p, w))
    return " ".join(w for _, w in sorted(pos))


def openalex(lead, query, full=False, n=3):
    url = "https://api.openalex.org/works?per-page=%d&search=%s" % (n, urllib.parse.quote(query))
    try:
        d = get(url)
    except Exception as e:  # noqa: BLE001
        print(f"\n### {lead}\nquery: {query}\nlookup failed: {e}")
        return
    print(f"\n### {lead}\nquery: {query}")
    for w in d.get("results", []):
        authors = "; ".join(a["author"]["display_name"] for a in w.get("authorships", [])[:6])
        src = ((w.get("primary_location") or {}).get("source") or {}).get("display_name")
        ab = abstract(w.get("abstract_inverted_index"))
        print(f"- {w.get('title')} | {authors} | {w.get('publication_year')} | {src} | {w.get('doi')}")
        print(f"    abstract: {ab if full else ab[:420]}")
    time.sleep(1.2)


def s2_abstract(doi):
    url = ("https://api.semanticscholar.org/graph/v1/paper/DOI:" + doi
           + "?fields=title,abstract,externalIds,year")
    try:
        d = get(url)
        print(f"\n### Semantic Scholar record for {doi}\n- {d.get('title')} ({d.get('year')}) "
              f"externalIds={d.get('externalIds')}\n    abstract: {d.get('abstract')}")
    except Exception as e:  # noqa: BLE001
        print(f"\n### Semantic Scholar record for {doi}\nlookup failed: {e}")
    time.sleep(1.5)


if __name__ == "__main__":
    import sys
    sys.stdout.reconfigure(encoding="utf-8")
    print("# OEIS lookups (sequences from experiments/E003_stress_test/output.txt)")
    oeis("classes, p=2 (binary trees up to swapping)", [1, 1, 2, 3, 6, 11, 23, 46, 98, 207, 451, 983])
    oeis("classes, p=3 (ternary trees up to rotation)", [1, 1, 2, 5, 11, 28, 74, 199, 551, 1553, 4436, 12832])
    oeis("classes, p=5", [1, 1, 3, 9, 30, 107, 392, 1489, 5783, 22874])
    oeis("classes, p=7", [1, 1, 4, 15, 62, 274, 1260, 5973, 28975])
    oeis("classes, q=4 (p=2, k=2)", [1, 1, 3, 6, 17, 44, 129, 373, 1131, 3453])
    oeis("classes, q=9 (p=3, k=2)", [1, 1, 3, 11, 37, 141, 561, 2291, 9608])
    oeis("classes, q=8 (p=2, k=3)", [1, 1, 4, 10, 36, 119, 442, 1643, 6358])
    oeis("labelled cyclic ternary trees: (3t)!/(t! 3^t)", [1, 2, 40, 2240, 246400, 44844800])
    oeis("labelled binary: (2t)!/(t! 2^t) = (2t-1)!!", [1, 1, 3, 15, 105, 945, 10395])
    oeis("tight level profiles, binary, by t (from E002)", [1, 3, 13, 75])

    print("\n\n# Literature leads (OpenAlex; titles and abstracts only)")
    openalex("L3 tree balance by symmetry nodes", "symmetry nodes tree balance index phylogenetic", full=True)
    s2_abstract("10.1016/j.mbs.2021.108690")
    openalex("L4 matchings and phylogenetic trees", "Matchings and phylogenetic trees", full=True, n=1)
    openalex("L1 Polya enumeration of chemical compounds",
             "Kombinatorische Anzahlbestimmungen für Gruppen, Graphen und chemische Verbindungen")
    openalex("L2 Wedderburn-Etherington numbers and tree shapes", "Wedderburn-Etherington numbers tree shapes")
    openalex("L5 abelian sandpile", "Self-organized critical state of sandpile automaton models")
    openalex("L5b chip-firing and carries", "chip-firing carries base p arithmetic digits")
    openalex("L6 Sylow subgroups of symmetric groups", "p-groupes de Sylow des groupes symétriques finis Kaloujnine")
    openalex("L6b adding machine automorphism of rooted tree", "adding machine odometer automorphism rooted tree")
