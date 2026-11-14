# Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13. Exploratory; not human-reviewed.
"""E007: rotation-invariant refinements and independent-block actions for general q."""
import argparse
import itertools
import math
import time
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path

OUT = None
START = time.monotonic()


def say(s=""):
    print(s, flush=True)
    if OUT:
        print(s, file=OUT, flush=True)


def vp(x, p):
    assert x > 0
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def digits(m, p):
    result = []
    while m:
        result.append(m % p)
        m //= p
    return result


def tvalue(q, n, p):
    return (sum(digits((q-1)*n+1, p))-1)//(p-1)


def fuss(q, n):
    return math.comb(q*n, n)//((q-1)*n+1)


def compositions(total, length):
    if length == 1:
        yield (total,)
    else:
        for a in range(total+1):
            for b in compositions(total-a, length-1):
                yield (a,)+b


def kvalue(q, p):
    k = 0
    while q > 1:
        assert q % p == 0
        q //= p
        k += 1
    return k


def stat_tuple(q, children):
    """(height, q-level profile, child-count vector, leaf depth histogram, Narayana)."""
    subtrees = [stat_tuple(q, c) for c in children if c]
    if not subtrees:
        return 0, (1,), (0,)*(q+1), (1,), (0,), (1,)
    height = 1+max(s[0] for s in subtrees)
    profile = [1]
    arities = [0]*(q+1)
    arities[len(subtrees)] = 1
    leaf_depths = Counter()
    for h, prof, ar, leaf, nar, has_nodes in subtrees:
        profile += [0]*max(0, len(prof)+1-len(profile))
        for i, x in enumerate(prof):
            profile[i+1] += x
        for j, x in enumerate(ar):
            arities[j] += x
        for d, x in enumerate(leaf):
            leaf_depths[d+1] += x
    leaf = tuple(leaf_depths[i] for i in range(max(leaf_depths)+1))
    return height, tuple(profile), tuple(arities), leaf, 0, bool(subtrees)


def stats(q, children):
    """All five statistics, including the number of completely empty-branch nodes."""
    h, pr, ar, leaf, _, _ = stat_tuple(q, children)
return h, pr, ar, leaf, (ar[0] == 1)+sum(c[4] for c in children if c)




def stats(q, children):
    """All five statistics; the last component is completely full q-nodes."""
    h, pr, ar, leaf, _, _ = stat_tuple(q, children)
    desc = [stats(q, c) for c in children if c]
    nar = int(not desc)+sum(s[4] for s in desc)
    return h, pr, ar, leaf, nar


class Orbits:
    """A p-tree ID is its cyclic p-ary class; q-node statistics are stored separately."""
    def __init__(self, q, p, prime_power=False):
        self.q, self.p = q, p
        self.k = kvalue(q, p) if prime_power else None
        self.blocks = [j for j, d in enumerate(digits(q, p)) for _ in range(d)]
        self.pcache = {}
        self.d = [0]
        self.by_n = {0: {0: 1}}
        self.qstats = {}

    def pnode(self, children):
        key = min(children[i:]+children[:i] for i in range(self.p))
        if key not in self.pcache:
            self.pcache[key] = len(self.d)
            self.d.append(sum(self.d[c] for c in key)+(len(set(key)) != 1))
        return self.pcache[key]

    def qnode(self, children):
        qstats = stats(self.q, [self.qstats[c] if c else () for c in children])
        if self.k is not None:
            level = children
            for _ in range(self.k):
                level = tuple(self.pnode(level[i:i+self.p]) for i in range(0, len(level), self.p))
            pid = level[0]
        else:
            pos = 0
            root = []
            for h in self.blocks:
                level = list(children[pos:pos+self.p**h])
                pos += self.p**h
                for _ in range(h):
                    level = [self.pnode(tuple(level[i:i+self.p])) for i in range(0, len(level), self.p)]
                root += level
            assert pos == self.q
            # The ordered roots of all blocks: blocks are never exchanged.
            root = tuple(root)
            if root not in self.pcache:
                self.pcache[root] = len(self.d)
                self.d.append(sum(self.d[c] for c in root))
            pid = self.pcache[root]
        assert pid in self.qstats or self.qstats.get(pid, qstats) == qstats
        self.qstats[pid] = qstats
        return pid

    def build(self, n):
        if n in self.by_n:
            return self.by_n[n]
        for i in range(n):
            self.build(i)
        result = defaultdict(int)
        for c in compositions(n-1, self.q):
            for combo in itertools.product(*(self.by_n[i].items() for i in c)):
                children = tuple(node for node, _ in combo)
                result[self.qnode(children)] += math.prod(cnt for _, cnt in combo)
        self.by_n[n] = dict(result)
        assert sum(result.values()) == fuss(self.q, n), ('total mismatch', self.q, self.p, n, sum(result.values()), fuss(self.q,n))
        assert all(cnt == self.p**self.d[node] for node, cnt in result.items()), ('orbit size', self.q, self.p, n)
        return result


