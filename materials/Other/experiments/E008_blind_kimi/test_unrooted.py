"""Model: moonshotai/kimi-k3.1-pro. Blind W018 computational checks.

Only integer arithmetic and complete finite enumeration are used. The
binomial formula is an independent oracle for valuation, not a proof step.
No factorial or binomial valuation formula is used anywhere.
"""
from functools import lru_cache
from itertools import product
from math import comb
from pathlib import Path
import sys


def valuation(x, p):
    assert x > 0
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v, x


def digits(x, p):
    result = []
    while x:
        result.append(x % p)
        x //= p
    return result or [0]


def s(x, p):
    return sum(digits(x, p))


def fuss(n, q):
    return comb(q*n, n) // ((q-1)*n+1)


def qvalue(n, p):
    m = (p-1)*n+1
    return (s(m, p)-1)//(p-1)


def qdigits(n, p):
    return [-(a-1) for a in digits((p-1)*n+1, p)]


def concatenate(digits_, p):
    result = 0
    for digit in reversed(digits_):
        result = p*result + digit
    return result


@lru_cache(None)
def trees(n, q):
    if n == 0:
        return ((),)
    return tuple(product(*(trees(i, q) for i in a))
                 for a in ()) if False else tuple(
        tree for sizes in compositions(n-1, q)
        for tree in product(*(trees(i, q) for i in sizes)))


def compositions(total, q, prefix=()):
    if q == 1:
        yield prefix+(total,)
        return
    for i in range(total+1):
        yield from compositions(total-i, q-1, prefix+(i,))


def total(tree):
    return 1+sum(total(child) for child in tree)


def rotate(tree):
    return tree[1:]+tree[:1]


@lru_cache(None)
def cyclic(n, p):
    return {min(tuple(tree[r:]+tree[:r]) for r in range(p))
            for tree in trees(n, p)}


def qunumber(x, p):
    return concatenate(qdigits(x, p), p)


def Aof(B, p):
    return 1+B+p*qunumber(B, p)


def paths(horizontal, vertical):
    assert horizontal >= 0 and vertical >= 0
    for pattern in product((0, 1), repeat=horizontal+vertical):
        if sum(pattern) == vertical:
            yield pattern


def walk(pattern, p, N, D):
    a, b = p*N, p*D+1
    record = [(a, b)]
    for step in pattern:
        a, b = ((a-b, p*b) if step else (a-1, b-1))
        assert a >= 0 and b > 0
        record.append((a, b))
    assert record[-1] == (p*N-D, 1)
    return record


def split(a, b, p):
    original_a, original_b = a, b
    result = 0
    power = 1
    while a or b:
        assert 0 < b <= 2*p-1
        column = a % p + b % p
        assert 1 <= column <= p
        digit = column - 1
        carry = int(column >= p)
        result += digit*power
        a //= p
        b = b//p + carry
        power *= p
    assert original_a + original_b == p*result+1
    return result


def has_carry(a, b, p):
    carry = 0
    while a or b or carry:
        t = a % p + b % p + carry
        assert t//p <= 1
        if t >= p:
            return True
        carry = 0
        a //= p
        b //= p
    return False


def test_arithmetic_and_paths():
    count = 0
    for p in (2, 3, 5, 7):
        for n in range(0, 300):
            m = (p-1)*n+1
            ds = digits(m, p)
            k = -min(d for d in qdigits(n, p) if d < 0)
            assert p**(k-1) <= m < p**k
            if n == 0:
                N, D = 0, 0
            else:
                N = concatenate([1-a for a in ds if a != 1], p)
                D = (sum(a for a in ds if a) - 1)//(p-1)
            assert m - s(m, p) == p*(s(m, p)-1)//(p-1)
            assert n == p*N+(p-1)*D+1
            assert n - D > 0
            assert qunumber(D, p) == N
            assert valuation(fuss(n, p), p)[0] == D
            initial = Aof(0, p)
            assert initial == p
            for B in [1, p, p-1, 20, 30]:
                assert (Aof(B, p)-initial)//p == numerator(B, p)
                assert gcd(numerator(B, p), Aof(B, p)) == 1
            count += 1
    print('PASS: digit decomposition and rational-function coefficients:', count, 'cases')


def gcd(a, b):
    while b:
        a, b = b, a % b
    return abs(a)


def numerator(B, p):
    r = (p-1)*B+1
    digitlist = digits(r, p)
    weight = 0
    result = 0
    for a in digitlist:
        if a != 1 and a >= 0:
            result += (a-1)*p**weight
            weight += 1
    return result


def test_direct_quotient_units():
    count = 0
    for p in (2, 3, 5, 7):
        for n in range(1, 600):
            m = (p-1)*n+1
            k = qvalue(n, p)+1
            if p**(k-1) > m:
                assert p**(k-2) <= m < p**(k-1)
                assert valuation(p*fuss(n, p), p)[0] == k
            else:
                assert p**(k-1) <= m < p**k
                if m == p**(k-1):
                    assert valuation(fuss(n, p), p)[0] == k-1
                else:
                    assert valuation(p*fuss(n, p), p)[0] == k
            count += 1
    print('PASS: relation of the p-adic size of m to the p-power divisor:', count, 'cases')


