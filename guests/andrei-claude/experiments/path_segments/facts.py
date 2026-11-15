# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.  Numbers quoted in the note, recomputed.
# Run:  uv run python facts.py   (standard library only)
import itertools, math
from collections import Counter
from check_paths import top_segments, canon, digits, carries
from check_models import bfs_orbits

def dval(w, p):
    return sum(canon(tuple(w[a:a+L]), p)[1] for (a, L) in top_segments(len(w), p))

# cycle lemma: among the N shifts exactly one is S.v with v weakly under the line
def under(v, q, n):
    x, y = 0, (q-1)*n
    for ch in v:
        if ch == 'E': x += 1
        else: y -= 1
        if y > (q-1)*(n-x): return False
    return True
for (q, n) in [(2,3),(2,4),(3,2),(3,3),(4,2),(4,3),(5,2),(9,2)]:
    N = q*n+1
    for pos in itertools.combinations(range(N), n):
        w = ''.join('E' if i in pos else 'S' for i in range(N))
        good = [r for r in range(N) if (w[r:]+w[:r])[0] == 'S' and under((w[r:]+w[:r])[1:], q, n)]
        assert len(good) == 1
print("cycle lemma: exactly one shift is S.v with v under the line")

for w in ["SSSSESESSE", "SESESSSSSE", "ESSESSSSSE", "EEESSSSSSS", "EESSSSSSSE", "EESESSSSSS"]:
    print(w, "d =", dval(w, 3))
print("under line SSSESESSE:", under("SSSESESSE", 3, 3))
for w in ["ESSE", "SEES", "ESES", "SESE", "EESS", "SSEE"]:
    print(w, "p=2 d =", dval(w, 2))
orbs = bfs_orbits(4, 2, 2); print("N=4,n=2,p=2 classes:", sorted(sorted(''.join(x) for x in o) for o in orbs))
orbs = bfs_orbits(10, 3, 3); print("N=10 sizes:", sorted(Counter(len(o) for o in orbs).items()))
for o in orbs:
    if len(o) == 9: print("size-9 class sample:", sorted(''.join(x) for x in o)[:3])
# example B
p, N, n = 3, 19, 2
wB = "SSSEESSSS" + "S"*9 + "S"
assert len(wB) == 19 and wB.count('E') == 2
print("example B word d =", dval(wB, 3), "carries", carries(2, 17, 3))
cnt = Counter()
for pos in itertools.combinations(range(N), n):
    w = ''.join('E' if i in pos else 'S' for i in range(N)); cnt[dval(w, 3)] += 1
print("N=19 n=2: words by d:", sorted(cnt.items()), "classes by d:", {d: c // 3**d for d, c in cnt.items()}, "binom", math.comb(19, 2))
