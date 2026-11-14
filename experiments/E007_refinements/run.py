# Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13. Exploratory; not human-reviewed.
"""E007: refinements by invariant statistics and general q block actions."""
import argparse
import itertools
import math
import time
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path

START = time.monotonic()
OUT = None


def say(s=""):
    print(s, flush=True)
    if OUT:
        print(s, file=OUT, flush=True)


def vp(a, p):
    assert a > 0
    v = 0
    while a % p == 0:
        a //= p
        v += 1
    return v


def digits(m, p):
    r = []
    while m:
        r.append(m % p)
        m //= p
    return r


def target(m, p):
    return (sum(digits(m, p))-1)//(p-1)


def fuss(q, n):
    return math.comb(q*n, n)//((q-1)*n+1)


def comps(total, length):
    if length == 1:
        yield (total,)
    else:
        for a in range(total+1):
            for b in comps(total-a, length-1):
                yield (a,)+b


def plog(q, p):
    k = 0
    while q > 1:
        assert q % p == 0
        q //= p
        k += 1
    return k


def profile_sum(profiles):
    result = [1]
    for prof in profiles:
        if not prof:
            continue
        if len(prof) >= len(result):
            result += [0]*(len(prof)+1-len(result))
        for i, x in enumerate(prof):
            result[i+1] += x
    return tuple(result)


def leaf_profile(ds):
    return tuple(Counter(ds)[i] for i in range(max(ds)+1))


def all_stats(q, children, subtrees):
    """Tuple height, q-level profile, j-nonempty counts, leaf profile, Narayana."""
    arities = [0]*(q+1)
    arities[sum(c != () for c in children)] = 1
    for ar, _, _, _, _ in subtrees:
        for j, value in enumerate(ar):
            arities[j] += value
    height = 0 if not any(subtrees) else 1+max(h for _, h, _, _, _ in subtrees)
    leaf_ds = (0,) if not any(subtrees) else tuple(d+1 for _, _, _, ds, _ in subtrees for d in ds)
    return (tuple(arities), height, profile_sum(pr for _, _, pr, _, _ in subtrees),
            leaf_ds, int(not any(subtrees))+sum(n for _, _, _, _, n in subtrees))


class Orbits:
    """Exact independent p-power block orbits, with q-node statistics attached."""
    def __init__(self, q, p, prime_power=False):
        self.q, self.p = q, p
        self.blocks = [j for j, a in enumerate(digits(q, p)) for _ in range(a)]
        self.k = plog(q, p) if prime_power else None
        if prime_power:
            assert q == p**self.k
        self.cache = {}
        self.d = [0]
        self.pchildren = [()]
        self.stats = [((0,)*(q+1), 0, (), (0,), 0)]
        self.bysize = {0: {0: 1}}

    def intern(self, children, stats=None):
        key = children
        if key in self.cache:
            i = self.cache[key]
            if stats is not None:
                assert self.stats[i] == stats
            return i
        i = len(self.d)
        self.cache[key] = i
        self.pchildren.append(key)
        if stats is None:
            assert len(key) == self.p
            self.d.append(sum(self.d[c] for c in key)+(len(set(key)) != 1))
            self.stats.append(None)
        else:
            self.d.append(sum(self.d[c] for c in key))
            self.stats.append(stats)
        return i

    def pnode(self, kids):
        return self.intern(min(kids[i:]+kids[:i] for i in range(self.p)))

    def node(self, kids):
        stats = all_stats(self.q, kids, [self.stats[c] if c else self.stats[0] for c in kids])
        if self.k is not None:
            level = list(kids)
            for _ in range(self.k):
                level = [self.pnode(tuple(level[i:i+self.p])) for i in range(0, len(level), self.p)]
            return self.intern(tuple(level), stats)
        root = []
        for h in self.blocks:
            block, kids = list(kids[:self.p**h]), list(kids[self.p**h:])
            for _ in range(h):
                block = [self.pnode(tuple(block[i:i+self.p])) for i in range(0, len(block), self.p)]
            root += block
        assert not kids
        return self.intern(tuple(root), stats)

    def build(self, n):
        if n in self.bysize:
            return self.bysize[n]
        for j in range(n):
            self.build(j)
        result = defaultdict(int)
        for comp in comps(n-1, self.q):
            for combo in itertools.product(*(self.bysize[c].items() for c in comp)):
                children = tuple(node for node, _ in combo)
                result[self.node(children)] += math.prod(count for _, count in combo)
        self.bysize[n] = dict(result)
        assert sum(result.values()) == fuss(self.q, n), (self.q, self.p, n)
        return result


