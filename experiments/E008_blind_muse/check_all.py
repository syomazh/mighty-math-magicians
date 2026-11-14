"""
Experiments for W018 blind proof search (muse).
Checks lemmas for all three strategies on small cases.
Run with: uv run python experiments/E008_blind_muse/check_all.py

Model: meta/muse-spark-open
"""
from math import comb
from fractions import Fraction
from collections import defaultdict
import sys

# ============================================================
# Helpers: Fuss-Catalan, valuations, digit sums
# ============================================================

def v_p(n, p):
    """p-adic valuation of n (n > 0 integer)."""
    if n == 0:
        return float('inf')
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e

def s_p(m, p):
    """Sum of base-p digits of m."""
    s = 0
    while m > 0:
        s += m % p
        m //= p
    return s

def digit_sum_formula(n, p, k):
    """Predicted valuation (s_p(m)-1)/(p-1) where m=(q-1)n+1, q=p^k."""
    q = p ** k
    m = (q - 1) * n + 1
    return (s_p(m, p) - 1) // (p - 1) if p > 2 else s_p(m, 2) - 1

def fuss_catalan(n, q):
    """C_n^{(q)} = binom(qn, n) / ((q-1)n+1). Assumes divisibility."""
    m = (q - 1) * n + 1
    return comb(q * n, n) // m

def check_valuation_formula(p, k, n_max=30):
    """Verify v_p(C_n^{(q)}) = (s_p(m)-1)/(p-1) for small n."""
    q = p**k
    ok = True
    for n in range(1, n_max+1):
        m = (q-1)*n + 1
        C = fuss_catalan(n, q)
        actual = v_p(C, p)
        predicted = digit_sum_formula(n, p, k)
        if actual != predicted:
            print(f"  FAIL: p={p} k={k} n={n} m={m} C={C} v_p={actual} predicted={predicted}")
            ok = False
    return ok

# ============================================================
# General checks: does the formula hold?
# ============================================================
print("=" * 60)
print("CHECK 0: Valuation formula on small cases")
print("=" * 60)
for p, k in [(2,1),(2,2),(2,3),(3,1),(3,2),(5,1),(5,2)]:
    ok = check_valuation_formula(p, k, n_max=20)
    print(f"  p={p}, k={k}: {'PASS' if ok else 'FAIL'}")

# ============================================================
# Strategy A: Orbit counting via p-group action on q-ary trees
# Based on idea: the cyclic group Z/pZ acts by rotating p-tuples of
# consecutive children at each node; orbits have p-power size where
# exponent counts "asymmetric branch points".
# ============================================================
print()
print("=" * 60)
print("STRATEGY A: p-group action on q-ary trees")
print("=" * 60)

# For q = p (simplest case), we can enumerate all q-ary trees with n nodes
# and study orbit structure.
# A q-ary tree: each node has q ordered slots, each either empty or a subtree.
# Represented as nested tuples: None = empty, tuple of q entries = node.

def enumerate_qary_trees(n, q):
    """
    Enumerate all q-ary trees with n nodes.
    Uses DP: number of trees satisfies C_n = sum over compositions
    where subtrees partition n-1 nodes among q slots.
    For enumeration, we generate recursively.
    """
    if n == 0:
        return [None]  # empty tree (no nodes)
    if n == 1:
        return [tuple([None]*q)]  # single node, all slots empty

    trees = []

    # We need to distribute n-1 nodes among q ordered slots
    # Each slot gets n_i nodes (possibly 0), sum n_i = n-1
    # For each composition, combine subtrees
    def compositions(total, parts):
        """Generate all ways to write total as sum of `parts` nonneg ints."""
        if parts == 1:
            yield (total,)
            return
        for first in range(total + 1):
            for rest in compositions(total - first, parts - 1):
                yield (first,) + rest

    # Cache subtrees by size
    cache = {}

    def get_trees(size):
        if size not in cache:
            cache[size] = enumerate_qary_trees(size, q)
        return cache[size]

    count = 0
    for comp in compositions(n - 1, q):
        # For each composition, take product of subtree choices
        sub_lists = [get_trees(c) for c in comp]

        # Cartesian product
        def product(lists, idx=0, current=None):
            if current is None:
                current = []
            if idx == len(lists):
                yield tuple(current)
                return
            for item in lists[idx]:
                current.append(item)
                yield from product(lists, idx+1, current)
                current.pop()

        for combo in product(sub_lists):
            trees.append(combo)

    return trees


