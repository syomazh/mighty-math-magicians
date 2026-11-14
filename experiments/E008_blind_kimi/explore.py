"""Scratch checks for blind tree proof search; model moonshotai/kimi-k3.1-pro."""
from itertools import product
from math import comb


def vp(a, p):
    v = 0
    while a % p == 0:
        a //= p
        v += 1
    return v, a


def cat(n, p):
    return comb(p*n, n) // ((p-1)*n+1)


def digits(a, p):
    out = []
    while a:
        out.append(a % p)
        a //= p
    return out or [0]


def carries(parts, p):
    c = 0
    while any(parts):
        if sum(a % p for a in parts) >= p:
            c += 1
        parts = [a // p for a in parts]
    return c


def explore(p, n):
    target = vp(cat(n, p), p)[0]
    terms = []
    for inds in product(range(n), repeat=p):
        if sum(inds) != n-1:
            continue
        if any(inds[i] > inds[(i+1) % p] for i in range(p)):
            continue  # lexicographically greatest in its cyclic orbit
        constant = len(set(inds)) == 1
        value = 1
        for i in inds:
            value *= cat(i, p)
        orbit = 1 if constant else p
        val, unit = vp(orbit*value, p)
        parts = [(p-1)*i+1 for i in inds]
        if not constant:
            assert val == target + carries(parts, p), (p, n, inds, val, target, carries(parts, p))
        terms.append((val, unit % p, inds, constant))
    w = min(t[0] for t in terms)
    assert w == target, (p, n, w, target)
    residue = sum(u for v, u, _, _ in terms if v == w) % p
    print(p, n, 'v=', w, 'residue=', residue, 'minimal=', [(i,u,c) for v,u,i,c in terms if v == w])
    assert residue != 0


if __name__ == '__main__':
    for p in (2,3,5):
        for n in range(1,9):
            explore(p,n)
