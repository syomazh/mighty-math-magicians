# Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Not human-reviewed.
# E015: computer checks of the exact statements behind the candidate connections ranked in
# notes/2026-11-14_connections_ranked.md. Self-contained (standard library only).
#   uv run python experiments/E015_connections_ranked/run.py
# Every check prints PASS or FAIL with the range tested; the script exits with status 1 on a FAIL.
import itertools
import math
import sys
from functools import lru_cache

FAILS = []


def check(name, ok, detail=""):
    print(("PASS  " if ok else "FAIL  ") + name + ("   [" + detail + "]" if detail else ""))
    if not ok:
        FAILS.append(name)


# ---------------------------------------------------------------- basics
def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def s(m, p):
    return sum(digits(m, p))


def vp(x, p):
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def nu(m, p):  # carry budget = exponent of p in m!
    return (m - s(m, p)) // (p - 1)


def tval(m, p):
    return (s(m, p) - 1) // (p - 1)


# ---------------------------------------------------------------- plane p-ary trees
# leaf = (), node = tuple of p children
@lru_cache(maxsize=None)
def trees(p, n):
    """all plane p-ary trees with n internal nodes"""
    if n == 0:
        return ((),)
    out = []

    def comps(total, parts):
        if parts == 1:
            yield (total,)
            return
        for a in range(total + 1):
            for rest in comps(total - a, parts - 1):
                yield (a,) + rest

    for comp in comps(n - 1, p):
        for kids in itertools.product(*[trees(p, c) for c in comp]):
            out.append(tuple(kids))
    return tuple(out)


@lru_cache(maxsize=None)
def canon(T):
    """canonical representative of the rotation class"""
    if T == ():
        return ()
    kids = tuple(canon(c) for c in T)
    return min(kids[i:] + kids[:i] for i in range(len(kids)))


@lru_cache(maxsize=None)
def d_asym(T):
    """number of asymmetric nodes"""
    if T == ():
        return 0
    kids = [canon(c) for c in T]
    return sum(d_asym(c) for c in T) + (0 if all(k == kids[0] for k in kids) else 1)


def nodes(T):
    return 0 if T == () else 1 + sum(nodes(c) for c in T)


def leaves(T):
    return 1 if T == () else sum(leaves(c) for c in T)


def classes(p, n):
    """dict: canonical tree -> class size"""
    out = {}
    for T in trees(p, n):
        c = canon(T)
        out[c] = out.get(c, 0) + 1
    return out


# ================================================================ K0: the method itself (sanity)
ok = True
for p, nmax in ((2, 9), (3, 6), (5, 4)):
    for n in range(nmax + 1):
        m = (p - 1) * n + 1
        cl = classes(p, n)
        ok &= all(size == p ** d_asym(c) for c, size in cl.items())           # Step 1
        ok &= min(d_asym(c) for c in cl) == tval(m, p)                         # Steps 2, 3
        ok &= sum(cl.values()) == math.comb(p * n, n) // ((p - 1) * n + 1)
check("K0  class size p^d, minimum d = t, total = Fuss-Catalan", ok, "p=2 n<=9, p=3 n<=6, p=5 n<=4")


# ================================================================ K1: Sylow subgroups of S_m
# (a) automorphisms of a cyclic tree: p^(n-d) of them; n - d <= nu(m), equality iff d = t
ok_a = True
for p, nmax in ((2, 9), (3, 6), (5, 4)):
    for n in range(nmax + 1):
        m = (p - 1) * n + 1
        for c in classes(p, n):
            a = n - d_asym(c)                       # log_p of the number of automorphisms
            ok_a &= a <= nu(m, p) and ((a == nu(m, p)) == (d_asym(c) == tval(m, p)))
        ok_a &= nu(m, p) == vp(math.factorial(m), p) and n == nu(m, p) + tval(m, p)
check("K1a |Aut| = p^(n-d) <= p^nu(m) = p-part of m!, equality iff the tree is minimal", ok_a,
      "same ranges")


