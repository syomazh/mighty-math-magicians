# EC01 - the chemistry tower: plane ternary trees -> stereoisomers -> structural isomers.
# Written by Claude Fable 5.2 (AI), 2026-11-14, in a second Claude Code session working with a
# team member (not the orchestrator). Not human-reviewed. Standard library only.
# Run from the repository root:  python3 guests/andrei-claudecode/experiments/EC01_chemistry_tower/run.py
#
# Model (Robinson-Harary-Balaban 1976, Polya 1936, Blair-Henze 1932): a monosubstituted alkane
# C_nH_(2n+1)X is a ternary tree with n nodes (carbons); the root hangs from X; a leaf is a hydrogen.
#   plane tree      = the three branches of every carbon are ordered        (group: trivial)
#   steric tree     = ordered up to cyclic rotation at every carbon         (group: C3)  = stereoisomer
#   structural tree = branches unordered                                    (group: S3)  = structural isomer

from math import comb, factorial
from fractions import Fraction
from collections import Counter, defaultdict

NMAX = 14     # classes are generated up to this many carbons
BRUTE = 8     # plane trees are listed one by one up to this many carbons
GROUPMAX = 8  # symmetry groups are built as permutation groups of the hydrogens up to this size

CHECKS = []


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok)))
    print(("PASS  " if ok else "FAIL  ") + name + ("   " + detail if detail else ""))
    assert ok, name


# --------------------------------------------------------------------------------------------
# 1. Steric classes (rotation classes) as integer ids
# --------------------------------------------------------------------------------------------
LEAF = 0
kids = [None]          # kids[i] = canonical triple of child ids
size = [0]
index = {}
by_size = [[LEAF]]


def rot_canon(a, b, c):
    return min((a, b, c), (b, c, a), (c, a, b))


for n in range(1, NMAX + 1):
    new = []
    for i in range(n):
        for j in range(n - i):
            k = n - 1 - i - j
            for a in by_size[i]:
                for b in by_size[j]:
                    for c in by_size[k]:
                        t = (a, b, c)
                        if t == rot_canon(a, b, c):
                            index[t] = len(kids)
                            new.append(len(kids))
                            kids.append(t)
                            size.append(n)
    by_size.append(new)

NCLS = len(kids)
d = [0] * NCLS          # carbons whose three branches are NOT all alike  (the team's "asymmetric nodes")
stg = [0] * NCLS        # carbons whose three branches are pairwise different (stereogenic centres)
mirror = [0] * NCLS
struct = [0] * NCLS     # id of the structural isomer
sindex = {}
skids = [None]
for i in range(1, NCLS):
    a, b, c = kids[i]
    d[i] = d[a] + d[b] + d[c] + (0 if a == b == c else 1)
    stg[i] = stg[a] + stg[b] + stg[c] + (1 if len({a, b, c}) == 3 else 0)
    mirror[i] = index[rot_canon(mirror[c], mirror[b], mirror[a])]
    key = tuple(sorted((struct[a], struct[b], struct[c])))
    if key not in sindex:
        sindex[key] = len(skids)
        skids.append(key)
    struct[i] = sindex[key]

NS = len(skids)
ssize = [0] * NS
alpha = [0] * NS        # Polya's asymmetric carbons of a structural formula: three branches pairwise different
s3orbit = [1] * NS      # number of plane trees over a structural isomer (orbit of the full group, Konvalinka)
for j in range(1, NS):
    a, b, c = skids[j]
    ssize[j] = 1 + ssize[a] + ssize[b] + ssize[c]
    k = len({a, b, c})
    alpha[j] = alpha[a] + alpha[b] + alpha[c] + (1 if k == 3 else 0)
    s3orbit[j] = s3orbit[a] * s3orbit[b] * s3orbit[c] * {1: 1, 2: 3, 3: 6}[k]


def smiles(i):
    """SMILES of the alcohol (X = OH) of steric class i, without stereo descriptors."""
    def carbon(v):
        parts = sorted((carbon(c) for c in kids[v] if c != LEAF), key=lambda s: (len(s), s))
        return "C" + "".join("(%s)" % p for p in parts[:-1]) + (parts[-1] if parts else "")
    return "O" + carbon(i) if i != LEAF else "O"


