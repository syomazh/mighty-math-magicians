# Written by Moonshot AI Kimi K3.1 Pro (Open Math OS), 2026-11-14; not human-reviewed.
"""Leaf orbits of the cyclic automorphism group of a rooted ternary tree."""
from collections import Counter
from itertools import product
from math import comb


def text(tree):
    return "." if tree is None else "(" + "".join(text(child) for child in tree) + ")"


def cyclic_class(tree):
    if tree is None:
        return None
    a, b, c = (cyclic_class(child) for child in tree)
    return min(((a, b, c), (b, c, a), (c, a, b)), key=text)


def transfers(source, target):
    """All maps between labelled leaves induced by local cyclic rotations.

    source and target are meant to be the same ordered tree.  If source is a
    single leaf, its identity is the empty local address.  At an internal node
    the root generator cycles leaf subtrees, while child generators act on the
    child subtrees.  We retain both directions to avoid signed-winding errors.
    """
    if source is None:
        assert target is None
        return [{(): ()}]
    assert target == source
    # For a ternary internal node: if its children are leaves, the generators
    # are the three cyclic shifts, and the leaf addresses are length 1.  For
    # deeper nodes create generators for each child, plus a root generator if
    # all child shapes are equivalent.
    if source[0] is None:
        assert all(c is None for c in source)
        return [{(i,): ((turn + i) % 3,) for i in range(3)} for turn in range(3)]
    identity = {leaf: leaf for leaf in addresses(source)}
    generators = []
    for child_index, child in enumerate(source):
        for child_map in transfers(child, child):
            if child_map == {leaf: leaf for leaf in addresses(child)}:
                continue
            g = {}
            for leaf in addresses(source):
                if leaf[0] == child_index:
                    g[leaf] = (child_index,) + child_map[leaf[1:]]
                else:
                    g[leaf] = leaf
            generators.append(g)
    if len({text(cyclic_class(c)) for c in source}) == 1:
        for turn in (1, 2):
            g = {}
            for i, child in enumerate(source):
                for leaf in addresses(child):
                    g[(i,) + leaf] = ((turn + i) % 3,) + leaf
            generators.append(g)
    # Closure under composition.
    elements = [identity]
    generators.append(identity)
    changed = True
    while changed:
        changed = False
        for a in elements[:]:
            for b in generators:
                g = {leaf: a[b[leaf]] for leaf in identity}
                if g not in elements:
                    elements.append(g)
                    changed = True
    return elements



def asymmetric_nodes(tree):
    if tree is None:
        return 0
    return int(len({text(cyclic_class(child)) for child in tree}) != 1) + sum(asymmetric_nodes(c) for c in tree)


def orbit_sizes(elements, leaves):
    seen = set()
    sizes = []
    for start in leaves:
        if start in seen:
            continue
        orbit = {element[start] for element in elements}
        seen.update(orbit)
        sizes.append(len(orbit))
    return sorted(sizes, reverse=True)


def addresses(tree):
    if tree is None:
        return [()]
    return [(i,) + address for i, child in enumerate(tree) for address in addresses(child)]


def valuation(m):
    answer, power = 0, 3
    while power <= m:
        answer += m // power
        power *= 3
    return answer


def base3(m):
    digits = []
    while m:
        digits.append(m % 3)
        m //= 3
    return digits


def main():
    classes = {0: [None]}
    for n in range(1, 6):
        # All triples whose internal-node counts sum to n-1.
        classes[n] = sorted({cyclic_class((a, b, c))
                             for i in range(n) for j in range(n - i)
                             for k in [n - 1 - i - j]
                             for a in classes[i] for b in classes[j] for c in classes[k]}, key=text)
        assert len(classes[n]) == [1, 1, 1, 2, 5, 11][n]
        m = 2 * n + 1
        best = valuation(m)
        expected = Counter({3 ** j: digit for j, digit in enumerate(base3(m)) if digit})
        print(f"n={n}, m={m}, base-3 digits={base3(m)}, v_3(m!)={best}, classes={len(classes[n])}")
        for index, tree in enumerate(classes[n], 1):
            elements = transfers(tree, tree)
            assert len(elements) == len({tuple(sorted(element.items())) for element in elements})
            if len(elements) != 3 ** (n - asymmetric_nodes(tree)):
                print("DEBUG", n, index, text(tree), len(elements), asymmetric_nodes(tree), flush=True)
                raise AssertionError("group order")
            leaves = addresses(tree)
            assert len(leaves) == m
            assert all(set(element) == set(leaves) and set(element.values()) == set(leaves) for element in elements)
            for a in elements:
                for b in elements:
                    assert {old: a[new] for old, new in b.items()} in elements
            sizes = orbit_sizes(elements, leaves)
            assert sum(sizes) == m
            assert all(size in (1, 3, 9, 27) for size in sizes)
            maximum = len(elements) == 3 ** best
            print(f"  {index:2}: {text(tree):35} d={asymmetric_nodes(tree)}, |G|=3^{n-asymmetric_nodes(tree)}, orbits={sizes}{' MAXIMUM' if maximum else ''}")
            if maximum:
                assert Counter(sizes) == expected
        assert sum(3 ** asymmetric_nodes(t) for t in classes[n]) == comb(3*n, n)//(2*n+1)
    print("Checks passed: class counts A000625, ordered-tree orbit sizes, group orders,")
    print("permutation bijectivity and closure, orbit sizes, and base-3 orbit sizes at the maxima.")


if __name__ == '__main__':
    main()