# (b) the automorphisms really form a group of leaf permutations of that order
def rotations_orbit(T_labelled):
    """orbit of a leaf-labelled plane tree under rotations at all nodes"""
    seen = {T_labelled}
    stack = [T_labelled]

    def rot_all(T):
        # all trees obtained by one rotation at one node
        if not isinstance(T, tuple):
            return []
        res = [T[1:] + T[:1]]
        for i, c in enumerate(T):
            for c2 in rot_all(c):
                res.append(T[:i] + (c2,) + T[i + 1:])
        return res

    while stack:
        T = stack.pop()
        for T2 in rot_all(T):
            if T2 not in seen:
                seen.add(T2)
                stack.append(T2)
    return seen


def label(T, counter=None):
    counter = counter if counter is not None else [0]
    if T == ():
        counter[0] += 1
        return counter[0]            # a leaf is its label (an int)
    return tuple(label(c, counter) for c in T)


def shape(T):
    return () if not isinstance(T, tuple) else tuple(shape(c) for c in T)


def leafword(T):
    return [T] if not isinstance(T, tuple) else [x for c in T for x in leafword(c)]


ok_b = True
tested = 0
for p, nmax in ((2, 5), (3, 3)):
    for n in range(1, nmax + 1):
        m = (p - 1) * n + 1
        for c in classes(p, n):
            L = label(c)
            orb = rotations_orbit(L)
            ok_b &= len(orb) == p ** n                              # free action on labelled trees
            perms = {tuple(leafword(T)) for T in orb if shape(T) == c}
            ok_b &= len(perms) == p ** (n - d_asym(c))             # automorphisms
            # closed under composition (a subgroup of S_m)
            ps = list(perms)
            ok_b &= all(tuple(a[b[i] - 1] for i in range(m)) in perms for a in ps[:8] for b in ps[:8])
            tested += 1
check("K1b automorphisms = a p-subgroup of S_m of order p^(n-d) (explicit leaf permutations)", ok_b,
      f"{tested} classes: p=2 n<=5, p=3 n<=3")

# (c) number of Sylow p-subgroups of S_m and the digit forests of the accounting proof
ok_c = True
for p in (2, 3, 5, 7):
    for m in range(1, 60):
        dg = digits(m, p)
        forest = math.factorial(m) // (p ** nu(m, p) * math.prod(math.factorial(x) for x in dg))
        ok_c &= forest % p == (-1) ** nu(m, p) % p
        syl = forest // math.prod((p - 1) ** (j * dg[j]) for j in range(len(dg)))
        ok_c &= syl * math.prod((p - 1) ** (j * dg[j]) for j in range(len(dg))) == forest
        ok_c &= syl % p == 1
check("K1c #Syl_p(S_m) = m!/(p^nu * prod m_j! * prod (p-1)^(j m_j)) is an integer = 1 mod p; "
      "digit forests = (-1)^nu mod p", ok_c, "p in 2,3,5,7, m < 60 (formula level)")


# ================================================================ K2: alkyl radicals (p = 3)
A000625 = [1, 1, 1, 2, 5, 11, 28, 74, 199]          # stereoisomeric alkyl radicals, n = 0..8
ok = True
rows = []
for n in range(0, 8):
    m = 2 * n + 1
    cl = classes(3, n)
    ok &= len(cl) == A000625[n]
    ok &= sum(cl.values()) == math.comb(3 * n, n) // (2 * n + 1)
    sizes = sorted(cl.values())
    ok &= sizes[0] == 3 ** tval(m, 3)
    # symmetry number of internal rotation = 3^(n - d); its maximum is 3^nu(m)
    ok &= max(3 ** (n - d_asym(c)) for c in cl) == 3 ** nu(m, 3)
    rows.append((n, len(cl), sum(cl.values()), tval(m, 3), sizes.count(sizes[0])))
check("K2  ternary classes = A000625; conformers 3^d sum to binom(3n,n)/(2n+1); "
      "fewest conformers 3^t; largest symmetry number 3^nu", ok, "n <= 7")
print("      n, stereoisomers, conformers in all, t, number of most rigid radicals:")
for r in rows:
    print("     ", r)
cl4 = classes(3, 4)
check("K2b butyl: 55 = 1 + 9 + 9 + 9 + 27", sorted(cl4.values()) == [1, 9, 9, 9, 27])


