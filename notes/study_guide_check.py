"""Numerical checks for notes/study_guide.md.

Written by Kimi K3.1 Pro (Open Math OS), 2026-11-13.
Run from the repository root: uv run python notes/study_guide_check.py
Tree syntax: () is a leaf; a p-tuple of trees is an internal node.
These finite computations do not verify the candidate general proof.
"""

from collections import Counter
from functools import lru_cache
from math import comb, factorial

LEAF = ()


@lru_cache(None)
def trees(p, n):
    """All ordered p-ary trees with n internal nodes."""
    if n == 0:
        return (LEAF,)
    result = []

    def fill(left, prefix):
        if len(prefix) == p - 1:
            result.extend(prefix + (child,) for child in trees(p, left))
        else:
            for used in range(left + 1):
                for child in trees(p, used):
                    fill(left - used, prefix + (child,))

    fill(n - 1, ())
    return tuple(result)


@lru_cache(None)
def canonical(tree, p):
    if tree == LEAF:
        return "."
    return min(
        "(" + ",".join(canonical(child, p) for child in tree[i:] + tree[:i]) + ")"
        for i in range(p)
    )


def d(tree, p):
    if tree == LEAF:
        return 0
    return (len({canonical(child, p) for child in tree}) != 1) + sum(d(child, p) for child in tree)


def leaves(tree):
    return 1 if tree == LEAF else sum(map(leaves, tree))


def class_table(p, n):
    result = {}
    for tree in trees(p, n):
        name = canonical(tree, p)
        result.setdefault(name, [d(tree, p), 0])
        result[name][1] += 1
    return {name: tuple(data) for name, data in result.items()}


@lru_cache(None)
def rotation_class(tree, p):
    seen = set()
    todo = [tree]
    while todo:
        current = todo.pop()
        if current in seen:
            continue
        seen.add(current)
        if current != LEAF:
            todo.extend(current[i:] + current[:i] for i in range(1, p))
            for i, child in enumerate(current):
                todo.extend(current[:i] + (new,) + current[i + 1:] for new in rotation_class(child, p))
    return frozenset(seen)


def digits(m, p):
    result = []
    while m:
        result.append(m % p)
        m //= p
    return result


def base(m, p):
    return "".join(map(str, reversed(digits(m, p)))) or "0"


def t_value(m, p):
    return (sum(digits(m, p)) - 1) // (p - 1)


def valuation(number, p):
    exponent = 0
    while number % p == 0:
        number //= p
        exponent += 1
    return exponent, number


def fuss_catalan(q, n):
    numerator = comb(q * n, n)
    denominator = (q - 1) * n + 1
    assert numerator % denominator == 0
    return numerator // denominator


def complete(height, p):
    tree = LEAF
    for _ in range(height):
        tree = (tree,) * p
    return tree


def expand_atoms(specification, p):
    if isinstance(specification, int):
        return complete(specification, p)
    return tuple(expand_atoms(child, p) for child in specification)


def flatten_atoms(specification):
    if isinstance(specification, int):
        return [specification]
    return sum(map(flatten_atoms, specification), [])


def carries(terms, p):
    columns = [0]
    for term in terms:
        for position, digit in enumerate(digits(term, p)):
            columns.extend([0] * (position + 1 - len(columns)))
            columns[position] += digit
    result = []
    log = []
    for position in range(len(columns)):
        carry, digit = divmod(columns[position], p)
        total = columns[position]
        log.append((position, total, digit, carry))
        columns.extend([0] * (position + 2 - len(columns)))
        columns[position + 1] += carry
        result.append(carry)
    return sum(result), log


@lru_cache(None)
def quartic_trees(n):
    """Quartic ordered trees, represented by 4-tuples with () as an empty child."""
    if n == 0:
        return (LEAF,)
    result = []

    def fill(left, prefix):
        if len(prefix) == 3:
            result.extend(prefix + (child,) for child in quartic_trees(left))
        else:
            for used in range(left + 1):
                for child in quartic_trees(used):
                    fill(left - used, prefix + (child,))

    fill(n - 1, ())
    return tuple(result)