def value(orb, node, name, j=None):
    ar, h, pr, ds, nar = orb.stats[node]
    if name == 'height':
        return h
    if name == 'level_profile':
        return pr
    if name == 'branch_j':
        return ar[j]
    if name == 'leaf_profile':
        return leaf_profile(ds)
    if name == 'narayana':
        return nar
    raise ValueError(name)


@lru_cache(None)
def trees(n, q):
    if n == 0:
        return ((),)
    return tuple(tuple(children) for c in comps(n-1, q)
                 for children in itertools.product(*(trees(i, q) for i in c)))


@lru_cache(None)
def tree_stats(tree):
    if not tree:
        return ((0, 0), 0, (), [], 0)
    return all_stats(len(tree), tree, [tree_stats(c) for c in tree])


def discard_refinements(q):
    p = 2 if q % 2 == 0 else q
    k = plog(q, p)
    def rec(tree):
        if not tree:
            return ('leaf',)
        return ('node',) + tuple(rec(c) for c in tree)
    def moves(tree):
        if not tree:
            yield tree
            return
        for ptree in refinement_moves(rec(tree)):
            original = tuple(tuple(c) for c in unrefine(ptree, p, k)[1])
            # Independent deeper moves are supplied by recursion, not assumed.
            yield original
        for i, child in enumerate(tree):
            for changed in moves(child):
                yield tree[:i] + (changed,) + tree[i+1:]
    def refinement_moves(tree):
        if tree == ('leaf',):
            yield tree
            return
        options = [list(refinement_moves(c)) for c in tree[1:]]
        for comb in itertools.product(*options):
            groups = [list(comb[i:i+p]) for i in range(0, len(comb), p)]
            children = [('node',)+tuple(g) for g in groups]
            previous = None
            for _ in range(p):
                if children != previous:
                    yield ('node',)+tuple(children)
                previous = children
                children = children[1:]+children[:1]
    moves.cache = {}
    def unrefine(tree, p, k):
        if tree == ('leaf',):
            return 0, ()
        if k == 1:
            return 0, (tree,)
        raise NotImplementedError
    return moves


def direct_refined_rotations(q):
    """Independent enumeration of the bottom-up complete p-ary refinement."""
    p = 2 if q % 2 == 0 else q
    k = plog(q, p)

    def ref(tree):
        if not tree:
            return (0,)
        level = [ref(c) for c in tree]
        for _ in range(k):
            level = [(1, tuple(level[i:i+p])) for i in range(0, len(level), p)]
        return level[0]

    def unref(tree, depth=0):
        if tree[0] == 0:
            return (), depth
        children, depths = [], []
        for c in tree[1]:
            child, d = unref(c, depth+1)
            if d == depth+k:
                children.append(child)
            else:
                assert d is None or d == depth
                children.append(c)
        raise RuntimeError

    # Flatten the p-refinement explicitly; its q leaves are the child roots at
    # depth k, while internal children are (level, subtree) tagged structures.
    def flatten(tree):
        # Tuples of length 2 in this routine represent q-nodes and empty slots;
        # every internal node has an integer tag, removing any ambiguity.
        if tree[0] == 0:
            return ()
        if depth_of_q_node(tree):
            return tree

    def rotate_closure(root):
        pending = [ref(root)]
        seen = set()
        while pending:
            tree = pending.pop()
            if tree in seen:
                continue
            seen.add(tree)
            if tree[0] == 0:
                continue
            for shift in range(1, p):
                pending.append((1, tree[1][shift:]+tree[1][:shift]))
            for i, child in enumerate(tree[1]):
                for new in rotate_closure(child):
                    seq = list(tree[1])
                    seq[i] = new
                    pending.append((1, tuple(seq)))
        return seen

    def qrotations(root):
        pending = [((), 0)]  # not used; retained no semantic effect
        for tree in rotate_closure(root):
            # A q-node in the p-refinement is at depth zero modulo k iff it has
            # zero preceding p-ary levels. We find the unique path collecting it.
            def descend(node, d):
                if node[0] == 0:
                    return (), d
                if d == k:
                    return node, 0
                parts = [descend(c, d+1) for c in node[1]]
                if d == 0:
                    return (), tuple(v[1] for v in parts)
                return tuple(v[0] for v in parts if v[0] != ()), None
            # Easier, exact parenthesis mapping via depth-indexed slots.
            def decode(node, depth):
                if depth == 0:
                    return tuple(decode_slot(c) for c in node[1])
                if node[0] == 0:
                    return (), None
                raise AssertionError((node, depth))
            def decode_slot(entry):
                # entry is still the p-tree rooted one level below a q node.
                def walk(subtree, remaining_depth):
                    if remaining_depth == k-1:
                        return tuple(extract(c) for c in subtree[1]) if subtree[0] else ()
                    assert subtree[0] == 1
                    return tuple(walk(c, remaining_depth+1) for c in subtree)
                return tuple(extract(c) for c in flatten_at_k([entry], 1))
            def flatten_at_k(level, d):
                if d == k:
                    return level
                return [sub for c in level if c[0] for sub in c[1]], d+1
            # Use a full expanded tree as q branches, with absent branches ().
            def expand(node, d):
                if d == k:
                    return node[0] != 0, node
                if node[0] == 0:
                    return False, None
                return False, [expand(c, d+1) for c in node[1]]
            def build_q(node):
                expanded = expand(node, 0)[1]
                # Traverse level k; each location is a q-node or empty subtree.
                if k == 1:
                    return tuple(() if c[0] == 0 else build_q(c) for c in node[1])
                slots = []
                def visit(sub, depth):
                    if depth == k-1:
                        slots.append(() if sub[0] == 0 else build_q(sub))
                    elif sub[0] != 0:
                        for c in sub[1]:
                            visit(c, depth+1)
                visit(node, 0)
                return tuple(slots)
            return build_q(tree)

    return [(q, n, tree, rot) for n in range(1, 4) for tree in trees(n, q) for rot in qrotations(tree)]