# ================================================================ K3: labelled trees (phylogenetics)
def labelled_classes(p, labels):
    """rotation classes of plane p-ary trees whose leaves carry the given labels, each once.
    Returned as canonical nested tuples with int leaves."""
    labels = tuple(labels)
    if len(labels) == 1:
        return {labels[0]}
    out = set()

    def can(T):
        if not isinstance(T, tuple):
            return T
        kids = tuple(can(c) for c in T)
        return min((kids[i:] + kids[:i] for i in range(len(kids))), key=repr)

    def splits(rest, k):
        # ordered set partitions of `rest` into k non-empty blocks of sizes = 1 mod (p-1)
        if k == 1:
            if len(rest) % (p - 1) == 1 % (p - 1) and rest:
                yield (rest,)
            return
        for r in range(1, len(rest) - k + 2):
            if r % (p - 1) != 1 % (p - 1):
                continue
            for block in itertools.combinations(rest, r):
                left = tuple(x for x in rest if x not in block)
                for tail in splits(left, k - 1):
                    yield (block,) + tail

    for blocks in splits(labels, p):
        for kids in itertools.product(*[labelled_classes_cached(p, b) for b in blocks]):
            out.add(can(tuple(kids)))
    return out


@lru_cache(maxsize=None)
def labelled_classes_cached(p, labels):
    return frozenset(labelled_classes(p, labels))


def has_cherry(T, C):
    if not isinstance(T, tuple):
        return False
    if all(not isinstance(c, tuple) for c in T) and set(T) == set(C):
        return True
    return any(has_cherry(c, C) for c in T)


def relabel(T, f):
    return f.get(T, T) if not isinstance(T, tuple) else tuple(relabel(c, f) for c in T)


def can_l(T):
    if not isinstance(T, tuple):
        return T
    kids = tuple(can_l(c) for c in T)
    return min((kids[i:] + kids[:i] for i in range(len(kids))), key=repr)


