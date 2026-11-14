# Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13.
"""E004: explicit checks for the accounting proof and the sandpile model.

Trees are actually constructed as nested tuples.  A node is ("N", children)
and a leaf is ("L", label).  Rotations at every node are enumerated; a cyclic
tree is the lexicographically least rotation at every node.  Nothing in the
small-object checks uses Fuss--Catalan or Legendre's formula as an input: those
formulas are compared to the constructed sets afterwards.
"""
from __future__ import annotations

import argparse
import itertools
import math
import platform
import random
import sys
import time
from collections import Counter
from functools import lru_cache
from pathlib import Path

from sympy import Matrix, ZZ
from sympy.matrices.normalforms import smith_normal_form


def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out or [0]


def nu(m, p):
    return sum(m // p**j for j in range(1, m.bit_length()+1))


def N(m, p):
    return (m - 1) // (p - 1)


def tvalue(m, p):
    return (sum(digits(m, p)) - 1) // (p - 1)


def fuss(p, k, n):
    q = p**k
    assert math.comb(q*n, n) % ((q-1)*n+1) == 0
    return math.comb(q*n, n) // ((q-1)*n+1)


def leaf(a):
    return ("L", a)


def canonical(tree):
    tree = choose_rotation(tree)
    if tree[0] == "L":
        return tree
    children = tuple(canonical(ch) for ch in tree[1])
    # Store the whole cyclic equivalence class at every node.
    return ("N", frozenset(children[i:]+children[:i] for i in range(len(children))))


def choose_rotation(node):
    return ("N", next(iter(node[1]))) if isinstance(node[1], frozenset) else node


def cyclic_nodes(tree):
    if tree[0] == "N":
        yield tree
        for child in choose_rotation(tree)[1]:
            yield from cyclic_nodes(child)


def leaves(tree):
    if tree[0] == "L":
        return (tree[1],)
    return sum((leaves(ch) for ch in choose_rotation(tree)[1]), ())


def node_count(tree):
    return sum(1 for _ in cyclic_nodes(tree))


def ordered_orbit(tree):
    if tree[0] == "L":
        return [tree]
    child_options = []
    for rotation_class in choose_rotation(tree)[1]:
        child_options.append(ordered_orbit(choose_rotation(rotation_class)))
    return [("N", children[i:]+children[:i])
            for children in itertools.product(*child_options)
            for i in range(len(children))]


def rotate_tree(tree):
    if tree[0] == "L":
        return tree
    children = tree[1]
    return canonical(("N", children[1:]+children[:1]))


def relabel(tree, permutation):
    if tree[0] == "L":
        return leaf(permutation.get(tree[1], tree[1]))
    return canonical(("N", tuple(relabel(ch, permutation) for ch in choose_rotation(tree)[1])))


def block_partitions(labels, p):
    """Ordered partitions into p nonempty blocks, with min in the first block."""
    if len(labels) < p:
        return
    if p == 1:
        if labels:
            yield (labels,)
        return
    rest = labels[1:]
    for size in range(len(rest)-p+2):
        for chosen in itertools.combinations(rest, size):
            first = (labels[0],)+chosen
            chosen_set = set(chosen)
            remaining = tuple(x for x in rest if x not in chosen_set)
            if p == 2:
                yield first, remaining
            else:
                for other in block_partitions(remaining, p-1):
                    yield (first,)+other


@lru_cache(maxsize=None)
def cyclic_trees(labels, classes, p, k, depth):
    """Cyclic trees with classes[c] on leaf c, in class -depth (mod k)."""
    if len(labels) == 1:
        if (depth+classes[0]) % k == 0:
            return (leaf(labels[0]),)
        return ()
    answer = set()
    for partition in block_partitions(labels, p):
        options = []
        possible = True
        for block in partition:
            bclasses = tuple(classes[labels.index(x)] for x in block)
            children = cyclic_trees(block, bclasses, p, k, (depth+1) % k)
            if not children:
                possible = False
                break
            options.append(children)
        if possible:
            for children in itertools.product(*options):
                answer.add(canonical(("N", children)))
    return tuple(sorted(answer))


def trees_with_classes(labels, classes, p, k):
    return cyclic_trees(tuple(sorted(labels)), tuple(classes), p, k, 0)


def cherry_collapse(tree, selected):
    selected = set(selected)
    hits = []
    for node in cyclic_nodes(tree):
        rotation = choose_rotation(node)
        if all(ch[0] == "L" for ch in rotation[1]):
                if {ch[1] for ch in rotation[1]} == selected:
                    hits.append(rotation)
    if len(hits) != 1:
        return None
    target = hits[0]

    def replace(tr):
        tr = choose_rotation(tr)
        if tr == target:
            return leaf(0)
        if tr[0] == "L":
            return tr
        return canonical(("N", tuple(replace(ch) for ch in tr[1])))
    return replace(tree)


class Checks:
    def __init__(self):
        self.failures = []
        self.counts = Counter()
        self.start = time.perf_counter()
        self.section = ""

    def begin(self, name):
        self.section = name
        print("\n" + "="*78 + "\n" + name + "\n" + "="*78, flush=True)

    def check(self, condition, detail):
        self.counts[self.section] += 1
        if not condition:
            message = f"FAIL [{self.section}] {detail}"
            self.failures.append(message)
            print(message, flush=True)

    def note(self, text):
        print(text, flush=True)


def symmetric_nodes(tree):
    return sum(1 for node in cyclic_nodes(tree)
               if len({frozenset(leaves(ch)) for ch in choose_rotation(node)[1]}) == 1)

def test_L1_L2(C):
    C.begin("L1/L2: actual labelled rotation classes and explicit cherry cycles")
    # This cap is on m!*C_n^(q), the number of ordered labelled trees.
    cap = 400_000
    for p in (2, 3, 5):
        for k in (1, 2):
            q = p**k
            feasible = []
            skipped = []
            for n in range(1, 80):
                m = (q-1)*n+1
                count = math.factorial(m)*fuss(p, k, n)
                if count > cap:
                    skipped.append((n, m, count))
                    break
                feasible.append((n, m, count))
            for n, m, expected in feasible:
                print(f"  constructing p={p}, k={k}, n={n}, m={m} ...", flush=True)
                start = time.perf_counter()
                trees = trees_with_classes(tuple(range(1, m+1)), (0,)*m, p, k)
                classes = len(trees)
                sizes = Counter()
                total = 0
                for tr in trees:
                    C.check(node_count(tr) == N(m, p), f"p={p},k={k},m={m}: node count {node_count(tr)} != {N(m,p)}")
                    orbit = ordered_orbit(tr)
                    C.check(len(orbit) == len(set(orbit)) and
                            all(canonical(o) == tr for o in orbit),
                            f"orbit representatives p={p},k={k},m={m}: {tr}")
                    sizes[len(orbit)] += 1
                    total += len(orbit)
                    C.check(symmetric_nodes(tr) == 0, f"p={p},k={k},m={m}: a symmetric labelled node exists: {tr}")
                C.check(total == expected == math.factorial(m)*fuss(p,k,n), f"L1 total p={p},k={k},m={m}: constructed {total}, factorial*Fuss-Catalan {expected}")
                C.check(classes*p**N(m,p) == expected, f"L1 class equation p={p},k={k},m={m}: classes={classes}, N={N(m,p)}, ordered={expected}")
                C.check(classes % p == (-1)**N(m,p) % p, f"L2 residue p={p},k={k},m={m}: L={classes}, residue={classes%p}, expected={(-1)**N(m,p)%p}")
                C.note(f"p={p},k={k},m={m}: cyclic classes={classes}, ordered labelled={total}, "
                       f"orbit-size histogram={dict(sizes)}, L mod p={classes%p}, expected={(-1)**N(m,p)%p}; {time.perf_counter()-start:.3f}s")
                if m >= p:
                    permutation = {i: i % p + 1 for i in range(1, p+1)}
                    fixed = [tr for tr in trees if relabel(tr, permutation) == tr]
                    remaining = tuple(range(p+1, m+1))
                    collapsed_labels = (0,)+remaining
                    collapsed_classes = (1 % k,)+(0,)*len(remaining)
                    collapsed_set = set(trees_with_classes(collapsed_labels, collapsed_classes, p, k))
                    collapses = Counter()
                    for tr in fixed:
                        before = node_count(tr)
                        collapsed = cherry_collapse(tr, range(1,p+1))
                        C.check(collapsed is not None, f"fixed non-cherry p={p},k={k},m={m}: {tr}")
                        if collapsed is not None:
                            C.check(node_count(collapsed) == before-1, f"collapse node bookkeeping p={p},k={k},m={m}")
                            collapses[collapsed] += 1
                    C.check(set(collapses) == collapsed_set, f"fixed-cherry bijection p={p},k={k},m={m}: collapsed set differs from all admissible collapsed trees")
                    C.check(all(v == p-1 for v in collapses.values()), f"fixed p-cycle arrangements p={p},k={k},m={m}: multiplicities not all {p-1}: {Counter(collapses.values())}")
                    C.check(len(fixed) == (p-1)*len(collapsed_set), f"fixed count p={p},k={k},m={m}: {len(fixed)} != {(p-1)*len(collapsed_set)}")
                    C.check(len(trees) % p == len(fixed) % p, f"Z_p fixed congruence p={p},k={k},m={m}")
                    C.note(f"  explicit p-cycle: fixed={len(fixed)}, collapsed classes={len(collapsed_set)}, "
                           f"multiplicity histogram={dict(Counter(collapses.values()))}")
            for n, m, count in skipped:
                C.note(f"EXPLICIT RANGE LIMIT p={p},k={k}: next n={n},m={m} would require {count} ordered labelled trees (cap {cap}); not attempted")
    C.begin("L2 extended exact-integer formula checks")
    for p in (2,3,5):
        for k in (1,2):
            q = p**k
            for n in range(1,201):
                m = (q-1)*n+1
                C0 = fuss(p,k,n)
                numerator = math.factorial(m)*C0
                C.check(numerator % p**N(m,p) == 0, f"formula integrality p={p},k={k},n={n}")
                L = numerator//p**N(m,p)
                C.check(L % p == (-1)**N(m,p) % p, f"formula L mod p p={p},k={k},n={n},m={m}")
            C.note(f"p={p},k={k}: exact L(m)=m!C_n^(q)/p^N(m) residue and integrality checked for 1<=n<=200")


@lru_cache(maxsize=None)
def complete_trees(labels, p, height):
    if height == 0:
        assert len(labels) == 1
        return (leaf(labels[0]),)
    assert len(labels) == p**height
    result = set()
    for partition in block_partitions(labels,p):
        options = [complete_trees(block,p,height-1) for block in partition]
        for children in itertools.product(*options):
            result.add(canonical(("N",children)))
    return tuple(sorted(result))


@lru_cache(maxsize=None)
def digit_forests(m, p):
    return forest_from_counts(tuple(range(1,m+1)), tuple(digits(m,p)), p)


@lru_cache(maxsize=None)
def forest_from_counts(labels, counts, p):
    if not labels:
        return ((),)  # one empty forest, not an empty set of forests
    if len(labels) == 1:
        return ((leaf(labels[0]),),) if sum(counts) == 1 and counts[0] == 1 else ()
    if sum(c*p**j for j,c in enumerate(counts)) != len(labels):
        return ()
    choices = [j for j,c in enumerate(counts) if c]
    if not choices:
        return ()
    j = choices[0]
    blocksize = p**j
    rest_counts = list(counts)
    rest_counts[j] -= 1
    result = set()
    for other in itertools.combinations(labels[1:], blocksize-1):
        block = (labels[0],)+other
        remaining = tuple(x for x in labels if x not in block)
        for tr in complete_trees(block,p,j):
            for forest in forest_from_counts(remaining,tuple(rest_counts),p):
                result.add(tuple(sorted((tr,)+forest)))
    return tuple(sorted(result))
    j = choices[0]
    blocksize = p**j
    rest_counts = list(counts)
    rest_counts[j] -= 1
    result = set()
    for other in itertools.combinations(labels[1:], blocksize-1):
        block = (labels[0],)+other
        remaining = tuple(x for x in labels if x not in block)
        for tr in complete_trees(block,p,j):
            for forest in forest_from_counts(remaining,tuple(rest_counts),p):
                result.add(tuple(sorted((tr,)+forest)))
    return tuple(sorted(result))


def K(a,p):
    return math.factorial(p*a)//(p**a*math.factorial(a))


def cycles_of(permutation,p):
    seen = set()
    result = []
    for x in range(len(permutation)):
        if x in seen:
            continue
        cycle = []
        y = x
        while y not in seen:
            seen.add(y)
            cycle.append(y)
            y = permutation[y]
        if len(cycle) != p:
            return None
        result.append(tuple(cycle))
    return tuple(result)


def test_L3(C):
    C.begin("L3: explicit digit forests, recurrence, actions and stabilizers")
    for p in (2,3,5):
        enumeration = []
        for m in range(1,10):
            start = time.perf_counter()
            forests = digit_forests(m,p)
            f = len(forests)
            expected = math.factorial(m)//(p**nu(m,p)*math.prod(math.factorial(j) for j in digits(m,p)))
            C.check(f == expected, f"digit-forest formula p={p},m={m}: actual={f}, expected={expected}; nu={nu(m,p)}, digits={digits(m,p)}")
            C.check(all(sorted(x for tr in forest for x in leaves(tr)) == list(range(1,m+1)) for forest in forests), f"forest leaf partition p={p},m={m}")
            m0 = m % p
            a = m//p
            recursive = math.comb(m,m0)*K(a,p)*(len(digit_forests(a,p)) if a else 1)
            C.check(f == recursive, f"explicit forest recurrence p={p},m={m}: F={f}, RHS={recursive}")
            if f:
                example = forests[0]
                C.check(sum(node_count(tr) for tr in example) == nu(m,p), f"forest internal nodes p={p},m={m}")
            enumeration.append((m,f))
            C.note(f"p={p},m={m}: |F|={f}, formula={expected}, recurrence RHS={recursive}, nu={nu(m,p)}; {time.perf_counter()-start:.3f}s")
        orbit_tests = sorted({p,p+1,p+2,7})
        for m in orbit_tests:
            forests = set(digit_forests(m,p))
            base = min(forests)
            orbit = set()
            stabilizer = 0
            for sigma in itertools.permutations(range(1,m+1)):
                permutation = dict(enumerate(sigma,1))
                image = tuple(sorted(relabel(tr,permutation) for tr in base))
                orbit.add(image)
                if image == base:
                    stabilizer += 1
            expected_stabilizer = p**nu(m,p)*math.prod(math.factorial(j) for j in digits(m,p))
            C.check(orbit == forests, f"transitivity p={p},m={m}: orbit={len(orbit)}, all structures={len(forests)}")
            C.check(stabilizer == expected_stabilizer, f"stabilizer p={p},m={m}: actual={stabilizer}, expected={expected_stabilizer}")
            C.note(f"  full S_{m} action: orbit={len(orbit)} (all structures={orbit == forests}), stabilizer={stabilizer}, expected={expected_stabilizer}")
    C.begin("L3: explicit K(a), binomial and fixed-point actions")
    for p in (2,3,5):
        for a in range(1, 8//p+1):
            objects = [pi for pi in itertools.permutations(range(p*a))
                       if cycles_of(pi,p) is not None]
            C.check(len(objects) == K(a,p), f"K enumeration p={p},a={a}: actual={len(objects)}, formula={K(a,p)}")
            sigma = tuple((i+1) % p if i<p else i for i in range(p*a))
            def conjugate(pi):
                return tuple(sigma[pi[sigma[x]]] for x in range(p*a))
            fixed = [pi for pi in objects if conjugate(pi) == pi]
            C.check(len(fixed) == K(a-1,p), f"K fixed action p={p},a={a}: fixed={len(fixed)}, K(a-1)={K(a-1,p)}")
            C.check(len(objects)%p == len(fixed)%p, f"K orbit congruence p={p},a={a}")
            C.note(f"p={p},a={a}: {p*a}-point permutations all of p-cycle type={len(objects)}, conjugation fixed={len(fixed)}")
        for a in range(0,31):
            C.check(K(a,p)%p == (-1)**a%p, f"K residue p={p},a={a}")
            if a:
                exact_recurrence = math.comb(p*a-1,p-1)*math.factorial(p-1)*K(a-1,p)
                C.check(K(a,p) == exact_recurrence, f"K exact recurrence p={p},a={a}")
        for m in range(1,10):
            m0 = m%p
            a = m//p
            rotation = {}
            for full in range(a):
                for i in range(p):
                    rotation[full*p+i+1] = full*p+(i+1)%p+1
            fixed = []
            for subset in itertools.combinations(range(1,m+1),m0):
                image = {rotation.get(x,x) for x in subset}
                if image == set(subset):
                    fixed.append(subset)
            C.check(math.comb(m,m0)==len(list(itertools.combinations(range(1,m+1),m0))), f"binomial enumeration p={p},m={m}")
            C.check(len(fixed)==1, f"binomial rotation fixed p={p},m={m}: {fixed}")
            C.check(math.comb(m,m0)%p == 1, f"binomial congruence p={p},m={m}")
    C.begin("L3 extended exact arithmetic, including the stabilizer identity")
    for p in (2,3,5):
        for m in range(1,1001):
            ds = digits(m,p)
            F = math.factorial(m)//(p**nu(m,p)*math.prod(math.factorial(j) for j in ds))
            a = m//p
            C.check(F == math.comb(m,m%p)*K(a,p)*(math.factorial(a)//(p**nu(a,p)*math.prod(math.factorial(j) for j in digits(a,p))) if a else 1), f"extended forest recurrence p={p},m={m}")
            C.check(F%p == (-1)**nu(m,p)%p, f"extended forest residue p={p},m={m}")
            C.check(math.comb(m,m%p)%p == 1, f"extended binomial p={p},m={m}")
        C.note(f"p={p}: forest formula/recurrence/residue and binomial residue checked for 1<=m<=1000")


def test_theorem(C):
    C.begin("THEOREM: C_n^(q) product(m_j!) congruent to (-p)^t mod p^(t+1)")
    tested = 0
    for p in (2,3,5,7,11,13):
        for k in range(1,5):
            for n in range(1,201):
                m = (p**k-1)*n+1
                t = tvalue(m,p)
                C0 = fuss(p,k,n)
                D = math.prod(math.factorial(j) for j in digits(m,p))
                modulus = p**(t+1)
                C.check((C0*D-(-p)**t)%modulus == 0, f"p={p},k={k},n={n},m={m},t={t}, C={C0}, D={D}")
                tested += 1
            C.note(f"p={p},k={k}: n=1..200 all congruences passed")
    C.note(f"total theorem cases={tested}")


def line_simulation(p,m,random_order,rng):
    a = [m]
    counts = Counter()
    while True:
        eligible = [i for i,v in enumerate(a) if v>=p]
        if not eligible:
            return a,counts
        i = rng.choice(eligible) if random_order else eligible[0]
        if i+1 == len(a):
            a.append(0)
        before = sum(v*p**j for j,v in enumerate(a))
        a[i] -= p
        a[i+1] += 1
        counts[i] += 1
        after = sum(v*p**j for j,v in enumerate(a))
        if before != after:
            raise AssertionError(f"line conserved quantity failed before={before}, after={after}")


def ring_simulation(p,k,m,random_order,rng):
    a = [m]+[0]*(k-1)
    counts = Counter()
    modulus = p**k-1
    while True:
        eligible = [i for i,v in enumerate(a) if v>=p]
        if not eligible:
            return a,counts
        i = rng.choice(eligible) if random_order else eligible[0]
        before = sum(v*p**j for j,v in enumerate(a)) % modulus if modulus>1 else 0
        a[i] -= p
        a[(i+1)%k] += 1
        counts[i] += 1
        after = sum(v*p**j for j,v in enumerate(a)) % modulus if modulus>1 else 0
        if before != after:
            raise AssertionError(f"ring conserved quantity failed before={before}, after={after}")


def expected_ring_state(p,k,m):
    modulus = p**k-1
    if modulus == 1:
        return [1] if m else []
    residue = m % modulus
    if residue == 0 and m > 0:
        residue = modulus
    return (digits(residue,p)+[0]*k)[:k]


def test_sand(C):
    C.begin("IDEA 2: local diamond, including ring wraparound")
    for p in (2,3,5):
        for k in (0,1,2,3):
            ring = k > 0
            length = k if ring else 4
            for state in itertools.product(range(p+1),repeat=length):
                def fire(x,i):
                    y=list(x)
                    y[i]-=p
                    y[(i+1)%length if ring else i+1]+=1
                    return tuple(y)
                for i,j in itertools.product(range(length),repeat=2):
                    if i != j and state[i]>=p and state[j]>=p:
                        first,second = fire(fire(state,i),j),fire(fire(state,j),i)
                        C.check(first == second, f"diamond p={p},k={k},state={state},sites={i},{j}: {first} != {second}")
            C.note(f"p={p}, ring length={k}: all sites 0..{p}, all legal distinct pairs commute")
    C.begin("IDEA 2: line and half-line; base-p digits, toppling counts, random orders")
    for p in (2,3,5):
        rng = random.Random(20261113+p)
        for m in range(1,201):
            deterministic = line_simulation(p,m,False,rng)
            C.check(deterministic[0] == digits(m,p), f"line final digits p={p},m={m}: {deterministic[0]} != {digits(m,p)}")
            C.check(sum(deterministic[1].values()) == nu(m,p), f"line toppling count p={p},m={m}")
            for c,x in deterministic[1].items():
                C.check(x == m//p**(c+1), f"line site counts p={p},m={m},site={c}: {x}")
            for trial in range(8):
                state,counts = line_simulation(p,m,True,rng)
                C.check(state == deterministic[0] and counts == deterministic[1], f"line abelian p={p},m={m},trial={trial}")
        C.note(f"p={p}: m=1..200; final digits, nu(m), site counts and 8 random orders checked; failures so far={len(C.failures)}")
    C.begin("IDEA 2: ring Z/k; conserved weight, final states, count N(m), random orders")
    for p in (2,3,5):
        for k in (1,2):
            rng = random.Random(20261113+10*p+k)
            for m in range(1,201):
                reference = ring_simulation(p,k,m,False,rng)
                expected = expected_ring_state(p,k,m)
                C.check(reference[0] == expected, f"ring final state p={p},k={k},m={m}: {reference[0]}, expected={expected}")
                expected_count = (m-sum(reference[0]))//(p-1)
                C.check(sum(reference[1].values()) == expected_count, f"ring toppling total p={p},k={k},m={m}")
                for trial in range(6):
                    state,counts = ring_simulation(p,k,m,True,rng)
                    C.check(state == reference[0] and sum(counts.values()) == sum(reference[1].values()), f"ring abelian p={p},k={k},m={m},trial={trial}")
            for n in range(1,301):
                m = (p**k-1)*n+1
                state,counts = ring_simulation(p,k,m,False,rng)
                C.check(state == [1]+[0]*(k-1), f"ring special final p={p},k={k},n={n}: {state}")
                C.check(sum(counts.values()) == N(m,p), f"ring N(m) p={p},k={k},n={n}: {sum(counts.values())} != {N(m,p)}")
            C.note(f"p={p},k={k}: all m<=200 with 6 random orders; special m=(p^k-1)n+1, n<=300, final e0 and N(m) topplings")
    C.begin("IDEA 2: toppling Laplacian pI-S and its integer cokernel")
    for p in (2,3,5,7):
        for k in (1,2,3,4):
            S = Matrix(k,k,lambda i,j: int((i-1)%k==j))
            A = p*Matrix.eye(k)-S
            C.check(A.det() == p**k-1, f"toppling determinant p={p},k={k}: {A.det()}")
            D = smith_normal_form(A,domain=ZZ)
            diagonal = [int(D[i,i]) for i in range(k)]
            expected = [1]*(k-1)+[p**k-1]
            C.check(diagonal == expected, f"cokernel p={p},k={k}: SNF diagonal={diagonal}, expected={expected}, A={A.tolist()}")
            C.note(f"p={p},k={k}: det(pI-S)={A.det()}, Smith diagonal={diagonal}, cokernel Z/{p**k-1}Z")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--only",choices=("trees","forest","theorem","sand","all"),default="all")
    args = parser.parse_args()
    print("E004 -- the accounting proof, explicit objects and exact arithmetic")
    print("Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13")
    print(f"Python {sys.version.split()[0]}; platform {platform.platform()}")
    print("A line beginning FAIL is a failed mathematical check. Range limits are reported separately.")
    print("No check is changed to fit the output; formulas are compared against explicit objects.")
    C = Checks()
    if args.only in ("trees","all"):
        test_L1_L2(C)
    if args.only in ("forest","all"):
        test_L3(C)
    if args.only in ("theorem","all"):
        test_theorem(C)
    if args.only in ("sand","all"):
        test_sand(C)
    print("\n" + "="*78)
    print("SUMMARY")
    for section,count in C.counts.items():
        failures = sum(1 for f in C.failures if f.startswith(f"FAIL [{section}]"))
        print(f"{section}: {count} checks, {failures} failures")
    print(f"TOTAL: {sum(C.counts.values())} checks, {len(C.failures)} failures; elapsed {time.perf_counter()-C.start:.3f}s")
    if C.failures:
        print("FAILURES, VERBATIM")
        for f in C.failures:
            print(f)
    return int(bool(C.failures))


if __name__ == "__main__":
    raise SystemExit(main())
