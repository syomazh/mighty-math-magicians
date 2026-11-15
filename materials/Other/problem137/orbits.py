"""Problem 137: orbit structure of q-ary plane trees under child rotation.

Group action: at every internal node, cyclically rotate its q ordered children
(Z/q at each node, Konvalinka-style). Two plane trees are equivalent if one is
reached from the other by such rotations. For q = p^k every orbit has size p^e,
where e = sum over internal nodes v of v_p(period of the child word at v).

So  C_n^{(q)} = sum over orbits p^{e(orbit)},  hence v_p(C) >= min e, with
equality iff the number of orbits attaining min e is not divisible by p.

This script computes N(n, e) = #orbits with n internal nodes and exponent e,
via necklace counting:

  F(x,y) = 1 + x * sum_{j=0..k} y^j * (A_j - A_{j-1}) / p^j,
  A_j    = F(x^{q/p^j}, y^{q/p^j})^{p^j},   A_{-1} = 0,

(A_j counts child words of length q whose period divides p^j).

Target formula: v_p(C_n^{(q)}) = (s_p((q-1)n + 1) - 1) / (p - 1).
"""
from math import comb
import sys


def s_p(m, p):
    s = 0
    while m:
        s += m % p
        m //= p
    return s


def vp(m, p):
    if m == 0:
        return float("inf")
    v = 0
    while m % p == 0:
        m //= p
        v += 1
    return v


# polynomials: dict n -> dict e -> coeff, truncated at degree N in x
def mul(a, b, N):
    out = {}
    for n1, ea in a.items():
        for n2, eb in b.items():
            n = n1 + n2
            if n > N:
                continue
            d = out.setdefault(n, {})
            for e1, c1 in ea.items():
                for e2, c2 in eb.items():
                    d[e1 + e2] = d.get(e1 + e2, 0) + c1 * c2
    return out


def power(a, m, N):
    res = {0: {0: 1}}
    base = a
    while m:
        if m & 1:
            res = mul(res, base, N)
        m >>= 1
        if m:
            base = mul(base, base, N)
    return res


def scale(a, t, N):
    """x -> x^t, y -> y^t"""
    return {n * t: {e * t: c for e, c in ea.items()} for n, ea in a.items() if n * t <= N}


def orbit_table(p, k, N):
    q = p ** k
    F = {0: {0: 1}}  # leaf
    for _ in range(N):  # each iteration fixes one more degree
        newF = {0: {0: 1}}
        prev = {}
        for j in range(k + 1):
            d = p ** j
            A = power(scale(F, q // d, N - 1), d, N - 1)
            for n, ea in A.items():
                for e, c in ea.items():
                    c -= prev.get(n, {}).get(e, 0)
                    if c:
                        assert c % d == 0
                        slot = newF.setdefault(n + 1, {})
                        slot[e + j] = slot.get(e + j, 0) + c // d
            prev = A
        F = newF
    return F


def main(p, k, N):
    q = p ** k
    F = orbit_table(p, k, N)
    print(f"p={p} q={q}")
    print(" n | C_n          | v_p(C) | formula | min e | #orbits at min e (mod p) | exponent spectrum")
    for n in range(1, N + 1):
        C = comb(q * n, n) // ((q - 1) * n + 1)
        total = sum(c * p ** e for e, c in F[n].items())
        assert total == C, (n, total, C)
        v = vp(C, p)
        form = (s_p((q - 1) * n + 1, p) - 1) // (p - 1)
        emin = min(F[n])
        nmin = F[n][emin]
        flag = "" if (v == form == emin and nmin % p) else "  <-- !"
        spec = {e: F[n][e] for e in sorted(F[n])}
        print(f"{n:2d} | {C:<12d} | {v:6d} | {form:7d} | {emin:5d} | {nmin} ({nmin % p}){flag} | {spec}")




# ---------------------------------------------------------------------------
# Variant: at each node act by the Sylow p-subgroup of S_q, i.e. the iterated
# wreath product Z/p wr ... wr Z/p (k times) acting on the q = p^k children
# viewed as leaves of a complete p-ary tree of depth k.  Orbits on child words
# = recursively, Z/p-necklaces of orbits of p blocks.

def necklaces_p(G, p, N):
    """Z/p necklaces of length p over class-GF G (dict n->e->c), exponent +1 if period p."""
    A1 = scale(G, p, N)          # constant words
    Ap = power(G, p, N)          # all words
    out = {}
    for n, ea in Ap.items():
        for e, c in ea.items():
            c1 = A1.get(n, {}).get(e, 0)
            if c1:
                slot = out.setdefault(n, {}); slot[e] = slot.get(e, 0) + c1
            if c - c1:
                assert (c - c1) % p == 0
                slot = out.setdefault(n, {}); slot[e + 1] = slot.get(e + 1, 0) + (c - c1) // p
    return out


def orbit_table_sylow(p, k, N):
    F = {0: {0: 1}}
    for _ in range(N):
        G = F
        for _ in range(k):
            G = necklaces_p(G, p, N - 1)
        newF = {0: {0: 1}}
        for n, ea in G.items():
            newF[n + 1] = dict(ea)
        F = newF
    return F


def report(p, k, N, F, label):
    q = p ** k
    print(f"[{label}] p={p} q={q}")
    bad = 0
    for n in range(1, N + 1):
        C = comb(q * n, n) // ((q - 1) * n + 1)
        assert sum(c * p ** e for e, c in F[n].items()) == C
        v = vp(C, p)
        form = (s_p((q - 1) * n + 1, p) - 1) // (p - 1)
        emin = min(F[n]); nmin = F[n][emin]
        ok = v == form == emin and nmin % p != 0
        bad += not ok
        print(f"  n={n:2d} v={v} formula={form} min_e={emin} #min={nmin} (mod p {nmin % p}){'' if ok else '  <-- !'}")
    print(f"  failures: {bad}")


if __name__ == "__main__":
    # usage: python orbits.py p k N [rot|sylow]
    p, k, N = (int(a) for a in sys.argv[1:4])
    mode = sys.argv[4] if len(sys.argv) > 4 else "rot"
    if mode == "sylow":
        report(p, k, N, orbit_table_sylow(p, k, N), "sylow")
    else:
        main(p, k, N)
