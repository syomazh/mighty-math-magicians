# Model: Kimi K3.1 Pro (Moonshot AI), 2026-11-13.
"""Independent explicit replication, without reading E000 source.

Ordered q-ary tuples represent the q-ary tree; p-ary leaves are None.
For k>1 the q-ary nodes themselves carry q=p^k children, so local
p-rotations are applied to every consecutive p-child grouping as well as
at the q-node level. All enumeration remains explicit and finite.
"""
from collections import Counter
from functools import lru_cache
from itertools import permutations
from math import factorial, comb, gcd
from time import perf_counter

CASES = ((2,1,5),(3,1,3),(5,1,2),(7,1,1))
FAILURES=[]
CHECKS=0

def check(x,msg):
    global CHECKS
    CHECKS += 1
    if not x:
        FAILURES.append(msg)
        print("FAIL",msg,flush=True)

@lru_cache(None)
def ordered(q,n):
    if n==0:
        return (None,)
    out=[]
    def rec(left,slots,parts):
        if slots==0:
            if left==0:
                out.append(tuple(parts))
            return
        for z in range(left+1):
            for c in ordered(q,z):
                rec(left-z,slots-1,parts+[c])
    rec(n-1,q,[])
    return tuple(out)

@lru_cache(None)
def pforest(p,m):
    if m==1:
        return (None,)
    if (m-1)%(p-1):
        return ()
    out=[]
    def rec(left,slots,parts):
        if slots==0:
            if left==0:
                out.append(tuple(parts))
            return
        for z in range(1,left-slots+2):
            for c in pforest(p,z):
                rec(left-z,slots-1,parts+[c])
    rec(m,p,[])
    return tuple(out)

def leaves(t):
    return 1 if t is None else sum(leaves(c) for c in t)

def rotate(t,a=()):
    if not a:
        return t[1:]+t[:1]
    return tuple(rotate(c,a[1:]) if i==a[0] else c for i,c in enumerate(t))

def addrs(t,prefix=()):
    if t is not None:
        yield prefix
        for i,c in enumerate(t):
            yield from addrs(c,prefix+(i,))

def eq(a,b):
    if a is None or b is None:
        return a is None and b is None
    return len(a)==len(b) and any(all(eq(a[i],b[(i+s)%len(b)]) for i in range(len(a))) for s in range(len(b)))

def dval(t):
    if t is None:
        return 0
    return int(any(not eq(t[0],c) for c in t[1:]))+sum(dval(c) for c in t)

def complete_height(t):
    if t is None:
        return 0
    hs=[complete_height(c) for c in t]
    if any(h is None for h in hs) or any(not eq(t[0],c) for c in t[1:]):
        return None
    return hs[0]+1

def digits(m,p):
    r=[]
    while m:
        r.append(m%p)
        m//=p
    return tuple(r)

