# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# Run:  uv run python check_paths.py   (standard library only; about a minute)
# Brute-force check of the "p-adic segment rotation" proof for lattice paths.
# Paths = words in {E,S} of length N with n letters E and m = N - n letters S.
import itertools, math, sys
from fractions import Fraction

def digits(x, p):
    d = []
    while x:
        d.append(x % p); x //= p
    return d

def sp(x, p): return sum(digits(x, p))

def top_segments(N, p):
    """Cut [0,N) into N_i consecutive segments of length p^i (largest first)."""
    segs, pos = [], 0
    d = digits(N, p)
    for i in reversed(range(len(d))):
        for _ in range(d[i]):
            segs.append((pos, p**i)); pos += p**i
    assert pos == N
    return segs

def canon(w, p):
    """Return (canonical form, d, mixed-by-level dict, has_symmetric_mixed)."""
    L = len(w)
    if L == 1:
        return w, 0, {}, False
    step = L // p
    kids = [canon(w[i*step:(i+1)*step], p) for i in range(p)]
    forms = [k[0] for k in kids]
    rots = [tuple(forms[r:] + forms[:r]) for r in range(p)]
    sym = all(f == forms[0] for f in forms)
    d = sum(k[1] for k in kids) + (0 if sym else 1)
    mixed = {}
    for k in kids:
        for lv, c in k[2].items(): mixed[lv] = mixed.get(lv, 0) + c
    mono = len(set(w)) == 1
    symmixed = any(k[3] for k in kids)
    if not mono:
        h = round(math.log(L, p)); mixed[h] = mixed.get(h, 0) + 1
        if sym: symmixed = True
    return min(rots), d, mixed, symmixed

def analyse(N, n, p):
    segs = top_segments(N, p)
    classes = {}
    for pos in itertools.combinations(range(N), n):
        w = ['S'] * N
        for x in pos: w[x] = 'E'
        w = tuple(w)
        key, d, mixed = [], 0, {}
        for (a, L) in segs:
            f, dd, mx, _ = canon(w[a:a+L], p)
            key.append(f); d += dd
            for lv, c in mx.items(): mixed[lv] = mixed.get(lv, 0) + c
        key = tuple(key)
        if key not in classes: classes[key] = [d, 0, mixed]
        classes[key][1] += 1
    return classes

def carries(n, m, p):
    N = n + m
    dn, dm, dN = digits(n, p), digits(m, p), digits(N, p)
    L = len(dN) + 1
    dn += [0]*(L-len(dn)); dm += [0]*(L-len(dm)); dN += [0]*(L-len(dN))
    c = [0]
    for i in range(L):
        tot = dn[i] + dm[i] + c[i]
        assert tot % p == dN[i]
        c.append(tot // p)
    return dn, dm, dN, c

def check(N, n, p, verbose=False):
    m = N - n
    dn, dm, dN, c = carries(n, m, p)
    t = sum(c)
    assert t * (p-1) == sp(n, p) + sp(m, p) - sp(N, p)
    cl = analyse(N, n, p)
    # Lemma 1: class size = p^d
    for key, (d, size, mixed) in cl.items():
        assert size == p**d, (N, n, p, key, d, size)
    # Lemma 2: d >= t, attained
    dmin = min(v[0] for v in cl.values())
    assert dmin == t, (N, n, p, dmin, t)
    minimal = [v for v in cl.values() if v[0] == t]
    # Lemma 4: mixed segments of length p^i number exactly c_i
    for v in minimal:
        for i in range(len(c)):
            assert v[2].get(i, 0) == c[i], (N, n, p, v[2], c)
    # Lemma 5: exact count of minimal classes
    num = 1
    for i in range(len(dN)):
        num *= Fraction(math.factorial(dN[i] + p*c[i+1]), math.factorial(dn[i]) * math.factorial(dm[i]) * p**c[i+1])
    assert num == len(minimal), (N, n, p, num, len(minimal))
    # congruence: (-1)^t prod N_i! / (n_i! m_i!)
    rhs = (-1)**t
    for i in range(len(dN)):
        rhs = rhs * math.factorial(dN[i]) * pow(math.factorial(dn[i]) * math.factorial(dm[i]), -1, p)
    assert (len(minimal) - rhs) % p == 0
    assert math.comb(N, n) % p**t == 0 and (math.comb(N, n) // p**t - rhs) % p == 0
    if verbose:
        print(f"p={p} N={N} n={n} m={m}: t={t}, classes={len(cl)}, minimal classes={len(minimal)}, binom/p^t mod p={(math.comb(N,n)//p**t)%p}")
    return t, len(minimal)

if __name__ == "__main__":
    # (A) all binomials, small N
    cnt = 0
    for p in (2, 3, 5):
        for N in range(1, 17):
            for n in range(0, N+1):
                check(N, n, p); cnt += 1
    print("general binomials checked:", cnt)
    # (B) Fuss-Catalan cases N = qn+1
    cases = [(2,1,n) for n in range(1,11)] + [(2,2,n) for n in range(1,6)] + [(2,3,n) for n in range(1,4)] \
          + [(3,1,n) for n in range(1,7)] + [(3,2,n) for n in range(1,4)] + [(5,1,n) for n in range(1,5)] + [(7,1,n) for n in range(1,4)]
    for (p,k,n) in cases:
        q = p**k; N = q*n + 1; m = (q-1)*n + 1
        t, nmin = check(N, n, p)
        C = math.comb(q*n, n) // m
        assert C * N == math.comb(N, n)
        assert t * (p-1) == sp(m, p) - 1
        rhs = (-1)**t * pow(math.prod(math.factorial(x) for x in digits(m, p)), -1, p)
        assert C % p**t == 0 and (C // p**t - rhs) % p == 0 and (nmin - rhs) % p == 0
        print(f"p={p} q={q} n={n}: N={N} C={C} t={t} minimal classes={nmin}  C/p^t mod p={(C//p**t)%p} = (-1)^t/prod m_j! mod p={rhs%p}")