def unused_old_direct_stats(q, n):
    return None


@lru_cache(None)
def old_recursive_stats(tree):
    if not tree:
        return ((0,)*len(tree) + (0,)*(2-len(tree)), 0, (), (0,), 0)
    return all_stats(len(tree), tree, [old_recursive_stats(c) for c in tree])


def part_a(case_map):
    check_stats_explicit()
    all_data = {}
    for (p, k), nmax in case_map.items():
        q = p**k
        orb = Orbits(q, p, prime_power=True)
        say(f"\n=== A q={q} p={p} k={k}; n=1..{nmax} ===")
        failures = Counter()
        for n in range(1, nmax+1):
            data = orb.build(n)
            all_data[p, k, n] = dict(data)
            t = target((q-1)*n+1, p)
            for name in ['height', 'level_profile', 'branch_j', 'leaf_depth_profile', 'narayana']:
                for j in (range(q+1) if name == 'branch_j' else [None]):
                    grouped = defaultdict(int)
                    minimal = Counter()
                    for node, size in data.items():
                        assert size == p**orb.d[node], ('C1 mismatch', q, n, node, size, orb.d[node])
                        val = value(orb, node, name, j)
                        grouped[val] += size
                        if size == p**t:
                            minimal[val] += 1
                    tight = []
                    for val, count in grouped.items():
                        if count % p**t:
                            failures['divisibility'] += 1
                            say(f"FAIL DIVISIBILITY n={n},{name},j={j},value={val},count={count},t={t}")
                        residue = count//p**t % p
                        if residue != minimal[val] % p:
                            failures['residue'] += 1
                            say(f"FAIL RESIDUE n={n},{name},j={j},value={val},residue={residue},minimal={minimal[val]}")
                        if vp(count, p) == t:
                            tight.append((val, residue))
                    label = name if j is None else f'branch_j[{j}]'
                    say(f"n={n},t={t},{label}: {fmt_tight(tight)}")
        say(f"A SUMMARY q={q}: failures={dict(failures) or 'none'}")
        check_profile_formula(q, p, k, all_data, orb)
    return all_data


def fmt_tight(rows):
    if not rows:
        return 'none (all refined counts strictly divisible by p^(t+1))'
    text = "; ".join(f"{v}:{r}" for v, r in sorted(rows, key=lambda row: str(row[0])))
    return f"tight(value:residue)={text}"


def check_profile_formula(q, p, k, all_data, orb):
    for n in range(1, max(n for pp, kk, n in all_data if (pp, kk) == (p, k))+1):
        grouped = defaultdict(int)
        for node, size in all_data[p, k, n].items():
            grouped[orb.stats[node][2]] += size
        products = {}
        def visit(pr, capacity, remaining, product):
            for nj in range(min(capacity, remaining)+1):
                count = product*math.comb(capacity, nj)
                if nj == 0:
                    if remaining == 0:
                        products[pr] = count
                else:
                    visit(pr+(nj,), q*nj, remaining-nj, count)
        visit((1,), q, n-1, 1)
        assert dict(grouped) == products, ('profile-formula mismatch', q, n)
        t = target((q-1)*n+1, p)
        assert all(count % p**t == 0 for count in products.values())
    say(f"A(iii/iv) q={q}: every profile agrees with prod binom(q*n_i,n_(i+1)) and is divisible by p^t, n<= {max(n for pp, kk, n in all_data if (pp, kk)==(p,k))}.")


