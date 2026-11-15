# Written by Claude Fable 5.2 (orchestrator), 2026-11-13/14. Not human-reviewed.
"""
E009 -- Idea 5: labelled cyclic p-ary trees <-> permutations all of whose cycles have length p.

A cyclic p-ary tree with leaves labelled 1..s (s = (p-1)t + 1) has t internal nodes and
s + t - 1 = pt non-root nodes.  Label the internal nodes other than the root with s+1, ..., pt
by this rule: repeatedly take, among the internal nodes all of whose children already carry a
label, the one whose smallest child label is least, and give it the next unused label (the
root comes last and gets no label).  The cyclic order of the children of each internal node is
a p-cycle on labels; the t cycles form a permutation of {1..pt} with cycle type p^t.

Claim: this is a bijection onto all permutations of {1..pt} made of t cycles of length p.
(For p = 2 it is the correspondence between rooted binary leaf-labelled trees and perfect
matchings.)  Consequence: the number of labelled cyclic p-ary trees is (pt)!/(p^t t!), with no
use of the Fuss-Catalan formula.

The script enumerates all trees for small s, applies the map, checks that the images are
distinct and that their number equals (pt)!/(p^t t!); and checks the inverse construction on
every permutation of the right cycle type (so surjectivity is tested directly as well).
"""
import itertools
from math import factorial


def set_partitions_into_p_cyclic(labels, p):
    """Ways to split a label tuple into p non-empty blocks in cyclic order (rotation removed by
    putting the block that contains the smallest label first)."""
    labels = tuple(sorted(labels))
    first, rest = labels[0], labels[1:]
    for assign in itertools.product(range(p), repeat=len(rest)):
        if len(set(assign) | {0}) < p:
            continue
        blocks = [[first]] + [[] for _ in range(p - 1)]
        for x, g in zip(rest, assign):
            blocks[g].append(x)
        yield tuple(tuple(b) for b in blocks)


def all_trees(labels, p):
    """Leaf = int label; node = tuple of p subtrees (cyclic, canonical rotation)."""
    labels = tuple(sorted(labels))
    if len(labels) == 1:
        yield labels[0]
        return
    if (len(labels) - 1) % (p - 1):
        return
    for blocks in set_partitions_into_p_cyclic(labels, p):
        if any((len(b) - 1) % (p - 1) for b in blocks):
            continue
        for kids in itertools.product(*[list(all_trees(b, p)) for b in blocks]):
            yield tuple(kids)


def canon_cycle(c):
    i = c.index(min(c))
    return tuple(c[i:] + c[:i])


def tree_to_perm(tree, s, p):
    """Returns a frozenset of canonical p-cycles."""
    nodes = []          # internal nodes as mutable lists of children (ints for labelled things)

    def build(T):
        if isinstance(T, int):
            return T
        node = {"kids": [build(c) for c in T], "label": None}
        nodes.append(node)
        return node
    root = build(tree)
    if isinstance(root, int):
        return frozenset()
    nxt = s + 1
    cycles = []
    pending = list(nodes)

    def lab(x):
        return x if isinstance(x, int) else x["label"]
    while pending:
        ready = [nd for nd in pending if all(lab(c) is not None for c in nd["kids"])]
        nd = min(ready, key=lambda n_: min(lab(c) for c in n_["kids"]))
        cycles.append(canon_cycle([lab(c) for c in nd["kids"]]))
        pending.remove(nd)
        if nd is not root:
            nd["label"] = nxt
            nxt += 1
    return frozenset(cycles)


def perm_to_tree(cycles, s, p):
    """Inverse construction; returns the tree in the same canonical form as all_trees."""
    unused = set(cycles)
    built = {}                      # label -> subtree
    for x in range(1, s + 1):
        built[x] = x
    nxt = s + 1
    last = None
    while unused:
        avail = [c for c in unused if all(x in built for x in c)]
        if not avail:
            return None
        c = min(avail, key=min)
        unused.remove(c)
        node = tuple(built[x] for x in c)
        last = node
        if unused:
            built[nxt] = node
            nxt += 1
    return canon_tree(last)


def leaves_of(T):
    return (T,) if isinstance(T, int) else tuple(x for c in T for x in leaves_of(c))


def canon_tree(T):
    if isinstance(T, int):
        return T
    kids = [canon_tree(c) for c in T]
    mins = [min(leaves_of(c)) for c in kids]
    i = mins.index(min(mins))
    return tuple(kids[i:] + kids[:i])


def perms_of_type(n, p):
    """All permutations of {1..n} whose cycles all have length p, as frozensets of canonical cycles."""
    def go(elems):
        if not elems:
            yield frozenset()
            return
        first, rest = elems[0], elems[1:]
        for others in itertools.permutations(rest, p - 1):
            remaining = tuple(x for x in rest if x not in others)
            for tail in go(remaining):
                yield tail | {(first,) + others}
    return go(tuple(range(1, n + 1)))


if __name__ == "__main__":
    ok = True
    for p, tmax in [(2, 5), (3, 3), (5, 2)]:
        for t in range(1, tmax + 1):
            s = (p - 1) * t + 1
            expected = factorial(p * t) // (p ** t * factorial(t))
            trees = [canon_tree(T) for T in all_trees(range(1, s + 1), p)]
            images = {tree_to_perm(T, s, p) for T in trees}
            well_typed = all(len(im) == t and all(len(c) == p for c in im)
                             and sorted(x for c in im for x in c) == list(range(1, p * t + 1))
                             for im in images)
            # inverse on every permutation of the type (skip when there are too many)
            inv_ok = None
            if expected <= 50000:
                tree_set = set(trees)
                inv_ok = True
                count = 0
                for perm in perms_of_type(p * t, p):
                    count += 1
                    T = perm_to_tree(perm, s, p)
                    if T is None or T not in tree_set or tree_to_perm(T, s, p) != perm:
                        inv_ok = False
                        break
                inv_ok = inv_ok and count == expected
            good = (len(trees) == len(set(trees)) == len(images) == expected) and well_typed and inv_ok is not False
            ok &= good
            print(f"p={p} t={t} s={s}: trees={len(trees)} distinct images={len(images)} "
                  f"(pt)!/(p^t t!)={expected} cycle type ok={well_typed} inverse ok={inv_ok} "
                  f"-> {'OK' if good else 'FAIL'}")
    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")