def digits3(m):
    out = []
    while m:
        out.append(m % 3)
        m //= 3
    return out


def v3(x):
    k = 0
    while x % 3 == 0:
        x //= 3
        k += 1
    return k


print("=" * 100)
print("PART A - the three counts against the chemical literature (n = 0..%d carbons)" % NMAX)
print("=" * 100)
RHB_steric = [1, 1, 1, 2, 5, 11, 28, 74, 199, 551, 1553, 4436, 12832, 37496, 110500]      # RHB 1976 Table 2 = A000625
RHB_quartic = [1, 1, 1, 2, 4, 8, 17, 39, 89, 211, 507, 1238, 3057, 7639, 19241]           # = A000598
RHB_achiral = [1, 1, 1, 2, 3, 5, 8, 14, 23, 41, 69, 122, 208, 370, 636]                   # RHB Table 2 (A005627)
A005628_chiral = [0, 0, 0, 0, 2, 6, 20, 60, 176, 510, 1484, 4314, 12624, 37126, 109864]   # OEIS A005628
POLYA_q = [1, 1, 1, 2, 3, 5, 8, 14, 23, 39, 65, 110, 184, 310, 520]                       # A000621: no asymmetric carbon
BH_stereo = [0, 0, 0, 0, 2, 6, 20, 60, 176, 512, 1488, 4326, 12648, 37186, 109980]        # A000620 (Blair-Henze)

