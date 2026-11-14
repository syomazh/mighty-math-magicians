# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Prints small cases so a human can eyeball them, and checks that the tests in t1 "have teeth"
# (i.e. that slightly wrong variants of the statements DO fail).
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t0_sanity_print.py
from fz_lib import compute_F, compute_G, sp, digits, cfpow

for (p, k, N) in [(2, 1, 12), (3, 1, 13), (2, 2, 16)]:
    F = compute_F(p, k, N)
    print(f"p={p} k={k}")
    for d in range(k):
        s = []
        for m in range(1, N + 1):
            if F[d][m]:
                s.append(f"x^{m}*{F[d][m]}")
        print(f"   F_{d} = ", " + ".join(s), "   (lists = y-polynomial, lowest degree first)")
    print("   G    = ", compute_G(p ** k, N))

# teeth 1: the bound "weight >= 0" must fail, and weight -1 must be attained at every m with
# s_p(m) = 1 mod (p-1) for delta s.t. ... (informational: for which (delta,m) is ell != 0 ?)
for (p, k, N) in [(2, 1, 64), (2, 2, 64), (3, 1, 81), (3, 2, 81), (2, 3, 64)]:
    F = compute_F(p, k, N)
    q = p ** k
    zero_ell = {d: [] for d in range(k)}
    for d in range(k):
        for m in range(1, N + 1):
            s = sp(m, p)
            if (s - 1) % (p - 1) == 0:
                dd = (s - 1) // (p - 1)
                c = F[d][m][dd] if dd < len(F[d][m]) else 0
                if c == 0:
                    zero_ell[d].append(m)
    # for which residues of m mod q-1 does F_d have support at all?
    supp = {d: sorted({m % (q - 1) if q > 2 else 0 for m in range(1, N + 1) if F[d][m]}) for d in range(k)}
    print(f"p={p} k={k}: support of F_d in m mod (q-1): {supp}")
    for d in range(k):
        # ell_d(m) != 0 expected exactly when m = p^(-d) mod (q-1)
        bad = [m for m in range(1, N + 1)
               if (sp(m, p) - 1) % (p - 1) == 0
               and ((m - pow(p, (-d) % k, q - 1 if q > 2 else 1)) % (q - 1 if q > 2 else 1) == 0) != (m not in zero_ell[d])]
        print(f"    delta={d}: m where [ell_d(m)!=0] differs from [m = p^(-d) mod (q-1)]: {bad[:10]}")

# teeth 2: wrong leading-part recursions must fail
p, k, N = 3, 2, 81
F = compute_F(p, k, N)
ell = []
for d in range(k):
    row = [0] * (N + 1)
    for m in range(1, N + 1):
        s = sp(m, p)
        if (s - 1) % (p - 1) == 0:
            dd = (s - 1) // (p - 1)
            row[m] = F[d][m][dd] if dd < len(F[d][m]) else 0
    ell.append(row)
# wrong variant: ell_d = alpha_d + (1/p) ell_d^{cf p}  (same index instead of delta+1)
viol = 0
for d in range(k):
    pwr = cfpow(ell[d], p, N, p)
    for m in range(N + 1):
        ds = digits(m, p)
        alpha = 1 if (m >= 1 and sum(ds) == 1 and (len(ds) - 1 + d) % k == 0) else 0
        if ell[d][m] * p != alpha * p + pwr[m]:
            viol += 1
print("teeth: wrong-index variant of lead(ii) violated at", viol, "places (should be > 0)")
# wrong variant: ordinary (not carry-free) product
viol = 0
for d in range(k):
    e = (d + 1) % k
    f = ell[e]
    # ordinary Cauchy p-th power
    h = [1] + [0] * N
    for _ in range(p):
        h2 = [0] * (N + 1)
        for a in range(N + 1):
            if h[a]:
                for b in range(N + 1 - a):
                    if f[b]:
                        h2[a + b] += h[a] * f[b]
        h = h2
    for m in range(N + 1):
        ds = digits(m, p)
        alpha = 1 if (m >= 1 and sum(ds) == 1 and (len(ds) - 1 + d) % k == 0) else 0
        if ell[d][m] * p != alpha * p + h[m]:
            viol += 1
print("teeth: ordinary-product variant of lead(ii) violated at", viol, "places (should be > 0)")
