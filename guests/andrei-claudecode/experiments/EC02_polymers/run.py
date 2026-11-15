# EC02 - branched polymers: hyperbranched molecules from AB_(f-1) monomers are rooted (f-1)-ary trees.
# Written by Claude Fable 5.2 (AI), 2026-11-14, in a second Claude Code session working with a
# team member (not the orchestrator). Not human-reviewed. Standard library only.
# Run from the repository root:  python3 guests/andrei-claudecode/experiments/EC02_polymers/run.py
#
# Chemical model (Flory 1952): a monomer carries one group A and f-1 groups B; A reacts only with B.
# Ideal assumptions: every free A and every free B are equally reactive; no rings.
# Dictionary: unit = node; the unit with the free A ("focal point") = root; a reacted B = an edge to a
# child; a free B = a leaf. So a molecule of n units is a tree with n nodes and (f-2)n+1 leaves.

import random
from math import comb, factorial, log
from fractions import Fraction
from collections import Counter

CHECKS = []


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok)))
    print(("PASS  " if ok else "FAIL  ") + name + ("   " + detail if detail else ""))
    assert ok, name


def fuss(q, n):
    return comb(q * n, n) // ((q - 1) * n + 1)


def canon(t):
    """Canonical form of a plane tree (nested tuples, () = leaf) up to rotation at every node."""
    if t == ():
        return ()
    k = tuple(canon(c) for c in t)
    return min(k[i:] + k[:i] for i in range(len(k)))


def dd(t):
    """Number of nodes whose branches are not all alike (t canonical)."""
    if t == ():
        return 0
    return sum(dd(c) for c in t) + (0 if all(c == t[0] for c in t) else 1)


def nodes(t):
    return 0 if t == () else 1 + sum(nodes(c) for c in t)


def digit_sum(m, p):
    s = 0
    while m:
        s += m % p
        m //= p
    return s


print("=" * 100)
print("PART A - counting molecules from the chemical model (monomers and bonds; no trees assumed)")
print("=" * 100)


def count_single_molecules(N, f):
    """Bond patterns of N labelled AB_(f-1) monomers (labelled B groups) that form ONE ring-free molecule."""
    q = f - 1
    slots = [(j, s) for j in range(N) for s in range(q)]
    total = 0
    free_b = set()
    for root in range(N):
        others = [i for i in range(N) if i != root]
        parent = {}
        used = set()

        def rec(k):
            if k == len(others):
                for i in others:            # every unit must lead to the root: one molecule, no ring
                    x, steps = i, 0
                    while x != root:
                        x = parent[x]
                        steps += 1
                        if steps > N:
                            return 0
                free_b.add(q * N - len(used))
                return 1
            i = others[k]
            c = 0
            for (j, s) in slots:
                if j != i and (j, s) not in used:
                    used.add((j, s))
                    parent[i] = j
                    c += rec(k + 1)
                    used.discard((j, s))
            return c
        total += rec(0)
    return total, free_b


ok = True
rows = []
for f, Nmax in ((3, 6), (4, 5), (5, 5), (6, 4)):
    for N in range(1, Nmax + 1):
        cnt, fb = count_single_molecules(N, f)
        ok &= cnt == factorial(N) * fuss(f - 1, N) and fb == {(f - 2) * N + 1}
        rows.append("f=%d n=%d: %d = %d! x %d" % (f, N, cnt, N, fuss(f - 1, N)))
check("A1 ring-free molecules of n labelled AB_(f-1) monomers number n! x FussCatalan(f-1, n); each has one free A and (f-2)n+1 free B",
      ok, "; ".join(rows[2:6]) + " ...")

print()
print("=" * 100)
print("PART B - the one-pot reaction, exactly, for a few monomers")
print("=" * 100)


def one_pot_exact(N, f):
    """All histories of the reaction 'a free A meets a free B of another molecule, all such pairs equally likely'."""
    q = f - 1
    start = tuple([None] * N)
    level = {start: 1}                      # state -> number of histories leading to it
    report = []
    for j in range(N - 1):
        nxt = Counter()
        move_counts = set()
        for state, paths in level.items():
            def root_of(i):
                while state[i] is not None:
                    i = state[i][0]
                return i
            used = {b for b in state if b is not None}
            roots = [i for i in range(N) if state[i] is None]
            moves = 0
            for x in roots:
                for jj in range(N):
                    if root_of(jj) == x:
                        continue
                    for s in range(q):
                        if (jj, s) not in used:
                            moves += 1
                            new = list(state)
                            new[x] = (jj, s)
                            nxt[tuple(new)] += paths
            move_counts.add(moves)
        report.append((j, move_counts, len(nxt), set(nxt.values())))
        level = dict(nxt)
    return level, report


