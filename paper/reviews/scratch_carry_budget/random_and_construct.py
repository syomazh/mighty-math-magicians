"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.

Three further tests, complementing the exhaustive check_facts.py.

Part A (converse direction of the minimal-tree description, by explicit construction).
    For every m: take EVERY plain p-ary tree with s_p(m) leaves as skeleton and EVERY placement
    on its leaves of the multiset of atoms {a_j complete trees with p^j leaves}, a_j = digits
    of m.  The set of rotation classes obtained must be exactly the set of classes with d = t
    found by exhaustive enumeration.

Part B (large random trees, more primes).
    Random trees with up to a few thousand nodes for p = 2,3,5,7,11,13, with a deliberate
    share of symmetric nodes (p copies of the same subtree), so that symmetric nodes with
    s_p(b) > 1 occur for every p.  Every statement checked in check_facts.Classes._stats is
    checked on every subtree created.  Also random large minimal trees built from the digits.

Part C (pure arithmetic behind Fact 2).
    For all primes p <= 31 and all b <= 20000: adding p copies of b in base p carries a total
    amount of exactly s_p(b).

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/random_and_construct.py
"""
import os
import sys
import random
import itertools
from functools import lru_cache

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_facts import digits, sp, add_carries, Classes  # noqa: E402

sys.setrecursionlimit(100000)


def intern(C, kids):
    """Canonical id of the node with the given child ids, creating the class if necessary."""
    key = C.canon(tuple(kids))
    cid = C.index.get(key)
    if cid is None:
        cid = len(C.kids)
        C.index[key] = cid
        C.kids.append(key)
        m = sum(C.m[c] for c in key)
        C.m.append(m)
        C._stats(cid, key, m)
    return cid


def complete_id(C, h):
    cid = 0
    for _ in range(h):
        cid = intern(C, (cid,) * C.p)
    return cid


def distinct_perms(items):
    return set(itertools.permutations(items))


def part_a(p, M):
    C = Classes(p)

    @lru_cache(maxsize=None)
    def skeletons(s):
        """All plain p-ary trees with s leaves, as nested tuples; leaf = None placeholder."""
        if s == 1:
            return ("L",)
        res = []

        def rec(slots, remaining, cur):
            if slots == 1:
                if remaining >= 1 and (remaining - 1) % (p - 1) == 0:
                    for T in skeletons(remaining):
                        res.append(cur + (T,))
                return
            for size in range(1, remaining - (slots - 1) + 1, p - 1):
                for T in skeletons(size):
                    rec(slots - 1, remaining - size, cur + (T,))

        rec(p, s, ())
        return tuple(res)

    def build(S, it):
        if S == "L":
            return next(it)
        return intern_existing(tuple(build(c, it) for c in S))

    def intern_existing(kids):
        key = C.canon(kids)
        return C.index[key]         # KeyError would mean the exhaustive enumeration missed a class

    all_ok = True
    total_trees = 0
    for m in range(p, M + 1, p - 1):
        ids = C.extend(m)
        t = (sp(m, p) - 1) // (p - 1)
        minimal = {c for c in ids if C.d[c] == t}
        dg = digits(m, p)
        atoms = []
        for j, a in enumerate(dg):
            atoms += [j] * a
        atom_ids = {j: complete_id_existing(C, j) for j in set(atoms)}
        built = set()
        n = 0
        perms = distinct_perms(atoms)
        for S in skeletons(len(atoms)):
            for perm in perms:
                it = iter([atom_ids[j] for j in perm])
                built.add(build(S, it))
                n += 1
        total_trees += n
        ok = (built == minimal) and (n == len(minimal) * p ** t)
        all_ok &= ok
        if not ok:
            print(f"   p={p} m={m}: built {len(built)} classes from {n} trees, "
                  f"enumeration has {len(minimal)} minimal classes  MISMATCH")
    print(f"Part A, p = {p}, m <= {M}: constructed {total_trees} trees from skeleton + digit atoms; "
          f"set of classes == set of minimal classes for every m: {'OK' if all_ok else 'FAIL'}")
    sys.stdout.flush()


def complete_id_existing(C, h):
    cid = 0
    for _ in range(h):
        cid = C.index[(cid,) * C.p]
    return cid


def part_b(p, n_trees, max_nodes, seed):
    rng = random.Random(seed)
    C = Classes(p)

    def split(total, parts, style):
        if style == 0:      # uniform random composition into `parts` non-negative parts
            cuts = sorted(rng.randint(0, total) for _ in range(parts - 1))
            xs = [b - a for a, b in zip([0] + cuts, cuts + [total])]
        elif style == 1:    # very unbalanced
            xs = [0] * parts
            xs[rng.randrange(parts)] = total
            for _ in range(min(total, 3)):
                i, j = rng.randrange(parts), rng.randrange(parts)
                if xs[i] > 0:
                    xs[i] -= 1
                    xs[j] += 1
        else:               # nearly balanced
            xs = [total // parts] * parts
            for i in rng.sample(range(parts), total % parts):
                xs[i] += 1
        return xs

    def rand_tree(n, q):
        if n == 0:
            return 0
        if (n - 1) % p == 0 and rng.random() < q:
            c = rand_tree((n - 1) // p, q)
            return intern(C, (c,) * p)
        xs = split(n - 1, p, rng.choice((0, 0, 1, 2)))
        return intern(C, tuple(rand_tree(x, q) for x in xs))

    roots = set()
    for _ in range(n_trees):
        n = rng.randint(1, max_nodes)
        q = rng.choice((0.0, 0.3, 0.7, 0.95))
        if rng.random() < 0.3:      # force size 1 + p + ... so that deep symmetry is possible
            n = rng.choice([(p ** k - 1) // (p - 1) * rng.randint(1, 3) + rng.randint(0, 2)
                            for k in range(1, 6) if (p ** k - 1) // (p - 1) * 3 + 2 <= max_nodes]
                           or [n])
        roots.add(rand_tree(n, q))

    # random minimal trees built from the digits of a random m
    n_min = 0
    for _ in range(n_trees // 4):
        # random digits (least significant first) with digit sum = 1 mod (p-1), top digit != 0
        while True:
            dg = [rng.randint(0, p - 1) for _ in range(rng.randint(1, 6))]
            if dg[-1] != 0 and (sum(dg) - 1) % (p - 1) == 0:
                break
        s = sum(dg)
        m = sum(a * p ** j for j, a in enumerate(dg))
        atoms = []
        for j, a in enumerate(dg):
            atoms += [complete_id(C, j)] * a
        rng.shuffle(atoms)

        def skel(k):    # random skeleton with k leaves, consuming atoms
            if k == 1:
                return atoms.pop()
            nn = (k - 1) // (p - 1) - 1
            xs = split(nn, p, rng.choice((0, 1, 2)))
            return intern(C, tuple(skel((p - 1) * x + 1) for x in xs))

        root = skel(s)
        t = (sp(m, p) - 1) // (p - 1)
        assert C.m[root] == m
        if C.d[root] != t:
            C.note_violation("constructed digit tree is not minimal", root)
        n_min += 1
        roots.add(root)

    n_classes = len(C.kids)
    with_bad = sum(1 for c in range(n_classes) if C.bad_sym[c] > 0)
    n_minimal = sum(1 for c in range(n_classes)
                    if C.d[c] == (sp(C.m[c], p) - 1) // (p - 1))
    print(f"Part B, p = {p}: {len(roots)} random root trees, {n_classes} distinct subtrees checked, "
          f"largest {max(C.m)} leaves; {with_bad} contain a symmetric node with s_p(b) > 1; "
          f"{n_minimal} are minimal ({n_min} built from digits); "
          f"violations: {dict(C.viol) if C.viol else 'none'}")
    sys.stdout.flush()


def part_c():
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
    bad = 0
    differ = 0
    n = 0
    for p in primes:
        for b in range(1, 20001):
            tot, cols = add_carries([b] * p, p)
            n += 1
            if tot != sp(b, p) or tot < 1 or sp(p * b, p) != sp(b, p):
                bad += 1
            if cols != tot:
                differ += 1
    print(f"Part C: {n} pairs (p, b): carried amount of p*b == s_p(b) fails in {bad} cases; "
          f"'number of carrying columns' differs from the carried amount in {differ} cases "
          f"(only the amount satisfies Fact 2)")
    # the smallest example that can occur at a node of a tree (b = 1 mod p-1)
    for p in (3, 5, 7):
        for b in range(1, 200, p - 1):
            tot, cols = add_carries([b] * p, p)
            if cols != tot:
                print(f"   smallest tree-realisable example for p = {p}: b = {b} "
                      f"(digits {digits(b, p)[::-1]}), amount carried {tot} = s_p(b), "
                      f"carrying columns {cols}")
                break
    sys.stdout.flush()


def main():
    part_c()
    part_a(2, 18)
    part_a(3, 27)
    part_a(5, 49)
    part_a(7, 55)
    for i, p in enumerate((2, 3, 5, 7, 11, 13)):
        part_b(p, 3000, 2500, 1000 + i)


if __name__ == "__main__":
    import threading
    threading.stack_size(200 * 1024 * 1024)     # deep recursion on very unbalanced trees
    th = threading.Thread(target=main)
    th.start()
    th.join()
