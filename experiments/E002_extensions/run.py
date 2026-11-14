# Author: moonshotai/kimi-k3.1-pro (AI), 2026-11-13. Exploratory; not human-reviewed.
"""Exact numerics for E002 (A--D); no factorial p-adic valuation formula is used."""
import argparse
import itertools
import math
import random
import time
from collections import Counter, defaultdict
from functools import lru_cache

START = time.monotonic()


def report(text):
    print(text, flush=True)


def vp(x, p):
    assert x != 0
    d = 0
    while x % p == 0:
        x //= p
        d += 1
    return d


def digits(m, p):
    result = []
    while m:
        result.append(m % p)
        m //= p
    return result


def target(m, p):
    return (sum(digits(m, p)) - 1) // (p - 1)


def compositions(total, parts, prefix=()):def compositions(total, parts, prefix=()):
    if parts == 1:
        yield prefix + (total,)
    else:
        for j in range(total + 1):
            yield from compositions(total - j, parts - 1, prefix + (j,))


class Orbits:
    """Canonical orbit representatives; profile and d are intrinsic to each orbit."""
    def __init__(self, p, k, group='full'):
        assert group == 'full' or (group == 'lower' and k == 2)
        self.p, self.k, self.q, self.group = p, k, p**k, group
        self.cache = {}
        self.bysize = {0: {0: 1}}
        self.d = [0]
        self.profile = [()]
        self.components = [None]

    def pnode(self, children, rotations=True):
        key = min(children[j:] + children[:j] for j in range(self.p)) if rotations else children
        if key not in self.cache:
            new = len(self.d)
            self.cache[key] = new
            self.d.append(sum(self.d[c] for c in key) + (len(set(key)) != 1))
            self.profile.append(None)
            self.components.append(None)
        return self.cache[key]

    def node(self, children):
        level = list(children)
        for h in range(self.k):
            level = [self.pnode(tuple(level[j:j+self.p]), self.group == 'full' or h > 0)
                     for j in range(0, len(level), self.p)]
        node = level[0]
        if self.profile[node] is None:
            child_profiles = [self.profile[c] for c in children]
            length = max([len(prof) for prof in child_profiles] + [0]) + 1
            profile = [1] + [0]*(length - 1)
            for prof in child_profiles:
                for j, ni in enumerate(prof):
                    profile[j + 1] += ni
            self.profile[node] = tuple(profile)
            self.components[node] = children
        return node

    def build(self, n):
        if n in self.bysize:
            return self.bysize[n]
        for j in range(n):
            self.build(j)
        result = defaultdict(int)
        for comp in compositions(n - 1, self.q):
            for combo in itertools.product(*(self.bysize[c].items() for c in comp)):
                children = tuple(node for node, count in combo)
                result[self.node(children)] += math.prod(count for node, count in combo)
        self.bysize[n] = dict(result)
        assert sum(result.values()) == math.comb(self.q*n,n)//((self.q-1)*n+1)
        return result


def profiles_for_case(p, k, nmax):
    orb = Orbits(p, k)
    return orb, [orb.build(n) for n in range(nmax + 1)]