ok = True
for m in range(2, 8):                                   # binary: phylogenetic trees
    cls = labelled_classes_cached(2, tuple(range(1, m + 1)))
    dfact = math.prod(range(2 * m - 3, 0, -2))
    ok &= len(cls) == dfact and dfact % 2 == 1
    swap = {1: 2, 2: 1}
    fixed = [T for T in cls if can_l(relabel(T, swap)) == T]
    ok &= all(has_cherry(T, (1, 2)) for T in fixed)
    ok &= len(fixed) == (math.prod(range(2 * m - 5, 0, -2)) if m >= 3 else 1)
    # labellings of one shape: m!/2^(symmetric nodes)
    by_shape = {}
    for T in cls:
        by_shape[canon(shape(T))] = by_shape.get(canon(shape(T)), 0) + 1
    ok &= all(cnt == math.factorial(m) // 2 ** ((m - 1) - d_asym(sh)) for sh, cnt in by_shape.items())
check("K3a binary: classes of labelled trees = (2m-3)!! (odd); swapping two labels fixes a tree iff "
      "they are a cherry; labellings of a shape = m!/2^(symmetric nodes)", ok, "m <= 7")

ok = True
for p, tmax in ((3, 3), (5, 2)):
    for t in range(1, tmax + 1):
        sz = (p - 1) * t + 1
        cls = labelled_classes_cached(p, tuple(range(1, sz + 1)))
        L = math.factorial(p * t) // (math.factorial(t) * p ** t)
        ok &= len(cls) == L and L % p == (-1) ** t % p
        cyc = {i: i % p + 1 for i in range(1, p + 1)}           # the p-cycle (1 2 ... p)
        fixed = [T for T in cls if can_l(relabel(T, cyc)) == T]
        ok &= all(has_cherry(T, tuple(range(1, p + 1))) for T in fixed)
        Lprev = math.factorial(p * (t - 1)) // (math.factorial(t - 1) * p ** (t - 1))
        ok &= len(fixed) == (p - 1) * Lprev
check("K3b p = 3, 5: classes of labelled trees = (pt)!/(t! p^t) = (-1)^t mod p; a p-cycle of labels "
      "fixes exactly (p-1) L(t-1) classes, all with the cherry", ok, "p=3 t<=3, p=5 t<=2")


# ================================================================ K4: knockout tournaments (p = 2)
ok = True
rows = []
for m in range(1, 13):
    cl = classes(2, m - 1)
    dmin = min(d_asym(c) for c in cl)
    ok &= dmin == bin(m).count("1") - 1
    rows.append((m, len(cl), dmin, sum(1 for c in cl if d_asym(c) == dmin)))
check("K4  knockout formats: fewest unbalanced matches = (number of 1 bits of m) - 1", ok, "m <= 12")
print("      players, formats (Wedderburn-Etherington), fewest unbalanced matches, fairest formats:")
print("     ", rows)


# ================================================================ K5: carries as merges
ok = True
for base in (2, 3, 4, 5, 10):
    for m in range(1, 400):
        runs = []                    # runs[j] = number of runs on level j
        merges = 0
        for _ in range(m):
            runs = runs or [0]
            runs[0] += 1
            j = 0
            while runs[j] == base:   # `base` equal runs merge into one of the next level
                runs[j] = 0
                if j + 1 == len(runs):
                    runs.append(0)
                runs[j + 1] += 1
                merges += 1
                j += 1
        ok &= [r for r in runs] == digits(m, base) + [0] * (len(runs) - len(digits(m, base)))
        ok &= merges == (m - s(m, base)) // (base - 1)
        if base in (2, 3, 5):
            ok &= merges == vp(math.factorial(m), base)
check("K5  tiered merging in base b: levels = digits of m; merges = (m - s_b(m))/(b-1) "
      "(= exponent of b in m! for prime b)", ok, "b in 2,3,4,5,10, m < 400")


# binomial heap: links when building by successive insertions
def heap_links(m):
    ranks = []                       # list of ranks of the trees present
    links = 0
    for _ in range(m):
        r = 0
        while r in ranks:
            ranks.remove(r)
            links += 1
            r += 1
        ranks.append(r)
    return links, sorted(ranks)


ok = all(heap_links(m) == (m - bin(m).count("1"), [j for j, b in enumerate(digits(m, 2)) if b])
         for m in range(1, 600))
check("K5b binomial heap: trees = 1 bits of m; links = m - (number of 1 bits)", ok, "m < 600")


# ================================================================ K6: the Merkle tree of RFC 6962
def merkle(n):
    """tree shape of RFC 6962: split at the largest power of two smaller than n"""
    if n == 1:
        return ()
    k = 1
    while 2 * k < n:
        k *= 2
    return (merkle(k), merkle(n - k))


def perfect_subtrees(T):
    """sizes of the maximal perfect subtrees"""
    def perfect(T):
        if T == ():
            return 0
        a, b = perfect(T[0]), perfect(T[1])
        return a + 1 if a is not None and a == b else None
    h = perfect(T)
    if h is not None:
        return [2 ** h]
    return perfect_subtrees(T[0]) + perfect_subtrees(T[1])


ok = True
for n in range(1, 200):
    T = merkle(n)
    ok &= leaves(T) == n and d_asym(T) == bin(n).count("1") - 1
    ok &= sorted(perfect_subtrees(T)) == sorted(2 ** j for j, b in enumerate(digits(n, 2)) if b)
check("K6  RFC 6962 Merkle tree: asymmetric nodes = (1 bits of n) - 1 (the minimum); its perfect "
      "subtrees are the binary digits of n", ok, "n < 200")


# ================================================================ K7: wrap-around carries (prime powers)
ok = True
for p, k in ((2, 2), (2, 3), (3, 2), (5, 2), (2, 4)):
    q = p ** k
    for n in range(0, 40):
        m = (q - 1) * n + 1
        # digits of m, folded onto a ring of k positions: weight is unchanged modulo q - 1
        ring = sum(dj * p ** (j % k) for j, dj in enumerate(digits(m, p)))
        ok &= ring % (q - 1) == 1 % (q - 1)
check("K7  for m = (q-1)n+1, q = p^k: the digits of m folded onto k positions weigh 1 modulo "
      "p^k - 1 (end-around carry)", ok, "(p,k) in (2,2),(2,3),(3,2),(5,2),(2,4), n < 40")

# ================================================================ K8: symmetry numbers (chemistry)
# Domalski and Hearing (1988), Appendix D, pp. 1655-1657. The numbers in DH below are copied from the
# paper's worked examples (text layer of the NIST reprint, read by the orchestrator on 2026-11-14).
#
# HISTORY (do not delete): the first version of this check listed "ethyl group (ethane = ethyl-H): 3"
# as a value of the paper. It is not: the paper gives N(int) = 3 x 3 = 9 for ethane. An independent
# fresh-context agent found this on 2026-11-14. The expected value had been typed from the model, not
# from the source. The CLAIM is therefore changed (the model describes a group attached to something
# without symmetry of its own, not a whole alkane), and the check now carries the paper's numbers.
#
# Model: an alkyl group R attached to a generic X is a rooted ternary tree; its number is
# 3^(number of symmetric nodes), "sym" below.
# (a) Groups on a benzene ring or a double bond: the paper's N(int) is sym(R), times 2 for the ring.
# (b) Whole alkanes R-R' (cut at one bond): sym(R) * sym(R') divides the paper's N(tot); the quotient
#     is symmetry that moves the cut bond, which the model does not see. Quotients 1, 2, 4 as listed.
H = ()
ME = (H, H, H)                                   # methyl
def C(a, b, c):
    return (a, b, c)

def sym_nodes(T):
    return nodes(T) - d_asym(T)

def symnum(T):
    return 3 ** sym_nodes(T)

tert_butyl = C(ME, ME, ME)
ethyl = C(H, H, ME)
isopropyl = C(H, ME, ME)
# (a) name: (group, other factor in the paper, paper's N(int))
DH_groups = {
    "toluene (methyl on a ring)": (ME, 2, 6),
    "t-butylbenzene (tert-butyl on a ring)": (tert_butyl, 2, 162),
    "propylene (methyl on a double bond)": (ME, 1, 3),
}
ok_a = all(symnum(T) * other == val for T, other, val in DH_groups.values())
# (b) name: (R, R', paper's N(tot), quotient)
DH_alkanes = {
    "methane = methyl-H": (ME, H, 12, 4),
    "ethane = methyl-methyl": (ME, ME, 18, 2),
    "n-butane = ethyl-ethyl (paper: 18 for every n-alkane)": (ethyl, ethyl, 18, 2),
    "2-methylpropane = tert-butyl-H": (tert_butyl, H, 81, 1),
    "2,2-dimethylpropane = tert-butyl-methyl": (tert_butyl, ME, 972, 4),
    "2,2-dimethylbutane = tert-butyl-ethyl": (tert_butyl, ethyl, 243, 1),
    "2,2,3,3-tetramethylbutane = tert-butyl-tert-butyl": (tert_butyl, tert_butyl, 13122, 2),
    "2-methylbutane = isopropyl-ethyl": (isopropyl, ethyl, 27, 1),
}
ok_b = all(symnum(R) * symnum(R2) * quo == tot for R, R2, tot, quo in DH_alkanes.values())
check("K8  Domalski-Hearing: groups on a ring or double bond have N(int) = 3^(symmetric nodes) "
      "(times 2 for a ring); for alkanes R-R', 3^sym(R) * 3^sym(R') * (1, 2 or 4) = N(tot)",
      ok_a and ok_b, "3 groups, 8 alkanes; the quotient is not predicted by the model")
print("      alkane: model product, paper's N(tot), quotient")
for name, (R, R2, tot, quo) in DH_alkanes.items():
    print("       %-52s %5d %6d %d" % (name, symnum(R) * symnum(R2), tot, quo))
# orbit-stabilizer in the butyl picture: class size * symmetry number = 3^4
ok = all(size * 3 ** sym_nodes(c) == 81 for c, size in classes(3, 4).items())
check("K8b butyl groups: (number of ordered trees) * (symmetry number) = 81 for each of the five", ok)
print("      butyl groups: (class size, symmetry number):",
      sorted((size, 3 ** sym_nodes(c)) for c, size in classes(3, 4).items()))


# ================================================================ K9: Vuillemin's merge costs
def ones(n):
    return bin(n).count("1")

def carries_add(a, b, base=2):
    c, carry = 0, 0
    while a or b or carry:
        s_ = a % base + b % base + carry
        carry = 1 if s_ >= base else 0
        c += carry
        a //= base
        b //= base
    return c

ok = all(ones(a) + ones(b) - ones(a + b) == carries_add(a, b) for a in range(1, 200) for b in range(1, 200))
# along any binary merge tree with m leaves the total cost is m - ones(m)
def merge_cost(T):
    if T == ():
        return 0
    a, b = leaves(T[0]), leaves(T[1])
    return merge_cost(T[0]) + merge_cost(T[1]) + ones(a) + ones(b) - ones(a + b)

ok2 = all(merge_cost(T) == leaves(T) - ones(leaves(T)) for n in range(0, 9) for T in trees(2, n))
check("K9  binomial queues: UNION(n, n') costs ones(n)+ones(n')-ones(n+n') = carries of n+n'; "
      "any merge order of m singletons costs m - ones(m)", ok and ok2, "n, n' < 200; all binary trees, m <= 9")


# ================================================================ K10: staggered conformers (OEIS A121179)
# The OEIS entry A121179 (data copied from the entry on 2026-11-14) is, by its comment, the number of
# staggered conformers of alkyls with n carbons; the same comment calls A001764(n) the number of
# positions of such conformers relative to another group without threefold symmetry.
# Claim checked: A121179(n) = number of ORDERED ternary trees with n nodes up to rotation at the
# root only, so an ordered tree is a conformer together with its position about the root bond, and
# a rotation class with d asymmetric nodes holds 3^d such positions.
A121179 = [1, 1, 1, 4, 19, 91, 476, 2586, 14421]
ok = True
for n in range(0, 9):
    seen = set()
    for T in trees(3, n):
        seen.add(min(T[i:] + T[:i] for i in range(3)) if T else ())
    ok &= len(seen) == A121179[n]
    # the formula in the entry: a(n) = A001764(n)/3, plus (2/3) A001764((n-1)/3) when n = 1 mod 3
    if n >= 1:
        b = lambda j: math.comb(3 * j, j) // (2 * j + 1)
        val = b(n) + (2 * b((n - 1) // 3) if n % 3 == 1 else 0)
        ok &= val % 3 == 0 and val // 3 == A121179[n]
check("K10 ordered ternary trees up to rotation at the root = A121179 (staggered conformers of alkyls)",
      ok, "n <= 8")

# ================================================================ K11: quadtrees (q = 4 = 2^2)
# A 4-ary node with quarters (NW, NE, SE, SW) is read as two levels of binary nodes that keep the
# diagonals together: ((NW, SE), (NE, SW)). Claims: (i) the permutations of the four quarters that
# the binary rotations generate are exactly the 8 symmetries of the square; (ii) families of
# pictures have 2^d members; with 3 cuts 22 = 2 + 4 + 16; the smallest family has 2^t pictures;
# (iii) the number of families is OEIS A398109 (data copied from the entry on 2026-11-14).
A398109 = [1, 1, 1, 3, 6, 17, 44]
def to_binary(T):          # 4-ary tree (NW, NE, SE, SW) -> binary tree with leaves at even depth
    if T == ():
        return ()
    nw, ne, se, sw = (to_binary(c) for c in T)
    return ((nw, se), (ne, sw))

def closure(gens):
    idn = tuple(range(4))
    seen, todo = {idn}, [idn]
    while todo:
        g = todo.pop()
        for h in gens:
            x = tuple(g[h[i]] for i in range(4))
            if x not in seen:
                seen.add(x)
                todo.append(x)
    return seen

# positions 0 = NW, 1 = NE, 2 = SE, 3 = SW
square = closure([(1, 2, 3, 0), (1, 0, 3, 2)])                    # quarter turn; mirror left-right
ours = closure([(2, 1, 0, 3), (0, 3, 2, 1), (1, 0, 3, 2)])        # swap NW/SE; swap NE/SW; swap the pairs
ok = square == ours and len(ours) == 8
rows = []
for n in range(0, 6):
    fam = {}
    for T in trees(4, n):
        c = canon(to_binary(T))
        fam[c] = fam.get(c, 0) + 1
    m = 3 * n + 1
    ok &= all(size == 2 ** d_asym(c) for c, size in fam.items())
    ok &= min(fam.values()) == 2 ** tval(m, 2) and len(fam) == A398109[n]
    ok &= sum(fam.values()) == math.comb(4 * n, n) // (3 * n + 1)
    rows.append((n, sum(fam.values()), sorted(fam.values())[:6]))
fam = {}
for T in trees(4, 3):
    c = canon(to_binary(T))
    fam[c] = fam.get(c, 0) + 1
ok &= sorted(fam.values()) == [2, 4, 16]
check("K11 quadtrees: the proof's group at a 4-ary node = the 8 symmetries of the square; families "
      "of 2^d pictures; 22 = 2 + 4 + 16; number of families = A398109", ok, "n <= 5 cuts")

print()
print("ALL PASS" if not FAILS else "FAILED: " + ", ".join(FAILS))
sys.exit(1 if FAILS else 0)
