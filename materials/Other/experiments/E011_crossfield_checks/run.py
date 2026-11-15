# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
E011 -- exact statements behind the cross-field readings (notes/2026-11-14_crossfield_analogies.md).

Notation: p prime, q = p^k, m = (q-1)n+1 leaves, N = (m-1)/(p-1) = number of p-ary nodes,
nu = (m - s_p(m))/(p-1) = v_p(m!), t = N - nu = (s_p(m)-1)/(p-1).

  A. "Dwork form":  C * m! = (-p)^N  (mod p^(N+1)).   With pi^(p-1) = -p this reads
     C = pi^(m-1)/m! * (unit = 1 mod p): the Fuss-Catalan numbers have, term by term, the valuation
     and leading residue of the Taylor coefficients of exp(pi x)/pi.
  B. Counter / heap:  the number of carries made while counting 0, 1, ..., m in base p is nu;
     summing the leaf counts up ANY p-ary tree with m leaves also makes exactly nu carries.
  C. Symmetric nodes:  for every rotation class, (number of symmetric nodes) <= nu, with equality
     exactly for the classes of minimal d; i.e. the symmetry group of a tree has order at most the
     order of a Sylow p-subgroup of S_m, with equality exactly for the minimal classes.
     (Brute force over all classes, via E000's Orbits; a symmetric node = a p-ary node whose p
     subtrees are equivalent, so #symmetric = N - d.)
  D. Partition function Z_m(y) = sum over classes of y^d : printed for a few m (Z_m(p) = C).
  E. Example tables: ternary trees / alkyl radicals (p = 3) and knockout brackets (p = 2).
"""
import importlib.util
import os
import random
import sys
from math import comb, factorial

HERE = os.path.dirname(os.path.abspath(__file__))


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


def sp(m, p):
    return sum(digits(m, p))


def vp(x, p):
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def fuss(q, n):
    return comb(q * n, n) // ((q - 1) * n + 1)


def carries_in_sum(parts, p):
    """Number of carries when adding the numbers in `parts` in base p (each carry lowers the
    digit sum by p-1)."""
    return (sum(sp(x, p) for x in parts) - sp(sum(parts), p)) // (p - 1)


def random_tree_carries(m, p, rng):
    """Split m leaves at random into a p-ary tree; return the total number of carries made when
    the leaf counts are added up node by node."""
    if m == 1:
        return 0
    # m = 1 (mod p-1); choose p positive parts, each = 1 (mod p-1), summing to m
    units = (m - p) // (p - 1)
    cut = sorted(rng.randint(0, units) for _ in range(p - 1))
    sizes = [b - a for a, b in zip([0] + cut, cut + [units])]
    parts = [1 + (p - 1) * u for u in sizes]
    return carries_in_sum(parts, p) + sum(random_tree_carries(x, p, rng) for x in parts)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    ok = True

    # A ---------------------------------------------------------------------------------------
    nA = 0
    for p, k, nmax in [(2, 1, 150), (2, 2, 60), (2, 3, 30), (2, 4, 16), (3, 1, 100), (3, 2, 30),
                       (3, 3, 10), (5, 1, 60), (5, 2, 12), (7, 1, 40), (11, 1, 25), (13, 1, 20)]:
        q = p ** k
        for n in range(nmax + 1):
            m = (q - 1) * n + 1
            N = (m - 1) // (p - 1)
            C = fuss(q, n)
            nA += 1
            good = (C * factorial(m) - (-p) ** N) % p ** (N + 1) == 0
            good &= vp(C, p) == N - vp(factorial(m), p)        # v_p(C) = v_p(pi^(m-1)/m!)
            ok &= good
    print(f"A. C*m! = (-p)^N mod p^(N+1): {nA} cases, {'ok' if ok else 'FAIL'}")

    # B ---------------------------------------------------------------------------------------
    rng = random.Random(137)
    okB = True
    nB = 0
    for p in (2, 3, 5, 7):
        for m in range(1, 400):
            nu = (m - sp(m, p)) // (p - 1)
            count_up = sum(vp(i, p) for i in range(1, m + 1))     # carries when counting to m
            okB &= count_up == nu == vp(factorial(m), p)
            if (m - 1) % (p - 1) == 0:
                for _ in range(5):
                    nB += 1
                    okB &= random_tree_carries(m, p, rng) == nu
    ok &= okB
    print(f"B. carries while counting to m = carries along any tree = v_p(m!): "
          f"{nB} random trees, {'ok' if okB else 'FAIL'}")

    # C ---------------------------------------------------------------------------------------
    spec = importlib.util.spec_from_file_location(
        "e000", os.path.join(HERE, "..", "E000_first_sanity_check", "check.py"))
    e000 = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(e000)
    okC = True
    nC = 0
    zpolys = {}
    for p, k, nmax in [(2, 1, 11), (3, 1, 7), (5, 1, 4), (2, 2, 5), (3, 2, 3), (2, 3, 3)]:
        q = p ** k
        orb = e000.Orbits(p, k)
        for n in range(nmax + 1):
            m = (q - 1) * n + 1
            N = (m - 1) // (p - 1)
            nu = vp(factorial(m), p)
            hist = {}
            for oid, cnt in orb.build(n).items():
                d = orb.d[oid]
                nC += 1
                sym = N - d
                okC &= cnt == p ** d and sym <= nu
                hist[d] = hist.get(d, 0) + 1
            okC &= max(N - d for d in hist) == nu          # some class reaches the Sylow bound
            zpolys[(p, k, n)] = hist
    ok &= okC
    print(f"C. #symmetric nodes <= v_p(m!), with equality attained: {nC} classes, "
          f"{'ok' if okC else 'FAIL'}")

    # D ---------------------------------------------------------------------------------------
    print("\nD. Partition functions Z_m(y) = sum over classes of y^d  (value at y = p is C):")
    for key in [(2, 1, 4), (2, 1, 6), (2, 1, 7), (3, 1, 3), (3, 1, 4), (3, 1, 5), (2, 2, 3)]:
        p, k, n = key
        q = p ** k
        hist = zpolys[key]
        poly = " + ".join((f"{c}" if c > 1 else "") + (f"y^{d}" if d else "1")
                          for d, c in sorted(hist.items()))
        val = sum(c * p ** d for d, c in hist.items())
        ok &= val == fuss(q, n)
        print(f"   p={p} q={q} n={n} m={(q-1)*n+1}: Z = {poly};  Z({p}) = {val}")

    # E ---------------------------------------------------------------------------------------
    print("\nE1. Ternary trees with n nodes (alkyl radicals C_nH_(2n+1), m = 2n+1 hydrogens):")
    print(f"   {'n':>3} {'m':>3} {'m in base 3':>11} {'trees':>12} {'v_3':>4} "
          f"{'largest symmetry group 3^(n-v_3)':>32} {'= 3^v_3(m!)':>11}")
    for n in range(1, 15):
        m = 2 * n + 1
        C = fuss(3, n)
        v = vp(C, 3)
        ok &= n - v == vp(factorial(m), 3) and v == (sp(m, 3) - 1) // 2
        print(f"   {n:>3} {m:>3} {''.join(map(str, reversed(digits(m, 3)))):>11} {C:>12} {v:>4} "
              f"{3 ** (n - v):>32} {'yes' if n - v == vp(factorial(m), 3) else 'NO':>11}")

    print("\nE2. Knockout brackets with m entrants (binary trees; v_2 of the Catalan number C_(m-1)):")
    print(f"   {'m':>4} {'binary':>10} {'unfair matches at least':>24} {'v_2(Catalan)':>13}")
    for m in (8, 12, 16, 24, 32, 48, 64, 68, 96, 100, 128):
        v = vp(fuss(2, m - 1), 2)
        ok &= v == sp(m, 2) - 1
        print(f"   {m:>4} {bin(m)[2:]:>10} {sp(m, 2) - 1:>24} {v:>13}")

    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")
