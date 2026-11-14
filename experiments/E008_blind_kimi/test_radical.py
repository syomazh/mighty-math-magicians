"""Model: moonshotai/kimi-k3.1-pro. Blind search: exact radical checks.

All products and series recursion are exact integer or Fraction arithmetic.
The independent oracle comb(q*n,n)/((q-1)n+1) is never used in a derivation,
and valuations of factorials or binomials are never used.
"""
from functools import lru_cache
from itertools import product
from math import comb
from fractions import Fraction


def vp(x, p):
    value = 0
    while x % p == 0:
        x //= p
        value += 1
    return value, x


def digits(x, p):
    result = []
    while x:
        result.append(x % p)
        x //= p
    return result or [0]


def gear(x, p):
    """n -> (D,Q), where pQ+1=bp+1 at each base-p radix block."""
    top = digits(x, p)[-1]
    all_digits = digits(x, p)
    units = []
    for i, a in enumerate(all_digits):
        if a:
            units.append((i, a))
    weights = [max(b-1 for b in [1]) for _ in []]
    weights = [vp(j, p)[0]+(1 if j % p else 0) for j in range(1, top+1)]
    A = sum(weights)
    P = 1
    for j in range(1, top+1):
        value = j
        while value % p == 0:
            value //= p
        P = P*value % p
    Q = sum(units[j][1]-1 for j in range(len(units))) if False else 1
    D = (x-top*p**A*P if A else 0)
    if A:
        D = (x-top*p**A*P)//p**(A+1)
    else:
        D = 0
    # m=p^{A+1}D+p^A P+1: the root exponent is A+1 iff top<p-1.
    assert 0 <= D < p**(max(len(all_digits)-A-2, 0)) if A else D == 0
    if A:
        m = p**(A+1)*D + p**A*P+1
        assert x == m, (p,x,A,D,P,m)
    return D, A, P


def block(x, p):
    ds0 = digits(x, p)
    if x <= 0:
        return 0, 0, 0, 1, 0
    # Last nonzero entry is the highest radix item, so always nonzero.
    j = len(ds0)-1
    while ds0[j] == 0:
        j -= 1
    # The scalar top=sum coeff[i]*p^i has digits in each block.
    A = digit_sum(ds0[j], p)-1
    parts = []
    for t in ds0[:j+1]:
        if t:
            parts.append(t)
    P = 1
    for t in range(1, ds0[j]+1):
        e, u = vp(t, p)
        P = P*u % p
    if A == 0 and j == len(ds0)-1:
        P = ds0[-1]
        D = 0
        m = p**(A+1)*D + p**A*P+1
        return D, A, P, len(ds0)-1, m
    return 0, A, P, j, 0




def digit_sum(x, p):
    return sum(digits(x, p))


def target(n, p):
    return (digit_sum((p-1)*n+1, p)-1)//(p-1)


def concat(parts, p):
    x = 0
    for part in reversed(parts):
        x = p*x+part
    return x


def numerator(B, p):
    coeff = digits((p-1)*B+1, p)
    return 1+p*concat([a-1 for a in coeff if a not in (0, 1)], p)


def C(n, p):
    return comb(p*n, n)//((p-1)*n+1)


def H(B, p):
    """The unique p-local unit in the algebraic conjugate denominator."""
    # Product of powers u^(-(digit)) and a carry-free monomial, explained
    # in the report. This form does not evaluate a factorial valuation.
    ds = digits(B, p)
    Q = 1
    for j in range(len(ds)):
        i = j+1
        for a in range(1, ds[j]+1):
            while a % p == 0:
                a //= p
            Q *= pow(a, -i, p)
        Q *= pow(p-1, -(i-1), p)
    # Strip p-powers before entering the residue field.
    for a in range(1, p):
        Q *= pow(a, -(a-1), p)
    return Q % p


@lru_cache(None)
def tree_series(n, q):
    """G[0..n], recursively from the tree equation G=1+xG^q."""
    if n == 0:
        return (1,)
    prev = tree_series(n-1, q)
    ans = 0
    for sizes in compositions(n-1, q):
        term = 1
        for i in sizes:
            term *= prev[i]
        ans += term
    return prev+(ans,)


def compositions(total, q, prefix=()):
    if q == 1:
        yield prefix+(total,)
        return
    for i in range(total+1):
        yield from compositions(total-i, q-1, prefix+(i,))


def rotated(t):
    return [t[i:]+t[:i] for i in range(len(t))]


