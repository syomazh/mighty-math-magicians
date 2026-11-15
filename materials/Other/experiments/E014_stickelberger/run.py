# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
E014 -- a numerical test of the "Stickelberger question" (claim C21).

Setting. p prime, q = p^r, F_q the field with q elements, W the ring of integers of the unramified
extension of Q_p of degree r (computed modulo p^N), omega the Teichmueller character of F_q^*,
zeta a primitive p-th root of unity, pi = zeta - 1 (so pi^(p-1) = -p * unit, unit = 1 mod pi).
Gauss sum, for 0 <= a < q - 1:

    G(a) = sum over x in F_q^*  of  omega(x)^(-a) * zeta^Tr(x).

For a = sum a_i p^i (base-p digits) let s(a) = sum a_i.

  S1 (Stickelberger's congruence, as quoted in our notes from a secondary source):
        G(a) * prod a_i!  =  - pi^s(a)     modulo pi^(s(a)+1).
  S2 (the comparison with our theorem): for Q = p^k and m = (Q-1) n + 1 < q - 1,
        C_n^(Q) * prod m_j!  =  - G(m) * prod m_j! / pi     modulo pi^(s(m)),
     i.e. the Fuss-Catalan number and -1/pi times the Gauss sum of exponent m have the same
     leading term. (Given S1, this is equivalent to our theorem C * prod m_j! = (-p)^t mod p^(t+1).)

Everything is exact arithmetic in R = (Z/p^N)[t]/(h(t)) [pi] / (minimal polynomial of pi).
An element sum c_i pi^i (c_i in W) has pi-adic valuation min_i ( i + (p-1) * v_p(c_i) ).
"""
import itertools
import sys
from math import comb, factorial


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


# ---------------------------------------------------------------------------------------------
def poly_divides(d, h, p):
    """Does the monic polynomial d divide h over F_p?  (lists, lowest degree first)"""
    h = h[:]
    while len(h) >= len(d):
        c = h[-1] % p
        if c:
            for i in range(len(d)):
                h[len(h) - len(d) + i] = (h[len(h) - len(d) + i] - c * d[i]) % p
        h.pop()
    return not any(x % p for x in h)


def irreducible(p, r):
    if r == 1:
        return [0, 1]
    for coeffs in itertools.product(range(p), repeat=r):
        h = list(coeffs) + [1]
        ok = True
        for dd in range(1, r // 2 + 1):
            for dc in itertools.product(range(p), repeat=dd):
                if poly_divides(list(dc) + [1], h, p):
                    ok = False
                    break
            if not ok:
                break
        if ok:
            return h
    raise RuntimeError("no irreducible polynomial found")


class Ring:
    """R = (Z/M)[t]/(h) [pi]/(Phi), M = p^N; an element is a tuple of p-1 tuples of r integers."""

    def __init__(self, p, r, N):
        self.p, self.r, self.N, self.M = p, r, N, p ** N
        self.h = irreducible(p, r)
        self.zeroW = tuple([0] * r)
        self.oneW = tuple([1] + [0] * (r - 1))
        self.deg = p - 1
        # pi^(p-1) = - sum_{i=1}^{p-1} binom(p, i) pi^(i-1)
        self.rel = [(-comb(p, i)) % self.M for i in range(1, p)]

    # --- W ---
    def wmul(self, a, b, mod=None):
        mod = mod or self.M
        r = self.r
        prod = [0] * (2 * r - 1)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(b):
                    if y:
                        prod[i + j] = (prod[i + j] + x * y) % mod
        for k in range(2 * r - 2, r - 1, -1):          # reduce by the monic polynomial h
            c = prod[k]
            if c:
                for i in range(r):
                    prod[k - r + i] = (prod[k - r + i] - c * self.h[i]) % mod
            prod[k] = 0
        return tuple(prod[:r])

    def wpow(self, a, e, mod=None):
        res = self.oneW
        while e:
            if e & 1:
                res = self.wmul(res, a, mod)
            a = self.wmul(a, a, mod)
            e >>= 1
        return res

    # --- R ---
    def const(self, w):
        return tuple([w] + [self.zeroW] * (self.deg - 1))

    def add(self, a, b):
        return tuple(tuple((x + y) % self.M for x, y in zip(u, v)) for u, v in zip(a, b))

    def scale_int(self, a, c):
        return tuple(tuple((x * c) % self.M for x in u) for u in a)

    def mul(self, a, b):
        d = self.deg
        prod = [list(self.zeroW) for _ in range(2 * d - 1)]
        for i, u in enumerate(a):
            if any(u):
                for j, v in enumerate(b):
                    if any(v):
                        w = self.wmul(u, v)
                        prod[i + j] = [(x + y) % self.M for x, y in zip(prod[i + j], w)]
        for k in range(2 * d - 2, d - 1, -1):
            c = prod[k]
            if any(c):
                for i in range(d):
                    prod[k - d + i] = [(x + self.rel[i] * y) % self.M for x, y in zip(prod[k - d + i], c)]
            prod[k] = list(self.zeroW)
        return tuple(tuple(x) for x in prod[:d])

    def pi(self):
        if self.deg == 1:                              # p = 2: pi = -2
            return self.const(tuple([(-2) % self.M] + [0] * (self.r - 1)))
        return tuple([self.zeroW, self.oneW] + [self.zeroW] * (self.deg - 2))

    def pi_pow(self, e):
        res = self.const(self.oneW)
        for _ in range(e):
            res = self.mul(res, self.pi())
        return res

    def val(self, a):
        """pi-adic valuation (capped where the working precision ends)."""
        p = self.p
        best = None
        for i, c in enumerate(a):
            vp = self.N
            for x in c:
                if x % self.M:
                    v = 0
                    y = x % self.M
                    while y % p == 0:
                        y //= p
                        v += 1
                    vp = min(vp, v)
            cand = i + (p - 1) * vp
            best = cand if best is None else min(best, cand)
        return best


def gauss_sums(p, r, N):
    R = Ring(p, r, N)
    q = p ** r
    elems = [tuple(c) for c in itertools.product(range(p), repeat=r) if any(c)]
    zeta = R.add(R.const(R.oneW), R.pi())              # 1 + pi
    zpow = [R.const(R.oneW)]
    for _ in range(p - 1):
        zpow.append(R.mul(zpow[-1], zeta))
    data = []
    for x in elems:
        tr = list(R.zeroW)                             # trace in F_q = sum of x^(p^i), computed modulo p
        y = x
        for _ in range(r):
            tr = [(u + v) % p for u, v in zip(tr, y)]
            y = R.wpow(y, p, mod=p)
        assert not any(tr[1:]), "trace not in the prime field"
        teich = R.wpow(x, q ** (N - 1))                # Teichmueller lift modulo p^N
        assert tuple(c % p for c in teich) == x
        data.append((teich, tr[0]))
    for teich, _ in data[:3]:
        assert R.wpow(teich, q - 1) == R.oneW

    def G(a):
        total = R.const(R.zeroW)
        e = (q - 1 - a) % (q - 1)
        for teich, tr in data:
            w = R.wpow(teich, e)
            total = R.add(total, R.mul(R.const(w), zpow[tr]))
        return total

    return R, G


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    ok = True
    print("S1: Stickelberger's congruence  G(a) * prod a_i! = -pi^s(a)  (mod pi^(s(a)+1)),  all 0 <= a < q-1")
    cache = {}
    for p, r in [(2, 2), (2, 3), (2, 4), (2, 5), (3, 1), (3, 2), (3, 3), (5, 1), (5, 2), (7, 1), (7, 2), (11, 1)]:
        N = r + 3
        R, G = gauss_sums(p, r, N)
        cache[(p, r)] = (R, G)
        q = p ** r
        bad = 0
        for a in range(q - 1):
            dg = digits(a, p)
            s = sum(dg)
            f = 1
            for x in dg:
                f *= factorial(x)
            lhs = R.add(R.scale_int(G(a), f), R.pi_pow(s))
            if R.val(lhs) < s + 1:
                bad += 1
        ok &= bad == 0
        print(f"   p = {p:>2}, q = {q:>3}: {q - 1:>3} exponents, failures: {bad}")

    print("\nS2: Fuss-Catalan against Gauss sums:  C * prod m_j! * pi + G(m) * prod m_j! = 0  (mod pi^(s(m)+1))")
    for p, k, r in [(2, 1, 4), (2, 1, 5), (2, 2, 4), (2, 3, 5), (3, 1, 3), (3, 2, 3), (5, 1, 2), (7, 1, 2)]:
        R, G = cache[(p, r)]
        Q, q = p ** k, p ** r
        bad = tested = 0
        n = 1
        while (Q - 1) * n + 1 < q - 1:
            m = (Q - 1) * n + 1
            C = comb(Q * n, n) // ((Q - 1) * n + 1)
            dg = digits(m, p)
            s = sum(dg)
            f = 1
            for x in dg:
                f *= factorial(x)
            lhs = R.add(R.scale_int(R.pi(), C * f), R.scale_int(G(m), f))
            tested += 1
            if R.val(lhs) < s + 1:
                bad += 1
            n += 1
        ok &= bad == 0
        print(f"   p = {p}, Q = {Q:>2} (trees), Gauss sums over F_{q}: {tested:>2} values of m, failures: {bad}")
    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")
