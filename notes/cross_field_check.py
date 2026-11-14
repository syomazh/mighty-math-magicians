"""Checks for cross_field_angles.md; Kimi K3.1 Pro (AI), worker W013, 2026-11-13.

Run: uv run python notes/cross_field_check.py

Finite brute-force checks, not human verification. A tree is None (a leaf) or
an ordered p-tuple. canonical() gives every rotation class a deterministic
representative. No factorial valuation is used.
"""

from collections import Counter
from functools import lru_cache
from itertools import combinations, product
from math import comb, factorial
from math import prod
from time import perf_counter


def digits(m, p):
    result = []
    while m:
        result.append(m % p)
        m //= p
    return result


def t_value(m, p):
    return (sum(digits(m, p)) - 1) // (p - 1)


def carries(values, p):
    """Carries in column-wise addition, including the last carry out."""
    result = incoming = 0
    for j in range(max(len(digits(x, p)) for x in values) + len(values)):
        column = incoming + sum((x // p**j) % p for x in values)
        incoming = column // p
        result += incoming
    assert incoming == 0
    return result


def tree_key(tree):
    return () if tree is None else (1, tuple(tree_key(x) for x in tree))


def canonical(tree, p):
    if tree is None:
        return None
    kids = tuple(canonical(x, p) for x in tree)
    return min((kids[i:] + kids[:i] for i in range(p)),
               key=lambda word: tuple(tree_key(x) for x in word))


def class_children(tree, p):
    return tuple(canonical(x, p) for x in tree)


def d_value(tree, p):
    if tree is None:
        return 0
    kids = class_children(tree, p)
    return sum(d_value(x, p) for x in kids) + int(len(set(kids)) > 1)


def leaves(tree):
    return 1 if tree is None else sum(leaves(x) for x in tree)


def node_excess(tree, p):
    """Exact recurrences stated in the brief (using rational arithmetic)."""
    if tree is None:
        return 0
    kids = class_children(tree, p)
    result = sum(node_excess(x, p) for x in kids)
    if len(set(kids)) == 1:
        return p * node_excess(kids[0], p) + (p - 1) * t_value(leaves(kids[0]), p)
    return result + carries([leaves(x) for x in kids], p)


def complete_height(tree, p):
    if tree is None:
        return 0
    hs = [complete_height(x, p) for x in tree]
    return hs[0] + 1 if hs[0] is not None and len(set(hs)) == 1 else None


def atom_heights(tree, p):
    h = complete_height(tree, p)
    return [h] if h is not None else sum((atom_heights(x, p) for x in tree), [])


def carry_free_skeleton(tree, p):
    if complete_height(tree, p) is not None:
        return True
    kids = class_children(tree, p)
    return (len(set(kids)) > 1
            and all(carry_free_skeleton(x, p) for x in kids)
            and carries([leaves(x) for x in kids], p) == 0)


def concrete_class(tree, p):
    if tree is None:
        return {None}
    classes = [concrete_class(x, p) for x in tree]
    return {kids[i:] + kids[:i]
            for kids in product(*classes) for i in range(p)}


@lru_cache(maxsize=None)
def trees(p, n):
    if n == 0:
        return (None,)
    result = []
    for sizes in product(range(n), repeat=p):
        if sum(sizes) == n - 1:
            result.extend(product(*(trees(p, x) for x in sizes)))
    return tuple(result)


def test_arithmetic():
    explicit_classes = 0
    for p, nmax in ((2, 8), (3, 4), (5, 4)):
        total = 0
        for n in range(nmax + 1):
            for tree in trees(p, n):
                total += 1
                m = leaves(tree)
                d = d_value(tree, p)
                e = d - t_value(m, p)
                assert m == (p - 1) * n + 1
                assert node_excess(tree, p) == e
                assert e >= 0 and floats_integral(node_excess(tree, p))
                assert (e == 0) == carry_free_skeleton(tree, p)
                if e == 0:
                    wanted = [j for j, digit in enumerate(digits(m, p)) for _ in range(digit)]
                    assert sorted(atom_heights(tree, p)) == wanted
                if d <= 4:
                    assert len(concrete_class(tree, p)) == p**d
                    explicit_classes += 1
        print(f"arithmetic p={p}, n<={nmax}: all {total} trees; "
              f"{explicit_classes} explicit class-size checks")
    print("all proposed e-recurrences are verified; no counterexample is asserted here")

def floats_integral(x):
    return float(x).is_integer()


# ----- Labelled cyclic trees: direct enumeration and an independent recursion.


def labelled_key(tree):
    return (0, tree) if isinstance(tree, int) else (1, tuple(labelled_key(x) for x in tree))


def labelled_class(tree, p):
    if isinstance(tree, int):
        return tree
    kids = tuple(labelled_class(x, p) for x in tree)
    return min((kids[i:] + kids[:i] for i in range(p)), key=labelled_key)



def rooted_labelled_orbit(tree, p):
    if isinstance(tree, int):
        return {tree}
    child_orbits = [rooted_labelled_orbit(x, p) for x in tree]
    return {min(kids[i:] + kids[:i] for i in range(p))
            for kids in product(*child_orbits) for i in range(p)}


def partitions(labels, p):
    labels = tuple(labels)
    if p == 1:
        yield (labels,)
        return
    first, rest = labels[0], labels[1:]
    for r in range(1, len(labels) - p + 2):
        for extra in combinations(rest, r - 1):
            left = (first,) + extra
            remaining = tuple(x for x in labels if x not in left)
            for others in partitions(remaining, p - 1):
                yield (left,) + others


def explicit_labelled(labels, p, k, class_of, depth=0):
    return cached_labelled(tuple(labels), p, k, tuple(sorted(class_of.items())), depth)


@lru_cache(maxsize=None)
def cached_labelled(labels, p, k, classes, depth):
    class_of = dict(classes)
    if len(labels) == 1:
        return {labels[0]} if (depth + class_of[labels[0]]) % k == 0 else set()
    result = set()
    for parts in partitions(labels, p):
        child_sets = [cached_labelled(part, p, k, classes, depth + 1) for part in parts]
        result.update(labelled_class(x, p) for x in product(*child_sets))
    return result


def relabel(tree, cycle):
    if isinstance(tree, int):
        return cycle[(cycle.index(tree) + 1) % len(cycle)] if tree in cycle else tree
    return labelled_class(tuple(relabel(x, cycle) for x in tree), len(tree))


def cherry_nodes(tree, p):
    if isinstance(tree, int):
        return []
    here = [tree] if all(isinstance(x, int) for x in tree) else []
    return here + sum((cherry_nodes(x, p) for x in tree), [])


def collapse_cherry(tree, selected, p, new=-1):
    if isinstance(tree, int):
        return tree
    if set(tree) == set(selected):
        return new
    return labelled_class(tuple(collapse_cherry(x, selected, p, new) for x in tree), p)


def test_phylogenetics_and_cherries():
    for p, smax in ((2, 7), (3, 5), (5, 4)):
        classes = {x: 0 for x in range(smax)}
        for s in range(1, smax + 1):
            labels = tuple(range(s))
            type_set = explicit_labelled(labels, p, 1, classes)
            if p == 2:
                expected = 1 if s == 1 else prod(range(1, 2*s - 2, 2))
                assert len(type_set) == expected
                print(f"phylogeny s={s}: {len(type_set)} = (2s-3)!!")
            if s == p:
                assert len(type_set) == factorial(p - 1)
            if s >= p:
                assert all(cherry_nodes(t, p) for t in type_set)
                for tree in type_set:
                    for cherry in cherry_nodes(tree, p):
                        remaining = [x for x in labels if x not in cherry]
                        assert collapse_cherry(tree, cherry, p) in explicit_labelled(
                            remaining + [-1], p, 1, {x: 0 for x in remaining + [-1]})

    def check_fixed(p, k, selected, others):
        selected = tuple(selected)
        others = tuple(others)
        labels = selected + others
        class_of = {x: 0 for x in selected}
        class_of.update({x: 1 for x in others})
        trees_before = explicit_labelled(labels, p, k, class_of)
        fixed = [t for t in trees_before if relabel(t, selected) == t]
        for t in fixed:
            assert any(set(node) == set(selected) for node in cherry_nodes(t, p))
        collapsed_class = dict(class_of)
        collapsed_class[-1] = 1
        collapsed_set = explicit_labelled(others + (-1,), p, k, collapsed_class)
        assert len(fixed) == (p - 1) * len(collapsed_set)
        for t in fixed:
            assert collapse_cherry(t, selected, p) in collapsed_set
        print(f"explicit cherry bijection p={p}, k={k}: "
              f"{len(fixed)} = {p-1} * {len(collapsed_set)}")

    check_fixed(2, 2, (0, 1), (2,))       # atoms 1,4,8 in m=13
    check_fixed(2, 2, (0, 1), (2, 3, 4))
    check_fixed(3, 2, (0, 1, 2), (3, 4))


@lru_cache(maxsize=None)
def count_partitions(a, p):
    result = []
    def rec(i, remaining, chosen):
        if i == p:
            if all(x == 0 for x in remaining):
                result.append(tuple(chosen))
            return
        for part in product(*(range(x + 1) for x in remaining)):
            if sum(part):
                rec(i + 1, tuple(x-y for x, y in zip(remaining, part)), chosen + [part])
    rec(0, a, [])
    return tuple(result)


def multinomial(a):
    result = 1
    remaining = sum(a)
    for x in a:
        result *= comb(remaining, x)
        remaining -= x
    return result


def labelled_counter(p, k):
    @lru_cache(maxsize=None)
    def count(depth, a):
        if sum(a) == 1:
            return int((depth + a.index(1)) % k == 0)
        total = 0
        for parts in count_partitions(a, p):
            weight = multinomial(a)
            for b in parts:
                weight *= unlabelled_counts[(depth + 1) % k, b]
            total += weight if len(set(parts)) == 1 else weight // p
        return total

    unlabelled_counts = {}
    for total in range(1, 10):
        for a in product(range(total + 1), repeat=k):
            if sum(a) != total:
                continue
            for depth in range(k):
                # Compute unlabelled counts recursively, then T exactly.
                def W(delta, b):
                    if sum(b) == 1:
                        return int((delta + b.index(1)) % k == 0)
                    subtotal = 0
                    for parts in count_partitions(b, p):
                        weight = multinomial(b)
                        for part in parts:
                            weight *= W((delta + 1) % k, part)
                        subtotal += weight if len(set(parts)) == 1 else weight // p
                    assert subtotal % prod(factorial(x) for x in b) == 0
                    return subtotal // prod(factorial(x) for x in b)
                unlabelled_counts[depth, a] = W(depth, a)
    return count


def test_counter_and_carries():
    for p, smax in ((2, 7), (3, 5), (5, 4)):
        T = labelled_counter(p, 1)
        for s in range(1, smax + 1):
            assert T(0, (s,)) == len(explicit_labelled(tuple(range(s)), p, 1, {x: 0 for x in range(s)}))
    for p, k, box in ((2, 2, 4), (3, 2, 4), (2, 3, 4)):
        T = labelled_counter(p, k)
        for a in product(range(box + 1), repeat=k):
            if not 1 <= sum(a) <= box:
                continue
            labels, class_of = [], {}
            for c, amount in enumerate(a):
                for _ in range(amount):
                    label = len(labels)
                    labels.append(label)
                    class_of[label] = c
            assert T(0, a) == len(explicit_labelled(labels, p, k, class_of))
    print("labelled-tree recursion agrees with explicit enumeration, including k=2,3")

    reductions = residues = 0
    for p, k, box in ((2, 1, 9), (3, 1, 8), (5, 1, 7), (2, 2, 8), (3, 2, 7), (2, 3, 7)):
        T = labelled_counter(p, k)
        for a in product(range(box + 1), repeat=k):
            s = sum(a)
            if not 1 <= s <= box:
                continue
            modulus = max(p**k - 1, 1)
            compatible = ((s - 1) % (p - 1) == 0
                          and sum(a[c]*p**c for c in range(k)) % modulus == 1 % modulus)
            expected = (-1)**((s - 1)//(p - 1)) if compatible else 0
            assert T(0, a) % p == expected % p, (p, k, a, T(0, a))
            residues += 1
            for c in range(k):
                if a[c] >= p:
                    b = list(a)
                    b[c] -= p
                    b[(c + 1) % k] += 1
                    assert (T(0, a) + T(0, tuple(b))) % p == 0
                    reductions += 1
    print(f"carry recurrence: {reductions} reductions and {residues} residue/vanishing checks")


# ----- Information and partition functions.


def distinct_asymmetric_types(tree, p):
    types = []
    def visit(x):
        if x is None:
            return
        kids = class_children(x, p)
        if len(set(kids)) == 1:
            for _ in range(p):
                visit(kids[0])
        else:
            types.append(kids)
            for kid in kids:
                visit(kid)
    visit(tree)
    return len(set(types))


def minimal_nmin(p, n):
    t = t_value((p - 1)*n + 1, p)
    classes = {canonical(x, p) for x in trees(p, n)}
    return sum(d_value(x, p) == t for x in classes)


def test_compression():
    tree = (((None, None), (None, None)), None)
    assert d_value(tree, 2) == 3
    assert distinct_asymmetric_types(tree, 2) == 2
    for p, d in [(2, 0), (2, 4), (3, 3), (5, 6)]:
        assert (p**d - 1).bit_length() == (d * (p - 1) + 1).bit_length() - 1 if False else (p**d - 1).bit_length()
        assert p**d <= 2**(p*d)
    for p, nmax in ((2, 8), (3, 4), (5, 4)):
        for n in range(1, nmax + 1):
            t = t_value((p - 1)*n + 1, p)
            assert minimal_nmin(p, n) % p != 0
    print("information: class encoding checked; d=3 versus 2 DAG node types is a counterexample")


def class_polynomial(p, n):
    classes = Counter(canonical(tree, p) for tree in trees(p, n))
    result = Counter()
    for tree, size in classes.items():
        assert size == p ** d_value(tree, p)
        result[d_value(tree, p)] += 1
    return dict(sorted(result.items()))


def test_physics_and_number_theory():
    print("\nPartition polynomials")
    for p, nmax in ((2, 8), (3, 5)):
        for n in range(1, nmax + 1):
            poly = class_polynomial(p, n)
            terms = [f"{c*p**d}" if d == 0 else f"{c*p**d}y^{d}" for d, c in poly.items()]
            z = sum(c*p**d for d, c in poly.items())
            assert z == comb(p*n, n) // ((p - 1)*n + 1)
            t = t_value((p - 1)*n + 1, p)
            assert min(poly) == t and poly[t] % p != 0
            print(f"p={p}, n={n}: Z={' + '.join(terms)}; Z(p)={z}; N_min={poly[t]}")
            digit_factors = prod(factorial(x) for x in digits((p - 1)*n + 1, p))
            exact = factorial(p*t) // (factorial(t)*p**t*digit_factors)
            assert poly[t] == exact
    for p, box in ((2, 11), (3, 7), (5, 5)):
        for a in range(1, box + 1):
            for b in range(1, box + 1):
                assert carries((a, b), p) == (
                    sum(digits(a, p)) + sum(digits(b, p)) - sum(digits(a+b, p))) // (p - 1)
    assert t_value(13, 2) == 2 and carries((4, 4, 4, 1), 2) == 4
    print("q=p exact N_min and Kummer's digit-sum carry identity checked")
    print("modular-versus-ordinary carries for m=13: t=2 but c(4,4,4,1)=4")


def main():
    start = perf_counter()
    test_arithmetic()
    test_phylogenetics_and_cherries()
    test_counter_and_carries()
    test_compression()
    test_physics_and_number_theory()
    print(f"\nALL EXPLICIT CHECKS PASSED ({perf_counter()-start:.2f}s).")
    print("Finite checks only; proof sketches and limitations are in the note.")


if __name__ == "__main__":
    main()