def tree_of(state, q):
    N = len(state)
    child = {}
    for i, b in enumerate(state):
        if b is not None:
            child[b] = i
    root = next(i for i in range(N) if state[i] is None)

    def build(i):
        return tuple(build(child[(i, s)]) if (i, s) in child else () for s in range(q))
    return build(root)


for f, N in ((3, 5), (4, 4)):
    q = f - 1
    final, report = one_pot_exact(N, f)
    ok_moves = all(mc == {(N - j - 1) * (q * N - j)} for j, mc, _, _ in report)
    ok_uniform = all(vals == {factorial(j + 1)} for j, _, _, vals in report)
    check("B1 f=%d, n=%d: the number of possible next bonds depends only on how many bonds exist" % (f, N), ok_moves,
          "after j bonds: (n-j-1) x ((f-1)n - j)")
    check("B2 f=%d, n=%d: hence at every stage all bond patterns are equally likely" % (f, N), ok_uniform,
          "states per stage: %s" % [r[2] for r in report])
    shapes = Counter(canon(tree_of(st, q)) for st in final)
    ok_shape = len(final) == factorial(N) * fuss(q, N) and all(v == factorial(N) * q ** dd(t) for t, v in shapes.items())
    probs = sorted((Fraction(q ** dd(t), fuss(q, N)) for t in shapes), reverse=True)
    check("B3 f=%d: among the final %d-mers an isomer (tree up to rotation) has probability %d^d / %d" % (f, N, q, fuss(q, N)), ok_shape,
          "isomer probabilities: " + ", ".join(str(x) for x in probs))

print()
print("=" * 100)
print("PART C - a large one-pot AB2 reaction, simulated (10^6 monomers)")
print("=" * 100)


