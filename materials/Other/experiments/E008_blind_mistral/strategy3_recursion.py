# Written by mistralai/mistral-large-4-0 (worker W018, blind proof search) on 2026-11-13.
"""Strategy 3: digit-peeling recursions.

We look for recursions that make v_p(C_n^(q)) computable by induction on n
(or on m = (q-1)n+1) without factorial valuations.

H1:  if q | n-1 (n = q a + 1, so m = q m_a):  v_p(C_n^(q)) = v_p(C_a^(q)).
H2:  v_p(C_{q a + 2}^(q)) = v_p(C_a^(q)) + k   (since s_p(m) gains s_p(q-1)=k(p-1)).
G:   generalized family A(b,c) = (c/(qb+c)) binom(qb+c, b); conjecture
     v_p(A(b,c)) = (s_p(qb+c) - s_p(c)) / (p-1)   for c >= 1.
P:   peel one base-p digit of m: n = p b + n_0, m_0 = m mod p,
     n_0 = (1 - m_0) mod p, m' = (m - m_0)/p = q b + c with
     c = 0 if m_0 == 1; c = p^{k-1} if m_0 == 0; else c = q-1-(m_0-1) p^{k-1}.
     Then conjecture v_p(C_n^(q)) = v_p(A(b,c)) + (s_p(c)+m_0-1)/(p-1) (c >= 1).
Also: table of delta = v_p(C_{q a + r}) - v_p(C_a) by r = n mod q.
"""
from common import v_p, s_p, fuss_catalan, fuss_gen


def xi(n, q, p):
    m = (q - 1) * n + 1
    return (s_p(m, p) - 1) // (p - 1)


def run():
    print("=== H1: q | n-1  =>  v_p(C_n) == v_p(C_{(n-1)/q}) ===")
    ok = True
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            for a in range(0, 60):
                n = q * a + 1
                if v_p(fuss_catalan(n, q), p) != v_p(fuss_catalan(a, q), p):
                    ok = False
                    print(f"  H1 FAIL p={p} k={k} a={a}")
    print(f"  H1 holds: {ok}")

    print("=== H2: v_p(C_{q a + 2}) == v_p(C_a) + k ===")
    ok = True
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            for a in range(0, 60):
                n = q * a + 2
                if v_p(fuss_catalan(n, q), p) != v_p(fuss_catalan(a, q), p) + k:
                    ok = False
                    print(f"  H2 FAIL p={p} k={k} a={a}")
    print(f"  H2 holds: {ok}")

    print("=== G: v_p(A(b,c)) == (s_p(qb+c) - s_p(c))/(p-1), c >= 1 ===")
    ok = True
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            for c in range(1, 3 * q + 2):
                for b in range(0, 40):
                    lhs = v_p(fuss_gen(b, c, q), p)
                    rhs_num = s_p(q * b + c, p) - s_p(c, p)
                    assert rhs_num % (p - 1) == 0
                    if lhs != rhs_num // (p - 1):
                        ok = False
                        print(f"  G FAIL p={p} k={k} q={q} b={b} c={c}: {lhs} vs {rhs_num//(p-1)}")
    print(f"  G holds: {ok}")

    print("=== P: peel one base-p digit of m ===")
    ok_id = True
    ok_rec = True
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p ** k
            for n in range(1, 400):
                m = (q - 1) * n + 1
                m0 = m % p
                n0 = (1 - m0) % p
                assert n % p == n0
                b = (n - n0) // p
                if m0 == 1:
                    c = 0
                elif m0 == 0:
                    c = p ** (k - 1)
                else:
                    c = q - 1 - (m0 - 1) * p ** (k - 1)
                mp = (m - m0) // p
                if mp != q * b + c:
                    ok_id = False
                    print(f"  identity FAIL p={p} k={k} n={n}: m'={mp}, qb+c={q*b+c}")
                if c >= 1:
                    corr_num = s_p(c, p) + m0 - 1
                    assert corr_num % (p - 1) == 0, (p, k, n, m0, c)
                    lhs = v_p(fuss_catalan(n, q), p)
                    rhs = v_p(fuss_gen(b, c, q), p) + corr_num // (p - 1)
                    if lhs != rhs:
                        ok_rec = False
                        print(f"  recursion FAIL p={p} k={k} n={n}: {lhs} vs {rhs}")
    print(f"  identity m' = qb + c holds: {ok_id}; recursion v_p(C_n)=v_p(A(b,c))+(s_p(c)+m0-1)/(p-1) holds (c>=1): {ok_rec}")

    print("=== delta table: v_p(C_{qa+r}) - v_p(C_a), r = n mod q ===")
    for (p, k) in [(2, 1), (2, 2), (3, 1), (3, 2), (5, 1)]:
        q = p ** k
        print(f" p={p} k={k} q={q}:")
        for r in range(q):
            deltas = set()
            for a in range(0, 30):
                n = q * a + r
                if n >= 1:
                    deltas.add(v_p(fuss_catalan(n, q), p) - v_p(fuss_catalan(a, q), p))
            print(f"   r={r}: deltas over a: {sorted(deltas)}")


if __name__ == "__main__":
    run()
