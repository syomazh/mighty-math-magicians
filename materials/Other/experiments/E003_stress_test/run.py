# Written by Claude Fable 5.2 (orchestrator), 2026-11-13 ~23:45 PT. Replaces a partial script by a
# Kimi worker that was stopped to save Open Math OS budget. Not human-reviewed.
"""
E003 -- large-scale stress test with a class-counting generating function.

Setting. p prime, q = p^k. Trees are p-ary; a q-ary tree is a p-ary tree all of whose leaves
have depth = 0 (mod k). Rotation classes; d = number of asymmetric nodes; a class with d
asymmetric nodes contains p^d trees (claim C1, taken as the definition of the weight here).

For delta in Z/k let F_delta(x, y) = sum over rotation classes of p-ary trees whose root is at
depth delta and whose leaves are all at depth = 0 (mod k) of x^(#leaves) y^(d). Then

    F_delta = [delta = 0] x + F_{delta+1}(x^p, y^p) + y (F_{delta+1}^p - F_{delta+1}(x^p, y^p)) / p.

(leaf / symmetric root = constant cyclic word / asymmetric root = non-constant cyclic word.)

No truncation in y: the full polynomial in y is kept for every coefficient, packed into one
Python integer (Kronecker substitution), so nothing about the claims is assumed.

Checks for every m <= M:
  (a) [x^m] F_0(x, p) = binom(qn, n)/((q-1)n+1) if m = (q-1)n+1, and 0 otherwise.
      (This tests the recursion AND "class size = p^d" against the true tree counts.)
  (b) min d = t = (s_p(m)-1)/(p-1)                                   (claims C2, C6)
  (c) N_min != 0 and N_min = (-1)^t / prod m_j!  (mod p)             (claim C7)
  (d) for k = 1: N_min = (pt)! / (t! p^t prod m_j!)                  (claim C8)
  (e) agreement with experiments/E000 on #classes and N_min for small n (printed).
"""
import csv
import sys
import time
from math import comb, factorial, prod


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


