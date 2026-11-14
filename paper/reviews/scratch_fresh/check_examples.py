"""Fresh-referee checks, part 3: recompute every number in the worked examples and
decompose the ten skeletons of Example 7.2 by atom partition."""
import sys
from itertools import permutations
from math import comb, factorial

sys.path.insert(0, __file__.rsplit("\\", 1)[0].rsplit("/", 1)[0])
from check_trees import make_trees, leaf_depths, digits, s_p
from check_skeletons import ccanon, fill, kids, _is_node, make_T, brute_labelled


def fc(q, n):
    assert comb(q * n, n) % ((q - 1) * n + 1) == 0
    return comb(q * n, n) // ((q - 1) * n + 1)


def vp(x, p):
    e = 0
    while x % p == 0:
        x //= p
        e += 1
    return e


print("== Example 7.1 (2,1,6)")
print(" m=7 digits", digits(7, 2), "s=", s_p(7, 2), "C_6=", fc(2, 6), "132/4=", 132 // 4, "v_2=", vp(fc(2, 6), 2),
      "exact count 4!/(2! 2^2)=", factorial(4) // (factorial(2) * 4))

print("== Example 7.2 (3,1,8)")
C = fc(3, 8)
print(" m=17 digits (lsb first)", digits(17, 3), "s=", s_p(17, 3), "binom(24,8)=", comb(24, 8), "C=", C, "C/9=", C // 9,
      "(C/9) mod 3=", (C // 9) % 3, "v_3=", vp(C, 3))
print(" N_min formula 6!/(2! 3^2 (2!2!1!)) =", factorial(6) // (factorial(2) * 9 * 4))
T = make_T(3, 1)
print(" T(5)=", T((5,)), "T(3)=", T((3,)), "T(1)=", T((1,)), " T(5) mod 3=", T((5,)) % 3, " -T(3) mod 3=", (-T((3,))) % 3)
print(" inverse of 2!2!1! mod 3 =", pow(4, -1, 3))

# ten unlabelled skeletons grouped by (multiset of atoms at root level, multiset of atoms in the cherry)
atoms = [0, 0, 1, 1, 2]
trees = make_trees(3)
skel = set()
for shape in trees(5):
    for perm in set(permutations(atoms)):
        skel.add(ccanon(fill(shape, iter(perm))))
print(" number of unlabelled skeletons:", len(skel))
groups = {}
for x in skel:
    top = sorted(c[1] for c in kids(x) if not _is_node(c))
    cherry = [c for c in kids(x) if _is_node(c)]
    assert len(cherry) == 1
    ch = sorted(c[1] for c in kids(cherry[0]))
    groups.setdefault((tuple(top), tuple(ch)), []).append(x)
for (top, ch), xs in sorted(groups.items()):
    print(f"   root-level atoms heights {top}, cherry atoms heights {ch}: {len(xs)} skeleton(s)")
    for x in xs:
        print("      ", x)

# labelled count for the two pictured atom partitions
labels = [(0, 0), (0, 1), (1, 0), (1, 1), (2, 0)]  # (height, copy)
lab = set()
for shape in trees(5):
    for perm in permutations(labels):
        lab.add(ccanon(fill(shape, iter(perm))))
print(" labelled trees:", len(lab))


def part(x):
    top = frozenset(c[1] for c in kids(x) if not _is_node(c))
    return top


for name, top in [("left picture: root-level {K_1', K_2}", frozenset({(1, 1), (2, 0)})),
                  ("right picture: root-level {K_0', K_2}", frozenset({(0, 1), (2, 0)}))]:
    n = sum(1 for x in lab if part(x) == top)
    print(f"   {name}: {n} labelled cyclic trees with exactly this labelled partition")

print("== Example 7.3 (2,2,4)")
C = fc(4, 4)
print(" m=13 digits (lsb first)", digits(13, 2), "s=", s_p(13, 2), "binom(16,4)=", comb(16, 4), "C=", C, "C/4=", C // 4, "v_2=", vp(C, 2))
T2 = make_T(2, 2)
print(" T(2,1)=", T2((2, 1)), "T(0,2)=", T2((0, 2)), "T(1,0)=", T2((1, 0)))
for a in [(2, 1), (0, 2), (1, 0)]:
    print("   brute force", a, len(brute_labelled(2, 2, a)), sorted(brute_labelled(2, 2, a)))

print("== the seven requested cases")
for p, k, n in [(2, 1, 3), (2, 1, 6), (3, 1, 2), (3, 1, 3), (2, 2, 2), (2, 2, 3), (3, 2, 2)]:
    q = p ** k
    m = (q - 1) * n + 1
    dg = digits(m, p)
    t = (sum(dg) - 1) // (p - 1)
    C = fc(q, n)
    den = 1
    for x in dg:
        den *= factorial(x)
    a = [0] * k
    for j, x in enumerate(dg):
        a[j % k] += x
    Tk = make_T(p, k)
    print(f" ({p},{k},{n}): m={m} t={t} C={C} v_p(C)={vp(C, p)} unit={C // p ** t} unit mod p={(C // p ** t) % p} "
          f"pred={((-1) ** t * pow(den, -1, p)) % p} a={tuple(a)} T(a)={Tk(tuple(a))} T(a) mod p={Tk(tuple(a)) % p} (-1)^t mod p={(-1) ** t % p} N_min=T/prod={Tk(tuple(a)) // den}")

print("== wider sweep of the theorem via the closed formula (sanity of the statement only)")
bad = 0
for p in (2, 3, 5, 7, 11):
    for k in (1, 2, 3):
        q = p ** k
        for n in range(1, 300 if q < 50 else 60):
            m = (q - 1) * n + 1
            dg = digits(m, p)
            t = (sum(dg) - 1) // (p - 1)
            C = fc(q, n)
            den = 1
            for x in dg:
                den *= factorial(x)
            if vp(C, p) != t or (C // p ** t) % p != ((-1) ** t * pow(den, -1, p)) % p:
                bad += 1
print(" counterexamples to the statement:", bad)

print("== Corollary 6.1 consistency: (pt)!/(t! p^t) = (-1)^t mod p (Wilson)")
for p in (2, 3, 5, 7):
    for t in range(0, 8):
        v = factorial(p * t) // (factorial(t) * p ** t)
        assert factorial(p * t) % (factorial(t) * p ** t) == 0
        assert (v - (-1) ** t) % p == 0
        if (p - 1) * t + 1 <= 9:
            assert make_T(p, 1)(((p - 1) * t + 1,)) == v
print(" OK")