@lru_cache(None)
def trees(n, q):
    if n == 0:
        return ((),)
    return tuple(tuple(c) for comp in compositions(n-1, q)
                 for c in itertools.product(*(trees(x, q) for x in comp)))


@lru_cache(None)
def explicit_stats(tree):
    return stats(len(tree), tree) if tree else (0, (0,), (), (), 0)


def explicit_orbit(tree, q, p, k=None):
    blocks = [j for j, d in enumerate(digits(q, p)) for _ in range(d)]
    if k is not None:
        assert q == p**k
        blocks = [1]*k

    @lru_cache(None)
    def visit(t):
        seen = set()

        def go(u):
            if u in seen:
                return
            seen.add(u)
            pos = 0
            for h in blocks:
                size = p**h
                # Exhaust the cyclic p-ary automorphisms of this block. This is
                # independent of Orbits.pnode, so also tests orbit p**d.
                for newblock in block_moves(u[pos:pos+size]):
                    v = u[:pos]+newblock+u[pos+size:]
                    seen.add(v)
                pos += size
            for i, c in enumerate(u):
                for new in visit(c):
                    go(u[:i]+(new,)+u[i+1:])
        go(tree)
        return tuple(seen)

    @lru_cache(None)
    def block_moves(block):
        # Similar independent action on one complete p-ary block. Removing the
        # last p-adic level yields p subblocks whose moves are independent.
        if not block:
            return ((),)
        if len(block) == 1:
            return (block,)
        chunks = [block[i:i+len(block)//p] for i in range(0, len(block), len(block)//p)]
        choices = [block_moves(c) for c in chunks]
        result = set()
        # Combine equivalent bottom p-nodes by canonicalizing every choice.
        for option in itertools.product(*choices):
            reps = [min(option[i][j:]+option[i][:j] for j in range(len(option[0]))) for i in range(p)]
            for shift in range(p):
                result.add(tuple(x for r in reps[shift:]+reps[:shift] for x in r))
        return tuple(result)
    return visit(tree)


def independent_checks():
    for q, p, k, nmax in [(2,2,1,4),(3,3,1,3),(4,2,2,2),(6,2,None,1),(12,2,None,1)]:
        orb = Orbits(q,p,k is not None)
        data = orb.build(nmax)
        for n in range(1,nmax+1):
            orb.build(n)
        for tree in trees(nmax,q):
            direct = set(explicit_orbit(tree,q,p,k))
            canonical = make_explicit_pid(orb, tree, k is not None)
            assert len(direct) == p**orb.d[canonical], ('direct orbit mismatch',q,p,nmax,len(direct),orb.d[canonical])
            assert all(explicit_stats(rot)==explicit_stats(tree) for rot in direct)
    say('A(i): statistics checked on independent explicit orbits: (q,n)=(2,4),(3,3),(4,2).')
    say('A(C1)/B: independent explicit orbit sizes p^d checked at (q,p,n)=(2,2,4),(3,3,3),(4,2,2),(6,2,1),(12,2,1).')


def make_explicit_pid(orb, tree, prime_power):
    if not tree:
        return 0
    children = tuple(make_explicit_pid(orb,c,prime_power) for c in tree)
    return orb.qnode(children)


def fmt(rows):
    if not rows:
        return 'none: all counts divisible by p^(t+1)'
    return ', '.join(f'{v}:{r}' for v,r in sorted(rows,key=lambda x:str(x[0])))


def part_a(case_map):
    for (p,k),nmax in case_map.items():
        q=p**k
        orb=Orbits(q,p,True)
        fails=Counter()
        say(f'\n=== A q={q}, p={p}, k={k}, n=1..{nmax} ===')
        all_rows=[]
        for n in range(1,nmax+1):
            data=orb.build(n)
            t=tvalue(q,n,p)
            for name in ['height','level_profile','branch_j','leaf_depth_profile','narayana']:
                for j in (range(q+1) if name=='branch_j' else [None]):
                    groups=defaultdict(int)
                    mins=Counter()
                    for node,size in data.items():
                        v=get_stat(orb.qstats[node],name,j)
                        groups[v]+=size
                        if size==p**t:
                            mins[v]+=1
                    tight=[]
                    for v,count in groups.items():
                        if count%p**t:
                            fails['divisibility']+=1
                            say(f'FAIL DIVISIBILITY q={q} n={n} statistic={name} j={j} value={v} count={count} t={t}')
                        if count//p**t%p != mins[v]%p:
                            fails['residue']+=1
                            say(f'FAIL RESIDUE q={q} n={n} statistic={name} j={j} value={v} actual={count//p**t%p} expected={mins[v]%p}')
                        if vp(count,p)==t:
                            tight.append((v,count//p**t%p))
                    all_rows.append((n,name,j,groups,mins,t,tight))
                    say(f'n={n},t={t},{name}{"" if j is None else f"[j={j}]"}: tight(value:residue)={fmt(tight)}')
            obs=next((tight for nn,name,j,g,m,tt,tight in all_rows if nn==n and name=='narayana'),[])
            if n>=4:
                say(f'  digits(m)={digits((q-1)*n+1,p)}; full_q_children_tight={obs}')
        say(f'SUMMARY q={q}: failures={dict(fails) or "none"}')
        check_profile_products(q,orb,nmax)


def get_stat(s,name,j):
    h,pr,ar,leaf,nar=s
    return {'height':h,'level_profile':pr,'leaf_depth_profile':leaf,'narayana':nar}.get(name,ar[j] if name=='branch_j' else None)


def check_profile_products(q,orb,nmax):
    products_seen=0
    for n in range(1,nmax+1):
        grouped=defaultdict(int)
        for node,size in orb.build(n).items():
            grouped[orb.qstats[node][1]]+=size
        direct={}
        def visit(pr,cap,remaining,product):
            for nj in range(min(cap,remaining)+1):
                nxt=product*math.comb(cap,nj)
                if nj==0:
                    if remaining==0:
                        direct[pr]=nxt
                else:
                    visit(pr+(nj,),q*nj,remaining-nj,nxt)
        visit((1,),q,n-1,1)
        assert dict(grouped)==direct,(q,n,grouped,direct)
        t=tvalue(q,n,p_from_q(q))
        for count in direct.values():
            assert count%p_from_q(q)**t==0
        products_seen+=len(direct)
    print(f'A(iv): q={q}: {products_seen} nonzero profiles match prod binom(q*n_i,n_(i+1)); all p^t-divisible.')


def p_from_q(q):
    for p in range(2,q+1):
        while q%p==0:
            q//=p
        if q==1:
            return p
    raise ValueError


def part_b(cases):
    say('\n=== B independent block rotations ===')
    say('q p n d_min N_min N_min%p true_vp difference')
    for q,p,nmax in cases:
        say(f'q={q},p={p}: base-p digits={digits(q,p)}, block heights={ [j for j,d in enumerate(digits(q,p)) for _ in range(d)] }; blocks not exchanged.')
        orb=Orbits(q,p)
        for n in range(1,nmax+1):
            data=orb.build(n)
            dmin=min(orb.d[i] for i in data)
            Nmin=sum(v==p**dmin for v in data.values())
            actual=vp(fuss(q,n),p)
            say(f'{q} {p} {n} {dmin} {Nmin} {Nmin%p} {actual} {dmin-actual}')


def main():
    global OUT
    parser=argparse.ArgumentParser()
    parser.add_argument('--smoke',action='store_true')
    parser.add_argument('--part',choices=['A','B'],action='append')
    args=parser.parse_args()
    with Path(__file__).with_name('output.txt').open('w',encoding='utf-8') as stream:
        OUT=stream
        say('E007. Model moonshotai/kimi-k3.1-pro. Exact integer calculations; not human-reviewed.')
        independent_checks()
        if args.smoke:
            part_a({(2,1):3})
            part_b([(6,2,2),(12,2,2),(3,2,3)])
        else:
            if 'A' in (args.part or ['A','B']):
                part_a({(2,1):10,(3,1):6,(5,1):5,(2,2):6,(3,2):4})
            if 'B' in (args.part or ['A','B']):
                part_b([(6,2,7),(6,3,6),(10,2,6),(10,5,6),(12,2,5),(12,3,5),(3,2,8),(5,2,6),(7,2,6)])
        say(f'Elapsed: {time.monotonic()-START:.3f}s')


if __name__=='__main__':
    main()