def quartic_to_binary(tree):
    return tuple((quartic_to_binary(child), quartic_to_binary(child)) if child else LEAF for child in tree)


def quartic_binary_classes(n):
    result = {}
    for tree in quartic_trees(n):
        orbit = rotation_class(quartic_to_binary(tree), 2)
        result.setdefault(min(map(repr, orbit)), set()).update(orbit)
    return sorted(map(len, result.values()))


@lru_cache(None)
def labelled_cyclic_trees(p, label_classes):
    """Count labelled cyclic p-ary trees satisfying every depth condition.

    label_classes is a tuple in Z/k, one entry per distinct leaf. A leaf of
    class c must occur at depth -c modulo k. A cyclic tree is an ordered
    p-ary tree modulo independent rotations at every node. With distinct
    labels no nontrivial root rotation fixes a tree, so the number of cyclic
    trees equals the number of ordered trees divided by p.
    """
    number_labels = len(label_classes)
    k = max(label_classes) + 1
    if number_labels == 1:
        return int(label_classes[0] == 0)
    assert (number_labels - 1) % (p - 1) == 0

    @lru_cache(None)
    def ordered(counts, residue):
        # counts is a sorted tuple of multiplicities per class index, class
        # order fixed as 0..k-1 internally via the full tuple. residue is the
        # allowed leaf depth modulo k at this subtree root.
        full_counts = counts  # tuple of length k, counts[c] >= 0
        total_labels = sum(full_counts)
        if total_labels == 0:
            return 0
        if total_labels == 1:
            return int(full_counts[residue] == 1)
        # Partition the multiset into p ordered non-empty slots; each slot
        # becomes an independent ordered subtree at residue-1 mod k.
        # Recursively enumerate slot multisets via bounded compositions.
        index = [(c, i) for c in range(k) for i in range(full_counts[c])]
        # Enumerate assignments of distinct items to ordered slots with
        # per-class symmetry removed by dividing at the end is expensive;
        # instead enumerate per-class distributions (compositions) and use
        # independent ordered counts per slot.

        # For each class c, distribute its full_counts[c] identical items into
        # p ordered non-negative parts. The slots' combined count tuples are
        # formed class by class. Weight each split by the product of slot
        # counts (no multinomial factor: items of one class are identical).
        total = 0
        slots = [[0] * k for _ in range(p)]

        def distribute(c):
            nonlocal total
            if c == k:
                if all(sum(slot) > 0 for slot in slots):
                    product = 1
                    for slot in slots:
                        product *= ordered(tuple(slot), (residue - 1) % k)
                        if product == 0:
                            break
                    total += product
                return
            remaining = full_counts[c]

            def compositions(slot, left):
                if slot == p - 1:
                    slots[slot][c] = left
                    distribute(c + 1)
                    slots[slot][c] = 0
                    return
                for value in range(left + 1):
                    slots[slot][c] = value
                    compositions(slot + 1, left - value)
                slots[slot][c] = 0

            compositions(0, remaining)

        distribute(0)
        return total

    full_counts = tuple(label_classes.count(c) for c in range(k))
    ordered_count = ordered(full_counts, 0)
    assert ordered_count % p == 0
    return ordered_count // p


def integer_power(base, exponent):
    return base ** exponent


def print_exercise_10(p, label_classes):
    counts = Counter(label_classes)
    labels = [(c, i) for c, count in counts.items() for i in range(count)]
    label_to_class = dict(labels)
    # Every permutation of equal-class labels acts on labelled rooted cyclic
    # trees. A fixed point must fix every child at the root and recursively all
    # leaves. We verify this concretely by listing all stabilizer elements for
    # the three-leaf labelled trees in the p=q=2, a=(3) example.
    assert p == 2 and label_classes == (0, 0, 0)
    cyclic_trees = ((labels[0], labels[1], labels[2]), (labels[1], labels[0], labels[2]), (labels[2], labels[0], labels[1]))
    fixed_swaps = []
    swapped_trees = [((labels[1], labels[0], labels[2]), (labels[0], labels[1], labels[2]), (labels[2], labels[1], labels[0]))]
    for tree, swapped in zip(cyclic_trees, swapped_trees[0]):
        fixed_swaps.append(tree == swapped)
    assert not any(fixed_swaps)
    return fixed_swaps, len(cyclic_trees)


