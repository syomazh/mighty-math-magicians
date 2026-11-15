# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# Run:  uv run python wilson_fixed_points.py   (standard library only)
# A symmetric replacement for the use of Wilson's theorem in the path proof (Proposition 16 of the note).
# Slots: N row slots (distinguishable) and p slots on a cycle, taken up to rotation of the cycle.
# L = bijections from N + p distinct labels to the slots, up to rotation: |L| = (N + p)!/p.
# sigma = the p-cycle (0 1 ... p-1) on p of the labels acts on L. Claim: it fixes exactly (p - 1) * N! classes,
# namely those with the p cycled labels on the cycle in one of p - 1 cyclic orders.  Hence (N+p)!/p = -N! (mod p).
import itertools, math

def canon(arr, N, p):
    row, cyc = arr[:N], arr[N:]
    return row + min(cyc[r:] + cyc[:r] for r in range(p))

def check(N, p):
    labels = tuple(range(N + p))
    classes = {canon(a, N, p) for a in itertools.permutations(labels)}
    assert len(classes) == math.factorial(N + p) // p
    sigma = lambda x: (x + 1) % p if x < p else x
    fixed = [c for c in classes if canon(tuple(sigma(x) for x in c), N, p) == c]
    assert len(fixed) == (p - 1) * math.factorial(N)
    assert all(set(c[N:]) == set(range(p)) for c in fixed)          # the cycled labels sit on the cycle
    assert (len(classes) - len(fixed)) % p == 0
    assert (len(classes) + math.factorial(N)) % p == 0              # (N+p)!/p = -N!  (mod p)
    return len(classes), len(fixed)

if __name__ == "__main__":
    for (N, p) in [(0,2),(1,2),(2,2),(3,2),(4,2),(0,3),(1,3),(2,3),(3,3),(0,5),(1,5),(2,5),(0,7)]:
        print(f"p={p} N={N}: classes, fixed =", check(N, p))
