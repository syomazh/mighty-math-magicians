# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# Test of a refinement of C6/C7 by a rotation-invariant statistic: the leaf-depth profile of a q-ary tree.
# Claim tested: for q = p^k, the number N(l) of q-ary trees with n internal nodes and l_D leaves at depth D is divisible by p^t, and
#   N(l)/p^t = (-1)^t * sum over matrices (a[delta][j]) of prod 1/a[delta][j]!   (mod p),
# where a[delta][j] = number of atoms (complete p-ary subtrees) of height j whose root is at depth delta in the k-blocked p-ary tree,
# column sums = base-p digits m_j of m = (q-1)n+1, delta + j = 0 (mod k), sum a[delta][j] p^(-delta) = 1 (Kraft),
# and l_D = sum_j a[kD - j][j] * p^j.
import itertools, math, sys
from fractions import Fraction
from collections import defaultdict

def digits(x, p):
    d = []
    while x: d.append(x % p); x //= p
    return d

def profiles(q, n):
    """dict: leaf-depth profile (tuple, index = depth) -> number of q-ary trees with n internal nodes."""
    memo = {}
    def trees(nn):                    # dict profile(relative depths) -> count, trees with nn internal nodes
        if nn in memo: return memo[nn]
        if nn == 0:
            memo[0] = {(1,): 1}; return memo[0]
        # forests of q trees with nn-1 internal nodes in total
        forest = {(): 1}; forest = [dict() for _ in range(nn)]
        cur = {(0, ()): 1}
        for _ in range(q):
            nxt = defaultdict(int)
            for (used, prof), c in cur.items():
                for a in range(nn - used):
                    for pr, c2 in trees(a).items():
                        L = max(len(prof), len(pr))
                        s = tuple((prof[i] if i < len(prof) else 0) + (pr[i] if i < len(pr) else 0) for i in range(L))
                        nxt[(used + a, s)] += c * c2
            cur = nxt
        out = defaultdict(int)
        for (used, prof), c in cur.items():
            if used == nn - 1: out[(0,) + prof] += c
        memo[nn] = dict(out); return memo[nn]
    return trees(n)

def formula(p, k, n):
    q = p**k; m = (q-1)*n + 1; dm = digits(m, p); t = (sum(dm) - 1)//(p-1)
    maxdepth = k*n
    per_j = []
    for j, mj in enumerate(dm):
        if mj == 0: continue
        allowed = [d for d in range(0, maxdepth + 1) if (d + j) % k == 0]
        per_j.append([(j, c) for c in itertools.combinations_with_replacement(allowed, mj)])
    res = defaultdict(int)
    for choice in itertools.product(*per_j):
        kraft = Fraction(0); w = 1; prof = defaultdict(int)
        for (j, depths) in choice:
            for d in set(depths):
                a = depths.count(d)
                kraft += Fraction(a, p**d); w = w * pow(math.factorial(a), -1, p) % p
                prof[(d + j)//k] += a * p**j
        if kraft != 1: continue
        L = max(prof) + 1
        res[tuple(prof.get(i, 0) for i in range(L))] += (-1)**t * w
    return {pr: v % p for pr, v in res.items() if v % p}, t

cases = [(2,1,n) for n in range(1,9)] + [(3,1,n) for n in range(1,7)] + [(2,2,n) for n in range(1,6)] + [(5,1,n) for n in range(1,5)] + [(3,2,1),(3,2,2),(3,2,3),(2,3,1),(2,3,2),(2,3,3)]
for (p, k, n) in cases:
    q = p**k
    prof = profiles(q, n)
    assert sum(prof.values()) == math.comb(q*n, n)//((q-1)*n+1)
    pred, t = formula(p, k, n)
    bad = 0
    for pr, c in prof.items():
        assert c % p**t == 0, (p, k, n, pr, c)
        if (c//p**t) % p != pred.get(pr, 0): bad += 1
    for pr in pred: assert pr in prof, (p, k, n, pr)
    nz = sum(1 for c in prof.values() if (c//p**t) % p)
    print(f"p={p} k={k} n={n}: C={sum(prof.values())} t={t} profiles={len(prof)} with nonzero residue={nz} mismatches={bad}")
    assert bad == 0
print("all cases agree")