def check_stats_explicit():
    # Directly rotate the q branches for q=2,3, and swap the two p-blocks for
    # q=4, recursively through children. The statistic itself is recomputed.
    for q in (2, 3, 4):
        for n in range(1, 4):
            for tree in trees(n, q):
                orbit = set()

                def visit(t):
                    if t in orbit:
                        return
                    orbit.add(t)
                    moves = [(1, 0)] if q == 2 else ([(1, 2, 0), (2, 0, 1)] if q == 3
                        else [(1, 0, 3, 2), (2, 3, 0, 1), (3, 2, 1, 0)])
                    for perm in moves:
                        visit(tuple(t[i] for i in perm))
                    for i, c in enumerate(t):
                        for new in child_orbit(c):
                            visit(t[:i]+(new,)+t[i+1:])
                def child_orbit(t):
                    if t == ():
                        return ((),)
                    pending = [t]
                    result = set()
                    while pending:
                        u = pending.pop()
                        if u in result:
                            continue
                        result.add(u)
                        moves = [(1, 0)] if q == 2 else ([(1, 2, 0), (2, 0, 1)] if q == 3
                            else [(1, 0, 3, 2), (2, 3, 0, 1), (3, 2, 1, 0)])
                        for perm in moves:
                            pending.append(tuple(u[i] for i in perm))
                        for i, c in enumerate(u):
                            for new in child_orbit(c):
                                pending.append(u[:i]+(new,)+u[i+1:])
                    return tuple(result)
                visit(tree)
                assert all(tree_stats(t) == tree_stats(tree) for t in orbit), (q, n, tree)
    say("A(i) independent direct group action q=2,3,4, n=1..3: all five statistics are invariant.")


def direct_block_classes(q, p, n):
    """Independent action and size, on all explicit trees for small cases."""
    rotations = [j for j, a in enumerate(digits(q, p)) for _ in range(a)]

    def move_at_root(tree):
        out = []
        for h in rotations:
            block = tree[:p**h]
            tree = tree[p**h:]
            level = list(block)
            for _ in range(h):
                level = [min(tuple(level[i:i+p][shift:]+level[i:i+p][:shift])
                              for shift in range(p)) for i in range(0, len(level), p)]
            # Above canonicalizes too many rotations: use recursive p-node IDs.
            out.append(block)
        assert not tree
        return tuple(out)

    def generate(tree):
        # Group elements specified as one cyclic rotation at each block node.
        # A block of size p alternates between an opaque tree and a 2-node.
        if not tree:
            return ((),)
        result = {tree}
        for h in rotations:
            pass
        # For q<=6,p<=5, at most a two-level block occurs. Implement its four
        # possible p^p slot rotations explicitly by a recursive group action.
        return tuple(result)
    return None


def part_b(cases):
    say("\n=== B: exact independent-block orbits ===")
    say("q p n d_min N_min N_min_mod_p true_vp difference")
    previous = set()
    for q, p, nmax in cases:
        if (q, p) in previous:
            continue
        previous.add((q, p))
        orb = Orbits(q, p)
        say(f"q={q},p={p}: base-p digits={digits(q,p)}, blocks={['p^'+str(j) for j in orb.blocks]}; blocks not exchanged.")
        for n in range(1, nmax+1):
            data = orb.build(n)
            dmin = min(orb.d[node] for node in data)
            sizes = [size for size in data.values() if size == p**dmin]
            actual = vp(fuss(q, n), p)
            for node, size in data.items():
                assert size == p**orb.d[node], ('orbit-size mismatch', q, p, n, node, size, orb.d[node])
            say(f"{q} {p} {n} {dmin} {len(sizes)} {len(sizes)%p} {actual} {dmin-actual}")


def main():
    global OUT
    parser = argparse.ArgumentParser()
    parser.add_argument('--smoke', action='store_true')
    parser.add_argument('--part', choices=['A', 'B'], action='append')
    args = parser.parse_args()
    with Path(__file__).with_name('output.txt').open('w', encoding='utf-8') as stream:
        OUT = stream
        say("E007. Model moonshotai/kimi-k3.1-pro. Exact integer arithmetic. Not human-reviewed.")
        if args.smoke:
            check_stats_explicit()
            part_a({(2, 1): 3})
            part_b([(6, 2, 3), (12, 2, 2), (3, 2, 3)])
        else:
            for part in args.part or ['A', 'B']:
                if part == 'A':
                    part_a({(2, 1): 10, (3, 1): 6, (5, 1): 5, (2, 2): 6, (3, 2): 4})
                else:
                    part_b([(6, 2, 7), (6, 3, 6), (10, 2, 7), (10, 5, 6),
                            (12, 2, 5), (12, 3, 5), (3, 2, 8), (5, 2, 7), (7, 2, 6)])
        say(f"Elapsed: {time.monotonic()-START:.3f}s")


if __name__ == '__main__':
    main()