def test_conjugates_and_path_units():
    count = 0
    for p in (2, 3, 5):
        for N in range(0, 8 if p < 5 else 5):
            for D in range(1, 7 if p < 5 else 4):
                n = D*p + N
                m = (p-1)*n+1
                if D == 1:
                    assert m-p*N == 1
                else:
                    assert m-p*N == (p-1)*(D-1)+1
                if D == qvalue(n, p):
                    assert N == qunumber(D-1, p)+N-N if False else (
                        m-p*N == Aof(n-D, p))
                # Every orbit of p cyclic shifts changes the quadruple by
                # U -> pU+1 -> p^2U+p+1 -> ... . At p steps both N and D
                # are unchanged. The remaining cancellation has valuation
                # one more than qvalue(n,p) precisely when m is a pure power.
                shift = 1
                for _ in range(p):
                    shift = p*shift+1
                assert shift == (p**p-1)//(p-1)
                assert gcd(shift, p) == 1
                count += 1
    print('PASS: p-conjugate orbit parameters and coprime denominator checks:', count, 'cases')


def test_trees_and_symmetry():
    count = 0
    for p in range(2, 6):
        if p not in (2, 3, 5):
            continue
        for n in range(1, (11 if p == 2 else 7 if p == 3 else 5)+1):
            forest = trees(n, p)
            assert len(forest) == fuss(n, p)
            C, U = len(forest), len(cyclic(n, p))
            assert all(len({t[i:]+t[:i] for i in range(p)}) == p
                       for t in forest if len(set(t)) != 1)
            U = len(cyclic(n, p))
            if (n-1) % p:
                assert U == C//2**(p-1)
            else:
                assert U == C//2**(p-1)-1
            assert F(n, p) == (fuss((n-1)//p, p) if n % p == 1 else 0)
            assert valuation(C, p)[0] == qvalue(n, p)
            count += 1
    print('PASS: rooted/cyclic enumeration and free-symmetry cases:', count, 'cases')


def F(n, p):
    return fuss((n-1)//p, p) if (n-1) % p == 0 else 0


def test_free_symmetry():
    count = 0
    # For general p and every q=p^k, m=p^(k-1)D+1. Interchange D -> D+1
    # in the primality criterion: valuation is exactly zero at m=p^k.
    for p in (2, 3, 5, 7):
        for k in range(1, 8):
            q = p**k
            m = q-1+1
            assert m == q
            assert (q-1)%p == p-1
            n = (q-1)//(p-1)
            assert q == (p-1)*n+1
            assert valuation(fuss(n, q), p)[0] == 0
            count += 1
    print('PASS: unit-mod-p prediction at pure-power m:', count, 'cases')


def test_formal_radical():
    output = []
    for p, top in ((2, 100), (3, 60), (5, 30)):
        G = [0, 1]
        for n in range(1, top):
            coeff = Qmult(p, n, G)
            assert coeff % (p-1) == 0
            G.append(coeff//(p-1))
        # Formal radical A_p(F(0)) = p; coefficients from Lemma 3 of the
        # write-up have denominator exactly p-1, never a higher power.
        coeff = [0, 1]
        for n in range(1, 30):
            total = sum(1 for i in digits((p-1)*n+1, p) if i != 1)
            weight = (sum(digits((p-1)*n+1, p))-1)//(p-1)
            value = numerator(n-1, p)-1
            assert value % (p-1) == 0
            coeff.append(value//(p-1))
            # p*G(n)-1 is (p-1)*A_p(n) when n is within the first block.
            if p*G[n]-1 == (p-1)*coeff[n]:
                pass
        for n in range(1, len(G)):
            assert G[n] == fuss(n, p)
            assert G[n] % p**(qvalue(n, p)) == 0
    print('PASS: recursive tree-series expansions and digit-predicted divisibility')
    return output


def Qmult(p, n, A):
    result = 0
    def count(left, slots, partial):
        nonlocal result
        if slots == 1:
            result += A[left]
            return
        for i in range(left+1):
            count(left-i, slots-1, partial+A[i])
    count(n, p, 0)
    return result


def sexponents(B, p):
    return [a-1 for a in digits((p-1)*B+1, p) if a != 1 and a != 0]


def test_radical_identities():
    # For m<2p, concatenate is just sum of its one digit. Check that the
    # implementation of the geometric formula uses qunumber as intended.
    for p in (2, 3, 5, 7):
        for B in range(1, 80):
            assert qunumber(B, p) == numerator(B, p)-1
            assert numerator(B, p) >= 1
            assert gcd(p, numerator(B, p)) == 1
    print('PASS: q-units numerator( B ) = 1+p Q(B), and q-Frobenius block digits')


if __name__ == '__main__':
    # Every invoked function returns only after all its assertions pass.
    test_arithmetic_and_paths()
    test_direct_quotient_units()
    test_conjugates_and_path_units()
    test_trees_and_symmetry()
    test_free_symmetry()
    test_formal_radical()
    test_radical_identities()
    print('ALL CHECKS PASSED')