# Test enumeration gives correct counts
print("\nEnumeration check (should match Fuss-Catalan numbers):")
for q in [2, 3, 4]:
    for n in range(6):
        trees = enumerate_qary_trees(n, q)
        expected = fuss_catalan(n, q) if n >= 1 else 1
        # n=0: 1 empty tree
        status = "OK" if len(trees) == expected else "MISMATCH"
        print(f"  q={q} n={n}: enumerated={len(trees)} expected={expected} {status}")

# Strategy A lemma checks (q=p prime, p=2 small cases)
# Lemma A1: orbit size counting
# For q=p=2 (binary trees), consider group G acting by swapping left/right
# subtrees at each node. The orbit size of a tree T under iterated swaps
# should be 2^(number of asymmetric internal nodes where left != right subtree).

def canonical_form(tree):
    """Canonical form of a tree for comparison (just use the tree itself as key)."""
    # For hashing/comparison, convert to string
    if tree is None:
        return "."
    return "(" + ",".join(canonical_form(c) for c in tree) + ")"

def orbit_size_binary(tree):
    """
    For q=2 binary trees, compute orbit size under the group generated by
    swapping children at each node (full automorphism of the infinite binary tree).
    This group acts by: at each node, optionally swap left and right subtrees
    (and recursively within subtrees). Need to account for the infinite group
    properly: we consider the action of the group G_n that allows independent
    swaps at each node of depth < n.

    The orbit size = 2^(number of nodes where left_subtree != right_subtree
    as unordered structures, counted with proper handling of automorphisms).

    For now, let's compute brute-force orbit for small trees.
    """
    pass

def brute_force_orbit_binary(tree):
    """
    Brute-force orbit computation for small binary trees (q=2).
    The group is generated by: at each node, swap left and right children.
    We generate the orbit by BFS applying all single swaps.
    """
    from collections import deque

    def all_swaps(tree):
        """Generate all trees reachable by one swap at any node."""
        results = []
        if tree is None:
            return results
        # Swap at root
        swapped = (tree[1], tree[0])
        results.append(swapped)
        # Recurse into children
        for i in range(len(tree)):
            if tree[i] is not None:
                for new_child in all_swaps(tree[i]):
                    new_tree = list(tree)
                    new_tree[i] = new_child
                    results.append(tuple(new_tree))
        return results

    visited = set()
    queue = deque([tree])
    start_key = canonical_form(tree)
    visited.add(start_key)

    while queue:
        current = queue.popleft()
        for nxt in all_swaps(current):
            key = canonical_form(nxt)
            if key not in visited:
                visited.add(key)
                queue.append(nxt)

    return len(visited)