steric = [len(by_size[n]) for n in range(NMAX + 1)]
structural = [len({struct[i] for i in by_size[n]}) for n in range(NMAX + 1)]
achiral = [sum(1 for i in by_size[n] if mirror[i] == i) for n in range(NMAX + 1)]
nostereo = [sum(1 for i in by_size[n] if stg[i] == 0) for n in range(NMAX + 1)]
plane = [comb(3 * n, n) // (2 * n + 1) for n in range(NMAX + 1)]
print("n            :", list(range(NMAX + 1)))
print("plane trees  :", plane)
print("stereoisomers:", steric)
print("structural   :", structural)
print("achiral      :", achiral)
print("no stereogenic centre:", nostereo)
check("A1 number of rotation classes = stereoisomers of C_nH_(2n+1)X (RHB Table 2, OEIS A000625)", steric == RHB_steric)
check("A2 classes up to all permutations = structural isomers (RHB Table 2, OEIS A000598)", structural == RHB_quartic)
check("A3 classes equal to their mirror image = achiral (RHB Table 2)", achiral == RHB_achiral)
check("A4 chiral = stereo - achiral (OEIS A005628)", [s - a for s, a in zip(steric, achiral)] == A005628_chiral)
check("A5 classes with no stereogenic centre = Polya's q (OEIS A000621)", nostereo == POLYA_q)
check("A6 stereo - q = Blair-Henze 'stereoisomeric' column (OEIS A000620)", [s - q for s, q in zip(steric, nostereo)] == BH_stereo)
first = next(n for n in range(NMAX + 1) if achiral[n] != nostereo[n])
extra = [smiles(i) for i in by_size[first] if mirror[i] == i and stg[i] > 0]
check("A7 'achiral' and 'no stereogenic centre' first differ at n = 9, by two meso-type alcohols", first == 9 and len(extra) == 2,
      "n=%d: %s" % (first, extra))

print()
print("=" * 100)
print("PART B - the 3^d law: plane trees over one stereoisomer")
print("=" * 100)
check("B1 sum over stereoisomers of 3^d = binom(3n,n)/(2n+1), n = 0..%d" % NMAX,
      all(sum(3 ** d[i] for i in by_size[n]) == plane[n] for n in range(NMAX + 1)))

# brute force: list plane trees as nested tuples and sort them into classes
memo = {(): LEAF}


def class_of(t):
    if t not in memo:
        a, b, c = (class_of(x) for x in t)
        memo[t] = index[rot_canon(a, b, c)]
    return memo[t]


plane_trees = [[()]]
for n in range(1, BRUTE + 1):
    cur = []
    for i in range(n):
        for j in range(n - i):
            k = n - 1 - i - j
            for a in plane_trees[i]:
                for b in plane_trees[j]:
                    for c in plane_trees[k]:
                        cur.append((a, b, c))
    plane_trees.append(cur)
ok = True
for n in range(BRUTE + 1):
    cnt = Counter(class_of(t) for t in plane_trees[n])
    ok &= len(plane_trees[n]) == plane[n] and set(cnt) == set(by_size[n]) and all(cnt[i] == 3 ** d[i] for i in cnt)
check("B2 brute force, n = 0..%d: every stereoisomer carries exactly 3^d plane trees" % BRUTE, ok)

ok = all(sum(3 ** d[i] for i in by_size[n] if struct[i] == j) == s3orbit[j]
         for n in range(NMAX + 1) for j in {struct[i] for i in by_size[n]})
check("B3 orbit of the full group (structural isomer) = sum of 3^d over its stereoisomers", ok)
print("   n = 4:  structural isomers carry", sorted(s3orbit[j] for j in {struct[i] for i in by_size[4]}),
      " stereoisomers carry", sorted(3 ** d[i] for i in by_size[4]))
for n in (4, 5, 6, 7, 8):
    sj = {struct[i] for i in by_size[n]}
    bad = sum(1 for j in sj if 3 ** v3(s3orbit[j]) != s3orbit[j])
    print("   n = %d: %d of %d structural isomers carry a number of plane trees that is NOT a power of 3" % (n, bad, len(sj)))

print()
print("=" * 100)
print("PART C - stereogenic centres: the 2026 table of Eriksen and Merkle (arXiv 2609.02932)")
print("=" * 100)
EM_322 = {1: [1], 2: [1], 3: [2], 4: [3, 2], 5: [5, 6], 6: [8, 16, 4], 7: [14, 40, 20], 8: [23, 92, 76, 8],
          9: [39, 204, 250, 58], 10: [65, 440, 732, 300, 16], 11: [110, 922, 2000, 1240, 164]}
EM_321 = {1: [1], 2: [1], 3: [2], 4: [3, 1], 5: [5, 3], 6: [8, 8, 1], 7: [14, 20, 5], 8: [23, 46, 19, 1],
          9: [39, 102, 63, 7], 10: [65, 220, 184, 37, 1], 11: [110, 461, 503, 154, 10]}


def row(counter):
    return [counter[k] for k in range(max(counter) + 1)]


ok1 = all(row(Counter(stg[i] for i in by_size[n])) == EM_322[n] for n in EM_322)
ok2 = all(row(Counter(alpha[j] for j in {struct[i] for i in by_size[n]})) == EM_321[n] for n in EM_321)
check("C1 stereoisomers by number of stereogenic centres = their Table 3.2.2 (n = 1..11)", ok1)
check("C2 structural isomers by number of asymmetric carbons = their Table 3.2.1 (n = 1..11)", ok2)
print("   joint distribution for stereoisomers: rows d (branches not all alike), columns stereogenic centres")
for n in (4, 5, 6, 7):
    joint = Counter((d[i], stg[i]) for i in by_size[n])
    ds = sorted({k[0] for k in joint})
    ss = sorted({k[1] for k in joint})
    print("   n = %d" % n)
    for dd in ds:
        print("      d = %d: " % dd + "  ".join("%d with %d stg" % (joint[(dd, s)], s) for s in ss if joint[(dd, s)]))

print()
print("=" * 100)
print("PART D - Polya 1936, equations (23)-(25), and the van 't Hoff rule 2^alpha")
print("=" * 100)


def mul(P, Q, N):
    R = defaultdict(Fraction)
    for (i, a), u in P.items():
        for (j, b), v in Q.items():
            if i + j <= N:
                R[(i + j, a + b)] += u * v
    return R


def subs(P, k, N):
    return {(k * i, k * a): u for (i, a), u in P.items() if k * i <= N}


def shift(P, dx, dy, N, factor=Fraction(1)):
    return {(i + dx, a + dy): u * factor for (i, a), u in P.items() if i + dx <= N}


def add(*Ps):
    R = defaultdict(Fraction)
    for P in Ps:
        for k, v in P.items():
            R[k] += v
    return {k: v for k, v in R.items() if v != 0}


def solve(step, N):
    P = {(0, 0): Fraction(1)}
    for _ in range(N + 2):
        P = step(P, N)
    return P


def polya24(Q, N):
    # Q = 1 + x Q(x,y) Q(x^2,y^2) + x y [Q^3 - 3 Q Q(x^2,y^2) + 2 Q(x^3,y^3)] / 6
    Q2, Q3 = subs(Q, 2, N), subs(Q, 3, N)
    QQ2 = mul(Q, Q2, N)
    cube = mul(mul(Q, Q, N), Q, N)
    inner = add(cube, {k: -3 * v for k, v in QQ2.items()}, {k: 2 * v for k, v in Q3.items()})
    return add({(0, 0): Fraction(1)}, shift(QQ2, 1, 0, N), shift(inner, 1, 1, N, Fraction(1, 6)))


def team3(A, N):
    # A = 1 + x A(x^3,y^3) + x y [A^3 - A(x^3,y^3)] / 3      (the team's deformed equation, p = 3, by carbons)
    A3 = subs(A, 3, N)
    cube = mul(mul(A, A, N), A, N)
    inner = add(cube, {k: -v for k, v in A3.items()})
    return add({(0, 0): Fraction(1)}, shift(A3, 1, 0, N), shift(inner, 1, 1, N, Fraction(1, 3)))


Q = solve(polya24, NMAX)
ok = True
for n in range(NMAX + 1):
    enum = Counter(alpha[j] for j in {struct[i] for i in by_size[n]})
    ser = {a: v for (i, a), v in Q.items() if i == n}
    ok &= {a: Fraction(v) for a, v in enum.items()} == ser
check("D1 Polya's equation (24) for Q(x,y) reproduces 'structural isomers by asymmetric carbons', n = 0..%d" % NMAX, ok)

firsts = {}
for n in range(NMAX + 1):
    for j in {struct[i] for i in by_size[n]}:
        firsts.setdefault(alpha[j], []).append(n)
ok = all(min(firsts[a]) == 2 * a + 2 and firsts[a].count(2 * a + 2) == 1 for a in range(1, 7))
check("D2 Polya: alpha asymmetric carbons first occur at n = 2 alpha + 2, in a single structure (alpha = 1..6)", ok)

nstereo = Counter(struct[i] for i in range(NCLS))
viol = [(ssize[j], j) for j in range(NS) if nstereo[j] != 2 ** alpha[j]]
firstn = min(v[0] for v in viol)
at_first = [j for (nn, j) in viol if nn == firstn]
rep = next(i for i in by_size[firstn] if struct[i] == at_first[0])
check("D3 Polya: 'stereoisomers = 2^alpha' first fails at C13H27OH, for a single structure",
      firstn == 13 and len(at_first) == 1,
      "structure %s: alpha = %d, 2^alpha = %d, actual stereoisomers = %d" % (smiles(rep), alpha[at_first[0]], 2 ** alpha[at_first[0]], nstereo[at_first[0]]))
print("   so the 2^alpha rule is a rule with exceptions (always <=), while the 3^d law of Part B has none.")
check("D4 where it fails the true number is smaller than 2^alpha", all(nstereo[j] < 2 ** alpha[j] for (_, j) in viol))

A = solve(team3, NMAX)
ok = True
for n in range(NMAX + 1):
    enum = Counter(d[i] for i in by_size[n])
    ser = {a: v for (i, a), v in A.items() if i == n}
    ok &= {a: Fraction(v) for a, v in enum.items()} == ser
check("D5 the team's deformed equation (p = 3) reproduces 'stereoisomers by d', n = 0..%d" % NMAX, ok)
ok = all(sum(v * 3 ** a for (i, a), v in A.items() if i == n) == plane[n] for n in range(NMAX + 1))
check("D6 at y = 3 it gives the Fuss-Catalan numbers, at y = 1 the stereoisomer numbers (Polya's (25))",
      ok and all(sum(v for (i, a), v in A.items() if i == n) == steric[n] for n in range(NMAX + 1)))
print("   n : Polya Q_n(y) [structural isomers, y marks asymmetric carbons]   |   team A_n(y) [stereoisomers, y marks d]")
for n in range(1, 9):
    def poly(P):
        co = sorted((a, v) for (i, a), v in P.items() if i == n)
        return " + ".join(("%d" % v if a == 0 else ("%dy^%d" % (v, a))) for a, v in co)
    print("   %d : %-45s |   %s" % (n, poly(Q), poly(A)))

print()
print("=" * 100)
print("PART E - the most symmetric alcohols (minimal classes) and the symmetry number")
print("=" * 100)
print("   n   H=2n+1  base 3   t   stereoisomers  min d  #minimal (chiral+achiral)  formula  3-part of H!   most symmetric alcohols")
okmin = okcount = okres = oksig = True
for n in range(1, NMAX + 1):
    m = 2 * n + 1
    dg = digits3(m)
    s = sum(dg)
    t = (s - 1) // 2
    mind = min(d[i] for i in by_size[n])
    mins = [i for i in by_size[n] if d[i] == mind]
    den = 1
    for x in dg:
        den *= factorial(x)
    formula = Fraction(factorial(3 * t), factorial(t) * 3 ** t * den)
    okmin &= mind == t
    okcount &= formula == len(mins)
    okres &= (len(mins) * den - (-1) ** t) % 3 == 0
    oksig &= 3 ** (n - mind) == 3 ** v3(factorial(m))
    ch = sum(1 for i in mins if mirror[i] != i)
    names = sorted({smiles(i) for i in mins})
    print("   %-3d %-6d %-8s %-3d %-13d %-6d %-4d (%d+%d) %18s %12d   %s" % (
        n, m, "".join(map(str, reversed(dg))), t, steric[n], mind, len(mins), ch, len(mins) - ch, formula, 3 ** v3(factorial(m)),
        ", ".join(names[:3]) + (" ..." if len(names) > 3 else "")))
check("E1 fewest 'not all alike' carbons = t = (digit sum of 2n+1 in base 3 - 1)/2, n = 1..%d" % NMAX, okmin)
check("E2 number of most symmetric stereoisomers = (3t)!/(t! 3^t prod m_j!)  (claim C8, p = 3)", okcount)
check("E3 that number times prod m_j! is congruent to (-1)^t mod 3 (so it is never divisible by 3)", okres)
check("E4 largest symmetry number 3^(n - t) = largest power of 3 dividing (2n+1)!", oksig)

print()
print("=" * 100)
print("PART F - symmetry groups as permutations of the hydrogens (n <= %d)" % GROUPMAX)
print("=" * 100)


def leaves(i):
    return 1 if i == LEAF else sum(leaves(c) for c in kids[i])


def generators(i, offset=0, total=None, gens=None):
    """Rotations at the carbons whose three branches are alike, as permutations of the leaves."""
    if gens is None:
        gens = []
        total = leaves(i)
    if i == LEAF:
        return gens
    a, b, c = kids[i]
    la = leaves(a)
    if a == b == c:
        g = list(range(total))
        for r in range(la):
            g[offset + r], g[offset + la + r], g[offset + 2 * la + r] = offset + la + r, offset + 2 * la + r, offset + r
        gens.append(tuple(g))
    off = offset
    for ch in (a, b, c):
        generators(ch, off, total, gens)
        off += leaves(ch)
    return gens


def closure(gens, n):
    ident = tuple(range(n))
    seen = {ident}
    frontier = [ident]
    while frontier:
        nxt = []
        for g in frontier:
            for h in gens:
                x = tuple(h[g[k]] for k in range(n))
                if x not in seen:
                    seen.add(x)
                    nxt.append(x)
        frontier = nxt
    return seen


def orbits(gens, n):
    parent = list(range(n))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x
    for g in gens:
        for k in range(n):
            parent[find(k)] = find(g[k])
    return Counter(find(k) for k in range(n))


okord = okorb = True
eq_nonmin = []
for n in range(1, GROUPMAX + 1):
    m = 2 * n + 1
    s = sum(digits3(m))
    t = (s - 1) // 2
    for i in by_size[n]:
        gens = generators(i)
        G = closure(gens, m)
        okord &= len(G) == 3 ** (n - d[i])
        orb = orbits(gens, m)
        okorb &= len(orb) >= s and all(3 ** v3(x) == x for x in orb.values())
        if len(orb) == s and d[i] != t:
            eq_nonmin.append("%s (n = %d, d = %d, t = %d)" % (smiles(i), n, d[i], t))
        if d[i] == t:
            okorb &= len(orb) == s and sorted(orb.values()) == sorted(3 ** j for j, x in enumerate(digits3(m)) for _ in range(x))
check("F1 the rotations that keep a stereoisomer form a group of order 3^(carbons with three like branches)", okord)
check("F2 it splits the hydrogens into at least (digit sum of 2n+1) classes; the most symmetric reach it, with class sizes = the digits", okorb,
      "%d others reach it without being most symmetric, first: %s" % (len(eq_nonmin), eq_nonmin[0] if eq_nonmin else "none"))

# Gilson and Irikura 2010, worked example 'tert-butyl radical': hydrogens numbered 1..9
gi_rot = tuple(x - 1 for x in [7, 8, 9, 1, 2, 3, 4, 5, 6])
gi_tor = tuple(x - 1 for x in [3, 1, 2, 4, 5, 6, 7, 8, 9])
gi_inv = tuple(x - 1 for x in [1, 2, 3, 7, 8, 9, 4, 5, 6])
g81 = closure([gi_rot, gi_tor], 9)
g162 = closure([gi_rot, gi_tor, gi_inv], 9)
tbu = index[rot_canon(*(index[(LEAF, LEAF, LEAF)],) * 3)]
ours = closure(generators(tbu), 9)
check("F3 Gilson-Irikura's generators for tert-butyl give groups of order 81 (rotations) and 162 (with inversion)",
      len(g81) == 81 and len(g162) == 162)
check("F4 the tree symmetry group of tert-butyl is the same group of 81 permutations of the 9 hydrogens", ours == g81,
      "81 = 3^4 = largest power of 3 dividing 9! = %d" % 3 ** v3(factorial(9)))

print()
print("=" * 100)
print("PART G - the alcohols with up to 5 carbons")
print("=" * 100)
NAMES = {"OC": "methanol", "OCC": "ethanol", "OCCC": "propan-1-ol", "OC(C)C": "propan-2-ol",
         "OCCCC": "butan-1-ol", "OC(C)CC": "butan-2-ol", "OCC(C)C": "2-methylpropan-1-ol", "OC(C)(C)C": "2-methylpropan-2-ol (tert-butanol)",
         "OCCCCC": "pentan-1-ol", "OC(C)CCC": "pentan-2-ol", "OC(CC)CC": "pentan-3-ol", "OCC(C)CC": "2-methylbutan-1-ol",
         "OCCC(C)C": "3-methylbutan-1-ol", "OC(C)(C)CC": "2-methylbutan-2-ol", "OC(C)C(C)C": "3-methylbutan-2-ol",
         "OCC(C)(C)C": "2,2-dimethylpropan-1-ol (neopentyl alcohol)"}
print("   n  SMILES        name                                         mirror forms  d  like-branched C  stereogenic  plane trees  symmetry number")
seen = set()
tot = Counter()
for n in range(1, 6):
    for i in sorted(by_size[n], key=lambda i: (d[i], smiles(i))):
        if mirror[i] in seen:
            continue
        seen.add(i)
        forms = 1 if mirror[i] == i else 2
        tot[n] += forms * 3 ** d[i]
        sm = smiles(i)
        print("   %d  %-13s %-44s %-13d %-2d %-16d %-12d %-12s %d" % (
            n, sm, NAMES[sm], forms, d[i], n - d[i], stg[i], ("%d" % 3 ** d[i]) + (" each" if forms == 2 else ""), 3 ** (n - d[i])))
    print("      total plane trees for n = %d: %d = binom(%d,%d)/%d" % (n, tot[n], 3 * n, n, 2 * n + 1))
check("G1 every alcohol with up to 5 carbons is named, and the plane trees add up", all(tot[n] == plane[n] for n in range(1, 6)))

print()
print("%d checks, %d passed" % (len(CHECKS), sum(1 for _, ok in CHECKS if ok)))