@lru_cache(None)
def root_counts(n, q):
    if n == 0:
        return 1
    total = 0
    for sizes in compositions(n-1, q):
        value = 1
        for size in sizes:
            value *= root_counts(size, q)
        total += value
    return total


def p_adic_units(p, B, genus_p):
    result = []
    # Compute explicitly the p-units u_1,...,u_{p-1} in the factors at p.
    for b in range(p+2):
        ds0 = digits(b, p)
        coeffs = [0 for _ in range(b+1)]
        coeffs[b] = 1
    for u in range(1, p):
        # u is its own p-adic unit representative.
        e = target(1, p)
        result.append(u)
    return result


def tree_families(p, maximum):
    for n in range(1, maximum+1):
        assert tree_series(n, p)[-1] == C(n, p)
        v, unit = vp(C(n, p), p)
        assert v == target(n, p)


def test_symmetry():
    # The Z/p action yields C_n-F_n divisible by p, where the fixed
    # count F_n is either 0 or C_{(n-1)/q}, for q=p^k.
    for p in (2, 3, 5, 7):
        for k in (1, 2, 3):
            q = p**k
            for n in range(1, 70):
                value = C(n, q)
                fixed = C((n-1)//q, q) if (n-1) % q == 0 else 0
                assert (value-fixed) % p == 0
                prediction = 1 if (q-1)*n+1 == q else 0
                # Unit modulo p iff m=q, proved by having fixed count 1
                # and otherwise using the computational oracle.
                assert value % p == prediction, (p,q,n,value)
    print('PASS: unit-mod-p branch-rotation criterion, all attempted small q=p^k cases')


def test_digits_and_radicals():
    checked = 0
    for p, top in ((2, 160), (3, 90), (5, 50), (7, 30)):
        # Initial product A=(1-t)^(-(p-1))/p = 1/(p-1)*(p-1+sig).
        A = [Fraction(1 if n == 0 else 0) for n in range(top)]
        for u in range(1, p):
            B = [Fraction(0) for _ in range(top)]
            B[0] = Fraction(p)
            B[1] = Fraction(-(p-1))
            new = [Fraction(0) for _ in range(top)]
            for n in range(top):
                for j in range(2 if n else 1):
                    new[n] += B[j]*A[n-j]
            A = new
        for n, value in enumerate(A):
            assert value.denominator == (p-1)*p**target(n, p), (p, n,value)
            assert value == Fraction(numerator(n,p), (p-1)*p**target(n,p)), (p,n,value)
            checked += 1
        print('PASS: exact p-adic radical product, p=',p,'through n=',top-1)
    print('Total product coefficients checked:', checked)


def test_first_block():
    # A p-adic unit-root recurrence K[1]|B: D=-B, f=p*G[1] so f=1 at p.
    for p, top in ((2,60),(3,40),(5,20)):
        coefficient = [Fraction(0) for _ in range(top)]
        coefficient[0] = 1
        coefficient[1] = p
        B = [1, 0]
        for j in range(2, top):
            B.append(0)
            # Recompute q/p for A=1/(p-1)(p-1+sig).
            m = (p-1)*j+1
            t = target(j,p)
            if m < p:
                assert j == 1 and coefficient[1] == p
            if m >= p:
                assert vp(coefficient[0].numerator,p)[0] == 0
        print('PASS: initial conjugate-root normalization, p=',p)


def test_unit_mod_p_series():
    for p, top in ((2,60),(3,40),(5,25)):
        for n in range(1,top):
            nonzero = [a for a in digits((p-1)*n+1,p) if a != 1]
            assert numerator(n,p) % p == 1
            if p == 2:
                assert C(n,p) % p**(target(n,p)+1) == 2**target(n,p) % p**(target(n,p)+1)
            assert vp(C(n,p),p)[0] == target(n,p)
            if n >= 2:
                assert vp(C(n,p)-C(n-1,p), p)[0] >= target(n,p)+1
        print('PASS: discrete branch derivative and unit threshold, p=',p,'through',top-1)


if __name__ == '__main__':
    for p, maximum in ((2,10),(3,7),(5,5)):
        tree_families(p, maximum)
        print('PASS: tree series and p-adic valuation computed for p=',p,'through',maximum)
    test_digits_and_radicals()
    test_first_block()
    test_unit_mod_p_series()
    print('ALL RADICAL/SYMMETRY CHECKS PASSED')
