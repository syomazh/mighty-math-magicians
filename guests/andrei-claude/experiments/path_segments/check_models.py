# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# Run:  uv run python check_models.py   (standard library only)
# (1) the two path models both give the Fuss-Catalan number; (2) true orbits under the moves (BFS) have size p^d.
import itertools, math
from collections import Counter
from check_paths import top_segments, canon, digits

def fuss(q, n): return math.comb(q*n, n) // ((q-1)*n + 1)

def under_diagonal(q, n):
    """S/E paths (0,(q-1)n) -> (n,0) weakly under the line y = (q-1)(n-x)."""
    cnt = 0
    for pos in itertools.combinations(range(q*n), n):
        E = set(pos); x, y, ok = 0, (q-1)*n, True
        for i in range(q*n):
            if i in E: x += 1
            else: y -= 1
            if y > (q-1)*(n-x): ok = False; break
        cnt += ok
    return cnt

def cyclic_classes(q, n):
    N = q*n + 1; seen = set(); cls = 0; sizes = set()
    for pos in itertools.combinations(range(N), n):
        w = tuple(1 if i in pos else 0 for i in range(N))
        if w in seen: continue
        orb = {w[r:] + w[:r] for r in range(N)}
        seen |= orb; cls += 1; sizes.add(len(orb))
    return cls, sizes

def moves(N, p):
    """All generators: rotate the p sub-segments of any p-adic segment."""
    gens = []
    def rec(a, L):
        if L == 1: return
        s = L // p
        perm = list(range(N))
        for i in range(L): perm[a + i] = a + (i + s) % L
        gens.append(perm)
        for i in range(p): rec(a + i*s, s)
    for (a, L) in top_segments(N, p): rec(a, L)
    return gens

def bfs_orbits(N, n, p):
    gens = moves(N, p); seen = {}; out = []
    for pos in itertools.combinations(range(N), n):
        w = tuple('E' if i in pos else 'S' for i in range(N))
        if w in seen: continue
        orb = {w}; stack = [w]
        while stack:
            u = stack.pop()
            for g in gens:
                v = tuple(u[g[i]] for i in range(N))
                if v not in orb: orb.add(v); stack.append(v)
        for u in orb: seen[u] = 1
        out.append(orb)
    return out

def main():
    for (q, n) in [(2,3),(2,5),(3,2),(3,3),(3,4),(4,3),(5,2),(5,3),(9,2)]:
        C = fuss(q, n); a = under_diagonal(q, n); b, sizes = cyclic_classes(q, n)
        assert a == C == b and sizes == {q*n+1}, (q, n, C, a, b, sizes)
    print("both path models give C; every cyclic class has exactly N paths")

    for (p, N, n) in [(2,9,4),(2,13,6),(3,10,3),(3,7,2),(3,13,4),(5,11,2),(2,11,5),(3,16,5)]:
        for orb in bfs_orbits(N, n, p):
            w = next(iter(orb)); d = 0
            for (a, L) in top_segments(N, p): d += canon(w[a:a+L], p)[1]
            assert len(orb) == p**d
    print("BFS orbits under the moves have size p^d(w)")

    # show the example p=3, q=3, n=3
    p, N, n = 3, 10, 3
    orbs = bfs_orbits(N, n, p)
    print("p=3 q=3 n=3: orbit sizes", sorted(Counter(len(o) for o in orbs).items()))
    print(sorted(''.join(w) for w in min(orbs, key=len)))
    p, N, n = 3, 7, 2
    orbs = bfs_orbits(N, n, p)
    print("p=3 q=3 n=2: orbit sizes", sorted(Counter(len(o) for o in orbs).items()))

if __name__ == "__main__":
    main()
