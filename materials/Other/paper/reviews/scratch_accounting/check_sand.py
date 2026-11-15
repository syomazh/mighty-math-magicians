# Written by Claude Fable 5.2 (fresh-context referee subagent), 2026-11-14.
# Referee check of paper/accounting_proof.tex, Proposition 1 ("Sand") and the remark after it.
# Pure stdlib.  Run: uv run python check_sand.py
import random
import sys
from functools import lru_cache

random.seed(137)


def digits(m, p):
    d = []
    while m:
        d.append(m % p)
        m //= p
    return d


def run(start, p, ring, strategy):
    """Topple until stable.  start: list of grains per site.  ring: number of sites k, or None for the half-line.
    Returns (final configuration as tuple without trailing zeros on the line, number of topplings)."""
    g = list(start)
    n = 0
    while True:
        cand = [i for i, x in enumerate(g) if x >= p]
        if not cand:
            break
        if strategy == "random":
            i = random.choice(cand)
        elif strategy == "low":
            i = cand[0]
        elif strategy == "high":
            i = cand[-1]
        else:  # biggest pile
            i = max(cand, key=lambda t: g[t])
        g[i] -= p
        if ring is None:
            if i + 1 == len(g):
                g.append(0)
            g[i + 1] += 1
        else:
            g[(i + 1) % ring] += 1
        n += 1
    if ring is None:
        while g and g[-1] == 0:
            g.pop()
    return tuple(g), n


def all_outcomes(start, p, ring):
    """Exhaustive: set of (final configuration, number of topplings) over ALL toppling sequences."""
    @lru_cache(maxsize=None)
    def go(g):
        cand = [i for i, x in enumerate(g) if x >= p]
        if not cand:
            h = list(g)
            if ring is None:
                while h and h[-1] == 0:
                    h.pop()
            return frozenset({(tuple(h), 0)})
        out = set()
        for i in cand:
            h = list(g)
            h[i] -= p
            if ring is None:
                if i + 1 == len(h):
                    h.append(0)
                h[i + 1] += 1
            else:
                h[(i + 1) % ring] += 1
            for fin, n in go(tuple(h)):
                out.add((fin, n + 1))
        return frozenset(out)
    return go(tuple(start))


def main():
    bad = 0
    strategies = ["random"] * 6 + ["low", "high", "big"]
    # (a) half-line
    cnt = 0
    for p in (2, 3, 5, 7):
        for m in list(range(0, 400)) + [random.randrange(400, 20000) for _ in range(40)]:
            dg = tuple(digits(m, p))
            nu = (m - sum(dg)) // (p - 1)
            for st in strategies:
                fin, n = run([m], p, None, st)
                cnt += 1
                if fin != dg or n != nu:
                    print("(a) FAILS", p, m, st, fin, n)
                    bad += 1
    print(f"(a) half-line: {cnt} runs (p in 2,3,5,7; m in 0..399 and 40 random m < 20000; random and "
          f"deterministic orders): final = base-p digits, topplings = nu(m); failures so far {bad}")
    # (a) exhaustive over all sequences
    cnt = 0
    for p in (2, 3, 5):
        for m in range(0, 61 if p > 2 else 41):
            dg = tuple(digits(m, p))
            nu = (m - sum(dg)) // (p - 1)
            out = all_outcomes([m], p, None)
            cnt += 1
            if out != frozenset({(dg, nu)}):
                print("(a) exhaustive FAILS", p, m, out)
                bad += 1
    print(f"(a) half-line, exhaustive over all toppling sequences: {cnt} pairs (p,m); failures so far {bad}")

    # (b) ring
    cnt = 0
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            for nn in range(0, 61):
                m = (q - 1) * nn + 1
                N = (m - 1) // (p - 1)
                e0 = (1,) + (0,) * (k - 1)
                for st in strategies:
                    fin, n = run([m] + [0] * (k - 1), p, k, st)
                    cnt += 1
                    if fin != e0 or n != N:
                        print("(b) FAILS", p, k, m, st, fin, n)
                        bad += 1
    print(f"(b) ring: {cnt} runs (p in 2,3,5,7; k in 1,2,3; m=(q-1)n+1, 0<=n<=60): final = one grain on site 0, "
          f"topplings = N(m); failures so far {bad}")
    cnt = 0
    for p, k, nmax in ((2, 1, 30), (2, 2, 12), (2, 3, 6), (3, 1, 20), (3, 2, 6), (3, 3, 2), (5, 1, 12), (5, 2, 2)):
        q = p ** k
        for nn in range(0, nmax + 1):
            m = (q - 1) * nn + 1
            out = all_outcomes([m] + [0] * (k - 1), p, k)
            cnt += 1
            if out != frozenset({((1,) + (0,) * (k - 1), (m - 1) // (p - 1))}):
                print("(b) exhaustive FAILS", p, k, m, out)
                bad += 1
    print(f"(b) ring, exhaustive over all toppling sequences: {cnt} triples (p,k,m); failures so far {bad}")

    # (b) with a general starting configuration of weight = 1 mod q-1 (this is statement (C) of the note)
    cnt = 0
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            tries = 0
            while tries < 300:
                g = [random.randrange(0, 4 * p) for _ in range(k)]
                w = sum(x * p ** c for c, x in enumerate(g))
                hyp = (g[0] >= 1) if q == 2 else (w % (q - 1) == 1)
                if not hyp:
                    continue
                tries += 1
                fin, n = run(g, p, k, "random")
                cnt += 1
                if fin != (1,) + (0,) * (k - 1) or n * (p - 1) != sum(g) - 1:
                    print("(C)-type FAILS", p, k, g, fin, n)
                    bad += 1
    print(f"ring from a general configuration with sum g_c p^c = 1 mod q-1 (q=2: g_0>=1): {cnt} runs end in e_0 "
          f"after (sum g_c - 1)/(p-1) topplings; failures so far {bad}")

    # Remark: p^k - 1 divides m
    print("Remark after the proposition: m divisible by p^k - 1")
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            full = (p - 1,) * k
            okfull = True
            for mult in range(1, 40):
                m = (q - 1) * mult
                for st in ("random", "random", "low", "high"):
                    fin, n = run([m] + [0] * (k - 1), p, k, st)
                    if fin != full or n * (p - 1) != m - k * (p - 1):
                        okfull = False
            if not okfull:
                print("  remark FAILS for", p, k)
                bad += 1
            e0 = (1,) + (0,) * (k - 1)
            note = ""
            if q == 2:
                note = ("  <-- q=2: p^k-1 = 1 divides EVERY m, including m=(q-1)n+1; the 'full configuration' "
                        "(1) is the single grain, so 'instead' and 'does not occur' are inaccurate here")
            print(f"  p={p} k={k}: m = j(q-1), 1<=j<=39: ends in (p-1,...,p-1) = {full}: {okfull}; "
                  f"equals e_0: {full == e0}{note}")
    # degenerate m = 0
    fin, n = run([0], 2, 1, "low")
    print(f"  degenerate: q=2, m=0 satisfies 'm = 1 mod p^k-1' vacuously; ring ends in {fin} after {n} topplings; "
          f"(b) would claim one grain after N(0) = -1 topplings")
    fin, n = run([0, 0], 3, 2, "low")
    print(f"  degenerate: m=0 is divisible by p^k-1; ring ends in {fin}, not the full configuration")

    print("ALL PASS (claims of the proposition for m=(q-1)n+1)" if bad == 0 else f"FAILURES: {bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
