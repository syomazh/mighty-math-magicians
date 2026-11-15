# Written by mistralai/mistral-large-4-0 (worker W018, blind proof search) on 2026-11-13.
"""Strategy 2: group actions on q-ary trees.

2a. The full automorphism group G_n of the complete q-ary tree of depth n acts
    on the set of q-ary trees with n nodes. Orbit size of T = |G_n| / |Stab(T)|,
    computed recursively. We check for q = p^k:
      - every orbit size is divisible by p^xi, xi = (s_p(m)-1)/(p-1);
      - the number of orbits of minimal size p^xi is prime to p
        (which would give EXACTNESS: v_p(|T_n|) = xi).

2b. The small p-group C_p acting at every node (cyclically rotating each block
    of p sibling slots): orbit sizes are 1 or p; we check |T_n| = Fix_n mod p
    and that the fixed-tree GF satisfies F = x(1+F^p)^{q/p}.
"""
from collections import Counter
from common import (v_p, s_p, fuss_catalan, trees, canon, aut_complete, stab,
                  orbit_size)


def part_a():
    print("=== 2a: full automorphism group of the complete q-ary tree ===")
    for (p, k) in [(2, 1), (2, 2), (3, 1), (3, 2), (5, 1), (2, 3)]:
        q = p ** k
        n_max = { (2,1): 8, (2,2): 5, (2,3): 4, (3,1): 5, (3,2): 4, (5,1): 4 }[(p, k)]
        for n in range(1, n_max + 1):
            m = (q - 1) * n + 1
            xi = (s_p(m, p) - 1) // (p - 1)
            all_trees = trees(n, q)
            assert len(all_trees) == fuss_catalan(n, q)
            orbit_sizes = Counter()
            for t in all_trees:
                orbit_sizes[orbit_size(t, n, q)] += 1
            min_size = min(orbit_sizes)
            min_v = v_p(min_size, p)
            all_div = all(v_p(sz, p) >= xi for sz in orbit_sizes)
            # number of orbits of minimal size = (#trees with that orbit size)/size
            n_min_orbits = orbit_sizes[min_size] // min_size
            count_prime_to_p = (n_min_orbits % p != 0)
            exact_from_orbits = (min_v == xi) and count_prime_to_p
            print(f"p={p} k={k} q={q} n={n} m={m} xi={xi}: #trees={len(all_trees)}, "
                  f"distinct orbit sizes={sorted(set(v_p(s,p) for s in orbit_sizes))}, "
                  f"min orbit p-valuation={min_v}, all sizes divisible by p^{xi}: {all_div}, "
                  f"#minimal orbits={n_min_orbits} (mod p = {n_min_orbits % p}), "
                  f"=> exactness from orbit count: {exact_from_orbits}")


def part_b():
    print("=== 2b: C_p acting at every node (rotate within blocks of p siblings) ===")
    for (p, k) in [(2, 1), (2, 2), (3, 1), (3, 2), (5, 1)]:
        q = p ** k
        for n in range(1, 13):
            all_trees = trees(n, q)
            # apply sigma: at every node, cyclically shift slots within each
            # consecutive block of p slots
            def sigma(t):
                if t is None:
                    return None
                ch = list(t)
                out = [None] * q
                for start in range(0, q, p):
                    block = ch[start:start + p]
                    for j in range(p):
                        out[start + (j + 1) % p] = sigma(block[j])
                return tuple(out)
            fixed = [t for t in all_trees if sigma(t) == t]
            # orbit sizes: 1 for fixed, else p
            sizes = Counter()
            for t in all_trees:
                o = t
                sz = 1
                while True:
                    o = sigma(o)
                    if o == t:
                        break
                    sz += 1
                sizes[sz] += 1
            ok_cong = (len(all_trees) - len(fixed)) % p == 0
            # fixed-tree GF check: F = x(1+F^p)^{q/p}; compute F coefficients by iteration
            N = n
            F = [0] * (N + 1)
            F[1] = 1
            mod = 10**9 + 7  # exact enough for these sizes? use exact big ints instead
            # exact iteration:
            F = [0] * (N + 1)
            F[1] = 1
            while True:
                # G = (1 + F^p)^{q//p}; newF = x*G
                Fp = [0] * (N + 1)
                # F^p exact
                acc = [0] * (N + 1)
                acc[0] = 1
                e = p
                base = F[:]
                while e:
                    if e & 1:
                        acc = polymul(acc, base, N)
                    e >>= 1
                    if e:
                        base = polymul(base, base, N)
                one_plus = [(1 if i == 0 else 0) + Fp_dummy for i, Fp_dummy in enumerate(acc)]
                # (1+F^p)^{q//p}
                G = [0] * (N + 1)
                G[0] = 1
                e = q // p
                base = one_plus
                while e:
                    if e & 1:
                        G = polymul(G, base, N)
                    e >>= 1
                    if e:
                        base = polymul(base, base, N)
                newF = [0] * (N + 1)
                for i in range(1, N + 1):
                    newF[i] = G[i - 1]
                if newF == F:
                    break
                F = newF
            fix_from_gf = F[n]
            print(f"p={p} q={q} n={n}: |T_n|={len(all_trees)}, Fix={len(fixed)}, "
                  f"orbit sizes={dict(sizes)}, |T|-Fix divisible by p: {ok_cong}, "
                  f"Fix from GF F=x(1+F^p)^(q/p): {fix_from_gf} (match: {fix_from_gf == len(fixed)})")


def polymul(A, B, N):
    C = [0] * (N + 1)
    for i, a in enumerate(A):
        if a:
            for j, b in enumerate(B):
                if b and i + j <= N:
                    C[i + j] += a * b
    return C


if __name__ == "__main__":
    part_a()
    part_b()
