"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.
The author of this script read only that note; nothing here is copied from experiments/.

What it does
------------
Enumerates ALL rotation classes of p-ary trees with up to M leaves (canonical form = the
lexicographically smallest rotation of the tuple of canonical child ids, so two trees are
rotation-equivalent iff they get the same id) and checks on every class:

  Fact 1   sum_v c(v) = (m - s_p(m))/(p-1)            (c(v) by formula AND by simulated addition)
  Fact 2   symmetric node => children have equal leaf count b and c(v) = s_p(b) >= 1
  Fact 3   d - t = nu - sigma = sum_sym (s_p(b)-1) + sum_asym c(v), all terms >= 0
  Cons. 1  d >= t
  Cons. 2  d = t  <=>  (every asymmetric node carry-free) and (every symmetric node has children
           with a power of p leaves);  in that case children of symmetric nodes are complete;
           "skeleton" description in both directions; atoms = base-p digits of m.

Completeness of the enumeration is checked independently: sum over classes of p^d must be the
Fuss-Catalan number C(pN,N)/((p-1)N+1) (number of all p-ary trees with N nodes).

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/check_facts.py 2:20 3:27 5:45 7:55
"""
import sys
import time
from math import comb, factorial
from collections import Counter, defaultdict


def digits(n, p):
    ds = []
    while n:
        ds.append(n % p)
        n //= p
    return ds


def sp(n, p):
    return sum(digits(n, p))


def add_carries(nums, p):
    """Schoolbook base-p addition of the list nums.
    Returns (total amount carried, number of columns with a non-zero carry-out)."""
    ds = [digits(x, p) for x in nums]
    L = max(len(d) for d in ds)
    carry = 0
    total = 0
    cols = 0
    res = 0
    pw = 1
    i = 0
    while i < L or carry:
        s = carry + sum(d[i] for d in ds if i < len(d))
        carry = s // p
        res += (s % p) * pw
        pw *= p
        total += carry
        cols += 1 if carry else 0
        i += 1
    assert res == sum(nums)
    return total, cols


def vp(n, p):
    assert n > 0
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def fuss(p, n):
    """Number of p-ary trees with n nodes."""
    num = comb(p * n, n)
    den = (p - 1) * n + 1
    assert num % den == 0
    return num // den


class Classes:
    """All rotation classes of p-ary trees, built by increasing number of leaves."""

    def __init__(self, p):
        self.p = p
        self.kids = [None]          # id 0 is the leaf
        self.m = [1]
        self.by_m = {1: [0]}
        self.index = {}
        self.N = [0]                # nodes
        self.sigma = [0]            # symmetric nodes
        self.d = [0]                # asymmetric nodes
        self.carr = [0]             # sum of c(v)
        self.cols = [0]             # sum over nodes of number of carrying columns
        self.A = [0]                # sum over symmetric nodes of s_p(b) - 1
        self.B = [0]                # sum over asymmetric nodes of c(v)
        self.cond1 = [True]         # every asymmetric node is carry-free
        self.cond2 = [True]         # every symmetric node has children with p^j leaves
        self.height = [0]           # height if complete, else -1
        self.symkids_complete = [True]   # every child of a symmetric node is complete
        self.asym_below_sym = [False]    # some asymmetric node lies below a symmetric one
        self.skel = [True]          # complete, or (root carry-free and all children skel)
        self.atoms = [(0,)]         # if skel: sorted heights of the maximal complete subtrees
        self.bad_sym = [0]          # number of symmetric nodes with s_p(b) > 1
        self.viol = defaultdict(list)
        self.max_m = 1

    def canon(self, tup):
        p = self.p
        best = tup
        for r in range(1, p):
            rot = tup[r:] + tup[:r]
            if rot < best:
                best = rot
        return best

    def note_violation(self, name, cid):
        if len(self.viol[name]) < 5:
            self.viol[name].append(cid)
        else:
            self.viol[name + "#more"] = [len(self.viol.get(name + "#more", [0])) + 1]

    def tree(self, cid):
        """Explicit nested-tuple tree of class cid (leaf = ())."""
        if cid == 0:
            return ()
        return tuple(self.tree(c) for c in self.kids[cid])

    def extend(self, m):
        p = self.p
        assert (m - 1) % (p - 1) == 0 and m > self.max_m
        by_m = self.by_m
        M_ = self.m
        sizes = sorted(by_m.keys())
        out = []

        def rec(slots, remaining, first, s0, cur):
            if slots == 1:
                for c in by_m.get(remaining, ()):
                    if c >= first:
                        out.append(cur + (c,))
                return
            for size in sizes:
                if size < s0:
                    continue
                if remaining - size < (slots - 1) * s0:
                    break
                for c in by_m[size]:
                    if c >= first:
                        rec(slots - 1, remaining - size, first, s0, cur + (c,))

        # the first child is a child with the smallest id (every necklace has such a rotation)
        for s0 in sizes:
            if p * s0 > m:
                break
            for c0 in by_m[s0]:
                rec(p - 1, m - s0, c0, s0, (c0,))

        new = []
        for tup in out:
            key = self.canon(tup)
            if key in self.index:
                continue
            cid = len(self.kids)
            self.index[key] = cid
            self.kids.append(key)
            self.m.append(m)
            new.append(cid)
            self._stats(cid, key, m)
        self.by_m[m] = new
        self.max_m = m
        return new

    def _stats(self, cid, k, m):
        p = self.p
        ms = [self.m[c] for c in k]
        assert sum(ms) == m
        sym = all(c == k[0] for c in k)     # same id <=> rotation-equivalent
        num = sum(sp(x, p) for x in ms) - sp(m, p)
        assert num % (p - 1) == 0, "c(v) not an integer"
        cv = num // (p - 1)
        tot, cols = add_carries(ms, p)
        if cv < 0:
            self.note_violation("c(v) < 0", cid)
        if tot != cv:
            self.note_violation("formula c(v) != simulated carried amount", cid)

        N = sum(self.N[c] for c in k) + 1
        assert N * (p - 1) == m - 1
        sigma = sum(self.sigma[c] for c in k) + (1 if sym else 0)
        d = sum(self.d[c] for c in k) + (0 if sym else 1)
        carr = sum(self.carr[c] for c in k) + cv
        colsum = sum(self.cols[c] for c in k) + cols
        A = sum(self.A[c] for c in k)
        B = sum(self.B[c] for c in k)
        bad = sum(self.bad_sym[c] for c in k)
        if sym:
            b = ms[0]
            if any(x != b for x in ms):
                self.note_violation("Fact 2: symmetric node, unequal leaf counts", cid)
            if cv != sp(b, p) or sp(b, p) < 1:
                self.note_violation("Fact 2: c(v) != s_p(b) or < 1", cid)
            A += sp(b, p) - 1
            if sp(b, p) > 1:
                bad += 1
        else:
            B += cv

        cond1 = all(self.cond1[c] for c in k) and (sym or cv == 0)
        cond2 = all(self.cond2[c] for c in k) and ((not sym) or sp(ms[0], p) == 1)
        hs = [self.height[c] for c in k]
        height = hs[0] + 1 if (hs[0] >= 0 and all(h == hs[0] for h in hs)) else -1
        symkids_complete = all(self.symkids_complete[c] for c in k) and (
            (not sym) or all(h >= 0 for h in hs))
        asym_below_sym = any(self.asym_below_sym[c] for c in k) or (
            sym and any(self.d[c] > 0 for c in k))
        skel = (height >= 0) or (cv == 0 and all(self.skel[c] for c in k))
        if skel:
            if height >= 0:
                atoms = (height,)
            else:
                atoms = tuple(sorted(h for c in k for h in self.atoms[c]))
        else:
            atoms = None

        self.N.append(N)
        self.sigma.append(sigma)
        self.d.append(d)
        self.carr.append(carr)
        self.cols.append(colsum)
        self.A.append(A)
        self.B.append(B)
        self.cond1.append(cond1)
        self.cond2.append(cond2)
        self.height.append(height)
        self.symkids_complete.append(symkids_complete)
        self.asym_below_sym.append(asym_below_sym)
        self.skel.append(skel)
        self.atoms.append(atoms)
        self.bad_sym.append(bad)

        # ---- the claims of the note, checked on this class ----
        nu = (m - sp(m, p)) // (p - 1)
        t = (sp(m, p) - 1) // (p - 1)
        assert (m - sp(m, p)) % (p - 1) == 0 and (sp(m, p) - 1) % (p - 1) == 0
        if carr != nu:
            self.note_violation("Fact 1: sum c(v) != nu(m)", cid)
        if N - nu != t:
            self.note_violation("t != N - nu", cid)
        if not (d - t == nu - sigma == A + B):
            self.note_violation("Fact 3: excess formula", cid)
        if A < 0 or B < 0:
            self.note_violation("Fact 3: negative term", cid)
        if d < t:
            self.note_violation("Consequence 1: d < t", cid)
        minimal = (d == t)
        if minimal != (cond1 and cond2):
            self.note_violation("Consequence 2: d = t <=> two bullets", cid)
        if minimal != skel:
            self.note_violation("Consequence 2: d = t <=> skeleton with complete atoms", cid)
        if minimal:
            if not symkids_complete:
                self.note_violation("Consequence 2: child of symmetric node not complete", cid)
            if asym_below_sym:
                self.note_violation("Consequence 2: asymmetric node below a symmetric node", cid)
            dg = digits(m, p)
            cnt = Counter(atoms)
            if any(cnt.get(j, 0) != dg[j] for j in range(len(dg))) or any(j >= len(dg) for j in cnt):
                self.note_violation("minimal tree: atoms != digits of m", cid)


def run(p, M):
    t0 = time.time()
    C = Classes(p)
    print(f"\n=== p = {p}, up to {M} leaves ===")
    print(f"{'m':>4} {'N':>3} {'nu':>3} {'t':>3} {'classes':>9} {'minimal':>8} {'maxexc':>6} "
          f"{'sym s_p(b)>1':>12} {'asym carry>0':>12} {'cols!=amount':>12}  checks")
    total = 1
    cum = {1: 1}
    for m in range(p, M + 1, p - 1):
        ids = C.extend(m)
        N = (m - 1) // (p - 1)
        nu = (m - sp(m, p)) // (p - 1)
        t = (sp(m, p) - 1) // (p - 1)
        assert nu == vp(factorial(m), p), "Legendre"
        n_min = sum(1 for c in ids if C.d[c] == t)
        maxexc = max(C.d[c] - t for c in ids)
        n_bad = sum(1 for c in ids if C.bad_sym[c] > 0)
        n_asymcarry = sum(1 for c in ids if C.B[c] > 0)
        n_cols = sum(1 for c in ids if C.cols[c] != C.carr[c])
        # completeness of the enumeration: class of T has p^d(T) trees
        tot_trees = sum(p ** C.d[c] for c in ids)
        ok_total = (tot_trees == fuss(p, N))
        # number of minimal classes predicted from the skeleton description
        dg = digits(m, p)
        s = sum(dg)
        multinom = factorial(s)
        for a in dg:
            multinom //= factorial(a)
        pred_num = fuss(p, t) * multinom
        ok_min = (pred_num % (p ** t) == 0 and pred_num // (p ** t) == n_min)
        ok_vp = (vp(fuss(p, N), p) == t)
        total += len(ids)
        cum[m] = total
        flags = []
        flags.append("sum p^d = FussCat OK" if ok_total else "ENUMERATION INCOMPLETE")
        flags.append("#minimal = formula OK" if ok_min else "#MINIMAL MISMATCH")
        flags.append("v_p(FussCat)=t OK" if ok_vp else "v_p(FussCat) != t")
        print(f"{m:>4} {N:>3} {nu:>3} {t:>3} {len(ids):>9} {n_min:>8} {maxexc:>6} "
              f"{n_bad:>12} {n_asymcarry:>12} {n_cols:>12}  " + "; ".join(flags))
        sys.stdout.flush()
    print(f"p = {p}: {total} classes in total, {time.time() - t0:.1f}s")
    print("cumulative class counts by max leaves:", cum)
    if C.viol:
        print("VIOLATIONS FOUND:")
        for name, lst in C.viol.items():
            print("  ", name, "class ids:", lst)
            for cid in lst[:2]:
                if isinstance(cid, int) and cid < len(C.kids) and "#more" not in name:
                    print("     example tree:", C.tree(cid))
    else:
        print("no violation of any checked statement")
    return C, cum


if __name__ == "__main__":
    args = sys.argv[1:] or ["2:16", "3:21", "5:29", "7:31"]
    for a in args:
        p, M = map(int, a.split(":"))
        run(p, M)
