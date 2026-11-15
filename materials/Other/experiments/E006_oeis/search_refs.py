"""
E006 / W016 Part 2 -- find the named leads through public APIs.
OpenAlex (https://api.openalex.org/works?search=...), Crossref and Semantic Scholar
Graph API. Saves raw JSON to references/raw/w016_api_*.json and prints a compact
summary: citation exactly as returned, plus abstract (inverted index reconstructed
for OpenAlex).

Author: Kimi K3.1 Pro (AI, via Open Math OS), 2026-11-13. Not human-reviewed.
One request per 1.1 s, generic User-Agent, no personal information, no PDFs.
"""
import json
import subprocess
import time
import urllib.parse
from pathlib import Path

RAW = Path(__file__).resolve().parents[2] / "references" / "raw"
UA = "Mozilla/5.0 (compatible; research)"


def fetch(url, name):
    out = RAW / f"w016_api_{name}.json"
    if out.exists():
        print(f"[cached] {name}")
        return json.loads(out.read_text(encoding="utf-8"))
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
        print(f"[NOT JSON] {name}: {txt[:150]}")
        return None
    out.write_text(json.dumps(data, indent=1, ensure_ascii=False), encoding="utf-8")
    return data


def openalex_search(query, name, rows=6):
    url = ("https://api.openalex.org/works?search=" + urllib.parse.quote(query)
           + f"&per-page={rows}")
    return fetch(url, "openalex_" + name)


def crossref_search(query, name, rows=5):
    url = ("https://api.crossref.org/works?query.bibliographic=" + urllib.parse.quote(query)
           + f"&rows={rows}")
    return fetch(url, "crossref_" + name)


def s2_search(query, name, rows=5):
    url = ("https://api.semanticscholar.org/graph/v1/paper/search?query="
           + urllib.parse.quote(query) + f"&limit={rows}&fields=title,abstract,authors,year,venue,externalIds")
    return fetch(url, "s2_" + name)


def oa_abstract(work):
    inv = work.get("abstract_inverted_index")
    if not inv:
        return ""
    pos = {}
    for w, idxs in inv.items():
        for i in idxs:
            pos[i] = w
    return " ".join(pos[i] for i in sorted(pos))


def oa_citation(work):
    authorships = work.get("authorships", [])
    authors = ", ".join(a["author"]["display_name"] for a in authorships[:6])
    if len(authorships) > 6:
        authors += " et al."
    src = (work.get("primary_location") or {}).get("source") or {}
    return {
        "title": work.get("title"),
        "authors": authors,
        "year": work.get("publication_year"),
        "venue": src.get("display_name"),
        "volume": (work.get("biblio") or {}).get("volume"),
        "pages": (work.get("biblio") or {}).get("first_page"),
        "doi": work.get("doi"),
        "openalex_id": work.get("id"),
    }


def show_oa(data, name, max_hits=6):
    print(f"\n### {name}")
    if not data or "results" not in data:
        print("  no data")
        return
    print(f"  {data['meta']['count']} hits")
    for w in data["results"][:max_hits]:
        cit = oa_citation(w)
        print("  " + json.dumps(cit, ensure_ascii=False))
        ab = oa_abstract(w)
        if ab:
            print("    abstract: " + ab[:1400])
        else:
            print("    abstract: (none returned)")


def show_crossref(data, name, max_hits=5):
    print(f"\n### {name}")
    if not data or "message" not in data:
        print("  no data")
        return
    items = data["message"].get("items", [])
    print(f"  {data['message'].get('total-results')} hits")
    for it in items[:max_hits]:
        authors = ", ".join(" ".join(filter(None, [a.get("given"), a.get("family")]))
                            for a in it.get("author", [])[:6])
        print(f"  title: {(it.get('title') or [''])[0]}")
        print(f"    authors: {authors}")
        print(f"    container: {(it.get('container-title') or [''])[0]}; "
              f"year: {(it.get('issued', {}).get('date-parts') or [[None]])[0][0]}; "
              f"DOI: {it.get('DOI')}")
        ab = it.get("abstract")
        if ab:
            print("    abstract: " + ab[:1200])


def show_s2(data, name, max_hits=5):
    print(f"\n### {name}")
    if not data or "data" not in data:
        print("  no data")
        return
    print(f"  {data.get('total')} hits")
    for p in data["data"][:max_hits]:
        print(f"  {p.get('title')} ({p.get('year')}), {p.get('venue')}")
        print(f"    authors: {', '.join(a['name'] for a in p.get('authors', []))}")
        print(f"    ids: {p.get('externalIds')}")
        ab = p.get("abstract")
        print("    abstract: " + (ab[:1400] if ab else "(none)"))


if __name__ == "__main__":
    jobs_oa = [
        ("symmetry nodes tree balance index", "balance"),
        ("matchings phylogenetic trees Diaconis Holmes", "matchings"),
        ("abelian sandpile model", "sandpile"),
        ("chip-firing carries base-p arithmetic", "chipcarries"),
        ("adding machine odometer automorphism rooted tree", "odometer"),
        ("Sylow subgroups symmetric groups wreath products Kaloujnine", "kaloujnine"),
        ("Polya enumeration alkyl radicals stereoisomers", "polya"),
        ("Wedderburn Etherington phylogenetic tree shapes", "wedderburn"),
        ("adding machine automorphism regular rooted tree Grigorchuk", "addingmachine"),
        ("sandpile group graph chip firing abelian property", "sandpilegroup"),
        ("chip firing base p carrying abelian", "chipbase"),
        ("symmetric nodes phylogenetic trees imbalance index", "symmetric_nodes"),
    ]
    for q, name in jobs_oa:
        show_oa(openalex_search(q, name), f"OpenAlex: {q}")

    jobs_s2 = [
        ("matchings and phylogenetic trees", "matchings"),
        ("vector representations phylogenetic trees", "vectorphylo"),
        ("adding machine automorphism tree", "addingmachine"),
        ("La multiplication sylow symmetrique wreath", "kaloujnine"),
        ("groupes abeliens de sandpile chip firing", "sandpile"),
        ("odometer adding machine rooted binary tree automorphism", "odometer"),
        ("chip firing games on graphs", "chipfiring"),
    ]
    for q, name in jobs_s2:
        show_s2(s2_search(q, name), f"SemanticScholar: {q}")

    jobs_cr = [
        ("Diaconis Holmes matchings phylogenetic trees", "diaconis_holmes"),
        ("Kaloujnine structure p-groupes Sylow groupes symetriques", "kaloujnine"),
        ("Polya kombinatorische Anzahlbestimmungen Gruppen Graphen chemische Verbindungen", "polya"),
        ("Kerber symmetric phylogenetic trees balance", "balance"),
    ]
    for q, name in jobs_cr:
        show_crossref(crossref_search(q, name), f"Crossref: {q}")