# Check orbit sizes for binary trees
print("\nOrbit structure for binary trees (q=2):")
for n in range(1, 7):
    trees = enumerate_qary_trees(n, 2)
    orbit_sizes = defaultdict(int)
    orbit_size_list = []
    visited_global = set()
    orbits = []
    for t in trees:
        key = canonical_form(t)
        if key in visited_global:
            continue
        # Find orbit of t
        from collections import deque as dq
        orbit_keys = set()
        queue = dq([t])
        orbit_keys.add(canonical_form(t))

        def get_all_swaps(tree):
            if tree is None:
                return []
            res = [(tree[1], tree[0])]
            for i in range(len(tree)):
                if tree[i] is not None:
                    for nc in get_all_swaps(tree[i]):
                        nt = list(tree)
                        nt[i] = nc
                        res.append(tuple(nt))
            return res

        orb_queue = dq([t])
        orb_visited = {canonical_form(t)}
        orb_members = [t]
        while orb_queue:
            cur = orb_queue.popleft()
            for nxt in get_all_swaps(cur):
                k2 = canonical_form(nxt)
                if k2 not in orb_visited:
                    orb_visited.add(k2)
                    orb_queue.append(nxt)
                    orb_members.append(nxt)
        for k2 in orb_visited:
            visited_global.add(k2)
        sz = len(orb_visited)
        orbit_sizes[sz] += 1
        orbit_size_list.append(sz)

    total_from_orbits = sum(s * c for s, c in orbit_sizes.items())
    print(f"  n={n}: {len(trees)} trees, orbits by size: {dict(orbit_sizes)}, total={total_from_orbits} (should be {len(trees)})")
    # Check v_2
    C = fuss_catalan(n, 2) if n >= 1 else 1
    vp = v_p(C, 2) if C > 0 else 0
    min_v2_orbit = min(orbit_size_list).bit_length() - 1 if orbit_size_list else 0  # v2 of min orbit
    # Actually min orbit size's 2-adic valuation
    min_orbit = min(orbit_size_list) if orbit_size_list else 1
    print(f"    v_2(C_{n}) = {vp}, min orbit size = {min_orbit}, v_2(min orbit) = {v_p(min_orbit, 2)}")


# Strategy A with q=4=2^2 case
print("\nOrbit structure for q=4 trees (q=2^2):")
for n in range(1, 5):
    trees = enumerate_qary_trees(n, 4)
    print(f"  q=4 n={n}: {len(trees)} trees, C={fuss_catalan(n, 4)}")
    # Orbit computation for q=4 would involve S_4 acting at each node
    # (permuting the 4 children) - much more complex, skip brute force for now
    vp = v_p(fuss_catalan(n, 4), 2)
    m = 3*n + 1
    predicted = s_p(m, 2) - 1
    print(f"    v_2(C)={vp} predicted={predicted} m={m} s_2(m)={s_p(m,2)}")


# ============================================================
# Strategy B: Recursive / functional-equation approach
# G(x) = x + G(x)^q  (generating function for q-ary trees)
# Read mod p^k: G(x) mod p relates to base-p digits
# ============================================================
print()
print("=" * 60)
print("STRATEGY B: Functional equation G = x + G^q mod p")
print("=" * 60)

# Key insight: C_n^{(q)} is the coefficient of x^{(q-1)n+1} in G(x)
# where G = x + G^q. We examine G modulo p.
# For q=p: G = x + G^p. Over F_p, the map f -> f^p is Frobenius.
# G mod p satisfies G = x + G^p, so G - G^p = x, i.e. G * (1 - G^{p-1}) = x
# This constrains which coefficients can be nonzero mod p.

# Let's compute C_n^{(q)} mod p for small cases to see the pattern
print("\nC_n^{(q)} mod p pattern:")
for p, k in [(2,1),(3,1),(2,2)]:
    q = p**k
    print(f"\n  p={p} q={q}:")
    for n in range(1, 15):
        m = (q-1)*n + 1
        C = fuss_catalan(n, q)
        print(f"    n={n:2d} m={m:3d} s_p(m)={s_p(m,p):2d} v_p(C)={v_p(C,p):2d} C mod {p}={C % p} C={C}")

