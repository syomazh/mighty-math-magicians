# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
E011, part F -- the "carry budget" identity, tested on explicit trees.

For a p-ary tree T with m leaves let, at each internal node v with children of m_1..m_p leaves,
    carries(v) = (s_p(m_1) + ... + s_p(m_p) - s_p(m_1 + ... + m_p)) / (p - 1)
(the number of carries made when the p leaf counts are added in base p). Claims:
  F1. sum over all nodes of carries(v) = nu(m) = (m - s_p(m))/(p-1), whatever the tree.
  F2. a symmetric node (p equivalent subtrees, each with c leaves) has carries(v) = s_p(c) >= 1.
  F3. d(T) - t(m) = sum over symmetric v of (s_p(c_v) - 1) + sum over asymmetric v of carries(v),
      where d = number of asymmetric nodes and t = (s_p(m)-1)/(p-1).
  F4. hence d(T) = t(m) exactly when every asymmetric node adds carry-free and every symmetric
      node has children whose number of leaves is a power of p.
All rotation classes of p-ary trees are enumerated explicitly (canonical nested tuples).
"""
import itertools
import sys


def sp(m, p):
    s = 0
    while m:
        s += m % p
        m //= p
    return s


def classes_up_to(p, M):
    """cls[m] = dict: canonical tree -> (d, total carries, sym part, asym part, minimal-shape flag)."""
    cls = {1: {(): (0, 0, 0, 0, True)}}
    for m in range(p, M + 1, p - 1):
        out = {}
        sizes = [x for x in cls if x < m]

        def comps(total, parts):
            if parts == 1:
                if total in cls:
                    yield (total,)
                return
            for a in sizes:
                if a <= total - (parts - 1):
                    for rest in comps(total - a, parts - 1):
                        yield (a,) + rest

        for comp in comps(m, p):
            car = (sum(sp(x, p) for x in comp) - sp(m, p)) // (p - 1)
            for kids in itertools.product(*[cls[x].items() for x in comp]):
                trees = tuple(t for t, _ in kids)
                canon = min(trees[i:] + trees[:i] for i in range(p))
                if canon in out:
                    continue
                d = sum(v[0] for _, v in kids)
                tot = sum(v[1] for _, v in kids) + car
                symp = sum(v[2] for _, v in kids)
                asymp = sum(v[3] for _, v in kids)
                flag = all(v[4] for _, v in kids)
                if len(set(trees)) == 1:                       # symmetric node
                    c = comp[0]
                    assert car == sp(c, p)                     # F2
                    symp += sp(c, p) - 1
                    flag &= sp(c, p) == 1
                else:
                    d += 1
                    asymp += car
                    flag &= car == 0
                out[canon] = (d, tot, symp, asymp, flag)
        cls[m] = out
    return cls


if __name__ == "__main__":
    ok = True
    for p, M in [(2, 13), (3, 15), (5, 17), (7, 19)]:
        cls = classes_up_to(p, M)
        n = 0
        for m, trees in cls.items():
            nu = (m - sp(m, p)) // (p - 1)
            t = (sp(m, p) - 1) // (p - 1)
            for tree, (d, tot, symp, asymp, flag) in trees.items():
                n += 1
                ok &= tot == nu                                # F1
                ok &= d - t == symp + asymp                    # F3
                ok &= (d == t) == flag                         # F4
        print(f"p = {p}: {n} classes with up to {M} leaves: F1-F4 {'ok' if ok else 'FAIL'}")
    print("OVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")
    sys.exit(0 if ok else 1)