def run_case(p, k, M, tlimit):
    q = p ** k
    nmax = (M - 1) // (p - 1)
    B = p * (nmax + 2) + 32          # bits per y-coefficient; safe upper bound on all counts
    mask = (1 << B) - 1
    F = [[0] * (M + 1) for _ in range(k)]
    P = [[[0] * (M + 1) for _ in range(p + 1)] for _ in range(k)]   # P[delta][j][m]: j-fold product

    def unpack(X):
        out = []
        while X:
            out.append(X & mask)
            X >>= B
        return out

    def frob(X):                      # y -> y^p on a packed polynomial
        r = 0
        for d, c in enumerate(unpack(X)):
            if c:
                r |= c << (B * p * d)
        return r

    t0 = time.time()
    reached = 0
    for m in range(1, M + 1):
        if time.time() - t0 > tlimit:
            break
        for delta in range(k):
            Fd, Pd = F[delta], P[delta]
            for j in range(2, p + 1):
                if (m - j) % (p - 1):
                    continue          # a sum of j leaf counts is = j (mod p-1)
                s = 0
                prev = Pd[j - 1]
                for a in range(1, m - (j - 1) + 1, p - 1):
                    fa = Fd[a]
                    if fa:
                        pb = prev[m - a]
                        if pb:
                            s += fa * pb
                Pd[j][m] = s
        new = [0] * k
        if (m - 1) % (p - 1) == 0:
            for delta in range(k):
                src = (delta + 1) % k
                val = 1 if (delta == 0 and m == 1) else 0
                sym = frob(F[src][m // p]) if m % p == 0 else 0
                asym = P[src][p][m] - sym
                assert asym >= 0, ("negative asymmetric part", p, k, m, delta)
                quo, rem = divmod(asym, p)
                assert rem == 0, ("asymmetric part not divisible by p", p, k, m, delta)
                new[delta] = val + sym + (quo << B)
        for delta in range(k):
            F[delta][m] = new[delta]
            P[delta][1][m] = new[delta]
        reached = m

    # ---- checks -------------------------------------------------------------------------
    fails = {"a": 0, "b": 0, "c": 0, "d": 0}
    tested = 0
    rows = []
    classes_seq, nmin_seq = [], []
    first_fail = None
    for m in range(1, reached + 1):
        poly = unpack(F[0][m])
        total = sum(c * p ** d for d, c in enumerate(poly))
        if (m - 1) % (q - 1) if q > 2 else False:
            if total != 0:
                fails["a"] += 1
                first_fail = first_fail or ("a: nonzero at inadmissible m", m)
            continue
        n = (m - 1) // (q - 1)
        tested += 1
        C = comb(q * n, n) // ((q - 1) * n + 1)
        if total != C:
            fails["a"] += 1
            first_fail = first_fail or ("a: total != Fuss-Catalan", m, total, C)
        dg = digits(m, p)
        t = (sum(dg) - 1) // (p - 1)
        dmin = next(d for d, c in enumerate(poly) if c)
        nmin = poly[dmin]
        if dmin != t:
            fails["b"] += 1
            first_fail = first_fail or ("b: min d != t", m, dmin, t)
        fact = prod(factorial(x) for x in dg)
        pred = ((-1) ** t * pow(fact, -1, p)) % p
        if nmin % p == 0 or nmin % p != pred:
            fails["c"] += 1
            first_fail = first_fail or ("c: residue", m, nmin % p, pred)
        if k == 1:
            exact = factorial(p * t) // (factorial(t) * p ** t * fact)
            if nmin != exact:
                fails["d"] += 1
                first_fail = first_fail or ("d: exact count", m, nmin, exact)
        n1 = poly[dmin + 1] if len(poly) > dmin + 1 else 0
        n2 = poly[dmin + 2] if len(poly) > dmin + 2 else 0
        rows.append((p, k, n, m, t, nmin % p, n1 % p, n2 % p, sum(poly)))
        if n >= 1 and len(classes_seq) < 12:
            classes_seq.append(sum(poly))
            nmin_seq.append(nmin)
    return dict(p=p, k=k, q=q, M=M, reached=reached, tested=tested, fails=fails,
                first_fail=first_fail, classes=classes_seq, nmin=nmin_seq,
                seconds=time.time() - t0), rows


if __name__ == "__main__":
    cases = [  # (p, k, M, time limit in seconds for the recursion)
        (2, 1, 400, 150), (3, 1, 401, 120), (5, 1, 401, 90), (7, 1, 403, 90),
        (11, 1, 401, 60), (13, 1, 409, 60),
        (2, 2, 301, 150), (3, 2, 305, 120), (5, 2, 313, 90),
        (2, 3, 302, 150), (3, 3, 313, 120), (2, 4, 301, 150),
    ]
    all_rows = []
    print(f"{'p':>3} {'k':>2} {'q':>4} {'M reached':>9} {'m tested':>8} {'fail a':>6} {'fail b':>6} "
          f"{'fail c':>6} {'fail d':>6} {'sec':>6}")
    ok = True
    for p, k, M, tl in cases:
        res, rows = run_case(p, k, M, tl)
        all_rows += rows
        f = res["fails"]
        ok &= not any(f.values())
        print(f"{p:>3} {k:>2} {res['q']:>4} {res['reached']:>9} {res['tested']:>8} {f['a']:>6} {f['b']:>6} "
              f"{f['c']:>6} {f['d']:>6} {res['seconds']:>6.0f}")
        print(f"      classes by n>=1: {res['classes']}")
        print(f"      N_min   by n>=1: {res['nmin']}")
        if res["first_fail"]:
            print(f"      FIRST FAILURE: {res['first_fail']}")
        sys.stdout.flush()
    with open(__file__.replace("run.py", "data.csv"), "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["p", "k", "n", "m", "t", "Nmin_mod_p", "N_t+1_mod_p", "N_t+2_mod_p", "classes"])
        w.writerows(all_rows)
    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")