# Check: for q=p, C_n mod p != 0 iff m is a power of p
# (since (s_p(m)-1)/(p-1) = 0 iff s_p(m)=1 iff m is a power of p)
print("\n  Checking: C_n nonzero mod p iff m is power of p (for q=p):")
for p in [2, 3, 5]:
    q = p
    print(f"  p={p}:")
    for n in range(1, 20):
        m = (q-1)*n + 1
        C = fuss_catalan(n, q)
        is_p_power = (m > 0 and (m & (m-1) == 0) if p == 2 else False)
        # General power check
        is_ppow = False
        tmp = m
        while tmp % p == 0:
            tmp //= p
        is_ppow = (tmp == 1)
        nonzero_mod_p = (C % p != 0)
        vp = v_p(C, p)
        expected_nonzero = (vp == 0)
        # vp==0 iff s_p(m)==1 iff m is p-power
        if nonzero_mod_p != is_ppow:
            print(f"    MISMATCH n={n} m={m} C%p={C%p} is_ppow={is_ppow}")
    print(f"    All checked (no mismatches means pattern holds)")

# Functional equation check: verify G = x + G^q as formal power series
print("\n  Functional equation verification (truncated):")
for q in [2, 3, 4]:
    # G(x) = sum C_n^{(q)} * x^{(q-1)*n+1}
    # Check that G(x) = x + G(x)^q to some order
    max_m = 30  # max exponent
    # Build G coefficients: G[m] = C_n if m=(q-1)*n+1, else 0
    G_coeffs = [0] * (max_m + 1)
    for n in range(20):
        m = (q-1)*n + 1
        if m <= max_m:
            if n == 0:
                G_coeffs[m] = 0  # C_0 by convention? Actually G starts at x
                # G = x corresponds to n=0 giving coefficient 1 for x^1
                # Let's set G[m] properly: G(x) = sum_{n>=0} C_n * x^{(q-1)n+1}
                # But C_0^{(q)} = 1 (empty tree) -- need to handle
                pass
            else:
                G_coeffs[m] = fuss_catalan(n, q)

    # C_0^{(q)} = 1: one empty q-ary tree... but G(x) = x + G(x)^q
    # G(x) = sum_{n>=0} a_n x^{(q-1)n+1} where a_0=1, a_n=C_n for n>=1?
    # Actually let's use: G = x + G^q means if G = sum g_m x^m,
    # then g_1 = 1 and higher coefficients determined by convolution.
    # Known: g_{(q-1)n+1} = C_n^{(q)}, g_1=1=C_0
    G_coeffs2 = [0] * (max_m + 1)
    G_coeffs2[1] = 1  # C_0 = 1
    for n in range(1, 20):
        m = (q-1)*n + 1
        if m <= max_m:
            G_coeffs2[m] = fuss_catalan(n, q)

    # Compute G^q truncation
    def poly_power(coeffs, power, max_deg):
        """Compute (sum coeffs[i] x^i)^power truncated to max_deg."""
        result = [0] * (max_deg + 1)
        result[0] = 1
        for _ in range(power):
            new_result = [0] * (max_deg + 1)
            for i in range(max_deg + 1):
                if result[i] == 0:
                    continue
                for j in range(max_deg + 1 - i):
                    if coeffs[j] == 0:
                        continue
                    if i + j <= max_deg:
                        new_result[i + j] += result[i] * coeffs[j]
            result = new_result
        return result

    Gq = poly_power(G_coeffs2, q, max_m)
    # Check: G should equal x + G^q
    # x corresponds to coefficient 1 at degree 1
    x_plus_Gq = [0] * (max_m + 1)
    x_plus_Gq[1] = 1
    for i in range(max_m + 1):
        x_plus_Gq[i] += Gq[i]

    match = all(G_coeffs2[i] == x_plus_Gq[i] for i in range(max_m + 1))
    print(f"  q={q}: G = x + G^q ? {match}")
    if not match:
        for i in range(max_m + 1):
            if G_coeffs2[i] != x_plus_Gq[i]:
                print(f"    degree {i}: G={G_coeffs2[i]} x+G^q={x_plus_Gq[i]}")

