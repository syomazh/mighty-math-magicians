# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Z_m(y) = sum over rotation classes of p-ary trees with m leaves of y^d,
# computed WITHOUT enumerating trees, from the "necklace" recursion
#
#   M(x; y) = x + M(x^p; y^p) + y * ( M(x; y)^p - M(x^p; y^p) ) / p ,
#
# where M(x; y) = sum_m Z_m(y) x^m.  First term: the leaf.  Second term: a
# symmetric root (p copies of one class; its asymmetric nodes are counted p
# times).  Third term: an asymmetric root: ordered p-tuples of classes that
# are not all equal, up to the p cyclic shifts (free action, p prime).
#
# Polynomials in y are lists of integers (index = exponent).

def padd(a, b):
    n = max(len(a), len(b))
    return [(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
            for i in range(n)]


def pmul(a, b):
    if not a or not b:
        return []
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                out[i + j] += x * y
    return out


def peval(a, y):
    return sum(c * y ** i for i, c in enumerate(a))


def trim(a):
    a = list(a)
    while a and a[-1] == 0:
        a.pop()
    return a


def class_polynomials(p, M):
    """Returns dict m -> Z_m(y) (list of coefficients) for all m <= M with
    m = 1 mod (p-1)."""
    Z = {1: [1]}
    power = {}                     # (k, n) -> [x^n] M^k as polynomial in y

    def pw(k, n):
        if n < k:
            return []
        if k == 1:
            return Z.get(n, [])
        key = (k, n)
        if key not in power:
            acc = []
            for a in range(1, n - k + 2):
                za = Z.get(a)
                if za:
                    acc = padd(acc, pmul(za, pw(k - 1, n - a)))
            power[key] = acc
        return power[key]

    for m in range(2, M + 1):
        if (m - 1) % (p - 1):
            continue
        sym = []
        if m % p == 0 and (m // p) in Z:
            base = Z[m // p]
            sym = [0] * ((len(base) - 1) * p + 1)
            for i, c in enumerate(base):
                sym[i * p] = c           # y -> y^p
        tot = pw(p, m)
        diff = padd(tot, [-c for c in sym])
        assert all(c % p == 0 for c in diff)
        asym = [0] + [c // p for c in diff]        # times y
        Z[m] = trim(padd(sym, asym))
    return Z