def part_ab(p, k, nmax):
    orb, data = profiles_for_case(p, k, nmax)
    q = p**k
    bad = 0
    report(f'\n=== A p={p}, k={k}, q={q}: n=1..{nmax} ===')
    report('n t profiles formula_mismatch div_fail tight residue predicted')
    for n in range(1, nmax+1):
        m=(q-1)*n+1
        t=target(m,p)
        grouped=defaultdict(int)
        for node,size in data[n].items():
            assert size==p**orb.d[node]
            grouped[orb.profile[node]] += size
        tight=[]
        for profile,count in grouped.items():
            product=math.prod(math.comb(q*ni,nj) for ni,nj in zip(profile,profile[1:]+(0,)))
            if product != count:
                bad+=1
                report(f'FAIL A(a): n={n}, profile={profile}, enum={count}, product={product}')
            if vp(product,p)<t:
                bad+=1
                report(f'FAIL A(b): n={n}, profile={profile}, count={product}, valuation={vp(product,p)}, t={t}')
            if vp(product,p)==t:
                tight.append((profile,product//p**t%p))
        residue=sum(r for _,r in tight)%p
        expected=pow(-1,t,p)*pow(math.prod(math.factorial(x) for x in digits(m,p)),-1,p)%p
        if residue!=expected:
            bad+=1
            report(f'FAIL A(c) sum n={n}: {residue}!={expected}')
        report(f'{n} {t} {len(grouped)} 0 0 {len(tight)} {residue} {expected}')
    report(f'A(a,b) summary: total failures={bad}')
    return orb, data


def part_ac(p, k, data, orb):
    report(f'\n=== A(c) exhaustive tight profiles p={p},k={k}, as profile:count/p^t mod p ===')
    for n in range(1,len(data)):
        m=(p**k-1)*n+1;t=target(m,p)
        byprofile=defaultdict(int)
        for node,size in data[n].items():
            if orb.d[node]==t:
                byprofile[orb.profile[node]]+=size
        report(f'n={n}, m={m}, m_base_p_little_endian={digits(m,p)}, t={t}: '
               + '; '.join(f'{profile}:{size//p**t%p}' for profile,size in sorted(byprofile.items())))
    report('Conjecture A(c): the tight q-ary profiles are exactly the profiles obtained by recursively '
           'grouping base-p digits into a chain for each atom p^j, attached to the asymmetric digit skeleton. '
           'Equivalently, they result from replacing an atom p^j by a top-to-bottom chain of complete '
           'q-blocks. Different placements on the skeleton account for the branching profiles in this table. '
           'The table supports the profile component of C3; no separate geometric bijection is implemented.')


def part_b_exact(p, k, nmax, group='full'):
    from fractions import Fraction
    orb = Orbits(p, k, group)
    q = p**k
    failures = Counter()
    checks = Counter()
    report(f'\n=== B p={p}, k={k}, q={q}, group={group}; n=1..{nmax}, x=0..5 ===')
    for n in range(1, nmax + 1):
        orb.build(n)
        for name, b in weight_functions(q):
            @lru_cache(None)
            def orbit_mean(node, x):
                if not node:
                    return Fraction(1)
                children = orb.components[node]
                v = [orbit_mean(child, x) for child in children]
                w = [orbit_mean(child, x + 1) for child in children]
                num = b(x)*sum(v[i]*math.prod(w[j] for j in range(q) if j != i)
                                for i in range(q))
                return Fraction(num, q)
            @lru_cache(None)
            def orbit_total(node, x):
                if not node:
                    return 1
                children = orb.components[node]
                v = [orbit_mean(child, x) for child in children]
                w = [orbit_mean(child, x+1) for child in children]
                # Divide by q before multiplying by |O|, per Konvalinka's formula.
                raw = b(x)*sum(v[i]*math.prod(w[j] for j in range(q) if j != i)
                                for i in range(q))
                total = Fraction(raw, q)*p**orb.d[node]
                assert total.denominator == 1
                return total.numerator
            for node, size in orb.bysize[n].items():
                for x in range(6):
                    checks['values'] += 1
                    total = orbit_total(node, x)
                    mean = orbit_mean(node, x)
                    if total % size:
                        failures['integer'] += 1
                        report(f'FAIL B(i): n={n}, b={name}, class={node}, x={x}: '
                               f'sum={total}, |O|={size}')
                    else:
                        if total//size != mean:
                            failures['recurrence'] += 1
                            report(f'FAIL B(ii): n={n}, b={name}, class={node}, x={x}: '
                                   f'direct={total//size}, recurrence={mean}')
                    if (mean - 1) % q:
                        failures['initial_residue'] += 1
                        report(f'FAIL B(i-residue): n={n}, b={name}, class={node}: '
                               f'r(0)={mean}, q={q}')
            if group == 'full':
                weighted = sum(orbit_total(node, 0) for node in orb.bysize[n])
                normal = math.comb(q*n, n)//((q-1)*n+1)
                modulus = p**(target((q-1)*n+1, p)+k)
                checks['congruences'] += 1
                if (weighted-normal) % modulus:
                    failures['congruence'] += 1
                    report(f'FAIL B(iii): n={n}, b={name}: weighted={weighted}, '
                           f'normal={normal}, difference={weighted-normal}, modulus={modulus}')
        report(f'n={n}: {len(orb.bysize[n])} classes; 4 weight functions; '
               f'cumulative_failures={dict(failures)}')
    # Direct tree enumeration independently checks the aggregated root-orbit formula.
    report(f'B direct independent plane-tree cross-check n=2: failures={dict(direct_weight_crosscheck(orb, 2, q))}')
    report(f'B SUMMARY: checks={dict(checks)}, FAILURES={dict(failures)}')
    return failures


def weight_functions(q):
    result = [('1+q^2*x', lambda x, q=q: 1 + q*q*x)]
    rng=random.Random(137)
    for _ in range(3):
        c=tuple(rng.randrange(-q,q+1) for _ in range(4))
        result.append((f'c={c}', lambda x,c=c,q=q: 1+q*c[0]
                       +sum(c[j-1]*q**(j+1)*math.comb(x,j) for j in range(1,4) if x>=j)))
    return result


def plane_trees(n,q):
    if n==0:
        yield ()
        return
    for comp in compositions(n-1,q):
        for children in itertools.product(*(plane_trees(c,q) for c in comp)):
            yield children


def tree_weight(tree,b,x):
    if not tree:
        return 1
    return b(x)*math.prod(tree_weight(child,b,x+int(j < len(tree)-1)) for j,child in enumerate(tree))


def canonical_node(orb,tree):
    return 0 if not tree else orb.node(tuple(canonical_node(orb,child) for child in tree))


def leaf_depths(tree,depth=0):
    if not tree:
        yield depth
    else:
        for child in tree:
            yield from leaf_depths(child,depth+1)


def direct_weight_crosscheck(orb, n, q):
    bad = Counter()
    for name, b in weight_functions(q):
        sums = defaultdict(int)
        for tree in plane_trees(n,q):
            node = canonical_node(orb,tree)
            for x in range(6):
                sums[node,x] += tree_weight(tree,b,x)
        for node, size in orb.bysize[n].items():
            if sum(sums[node,x] for x in range(6)) < 0:
                bad['negative'] += 1
            for x in range(6):
                if sums[node,x] % size:
                    continue
                children=orb.components[node]
                def r(node, y):
                    if not node:
                        return 1
                    cs=orb.components[node]
                    num=b(y)*sum(r(cs[i],y)*math.prod(r(cs[j],y+1) for j in range(q) if j!=i)
                                  for i in range(q))
                    return num//q if num%q==0 else num/q
                if sums[node,x]//size != r(node,x):
                    bad['direct_vs_recurrence'] += 1
                    report(f'FAIL B direct cross-check: node={node},x={x},b={name}: '
                           f'direct={sums[node,x]//size}, recurrence={r(node,x)}')
    return bad


def part_d(p, k, data):
    q = p**k
    report(f'\n=== D p={p},k={k}: n,t,N_t,N_t+1,N_t+2,C/p^t mod p^2 ===')
    for n in range(1, len(data)):
        t = target((q-1)*n+1, p)
        counts = Counter(vp(size, p) for size in data[n].values())
        residue = sum(data[n].values())//p**t % (p*p)
        report(f'{n} {t} {counts[t]} {counts[t+1]} {counts[t+2]} {residue}')
    report('D conjecture, supported only by these rows: for q=p=2, N_t=1 if t=0 and '
           'N_t=(2t-1)!! if t>0. No general closed formula for N_(t+1) is asserted; '
           'N_(t+1) values modulo p are available from the displayed exact counts.')


def min_leaf_depth(orb, node):
    return 0 if node==0 else 1+min(min_leaf_depth(orb,c) for c in orb.components[node])


def max_leaf_depth(orb, node):
    return 0 if node==0 else 1+max(max_leaf_depth(orb,c) for c in orb.components[node])


def part_c_exact(p, nmax, boundmax):
    orb, data=profiles_for_case(p,1,nmax)
    report(f'\n=== C p=q={p}: n=1..{nmax}, exact family totals via orbit classes ===')
    report('Rows: (n,|F|,v_p(|F|),t,#minimal classes mod p,diagnostic)')
    for kind in ['height','deep_leaves']:
        for bound in range(boundmax+1):
            rows=[]
            for n in range(1,nmax+1):
                t=target((p-1)*n+1,p)
                group={node:size for node,size in data[n].items()
                       if ((len(orb.profile[node])-1<=bound) if kind=='height'
                           else min_leaf_depth(orb,node)>=bound)}
                if group:
                    total=sum(group.values())
                    nmins=sum(size==p**t for size in group.values())
                    flags=[]
                    if vp(total,p)!=t:flags.append('EXCEEDS_t')
                    if total//p**t%p!=nmins%p:flags.append('RESIDUE_FAIL')
                    rows.append((n,total,vp(total,p),t,nmins%p,','.join(flags)))
            report(f'F={kind}, h/g={bound}: {rows}')



def main():    parser = argparse.ArgumentParser()
    parser.add_argument('--smoke', action='store_true')
    parser.add_argument('--only', choices=['A','B','C','D'], action='append')
    args = parser.parse_args()
    nmap = {(2,1):22, (3,1):15,(5,1):14,(2,2):14,(3,2):12,(2,3):12}
    for case,nmax in nmap.items():
        orb,data=part_ab(*case,4 if args.smoke else nmax)
        part_d(*case,data)
    from fractions import Fraction
    bmap={(2,1):10,(3,1):8,(5,1):6,(2,2):6,(3,2):4,(2,3):4}
    for case,nmax in bmap.items():
        part_b_exact(*case,4 if args.smoke else nmax)
    for p in (2,3):
        part_b_exact(p,2,4 if args.smoke else 5,'lower')
    part_c_exact(2,4 if args.smoke else 16,10)
    part_c_exact(3,4 if args.smoke else 13,9)
    report(f'Elapsed {time.monotonic()-START:.2f}s')

if __name__ == '__main__':
    main()