# Lucas-type divisibility: check C_n mod p using Lucas
print("\n  Lucas-type check: when is C_n divisible by p?")
for p in [2, 3]:
    q = p
    print(f"  p={p} q={q}: n, m, s_p(m), v_p(C_n), C_n mod p")
    for n in range(1, 12):
        m = (q-1)*n + 1
        C = fuss_catalan(n, q)
        print(f"    n={n}: m={m} s_p={s_p(m,p)} v_p={v_p(C,p)} C mod p = {C % p}")

# ============================================================
# Strategy C: Necklace / cycle-lemma approach
# ============================================================
print()
print("=" * 60)
print("STRATEGY C: Necklaces, cycle lemma, rotation symmetry")
print("=" * 60)

# Key idea: Fuss-Catalan numbers count dissections of a polygon, or
# equivalently (via cycle lemma): C_n^{(q)} = (1/m) * binom(qn, n)
# where m = (q-1)n+1. The cycle lemma says: among qn words with n
# "special" symbols, exactly 1/m fraction have a ballot/Lukasiewicz property.
#
# The necklace approach: consider words of length qn with n marked positions
# (or n "up" steps and (q-1)n "down" steps). Rotations partition into necklaces.
# Most necklaces have m distinct rotations; the cycle lemma picks one per necklace.

# Check cycle-lemma divisibility numerically
print("\nCycle lemma: C_n^{(q)} = binom(qn,n) / m")
for q in [2, 3, 4]:
    for n in range(1, 8):
        m = (q-1)*n + 1
        bc = comb(q*n, n)
        C = bc // m
        assert bc % m == 0
        print(f"  q={q} n={n}: binom({q*n},{n})={bc} m={m} C={C} (divisible: {bc % m == 0})")

# For q=p, investigate p-adic valuation of binom(qn, n) and of m separately
print("\nValuation decomposition: v_p(C) = v_p(binom(qn,n)) - v_p(m)")
for p in [2, 3, 5]:
    q = p
    print(f"  p={p} q={q}:")
    for n in range(1, 15):
        m = (q-1)*n + 1
        bc = comb(q*n, n)
        C = bc // m
        a = v_p(bc, p)
        b = v_p(m, p)
        actual = v_p(C, p)
        print(f"    n={n:2d} m={m:3d} v_p(binom)={a} v_p(m)={b} v_p(C)={a-b} actual={actual} {'OK' if a-b==actual else 'FAIL'}")

# Carry analysis for binom(qn, n) mod p (Kummer's theorem: v_p(binom) = carries)
def count_carries(a, b, p):
    """Number of carries when adding b and a-b in base p (equals v_p(binom(a,b)))."""
    carries = 0
    carry = 0
    while a > 0 or b > 0:
        da = a % p
        db = b % p
        # Adding db + (da - db) = da; carry if db + carry > da (in some sense)
        # More precisely: v_p(binom(a,b)) = carries when adding b and a-b in base p
        # Equivalently: s_p(b) + s_p(a-b) - s_p(a) over (p-1)
        a //= p
        b //= p
        # Track carries properly
        total = db + carry
        if total > da:
            carries += 1
            carry = 1
        elif total < da:
            carry = 0
        else:
            # total == da, carry stays?
            # Actually need b + (a-b) = a digit by digit with carries
            # If total == da, no new carry generated, but existing carry propagates if da==p-1?
            pass
    return carries

def v_p_binom_kummer(a, b, p):
    """v_p(binomial(a,b)) via digit sums: (s_p(b)+s_p(a-b)-s_p(a))/(p-1)."""
    return (s_p(b, p) + s_p(a - b, p) - s_p(a, p)) // (p - 1)

print("\n  Kummer verification: v_p(binom(qn,n)) via carries/digit sums")
for p in [2, 3, 5]:
    q = p
    for n in range(1, 12):
        a_vp = v_p_binom_kummer(q*n, n, p)
        actual = v_p(comb(q*n, n), p)
        if a_vp != actual:
            print(f"    FAIL p={p} n={n}: kummer={a_vp} actual={actual}")

print("  Kummer check: all passed (no FAIL printed means OK)")