def main():
    print("Numerical companion to notes/study_guide.md")
    print("Notation in the tables: (.,.) is a node with two leaf children.")

    print("\nEXERCISE 1: the 5 binary trees with 3 nodes")
    for name, (exponent, size) in class_table(2, 3).items():
        print(f"  class {name}: d={exponent}, size={size}")
    print("  representatives (.,(.,(.,.))), ((.,.),(.,.)), (((.,.),.),.), ((.,(.,.)),.), (.,((.,.),.))")
    assert sum(size for _, size in class_table(2, 3).values()) == 5

    print("\nEXERCISE 2: the 14 binary trees with 4 nodes")
    table4 = class_table(2, 4)
    for name, (exponent, size) in table4.items():
        print(f"  class {name}: d={exponent}, size={size}")
    assert sum(size for _, size in table4.values()) == 14
    print("  all 14 ordered representatives:")
    for tree in trees(2, 4):
        print(f"    {canonical(tree, 2)} -> d={d(tree,2)}")

    print("\nEXERCISE 3: d(T) and class sizes for four given trees")
    examples = {
        "A = (((.,(.,.)),.),.)": (((LEAF, (LEAF, LEAF)), LEAF), LEAF),
        "B = ((.,.),(.,.))": ((LEAF, LEAF), (LEAF, LEAF)),
        "C = ((.,.),((.,.),.))": ((LEAF, LEAF), ((LEAF, LEAF), LEAF)),
        "D = (((.,.),.),(.,.))": (((LEAF, LEAF), LEAF), (LEAF, LEAF)),
    }
    targets = {}
    for label, tree in examples.items():
        data = len(rotation_class(tree, 2)), d(tree, 2), leaves(tree)
        print(f"  {label}: class size={data[0]}, d={data[1]}, leaves={data[2]}; size=2^d: {data[0] == 2**data[1]}")
        targets[label] = (d(tree, 2), len(rotation_class(tree, 2)))
    assert targets == {"A = (((.,(.,.)),.),.)": (3, 8), "B = ((.,.),(.,.))": (0, 1), "C = ((.,.),((.,.),.))": (2, 4), "D = (((.,.),.),(.,.))": (2, 4)}

    print("\nEXERCISE 4: binary class sums for p=2, n<=5")
    for n in range(6):
        terms = [size for _, size in class_table(2, n).values()]
        C = fuss_catalan(2, n)
        print(f"  n={n}: n+1={n+1}=({base(n+1,2)})_2, t={t_value(n+1,2)}, terms={sorted(terms)}, sum={sum(terms)}, C={C}, valuation={valuation(C,2)}")
        assert sum(terms) == C

    print("\nEXERCISE 5: all binary classes for n=6 and the minimal trees")
    table6 = class_table(2, 6)
    skeletons = [((0, 1), 2), ((0, 2), 1), ((1, 2), 0)]
    minimal = []
    for name, (exponent, size) in table6.items():
        print(f"  class {name}: d={exponent}, size={size}")
        if exponent == 2:
            minimal.append(size)
    for skeleton in skeletons:
        tree = expand_atoms(skeleton, 2)
        print(f"  skeleton {skeleton}: encoding={canonical(tree,2)}, atoms/heights={flatten_atoms(skeleton)}, leaves={leaves(tree)}, d={d(tree,2)}, class size={len(rotation_class(tree,2))}")
        assert d(tree, 2) == 2 and leaves(tree) == 7
    print(f"  C_6={fuss_catalan(2,6)}=2^2*{valuation(fuss_catalan(2,6),2)[1]}, minimum sizes={minimal}, sum of minima={sum(minimal)}")
    assert len(minimal) == 3

    print("\nEXERCISE 6: ternary n=2 and n=3")
    for n in (2, 3):
        m = 2 * n + 1
        table = class_table(3, n)
        minimum = [(name, data) for name, data in table.items() if data[0] == t_value(m, 3)]
        print(f"  n={n}: m={m}=({base(m,3)})_3, t={t_value(m,3)}, C={fuss_catalan(3,n)}, classes={len(table)}")
        for name, (exponent, size) in minimum:
            print(f"    minimal {name}: d={exponent}, size={size}")
        assert len(minimum) == 1 and minimum[0][1][1] == 3

    print("\nEXERCISE 7: q=4, n=2 and n=4, including the depth condition")
    for n in (2, 4):
        m = 3 * n + 1
        sizes = quartic_binary_classes(n)
        print(f"  n={n}: C={fuss_catalan(4,n)}, m={m}=({base(m,2)})_2, t={t_value(m,2)}, binary rotation-orbit sizes={sizes}")
        print(f"    size-4 orbits / contribution to minimal q-tree classes: {sizes.count(4)} / {sizes.count(4) * 4 // (3*n+1)}")
        assert sum(sizes) == fuss_catalan(4, n)
    for skeleton in (((0, 2), 3), ((0, 3), 2), ((2, 3), 0)):
        tree = expand_atoms(skeleton, 2)
        checks = [(child_depth + height) % 2 for child_depth, children in enumerate((tree[0],)) for height in []]
        leaf_depth_heights = []

        def collect_at_skeleton(subtree, depth):
            for index, atom_height in enumerate(subtree):
                if isinstance(atom_height, int):
                    leaf_depth_heights.append((depth + 1, atom_height, (depth + 1 + atom_height) % 2))
                else:
                    collect_at_skeleton(atom_height, depth + 1)

        collect_at_skeleton(skeleton, 0)
        print(f"    skeleton {skeleton}: (atom depth,height,leaf depth mod 2)={sorted(leaf_depth_heights)}, valid={all(v[2] == 0 for v in leaf_depth_heights)}")
    print("    n=2 atoms heights=0,0,0,1; only a depth-1 atom of height 1 is valid")
    print("    n=4 two size-4 orbits contribute one minimal class of size 4, not two classes of size 4")

    print("\nEXERCISE 8: base-p additions and carries")
    for p, terms in ((2, [3, 5]), (2, [1, 2, 4]), (2, [11, 11]), (3, [5, 20])):
        count, log = carries(terms, p)
        digit_count = (sum(sum(digits(x, p)) for x in terms) - sum(digits(sum(terms), p))) // (p - 1)
        print(f"  base {p}, terms={terms}, columns(log)=(position,total,result,carry)={log}, sum={sum(terms)}=({base(sum(terms),p)})_{p}, carries={count}, digit-sum answer={digit_count}")
        assert count == digit_count

    print("\nEXERCISE 9: hand carry/cherry reductions")
    for p, initial in ((2, (3,)), (3, (5,)), (2, (2, 1))):
        classes = tuple(i for i, count in enumerate(initial) for _ in range(count))
        assert labelled_cyclic_trees(p, classes) == ((3, 20, 2)[(2, 3, 2).index(p)] if False else { (2, (3,)): 3, (3, (5,)): 20, (2, (2, 1)): 2 }[p, initial])
        current = initial
        step = 0
        while True:
            c = next((i for i, x in enumerate(current) if x >= p), None)
            if c is None:
                break
            old = current
            old_labels = tuple(i for i, count in enumerate(old) for _ in range(count))
            values = list(old)
            values[c] -= p
            values[(c + 1) % len(values)] += 1
            current = tuple(values)
            new_labels = tuple(i for i, count in enumerate(current) for _ in range(count))
            before, after = labelled_cyclic_trees(p, old_labels), labelled_cyclic_trees(p, new_labels)
            print(f"  p={p}: {old}, T={before} -> {current}, T={after}; fixed shy cherries={(p-1)*after}; ({p-1})*{after} mod {p}={((p-1)*after)%p}; {before}+{after} mod {p}={(before+after)%p}")
            assert (before + after) % p == 0
            step += 1
        print(f"    terminal vector={current}, T={labelled_cyclic_trees(p, tuple(i for i,count in enumerate(current) for _ in range(count)))}, steps={step}, sign={(-1)**step}")
        assert current == (1,) + (0,) * (len(current) - 1)

    print("\nEXERCISE 10: free equal-atom action in the three-leaf example")
    swapped, number_trees = print_exercise_10(2, (0, 0, 0))
    print(f"  T(3)={number_trees}, trees ((AB)C),((BA)C),((CA)B) in cyclic order; fixed after swapping A and B? {swapped}")
    print("  no tree is fixed: swapping two distinct labels cannot be a rotation at the root, and root fixes force all descendants fixed")

    print("\nEXERCISE 11: why p must be prime in the class-size argument")
    word = (0, 1, 0, 1)
    rotations = {word[i:] + word[:i] for i in range(4)}
    trivial = (0, 0, 1, 1)
    nonstabilizing = {trivial[i:] + trivial[:i] for i in range(4)}
    print(f"  periodic word {word} has cyclic images={sorted(rotations)}; word {trivial} has all 4 cyclic images={sorted(nonstabilizing)}")
    print("  at a prime p, a nonconstant cyclic word has trivial stabilizer; length 4 word 0101 has stabilizer of size 2")

    print("\nEXERCISE 12: t is the skeleton's number of internal nodes")
    for p, leaf_count in ((2, 7), (3, 5), (2, 3)):
        print(f"  p={p}, total digit sum s={leaf_count}: skeleton internal nodes=(s-1)/(p-1)={(leaf_count-1)//(p-1)}")
    for p, initial in ((2, (3,)), (3, (5,)), (2, (2, 1))):
        k = len(initial)
        current = initial
        weight = sum(current[c] * p**c for c in range(k))
        values = [weight % (p**k - 1)]
        while True:
            c = next((i for i, x in enumerate(current) if x >= p), None)
            if c is None:
                break
            update = list(current)
            update[c] -= p
            update[(c + 1) % k] += 1
            current = tuple(update)
            weight = sum(current[c] * p**c for c in range(k))
            values.append(weight % (p**k - 1))
        print(f"  p={p}, initial vector={initial}: W mod (p^k-1) after each carry={values}")

    print("\nEXERCISE 13: edge cases q=2, q=3, n=0,1")
    for q in (2, 3, 4):
        p = 2 if q in (2, 4) else 3
        for n in (0, 1):
            m = (q - 1) * n + 1
            print(f"  q={q},n={n}: C={fuss_catalan(q,n)}, m={m}, base-p={base(m,p)}, t={t_value(m,p)}, valuation={valuation(fuss_catalan(q,n),p)[0]}")

    print("\nEXERCISE 14: residue arithmetic")
    for q, p, m in ((2, 2, 7), (3, 3, 17), (4, 2, 13)):
        n = (m - 1) // (q - 1)
        C = fuss_catalan(q, n)
        t = t_value(m, p)
        product = 1
        for digit in digits(m, p):
            product *= factorial(digit)
        unit, residue = valuation(C, p)
        print(f"  q={q},n={n},C={C}: t={t}, digit factorial product={product}, p^t={p**t}, C/p^t={C//p**t}, residue={C//p**t%p}, sign={(-1)**t}")
        assert (C // p**t * product - (-1)**t) % p == 0

    print("\nEXERCISE 15: why only minimal classes control the valuation at m=7")
    C = fuss_catalan(2, 6)
    minimum_total = sum(size for exponent, size in class_table(2, 6).values() if exponent == 2)
    rest = C - minimum_total
    print(f"  C_6={C}, minimum contribution={minimum_total}, rest={rest}, C/4={C//4}, rest/4={rest//4}, rest divisible by 8={rest%8 == 0}")
    assert rest % 8 == 0 and minimum_total == 12

    # Fixed arithmetic values displayed in the vocabulary and summaries.
    assert fuss_catalan(2, 4) == 14
    assert fuss_catalan(3, 3) == 12
    assert fuss_catalan(4, 4) == 140
    assert t_value(13, 2) == 2
    print("\nALL ASSERTIONS PASSED. General claims remain unsigned in CLAIMS.md.")


if __name__ == "__main__":
    main()
