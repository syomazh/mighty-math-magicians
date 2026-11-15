# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Independent re-implementation, from the definitions in paper/frobenius_proof.tex only.
# Standard library only. Not human-verified.
"""Shared helpers for the referee's checks of frobenius_proof.tex."""
from fractions import Fraction
from math import comb, factorial


# ---------------------------------------------------------------- digits
def digits(m, p):
    ds = []
    while m > 0:
        ds.append(m % p)
        m //= p
    return ds


def sp(m, p):
    return sum(digits(m, p))


def carry_free(nums, p):
    """Literal definition of (E1): in every position the digits add up to <= p-1."""
    nums = list(nums)
    while any(nums):
        if sum(n % p for n in nums) > p - 1:
            return False
        nums = [n // p for n in nums]
    return True


# ---------------------------------------------------------------- polynomials in y (lists of ints)
def ptrim(a):
    while a and a[-1] == 0:
        a.pop()
    return a


def padd(a, b):
    if len(a) < len(b):
        a, b = b, a
    r = list(a)
    for i, c in enumerate(b):
        r[i] += c
    return ptrim(r)


def psub(a, b):
    n = max(len(a), len(b))
    r = [0] * n
    for i, c in enumerate(a):
        r[i] += c
    for i, c in enumerate(b):
        r[i] -= c
    return ptrim(r)


def pmul(a, b):
    if not a or not b:
        return []
    r = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    r[i + j] += x * y
    return ptrim(r)


def pphi(a, p):
    """y^d -> y^(p d)."""
    if not a:
        return []
    r = [0] * (p * (len(a) - 1) + 1)
    for d, c in enumerate(a):
        r[p * d] = c
    return r


def peval(a, v):
    return sum(c * v ** d for d, c in enumerate(a))


# ---------------------------------------------------------------- series in x with y-poly coefficients
def smul(A, B, N):
    R = [[] for _ in range(N + 1)]
    for i, a in enumerate(A):
        if not a:
            continue
        for j in range(0, N - i + 1):
            b = B[j]
            if b:
                R[i + j] = padd(R[i + j], pmul(a, b))
    return R


def spow(A, e, N):
    R = [[] for _ in range(N + 1)]
    R[0] = [1]
    for _ in range(e):
        R = smul(R, A, N)
    return R


def sphi(A, p, N):
    R = [[] for _ in range(N + 1)]
    for m, a in enumerate(A):
        if a and m * p <= N:
            R[m * p] = pphi(a, p)
    return R


def compute_F(p, k, N):
    """F[delta][m] = coefficient of x^m in F_delta as a y-polynomial (list), 0<=m<=N.

    Degree-by-degree recursion from eq. (system):
        F_d = [d=0] x + phi(F_{d+1}) + y * (F_{d+1}^p - phi(F_{d+1})) / p,
    theta being computed LITERALLY as (f^p - phi(f))/p with an exact-division assertion.
    """
    F = [[[] for _ in range(N + 1)] for _ in range(k)]
    pw = [[[[] for _ in range(N + 1)] for _ in range(p + 1)] for _ in range(k)]
    for m in range(1, N + 1):
        for d in range(k):
            for j in range(2, p + 1):
                acc = []
                prev = pw[d][j - 1]
                Fd = F[d]
                for i in range(1, m - j + 2):
                    a = Fd[i]
                    if a:
                        b = prev[m - i]
                        if b:
                            acc = padd(acc, pmul(a, b))
                pw[d][j][m] = acc
        new = []
        for d in range(k):
            e = (d + 1) % k
            ph = pphi(F[e][m // p], p) if m % p == 0 else []
            diff = psub(pw[e][p][m], ph)
            if any(c % p for c in diff):
                raise AssertionError(f"theta not integral: p={p} k={k} m={m} delta={d}")
            th = [c // p for c in diff]
            val = padd(ph, [0] + th if th else [])
            if d == 0 and m == 1:
                val = padd(val, [1])
            new.append(val)
        for d in range(k):
            F[d][m] = new[d]
            pw[d][1][m] = new[d]
    return F


def compute_G(q, N):
    """G = x + G^q, integer coefficients, by the literal recursion (no closed formula)."""
    G = [0] * (N + 1)
    pw = [[0] * (N + 1) for _ in range(q + 1)]
    for m in range(1, N + 1):
        for j in range(2, q + 1):
            if m < j:
                continue
            acc = 0
            prev = pw[j - 1]
            for i in range(1, m - j + 2):
                a = G[i]
                if a:
                    b = prev[m - i]
                    if b:
                        acc += a * b
            pw[j][m] = acc
        G[m] = (1 if m == 1 else 0) + pw[q][m]
        pw[1][m] = G[m]
    return G


def fuss_catalan(q, n):
    num = comb(q * n, n)
    den = (q - 1) * n + 1
    assert num % den == 0
    return num // den


# ---------------------------------------------------------------- carry-free algebra A (functions on 0..N)
def cfprod(f, g, N, p):
    h = [0] * (N + 1)
    for a in range(N + 1):
        fa = f[a]
        if fa == 0:
            continue
        for b in range(N + 1 - a):
            gb = g[b]
            if gb != 0 and carry_free((a, b), p):
                h[a + b] += fa * gb
    return h


def cfpow(f, r, N, p):
    h = [0] * (N + 1)
    h[0] = 1
    for _ in range(r):
        h = cfprod(h, f, N, p)
    return h


# ---------------------------------------------------------------- power series in k variables (dict tuple -> Fraction)
def mmul(A, B, D):
    R = {}
    for a, x in A.items():
        da = sum(a)
        for b, y in B.items():
            if da + sum(b) > D:
                continue
            c = tuple(i + j for i, j in zip(a, b))
            R[c] = R.get(c, 0) + x * y
    return {c: v for c, v in R.items() if v != 0}


def mpow(A, e, D, k):
    R = {tuple([0] * k): Fraction(1)}
    for _ in range(e):
        R = mmul(R, A, D)
    return R


def madd(A, B):
    R = dict(A)
    for c, v in B.items():
        R[c] = R.get(c, 0) + v
    return {c: v for c, v in R.items() if v != 0}


def mscale(A, s):
    return {c: v * s for c, v in A.items() if v * s != 0}


def mderiv(A, c, k, times=1):
    R = A
    for _ in range(times):
        S = {}
        for a, v in R.items():
            if a[c] > 0:
                b = list(a)
                b[c] -= 1
                S[tuple(b)] = v * a[c]
        R = S
    return R


def afact(a):
    r = 1
    for x in a:
        r *= factorial(x)
    return r


def unit(c, k):
    e = [0] * k
    e[c % k] = 1
    return tuple(e)


def compute_H(p, k, D):
    """H[delta] as dict exponent-tuple -> Fraction, truncated at total degree D.

    Fixed-point iteration of H_d = z_{-d} + H_{d+1}^p / p; iteration r is exact up to
    degree 1 + r(p-1), so the working truncation grows with r.
    """
    H = [{unit(-d, k): Fraction(1)} for d in range(k)]
    r = 0
    while True:
        r += 1
        Dr = min(D, 1 + r * (p - 1))
        new = []
        for d in range(k):
            P = mpow(H[(d + 1) % k], p, Dr, k)
            new.append(madd({unit(-d, k): Fraction(1)}, mscale(P, Fraction(1, p))))
        done = (Dr == D and new == H)
        H = new
        if done:
            return H


def T_of(Hd, a):
    return Hd.get(tuple(a), Fraction(0)) * afact(a)