# Show how digit sum formula emerges from Kummer + v_p(m)
print("\n  How digit-sum formula connects to Kummer:")
print("  For q=p: m=(p-1)n+1, so (q-1)n+1 = m")
print("  v_p(C_n^{(p)}) = v_p(binomial(pn,n)) - v_p(m)")
print("  And v_p(binomial(pn,n)) = (s_p(n)+s_p((p-1)n)-s_p(pn))/(p-1)")
print("  Need to show this equals (s_p(m)-1)/(p-1) + v_p(m)")
print("  Check numerically:")
for p in [2, 3, 5]:
    q = p
    print(f"  p={p}:")
    for n in range(1, 12):
        m = (q-1)*n + 1
        vp_binom = v_p(comb(q*n, n), p)
        vp_m = v_p(m, p)
        vp_C = vp_binom - vp_m
        predicted = (s_p(m, p) - 1) // (p - 1)
        kummer_val = (s_p(n, p) + s_p((p-1)*n, p) - s_p(p*n, p)) // (p-1) if p > 2 else s_p(n,2)+s_p(n,2)-s_p(2*n,2)
        # For p=2, pn=2n, s_2(2n)=s_2(n) so kummer gives s_2(n)+s_2(n)-s_2(n) = s_2(n)... let's just compute directly
        kv = v_p_binom_kummer(q*n, n, p)
        print(f"    n={n:2d} m={m:3d} v_p(binom)={kv} v_p(m)={vp_m} diff={kv-vp_m} predicted={(s_p(m,p)-1)//(p-1)} {'OK' if kv-vp_m==predicted else 'MISMATCH'}")

# Digit sum relation: s_p(pn) = s_p(n), and (p-1)n = m-1, pn = m+n-1
# Let's explore the identity s_p((p-1)n) + s_p(n) - s_p(pn) = s_p(m) - 1 + (p-1)*v_p(m) ???
print("\n  Digit sum identity check:")
print("  Is (s_p(n)+s_p((p-1)n)-s_p(pn))/(p-1) = (s_p(m)-1)/(p-1) + v_p(m) ?")
for p in [2, 3, 5]:
    q = p
    all_ok = True
    for n in range(1, 30):
        m = (q-1)*n + 1
        lhs = v_p_binom_kummer(q*n, n, p)
        rhs = (s_p(m, p) - 1) // (p-1) + v_p(m, p)
        if lhs != rhs:
            print(f"    FAIL p={p} n={n} lhs={lhs} rhs={rhs}")
            all_ok = False
    if all_ok:
        print(f"  p={p}: all n=1..29 PASS")

# For general q=p^k, similar but more involved
print("\n  General q=p^k case:")
for p, k in [(2, 2), (2, 3), (3, 2)]:
    q = p**k
    all_ok = True
    for n in range(1, 20):
        m = (q-1)*n + 1
        # C_n^{(q)} = binom(qn,n)/m
        # v_p(C) = v_p(binom(qn,n)) - v_p(m)  -- but binom may not capture full story
        # Actually C = binom(qn,n)/m so v_p(C) = v_p(binom) - v_p(m) always
        vp_binom = v_p(comb(q*n, n), p)
        vp_m = v_p(m, p)
        vp_C = vp_binom - vp_m
        actual_vp = v_p(fuss_catalan(n, q), p)
        predicted = (s_p(m, p) - 1) // (p-1)
        if vp_C != actual_vp:
            print(f"    FAIL structure p={p} k={k} n={n}: vp_binom-vp_m={vp_C} actual={actual_vp}")
            all_ok = False
        if actual_vp != predicted:
            print(f"    FAIL formula p={p} k={k} n={n}: actual={actual_vp} predicted={predicted}")
            all_ok = False
    if all_ok:
        print(f"  p={p} k={k} (q={q}): all n=1..19 PASS")

print()
print("=" * 60)
print("ALL CHECKS COMPLETE")
print("=" * 60)
