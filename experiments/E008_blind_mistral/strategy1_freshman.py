# Written by mistralai/mistral-large-4-0 (worker W018, blind proof search) on 2026-11-13.
"""Strategy 1: the functional equation T = x(1+T)^q in F_p[[x]] and its
'freshman's dream' reduction T = x + x T^q.

Checks, all mod p (and mod p^j for the valuation layers):
  (a) iterating T <- x(1+T)^q mod p^j starting from T=x converges to the
      unique series solution of T = x(1+T)^q mod p^j;
  (b) mod p the solution equals S = sum_{j>=0} x^{e_j}, e_j = (q^{j+1}-1)/(q-1),
      i.e. C_n^(q) =/= 0 mod p  <=>  m = q^{j+1}  <=>  s_p(m) = 1;
  (c) coefficient-wise valuations of the exact series match (s_p(m)-1)/(p-1).
"""
from common import v_p, s_p, fuss_catalan


def series_T(N, q, mod):
    """Coefficients of T = x(1+T)^q modulo `mod`, up to degree N, by iteration."""
    T = [0] * (N + 1)
    T[1] = 1 % mod
    while True:
        # compute x*(1+T)^q mod `mod`
        # (1+T)^q via repeated multiplication, truncating at N
        U = [0] * (N + 1)
        U[0] = 1
        base = [(1 + T[i]) % mod for i in range(N + 1)]
        # U = base^q
        result = [0] * (N + 1)
        result[0] = 1
        e = q
        b = base[:]
        while e:
            if e & 1:
                result = poly_mul(result, b, N, mod)
            e >>= 1
            if e:
                b = poly_mul(b, b, N, mod)
        newT = [0] * (N + 1)
        for i in range(1, N + 1):
            newT[i] = result[i - 1] % mod
        if newT == T:
            return T
        T = newT


def poly_mul(A, B, N, mod):
    C = [0] * (N + 1)
    for i, a in enumerate(A):
        if a:
            for j, b in enumerate(B):
                if b and i + j <= N:
                    C[i + j] = (C[i + j] + a * b) % mod
    return C


def run():
    N = 120
    for p in (2, 3, 5):
        for k in (1, 2):
            q = p ** k
            # (b) mod p: compare with S = sum x^{e_j}
            T1 = series_T(N, q, p)
            S = [0] * (N + 1)
            e = 1
            while e <= N:
                S[e] = 1
                e = q * e + 1
            ok_b = all(T1[n] == S[n] % p for n in range(1, N + 1))
            # and T1 satisfies T = x + x T^q mod p
            Tq = [0] * (N + 1)
            Tq[0] = 1
            e = q
            b = T1[:]
            while e:
                if e & 1:
                    Tq = poly_mul(Tq, b, N, p)
                e >>= 1
                if e:
                    b = poly_mul(b, b, N, p)
            lhs = [0] * (N + 1)
            for i in range(1, N + 1):
                lhs[i] = Tq[i - 1] % p
            lhs[1] = (lhs[1] + 1) % p  # + x
            ok_eq = all(lhs[n] == T1[n] for n in range(1, N + 1))
            # (c) valuations of exact coefficients vs digit-sum formula
            max_xi = 0
            for n in range(1, N + 1):
                m = (q - 1) * n + 1
                xi = (s_p(m, p) - 1) // (p - 1)
                max_xi = max(max_xi, xi)
            mod = p ** (max_xi + 1)
            Tj = series_T(N, q, mod)
            ok_c = True
            for n in range(1, N + 1):
                m = (q - 1) * n + 1
                xi = (s_p(m, p) - 1) // (p - 1)
                c_mod = Tj[n]  # C_n mod p^{xi+1}... we built mod p^{max+1}
                c_exact = fuss_catalan(n, q)
                if c_mod != c_exact % mod:
                    ok_c = False
                    print(f"  series mismatch p={p} q={q} n={n}")
                if v_p(c_exact, p) != xi:
                    ok_c = False
                    print(f"  valuation mismatch p={p} q={q} n={n}")
            # (b') nonvanishing pattern from the formula side
            ok_pattern = True
            for n in range(1, N + 1):
                m = (q - 1) * n + 1
                nonzero = (s_p(m, p) == 1)
                if (T1[n] != 0) != nonzero:
                    ok_pattern = False
                    print(f"  pattern mismatch p={p} q={q} n={n} m={m}")
            print(f"p={p} k={k} q={q}: T==x+xT^q mod p: {ok_eq}; "
                  f"T==sum x^e_j mod p: {ok_b}; nonzero<=>s_p(m)=1: {ok_pattern}; "
                  f"exact valuation check (mod p^{max_xi+1}, max_xi={max_xi}): {ok_c}")


if __name__ == "__main__":
    run()
