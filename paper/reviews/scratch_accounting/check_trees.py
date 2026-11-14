# Written by Claude Fable 5.2 (fresh-context referee subagent), 2026-11-14.
# Referee check of paper/accounting_proof.tex: quoted statements (A), (B), (C) and Lemma 1.
# Pure stdlib.  Run: uv run python check_trees.py
#
# Part 1 (brute force, uses nothing from the paper): enumerate plane p-ary trees with distinctly
#   labelled leaves, reduce modulo rotation at every node by a canonical form, and
#   - check that every rotation class has exactly p^(number of internal nodes) elements  [(A)];
#   - count T(a) = number of labelled cyclic trees with a_c labels of class c, class-c leaves at
#     depth = -c mod k, and check L(m) = T(m e_0) = m! C / p^N(m) and L(m) = (-1)^N(m) mod p [Lemma 1];
#   - check (B) both as a congruence and at the level of its proof: the number of classes fixed by
#     the cyclic relabelling sigma of p labels of class c equals (p-1) T(a - p e_c + e_{c+1});
#   - check Lemma "Terminal vectors" and (C) for every vector a in range.
# Part 2 (larger range, uses (A) to convert plane counts to cyclic counts):
#   T(a) = prod_c a_c! * #{plane p-ary trees with a_c leaves at depth = -c mod k} / p^((|a|-1)/(p-1)),
#   then (B) and (C) for all vectors a up to a degree bound, plus random carry orders.
import itertools
import random
import sys
from math import comb, factorial

random.seed(20261114)


# ---------- plane trees ----------
def plane_trees(p, leaves, _memo={}):
    """All plane p-ary trees with the given number of leaves; a leaf is None, a node is a tuple."""
    key = (p, leaves)
    if key in _memo:
        return _memo[key]
    res = []
    if leaves == 1:
        res.append(None)
    if leaves >= p:
        def comps(total, parts):
            if parts == 1:
                if total >= 1:
                    yield (total,)
                return
            for first in range(1, total - parts + 2):
                for rest in comps(total - first, parts - 1):
                    yield (first,) + rest
        for c in comps(leaves, p):
            if any((ci - 1) % (p - 1) for ci in c):
                continue
            for kids in itertools.product(*[plane_trees(p, ci) for ci in c]):
                res.append(tuple(kids))
    _memo[key] = res
    return res


def leaf_depths(t, d=0):
    if t is None:
        return [d]
    out = []
    for c in t:
        out.extend(leaf_depths(c, d + 1))
    return out


def n_internal(t):
    return 0 if t is None else 1 + sum(n_internal(c) for c in t)


def canon(t, labels, pos=0):
    """Canonical form of the labelled cyclic tree defined by plane tree t whose leaves, left to right,
    carry labels[pos], labels[pos+1], ...  Returns (min label, canonical nested tuple, next pos).
    Labels are distinct, so 'rotate the child containing the smallest label to the front' is canonical."""
    if t is None:
        return labels[pos], labels[pos], pos + 1
    kids = []
    for c in t:
        mn, rep, pos = canon(c, labels, pos)
        kids.append((mn, rep))
    i = min(range(len(kids)), key=lambda j: kids[j][0])
    kids = kids[i:] + kids[:i]
    return kids[0][0], tuple(r for _, r in kids), pos


def recanon(rep, sigma):
    """Apply the label permutation sigma (dict) to a canonical form and re-canonicalise."""
    if not isinstance(rep, tuple):
        v = sigma.get(rep, rep)
        return v, v
    kids = [recanon(c, sigma) for c in rep]
    i = min(range(len(kids)), key=lambda j: kids[j][0])
    kids = kids[i:] + kids[:i]
    return kids[0][0], tuple(r for _, r in kids)


def cyclic_classes(p, k, a):
    """Dict canonical form -> number of plane labelled trees in that rotation class,
    for a_c labels of class c (labels are consecutive integers, class 0 first), class-c leaf at depth = -c mod k."""
    M = sum(a)
    cls_labels = []
    nxt = 0
    for c in range(k):
        cls_labels.append(list(range(nxt, nxt + a[c])))
        nxt += a[c]
    classes = {}
    if M < 1 or (M - 1) % (p - 1):
        return classes, cls_labels
    for t in plane_trees(p, M):
        deps = leaf_depths(t)
        need = [(-d) % k for d in deps]            # class required at each leaf
        if any(need.count(c) != a[c] for c in range(k)):
            continue
        slots = [[i for i, c in enumerate(need) if c == cc] for cc in range(k)]
        for perms in itertools.product(*[itertools.permutations(cls_labels[c]) for c in range(k)]):
            lab = [None] * M
            for c in range(k):
                for i, l in zip(slots[c], perms[c]):
                    lab[i] = l
            _, rep, _ = canon(t, lab)
            classes[rep] = classes.get(rep, 0) + 1
    return classes, cls_labels


