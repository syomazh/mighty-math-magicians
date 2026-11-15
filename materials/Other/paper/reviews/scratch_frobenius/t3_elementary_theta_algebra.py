# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of paper/frobenius_proof.tex: (E1), (E2), Lemma theta (formula and integrality,
# including negative coefficients and monomials of x-degree 0), (wprod), (wphi), and the algebra A
# (commutative, associative, unit, powers of the x_j).
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t3_elementary_theta_algebra.py
import random
from fractions import Fraction
from itertools import product

from fz_lib import carry_free, cfprod, digits, sp

random.seed(137)
ok_all = True


def report(name, ok, extra=""):
    global ok_all
    ok_all = ok_all and ok
    print(f"   {'PASS' if ok else 'FAIL'}  {name} {extra}")


# ---------------------------------------------------------------- (E1)
for p in (2, 3, 5, 7, 11):
    ok = True
    # exhaustive small
    for r in (2, 3):
        for tup in product(range(0, 40), repeat=r):       # zeros included on purpose
            S = sum(tup)
            lhs = sp(S, p)
            rhs = sum(sp(a, p) for a in tup)
            cf = carry_free(tup, p)
            if lhs > rhs or (lhs == rhs) != cf or (rhs - lhs) % (p - 1) != 0:
                ok = False
    for _ in range(20000):
        r = random.randint(1, p + 2)
        tup = [random.randint(1, 10 ** random.randint(1, 8)) for _ in range(r)]
        S = sum(tup)
        lhs = sp(S, p)
        rhs = sum(sp(a, p) for a in tup)
        cf = carry_free(tup, p)
        if lhs > rhs or (lhs == rhs) != cf or (rhs - lhs) % (p - 1) != 0:
            ok = False
    report(f"(E1) p={p}: s_p(sum) <= sum s_p, equality iff carry-free (zeros allowed too)", ok)
    ok = all(sp(p * m, p) == sp(m, p) and not carry_free([m] * p, p) for m in range(1, 5000))
    report(f"(E1) p={p}: s_p(pm)=s_p(m); m+...+m (p times) never carry-free", ok)

# ---------------------------------------------------------------- (E2)
for p, A in ((2, 5), (3, 4), (5, 3), (7, 2)):
    seen = set()
    ok = True
    for tup in product(range(A), repeat=p):
        if len(set(tup)) == 1 or tup in seen:
            continue
        orb = {tup[i:] + tup[:i] for i in range(p)}
        if len(orb) != p:
            ok = False
        seen |= orb
    report(f"(E2) p={p}: non-constant p-tuples over {A} letters fall into orbits of size p", ok)
orb = {(0, 1, 0, 1)[i:] + (0, 1, 0, 1)[:i] for i in range(4)}
print(f"   teeth: for the composite length 4 the tuple (0,1,0,1) has an orbit of size {len(orb)} (not 4)")


# ---------------------------------------------------------------- Lemma theta
def poly_mul(A, B):
    R = {}
    for (m1, d1), c1 in A.items():
        for (m2, d2), c2 in B.items():
            key = (m1 + m2, d1 + d2)
            R[key] = R.get(key, 0) + c1 * c2
    return {k: v for k, v in R.items() if v}


for p in (2, 3, 5):
    ok_int = True
    ok_formula = True
    for trial in range(40):
        nmon = random.randint(1, 5 if p < 5 else 4)
        f = {}
        while len(f) < nmon:
            f[(random.randint(0, 4), random.randint(0, 3))] = random.choice([-7, -3, -2, -1, 1, 2, 3, 5, 10])
        fp = {(0, 0): 1}
        for _ in range(p):
            fp = poly_mul(fp, f)
        phi = {(p * m, p * d): c for (m, d), c in f.items()}
        diff = dict(fp)
        for key, c in phi.items():
            diff[key] = diff.get(key, 0) - c
        diff = {k: v for k, v in diff.items() if v}
        if any(v % p for v in diff.values()):
            ok_int = False
        theta = {k: Fraction(v, p) for k, v in diff.items()}
        # the formula (theta): (1/p) sum over non-constant tuples + sum (c^p - c)/p mu^p
        rhs = {}
        items = list(f.items())
        for tup in product(range(len(items)), repeat=p):
            if len(set(tup)) == 1:
                continue
            c = 1
            m = d = 0
            for i in tup:
                c *= items[i][1]
                m += items[i][0][0]
                d += items[i][0][1]
            rhs[(m, d)] = rhs.get((m, d), 0) + Fraction(c, p)
        for (m, d), c in items:
            key = (p * m, p * d)
            rhs[key] = rhs.get(key, 0) + Fraction(c ** p - c, p)
        rhs = {k: v for k, v in rhs.items() if v}
        if rhs != theta:
            ok_formula = False
    report(f"Lemma theta p={p}: (f^p - phi f)/p integral (random f, negative coeffs, x-degree-0 terms)", ok_int)
    report(f"Lemma theta p={p}: formula (theta) reproduces it", ok_formula)

# ---------------------------------------------------------------- (wprod), (wphi)
for p in (2, 3, 5, 7):
    ok = True
    for _ in range(20000):
        r = random.randint(1, p + 1)
        mons = [(random.randint(1, 3000), random.randint(0, 6)) for _ in range(r)]
        w = lambda m, d: (p - 1) * d - sp(m, p)
        M = sum(m for m, d in mons)
        Dd = sum(d for m, d in mons)
        lhs = w(M, Dd)
        rhs = sum(w(m, d) for m, d in mons)
        if lhs < rhs or (lhs == rhs) != carry_free([m for m, d in mons], p):
            ok = False
        m, d = mons[0]
        if w(p * m, p * d) != w(m, d) + (p - 1) ** 2 * d:
            ok = False
    report(f"(wprod),(wphi) p={p}", ok)

# ---------------------------------------------------------------- the algebra A
for p, N in ((2, 70), (3, 90), (5, 130)):
    ok = True
    for trial in range(4):
        f = [Fraction(random.randint(-3, 3)) for _ in range(N + 1)]
        g = [Fraction(random.randint(-3, 3)) for _ in range(N + 1)]
        h = [Fraction(random.randint(-3, 3)) for _ in range(N + 1)]
        one = [Fraction(1)] + [Fraction(0)] * N
        fg = cfprod(f, g, N, p)
        if fg != cfprod(g, f, N, p):
            ok = False
        if cfprod(fg, h, N, p) != cfprod(f, cfprod(g, h, N, p), N, p):
            ok = False
        if cfprod(f, one, N, p) != f:
            ok = False
        # distributivity
        gh = [a + b for a, b in zip(g, h)]
        if cfprod(f, gh, N, p) != [a + b for a, b in zip(fg, cfprod(f, h, N, p))]:
            ok = False
    report(f"A p={p}: commutative, associative, unital, distributive on random functions (N={N})", ok)
    # powers of x_j
    ok = True
    j = 0
    while p ** j <= N:
        xj = [0] * (N + 1)
        xj[p ** j] = 1
        pw = [1] + [0] * N
        for b in range(1, p + 2):
            pw = cfprod(pw, xj, N, p)
            want = [0] * (N + 1)
            if b <= p - 1 and b * p ** j <= N:
                want[b * p ** j] = 1
            if b <= p - 1 and b * p ** j > N:
                continue
            if pw != want:
                ok = False
        j += 1
    report(f"A p={p}: x_j^(cf b) = indicator of {{b p^j}} for b<=p-1, and 0 for b>=p", ok)

print("ALL PASS" if ok_all else "SOME FAILED")
