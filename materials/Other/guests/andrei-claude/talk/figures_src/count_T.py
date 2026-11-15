# Written by Claude Fable 5.2 (claude-fable-5-2), 2026-11-15. Not human-reviewed.
# Brute-force count of T(a): p-ary trees, children up to cyclic rotation, distinct labelled leaves,
# a label of class c at depth = -c (mod k).  Also fixed points of a p-cycle sigma on p labels of one class.
import itertools, math, sys
def set_partitions_ordered(items, parts):
    """ordered tuples of `parts` non-empty disjoint subsets covering items"""
    items = list(items)
    if parts == 1:
        yield (tuple(items),); return
    n = len(items)
    for r in range(1, n - parts + 2):
        for first in itertools.combinations(items, r):
            rest = [x for x in items if x not in first]
            for tail in set_partitions_ordered(rest, parts - 1):
                yield (first,) + tail
def trees(labels, depth, p, k, cls, memo):
    key = (tuple(sorted(labels)), depth % k)
    if key in memo: return memo[key]
    out = set()
    if len(labels) == 1:
        l = labels[0]
        if (depth + cls[l]) % k == 0: out.add(l)
    elif (len(labels) - 1) % (p - 1) == 0:
        for parts in set_partitions_ordered(labels, p):
            if any((len(b) - 1) % (p - 1) for b in parts): continue
            subs = [trees(b, depth + 1, p, k, cls, memo) for b in parts]
            if any(not s for s in subs): continue
            for combo in itertools.product(*subs):
                out.add(min((tuple(combo[r:] + combo[:r]) for r in range(p)), key=repr))
    memo[key] = out; return out
def relabel(t, f):
    if not isinstance(t, tuple): return f.get(t, t)
    kids = [relabel(c, f) for c in t]
    return min((tuple(kids[r:] + kids[:r]) for r in range(len(kids))), key=repr)
def T(a, p):
    k = len(a); cls = {}; labels = []
    for c, ac in enumerate(a):
        for i in range(ac):
            name = f"{'xu'[c] if k == 2 else 'x'}{i+1}"; cls[name] = c; labels.append(name)
    return trees(tuple(labels), 0, p, k, cls, {}), cls
for (a, p) in [((5,), 3), ((3, 2), 3), ((0, 3), 3), ((1, 0), 3), ((6, 1), 3), ((2, 5), 3)]:
    S, cls = T(a, p)
    big = [c for c in range(len(a)) if a[c] >= p]
    line = f"p={p} k={len(a)} a={a}: |T(a)| = {len(S)}"
    if big:
        c = big[0]; xs = [l for l in sorted(cls) if cls[l] == c][:p]
        f = {xs[i]: xs[(i + 1) % p] for i in range(p)}
        fixed = [t for t in S if relabel(t, f) == t]
        line += f"; sigma on {xs}: fixed {len(fixed)}, moved {len(S)-len(fixed)} in {(len(S)-len(fixed))//p} orbits"
    print(line)
S, _ = T((3, 2), 3)
for t in sorted(S, key=repr): print("   T(3,2):", t)
# skeleton counts for m = 17 = 122_3 : |S| = |T| / prod m_j!
print("m=17: prod m_j! =", 2*2*1, " k=1:", len(T((5,),3)[0])//4, " k=2:", len(T((3,2),3)[0])//4)
print("C_2^(9) =", math.comb(18, 2)//17, " C_8^(3) =", math.comb(24, 8)//17, " C_23^(9): m =", 8*23+1)

# The smallest n with q = 9 (p = 3, k = 2) whose label vector a = (a_0, a_1) is (6, 1):
# a_c = sum of the base-3 digits m_j of m = 8n + 1 with j = c (mod 2).
def label_vector(m, p=3, k=2):
    a = [0] * k; j = 0
    while m:
        a[j % k] += m % p; m //= p; j += 1
    return tuple(a)
first = next(n for n in range(1, 1000) if label_vector(8 * n + 1) == (6, 1))
assert first == 23 and label_vector(17) == (3, 2)
print("smallest n with q = 9 and a = (6, 1):", first, " (m =", 8 * first + 1, ")")
