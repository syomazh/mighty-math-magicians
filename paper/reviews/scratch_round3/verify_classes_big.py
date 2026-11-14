"""Round-3 referee check, larger range, class level.

Rotation classes are enumerated directly as necklaces of child classes (this uses the normal-form
lemma, which verify_classes.py cross-checked against the generators by union-find on the small range).
For each (p,k,n):  sum over classes of p^d == Fuss-Catalan number (class-size lemma, globally),
min d == t, #classes with d == t == #cyclic skeleton trees (independent enumeration), and the
congruence N_min == (-1)^t / prod m_j! (mod p).  Purpose: reach k >= 2 cases with several minimal classes.
"""
import itertools
import os
import sys
import time
from math import factorial

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_classes import World, comps, digits, fuss  # noqa: E402


class ClassWorld:
    def __init__(self, p, k):
        self.p, self.k = p, k
        self.ids = {}
        self.d = [0]  # id 0 = the leaf
        self.memo = {}

    def classes(self, m, phase):
        key = (m, phase)
        if key in self.memo:
            return self.memo[key]
        p, k = self.p, self.k
        if m == 1:
            res = [0] if phase % k == 0 else []
        elif (m - 1) % (p - 1):
            res = []
        else:
            out = set()
            nxt = (phase + 1) % k
            for comp in comps(m, p, p - 1):
                if comp != min(comp[r:] + comp[:r] for r in range(p)):
                    continue  # every necklace has a representative with rotation-minimal leaf counts
                lists = [self.classes(c, nxt) for c in comp]
                if any(not l for l in lists):
                    continue
                for ch in itertools.product(*lists):
                    can = min(ch[r:] + ch[:r] for r in range(p))
                    i = self.ids.get(can)
                    if i is None:
                        i = len(self.d)
                        self.ids[can] = i
                        self.d.append(sum(self.d[c] for c in can) + (0 if all(c == can[0] for c in can) else 1))
                    out.add(i)
            res = sorted(out)
        self.memo[key] = res
        return res


def check(p, k, n, CW=None, SW=None):
    t0 = time.time()
    q = p ** k
    m = (q - 1) * n + 1
    ds = digits(m, p)
    t = (sum(ds) - 1) // (p - 1)
    CW = CW or ClassWorld(p, k)
    cl = CW.classes(m, 0)
    FC = fuss(q, n)
    assert sum(p ** CW.d[i] for i in cl) == FC, (p, k, n)
    dmin = min(CW.d[i] for i in cl)
    assert dmin == t, (p, k, n, dmin, t)
    nmin = sum(1 for i in cl if CW.d[i] == t)
    SW = SW or World(p, k)
    nsk = len(SW.skeletons(m))
    assert nmin == nsk, (p, k, n, nmin, nsk)
    prod = 1
    for dj in ds:
        prod *= factorial(dj)
    pred = ((-1) ** t * pow(prod, -1, p)) % p
    assert nmin % p == pred and (FC // p ** t) % p == pred
    print(f"p={p} k={k} n={n:2d} m={m:3d} t={t} trees={FC} classes={len(cl)} N_min={nmin} skeletons={nsk} "
          f"pred_mod_p={pred} {time.time() - t0:.1f}s", flush=True)


if __name__ == "__main__":
    plan = [(2, 1, range(1, 19)), (2, 2, range(1, 13)), (2, 3, range(1, 9)), (2, 4, range(1, 7)),
            (3, 1, range(1, 12)), (3, 2, range(1, 8)), (3, 3, range(1, 5)),
            (5, 1, range(1, 9)), (5, 2, range(1, 5)), (7, 1, range(1, 7))]
    total = 0
    for p, k, rng in plan:
        CW, SW = ClassWorld(p, k), World(p, k)
        for n in rng:
            check(p, k, n, CW, SW)
            total += 1
    print(f"ALL {total} CLASS-LEVEL CASES PASSED")