def simulate(N, f, bonds, seed):
    rng = random.Random(seed)
    q = f - 1
    dsu = list(range(N))
    size = [1] * N

    def find(x):
        r = x
        while dsu[r] != r:
            r = dsu[r]
        while dsu[x] != r:
            dsu[x], x = r, dsu[x]
        return r
    roots = list(range(N))
    pos = list(range(N))
    free_b = list(range(N * q))
    child = [-1] * (N * q)
    for _ in range(bonds):
        while True:
            x = roots[rng.randrange(len(roots))]
            bi = rng.randrange(len(free_b))
            b = free_b[bi]
            rx, ry = find(x), find(b // q)
            if rx != ry:
                break
        child[b] = x
        free_b[bi] = free_b[-1]
        free_b.pop()
        last = roots[-1]
        roots[pos[x]] = last
        pos[last] = pos[x]
        roots.pop()
        dsu[rx] = ry
        size[ry] += size[rx]
    return roots, child, size, find


def build(i, child, q):
    return tuple(build(child[i * q + s], child, q) if child[i * q + s] >= 0 else () for s in range(q))


NMC, PA, SEED = 1_000_000, 0.8, 137
bonds = int(PA * NMC)
roots, child, size, find = simulate(NMC, 3, bonds, SEED)
alpha = bonds / (2 * NMC)
mol = len(roots)
sizes = Counter(size[find(r)] for r in roots)
print("   monomers %d, bonds %d (conversion of A: %.2f; of B: alpha = %.2f), molecules %d, largest molecule %d units" % (
    NMC, bonds, PA, alpha, mol, max(sizes)))
print("   size n   observed   Flory: molecules x Catalan(n) x alpha^(n-1) x (1-alpha)^(n+1)")
chi = 0.0
tail_obs, tail_exp = mol, float(mol)
for n in range(1, 13):
    e = mol * fuss(2, n) * alpha ** (n - 1) * (1 - alpha) ** (n + 1)
    o = sizes[n]
    chi += (o - e) ** 2 / e
    tail_obs -= o
    tail_exp -= e
    print("   %-8d %-10d %.1f" % (n, o, e))
chi += (tail_obs - tail_exp) ** 2 / tail_exp
print("   >12      %-10d %.1f" % (tail_obs, tail_exp))
check("C1 the size distribution follows Flory's formula with the Catalan numbers (chi-square, 12 degrees of freedom)", chi < 40,
      "chi-square = %.1f" % chi)

okshape = True
print("   isomers among the n-mers: observed against 2^d / Catalan(n)")
for n in range(3, 8):
    obs = Counter()
    for r in roots:
        if size[find(r)] == n:
            obs[canon(build(r, child, 2))] += 1
    tot = sum(obs.values())
    classes = sorted({canon(t) for t in obs}, key=lambda t: (dd(t), t))
    chi = sum((obs[t] - tot * 2 ** dd(t) / fuss(2, n)) ** 2 / (tot * 2 ** dd(t) / fuss(2, n)) for t in classes)
    # classes that did not occur at all
    df = len(classes) - 1
    perfect = [t for t in classes if dd(t) == 0]
    line = "   n = %d: %d molecules, %d isomers seen, chi-square = %.1f on %d d.f." % (n, tot, len(classes), chi, df)
    if perfect:
        line += "; perfect dendrons: %d observed, %.1f expected (1 in %d)" % (obs[perfect[0]], tot / fuss(2, n), fuss(2, n))
    print(line)
    okshape &= chi < 3 * df + 25
check("C2 among n-mers (n = 3..7) each isomer occurs in proportion to 2^d", okshape)

units = Counter()
for i in range(NMC):
    units[(child[2 * i] >= 0) + (child[2 * i + 1] >= 0)] += 1
D, L, T = units[2], units[1], units[0]
db = 2 * D / (2 * D + L)
check("C3 degree of branching 2D/(2D+L) equals alpha = (conversion of A)/2, the chemists' linear law", abs(db - alpha) < 0.002,
      "dendritic %d, linear %d, terminal %d units; DB = %.4f, alpha = %.4f" % (D, L, T, db, alpha))

print()
print("=" * 100)
print("PART D - Flory's distribution, the gel point and the radius of convergence")
print("=" * 100)
ok = True
for q in (2, 3, 4, 5):
    for a in (Fraction(1, 10), Fraction(1, 2 * q), Fraction(9, 10 * q)):
        s = sum(fuss(q, n) * a ** (n - 1) * (1 - a) ** ((q - 1) * n + 1) for n in range(1, 4000))
        ok &= abs(float(1 - s)) < 1e-6
check("D1 sum over n of FussCatalan(q, n) alpha^(n-1) (1-alpha)^((q-1)n+1) = 1 below alpha = 1/q", ok)
ok = True
for f in range(3, 9):
    q = f - 1
    crit = Fraction((q - 1) ** (q - 1), q ** q)                    # radius of convergence of sum FussCatalan(q,n) z^n
    a = Fraction(1, f - 1)
    beta_max = a * (1 - a) ** (f - 2)
    ratio = Fraction(fuss(q, 3000), fuss(q, 3001))
    ok &= beta_max == crit and abs(float(ratio / crit) - 1) < 2e-3
    # beta(alpha) = alpha (1-alpha)^(f-2) is largest at alpha = 1/(f-1)
    ok &= all(Fraction(k, 1000) * (1 - Fraction(k, 1000)) ** (f - 2) <= beta_max for k in range(1, 1000))
check("D2 Flory's gel point alpha = 1/(f-1) is where alpha(1-alpha)^(f-2) reaches the radius of convergence of the Fuss-Catalan series", ok,
      "f = 3: 1/4;  f = 4: 4/27;  f = 5: 27/256")
ok = all(Fraction(factorial(f * n - n), factorial(n) * factorial(f * n - 2 * n + 2)) == Fraction(fuss(f - 1, n), (f - 2) * n + 2)
         for f in range(3, 8) for n in range(1, 40))
check("D3 Stockmayer's factor (fn-n)!/(n!(fn-2n+2)!) = FussCatalan(f-1, n) / (number of free groups)", ok)

print()
print("=" * 100)
print("PART E - degree of branching of a random n-mer (all plane binary trees equally likely)")
print("=" * 100)
NN = 2000
trees = [1] + [0] * NN
totD = [0] * (NN + 1)
totL = [0] * (NN + 1)
for n in range(1, NN + 1):
    t = dsum = lsum = 0
    for i in range(n):
        j = n - 1 - i
        w = trees[i] * trees[j]
        t += w
        dsum += totD[i] * trees[j] + trees[i] * totD[j] + (w if i > 0 and j > 0 else 0)
        lsum += totL[i] * trees[j] + trees[i] * totL[j] + (w if (i > 0) != (j > 0) else 0)
    trees[n], totD[n], totL[n] = t, dsum, lsum
ok = all(trees[n] == fuss(2, n) for n in range(1, 200))
vals = {n: float(Fraction(2 * totD[n], 2 * totD[n] + totL[n])) for n in (7, 15, 31, 100, 1000, 2000)}
check("E1 DB over all n-mers tends to 1/2 (the value chemists quote for random AB2 polymers)", ok and abs(vals[2000] - 0.5) < 1e-3,
      ", ".join("n=%d: %.4f" % kv for kv in vals.items()))

# AB3 at full conversion of A: every B has reacted with probability 1/3, independently.
a3 = Fraction(1, 3)
frac = [comb(3, k) * a3 ** k * (1 - a3) ** (3 - k) for k in range(4)]      # units with k reacted B
db3 = (2 * frac[3] + frac[2]) / (Fraction(2, 3) * (3 * frac[3] + 2 * frac[2] + frac[1]))
check("E2 AB3 at full conversion: DB = (2D + sD) / ((2/3)(3D + 2sD + L)) = 4/9 = 0.44, the published value", db3 == Fraction(4, 9),
      "the formula is the Hoelter-Burgath-Frey definition as remembered, not read today; the value 0.44 is quoted in a review")

print()
print("=" * 100)
print("PART F - the theorem in polymer words (AB2, p = 2)")
print("=" * 100)
print("   n units  free B = n+1 (binary)   lightest isomer weight 2^t   Catalan(n)            chance that a random n-mer is the perfect dendron")
ok = True
for n in (1, 2, 3, 4, 5, 6, 7, 15, 31, 63):
    m = n + 1
    t = digit_sum(m, 2) - 1
    c = fuss(2, n)
    v = 0
    while c % 2 ** (v + 1) == 0:
        v += 1
    ok &= v == t
    perfect = "1 in %d" % c if t == 0 else "none exists"
    print("   %-8d %-22s %-27d %-21d %s" % (n, "%d = %s" % (m, bin(m)[2:]), 2 ** t, c, perfect))
check("F1 the power of 2 in Catalan(n) = log2 of the weight of the lightest isomer = (ones in n+1) - 1", ok)

# exact isomer statistics from the class polynomial, to n = 15
Z = {1: {0: 1}}                    # leaves m -> {d: number of shapes}; a single free B is the empty tree


def shapes(m, memo={1: [((), 0)]}):
    if m not in memo:
        out = {}
        for a in range(1, m // 2 + 1):
            b = m - a
            for (ta, da) in shapes(a):
                for (tb, db_) in shapes(b):
                    if a == b and ta > tb:
                        continue
                    key = (ta, tb) if ta <= tb else (tb, ta)
                    out[key] = da + db_ + (0 if ta == tb else 1)
        memo[m] = list(out.items())
    return memo[m]


ok = True
for n in (3, 7, 15):
    sh = shapes(n + 1)
    c = fuss(2, n)
    ok &= sum(2 ** d_ for _, d_ in sh) == c and sum(1 for _, d_ in sh if d_ == 0) == 1
    half = sum(2 ** d_ for _, d_ in sh if d_ >= n - 3)
    print("   n = %d: %d isomers; perfect dendron weight 1 of %d; mean number of lopsided units per molecule %.2f of %d" % (
        n, len(sh), c, sum(d_ * 2 ** d_ for _, d_ in sh) / c, n))
check("F2 for n = 3, 7, 15 the weights 2^d of all isomers add up to Catalan(n), and exactly one isomer has weight 1", ok)

print()
print("%d checks, %d passed" % (len(CHECKS), sum(1 for _, ok in CHECKS if ok)))