def vectors(k, total):
    if k == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in vectors(k - 1, total - first):
            yield (first,) + rest


def W(a, p):
    return sum(ac * p ** c for c, ac in enumerate(a))


def carry(a, c):
    k = len(a)
    b = list(a)
    b[c] -= len_p[0]
    b[(c + 1) % k] += 1
    return tuple(b)


len_p = [0]  # current prime, used by carry()


def part1():
    bad = 0
    print("Part 1: brute force over labelled plane trees")
    # (p, k, maximal number of labels)
    plans = [(2, 1, 7), (2, 2, 7), (2, 3, 8), (3, 1, 7), (3, 2, 9), (3, 3, 7), (5, 1, 9), (5, 2, 9), (7, 1, 7)]
    for p, k, Mmax in plans:
        len_p[0] = p
        q = p ** k
        Tcache = {}
        n_vec = n_cls = 0
        for M in range(0, Mmax + 1):
            for a in vectors(k, M):
                classes, cls_labels = cyclic_classes(p, k, a)
                Tcache[a] = (classes, cls_labels)
                n_vec += 1
                if not classes:
                    continue
                N = (M - 1) // (p - 1)
                # (A): every class has p^N members (all N internal nodes asymmetric)
                sizes = set(classes.values())
                n_cls += len(classes)
                if sizes != {p ** N}:
                    print("  (A) FAILS: class sizes", sizes, "expected", p ** N, (p, k, a))
                    bad += 1
        # Lemma 1
        for M in range(1, Mmax + 1):
            if (M - 1) % (q - 1):
                continue
            n = (M - 1) // (q - 1)
            C = comb(q * n, n) // M
            N = (M - 1) // (p - 1)
            a = (M,) + (0,) * (k - 1)
            L = len(Tcache[a][0])
            ok1 = factorial(M) * C == p ** N * L
            ok2 = (L - (-1) ** N) % p == 0
            print(f"  p={p} k={k} m={M}: L(m)=T(m e_0)={L} by enumeration; m!C/p^N={factorial(M) * C // p ** N}; "
                  f"identity {'ok' if ok1 else 'FAILS'}; L=(-1)^N mod p {'ok' if ok2 else 'FAILS'}")
            bad += (not ok1) + (not ok2)
        # (B), proof-level: fixed classes of sigma; and Lemma terminal; and (C)
        nB = nC = nT = nBnz = 0
        for a, (classes, cls_labels) in Tcache.items():
            M = sum(a)
            T = len(classes)
            if all(ac < p for ac in a):
                nT += 1
                e0 = (1,) + (0,) * (k - 1)
                if T != (1 if a == e0 else 0):
                    print("  Lemma terminal FAILS", (p, k, a), T)
                    bad += 1
            for c in range(k):
                if a[c] >= p:
                    a2 = carry(a, c)
                    T2 = len(Tcache[a2][0])
                    chosen = cls_labels[c][:p]
                    sigma = {chosen[i]: chosen[(i + 1) % p] for i in range(p)}
                    fixed = sum(1 for rep in classes if recanon(rep, sigma)[1] == rep)
                    nB += 1
                    nBnz += (T != 0 or T2 != 0)
                    if fixed != (p - 1) * T2:
                        print("  (B) proof-level FAILS: fixed", fixed, "expected", (p - 1) * T2, (p, k, a, c))
                        bad += 1
                    if (T + T2) % p:
                        print("  (B) FAILS", (p, k, a, c), T, T2)
                        bad += 1
            hyp = (a[0] >= 1) if q == 2 else (W(a, p) % (q - 1) == 1 % (q - 1))
            if hyp:
                nC += 1
                if (M - 1) % (p - 1):
                    print("  (C): exponent not an integer", (p, k, a))
                    bad += 1
                elif (T - (-1) ** ((M - 1) // (p - 1))) % p:
                    print("  (C) FAILS", (p, k, a), T)
                    bad += 1
        print(f"  p={p} k={k}: vectors a with |a|<={Mmax}: {n_vec}; classes enumerated: {n_cls}; "
              f"(B) instances {nB} ({nBnz} with T(a) or T(a') nonzero); (C) instances {nC}; terminal vectors {nT}")
    return bad


# ---------- Part 2: series ----------
def part2():
    bad = 0
    print("Part 2: T(a) from plane counts by depth class, larger range")
    plans = [(2, 1, 40), (2, 2, 18), (2, 3, 13), (3, 1, 41), (3, 2, 19), (3, 3, 13),
             (5, 1, 41), (5, 2, 21), (5, 3, 13), (7, 1, 43), (7, 2, 19), (7, 3, 13)]
    for p, k, D in plans:
        len_p[0] = p
        q = p ** k

        def mul(u, v):
            w = {}
            for eu, cu in u.items():
                du = sum(eu)
                for ev, cv in v.items():
                    if du + sum(ev) > D:
                        continue
                    e = tuple(x + y for x, y in zip(eu, ev))
                    w[e] = w.get(e, 0) + cu * cv
            return w

        def power(u, e):
            r = u
            for _ in range(e - 1):
                r = mul(r, u)
            return r

        G = [dict() for _ in range(k)]
        for _ in range(D * k + 3):
            newG = []
            for d in range(k):
                g = power(G[(d + 1) % k], p) if G[(d + 1) % k] else {}
                g = dict(g)
                unit = tuple(1 if c == (-d) % k else 0 for c in range(k))
                g[unit] = g.get(unit, 0) + 1
                newG.append(g)
            if newG == G:
                break
            G = newG
        else:
            print("  series did not stabilise", p, k)
            bad += 1
        plane = G[0]

        def T(a):
            M = sum(a)
            if M < 1 or (M - 1) % (p - 1):
                return 0
            cnt = plane.get(tuple(a), 0)
            for ac in a:
                cnt *= factorial(ac)
            N = (M - 1) // (p - 1)
            assert cnt % p ** N == 0, ("non-integral T", p, k, a)
            return cnt // p ** N

        nB = nC = nT = nR = nBnz = 0
        for M in range(0, D + 1):
            for a in vectors(k, M):
                Ta = T(a)
                if all(ac < p for ac in a):
                    nT += 1
                    if Ta != (1 if a == (1,) + (0,) * (k - 1) else 0):
                        print("  Lemma terminal FAILS", (p, k, a))
                        bad += 1
                for c in range(k):
                    if a[c] >= p:
                        nB += 1
                        nBnz += (Ta != 0 or T(carry(a, c)) != 0)
                        if (Ta + T(carry(a, c))) % p:
                            print("  (B) FAILS", (p, k, a, c))
                            bad += 1
                hyp = (a[0] >= 1) if q == 2 else (W(a, p) % (q - 1) == 1)
                if hyp:
                    nC += 1
                    if (M - 1) % (p - 1) or (Ta - (-1) ** ((M - 1) // (p - 1))) % p:
                        print("  (C) FAILS", (p, k, a))
                        bad += 1
                    # carries in random order: must end at e_0 after exactly (|a|-1)/(p-1) carries
                    for _ in range(3):
                        b = a
                        r = 0
                        while True:
                            cs = [c for c in range(k) if b[c] >= p]
                            if not cs:
                                break
                            b = carry(b, random.choice(cs))
                            r += 1
                        nR += 1
                        if b != (1,) + (0,) * (k - 1) or r * (p - 1) != M - 1:
                            print("  (C) termination FAILS", (p, k, a), b, r)
                            bad += 1
        # the instance used in Lemma 1
        for M in range(1, D + 1):
            if (M - 1) % (q - 1) == 0:
                n = (M - 1) // (q - 1)
                C = comb(q * n, n) // M
                a = (M,) + (0,) * (k - 1)
                if T(a) * p ** ((M - 1) // (p - 1)) != factorial(M) * C:
                    print("  L(m)=T(m e_0) vs m!C/p^N FAILS", (p, k, M))
                    bad += 1
        print(f"  p={p} k={k} |a|<={D}: (B) instances {nB} ({nBnz} with T(a) or T(a') nonzero); (C) instances {nC}; "
              f"random carry runs {nR}; terminal vectors {nT}")
    return bad


def main():
    bad = part1()
    bad += part2()
    print("ALL PASS" if bad == 0 else f"FAILURES: {bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