def carry(ns,p):
    incoming=0
    result=0
    while any(ns) or incoming:
        incoming=(incoming+sum(x%p for x in ns))//p
        result+=incoming
        ns=tuple(x//p for x in ns)
    return result

def atom_obstruction(t,p,k,depth=0):
    h=complete_height(t)
    if h is not None:
        return None if depth%k==(-h)%k else f"atom height {h}, depth {depth}, k {k}"
    if all(eq(t[0],c) for c in t[1:]):
        return "symmetric non-atom"
    if carry([leaves(c) for c in t],p):
        return "carry"
    for c in t:
        z=atom_obstruction(c,p,k,depth+1)
        if z:
            return z
    return None

def atoms(t):
    h=complete_height(t)
    if h is not None:
        return Counter({h:1})
    return sum((atoms(c) for c in t),Counter())

def core(p,k,n):
    q=p**k
    m=(q-1)*n+1
    ds=digits(m,p)
    t=(sum(ds)-1)//(p-1)
    forest=ordered(q,n)
    check(len(forest)==comb(q*n,n)//m,f"C0 count {(p,k,n)}: {len(forest)}")
    check(all(leaves(x)==m for x in forest),f"C0 leaf count {(p,k,n)}")
    if k==1:
        check(set(forest)<=set(pforest(p,m)),f"C0 independent enumeration {(p,k,n)}")
    remaining=set(forest)
    groups=[]
    while remaining:
        seed=next(iter(remaining))
        g={seed}
        remaining.remove(seed)
        todo=[seed]
        while todo:
            x=todo.pop()
            for a in addrs(x):
                y=rotate(x,a)
                check(y in remaining or y in g,f"rotation left set {(p,k,n)} at {a}")
                if y not in g:
                    g.add(y)
                    remaining.remove(y)
                    todo.append(y)
        groups.append(g)
    dsx={x:dval(x) for x in forest}
    hist=Counter(dsx.values())
    check(min(hist)==t,f"C2 {(p,k,n)} min d {min(hist)} vs {t}")
    for g in groups:
        x=next(iter(g))
        check(len(g)==p**dsx[x],f"C1 {(p,k,n)} orbit size {len(g)} vs {p**dsx[x]}")
    expected=Counter({j:a for j,a in enumerate(ds)})
    for x in forest:
        if dsx[x]==t:
            check(atom_obstruction(x,p,k) is None,f"C3 minimal {(p,k,n)}: {atom_obstruction(x,p,k)}")
            check(atoms(x)==expected,f"C3 atom multiset {(p,k,n)}: {atoms(x)} vs {expected}")
    bad=[x for x in forest if atom_obstruction(x,p,k) is None and dsx[x]!=t]
    check(not bad,f"C3 converse {(p,k,n)}: {len(bad)}")
    nmin=sum(dsx[next(iter(g))]==t for g in groups)
    residue=1 if t%2==0 else p-1
    for a in ds:
        residue=residue*pow(factorial(a),-1,p)%p
    check(nmin%p==residue,f"C7 {(p,k,n)}: {nmin%p} vs {residue}")
    exact=None
    if k==1:
        den=factorial(t)*p**t
        for a in ds:
            den*=factorial(a)
        exact=factorial(p*t)//den
        check(nmin==exact,f"C8 {(p,k,n)}: {nmin} vs {exact}")
    return dict(p=p,k=k,n=n,m=m,t=t,C_n=len(forest),orbits=len(groups),min_d=min(hist),
                histogram=dict(sorted(hist.items())),N_min=nmin,N_min_mod_p=nmin%p,
                residue=residue,C8_exact=exact)

# Cyclic labelled-tree utilities.
def canonical(t):
    if isinstance(t,int) or t is None:
        return t
    cs=tuple(canonical(c) for c in t)
    return min((cs[i:]+cs[:i] for i in range(len(cs))), key=lambda x: repr(x))

def lab(t):
    if t is None:
        return ()
    if isinstance(t,int):
        return (t,)
    return sum((lab(c) for c in t),())

def relabel(t,pi):
    if isinstance(t,int):
        return pi[t]
    if t is None:
        return None
    return canonical(tuple(relabel(c,pi) for c in t))

def labelled(p,k,counts):
    total=sum(counts)
    forest=pforest(p,total)
    names=tuple(range(1,total+1))
    def cls(x):
        for c in range(k):
            if sum(counts[:c]) < x <= sum(counts[:c+1]):
                return c
        return None
    def go(t,depth,unused):
        if t is None:
            c=(-depth)%k
            return [(x,unused[:i]+unused[i+1:]) for i,x in enumerate(unused) if cls(x)==c]
        cur=[((),unused)]
        for child in t:
            nxt=[]
            for prefix,left in cur:
                for sub,rest in go(child,depth+1,left):
                    nxt.append((prefix+(sub,),rest))
            cur=nxt
        return cur
    ts=set()
    for shape in forest:
        for t,left in go(shape,0,names):
            if not left:
                ts.add(canonical(t))
    ident=tuple(range(total+1))
    fixed=[]
    for perm in permutations(range(1,total+1)):
        pi=(0,)+perm
        if pi!=ident:
            cur=pi
            order=1
            while cur!=ident:
                cur=tuple(pi[cur[j]] for j in range(total+1))
                order+=1
            if gcd(order,p)==1:
                fs=[t for t in ts if relabel(t,pi)==t]
                if fs:
                    fixed.append((pi,fs))
    row=dict(p=p,k=k,counts=counts,T=len(ts),literal_fixed=len(fixed))
    valid=[c for c,a in enumerate(counts) if a>=p]
    if valid:
        c=valid[0]
        chosen=tuple(range(sum(counts[:c])+1,sum(counts[:c])+p+1))
        pi=list(range(total+1))
        for i,x in enumerate(chosen):
            pi[x]=chosen[(i+1)%p]
        pi=tuple(pi)
        fixedp={t for t in ts if relabel(t,pi)==t}
        cherries={t for t in ts if hascherry(t,chosen)}
        check(fixedp==cherries,f"C5 fixed=cherry {(p,k,counts)}")
        red=list(counts)
        red[c]-=p
        red[(c+1)%k]+=1
        # Count the reduced class by the same explicit recursion when possible.
        if sum(red)>1:
            reduced=labelled(p,k,tuple(red))["T"]
        else:
            reduced=1
        check(len(fixedp)==(p-1)*reduced,f"C5 collapse count {(p,k,counts)}: {len(fixedp)} vs {(p-1)*reduced}")
        check(len(ts)%p==(-reduced)%p,f"C5 recursion {(p,k,counts)}: {len(ts)%p} vs {-reduced%p}")
        check(not fixed,f"C4 non-p-order fixed points {(p,k,counts)}: {len(fixed)}")
        row.update(fixed=len(fixedp),collapsed=reduced,T_mod_p=len(ts)%p,expected_mod_p=-reduced%p)
    return row

def hascherry(t,chosen):
    if t is None or isinstance(t,int):
        return False
    if set(lab(t))==set(chosen):
        return True
    return any(hascherry(c,chosen) for c in t)

def main():
    start=perf_counter()
    print("Independent explicit replication; E000 source was not read.",flush=True)
    for p,k,last in CASES:
        for n in range(1,last+1):
            print("CORE",core(p,k,n),flush=True)
    for args in [(2,1,(5,)),(2,2,(2,2)),(3,2,(1,2)),(2,3,(2,0,0))]:
        print("LABELLED",labelled(*args),flush=True)
    print("ELAPSED_SECONDS",round(perf_counter()-start,3),flush=True)
    print("CHECKS",CHECKS,"FAILURES",len(FAILURES),flush=True)
    for x in FAILURES:
        print("FAILURE",x,flush=True)

if __name__=="__main__":
    main()
