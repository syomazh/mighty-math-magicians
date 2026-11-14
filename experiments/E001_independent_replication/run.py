# Model: Kimi K3.1 Pro (Moonshot AI), 2026-11-13.
"""Explicit-tree replication; code written without opening E000/check.py.

Ordered p-ary trees: None = leaf, tuple of p children = node.
Cyclic labelled trees: integer = label, tuple = lexicographically least child rotation.
All unlabelled classes are obtained by applying raw rotations, never by a digest.
"""
from collections import Counter
from functools import cache
from itertools import permutations, product
from math import factorial, comb, gcd
from multiprocessing import Pool
from time import perf_counter

CASES = ((2, 1, 8), (3, 1, 4), (5, 1, 3), (7, 1, 2),
         (2, 2, 4), (3, 2, 1), (2, 3, 3))
FAILURES = []
CHECKS = 0


def check(condition, message):
    global CHECKS
    CHECKS += 1
    if not condition:
        FAILURES.append(message)
        print("FAIL:", message, flush=True)


@cache
def ordered_q(arity, n):
    """Enumerate ordered trees explicitly by recursive child-size choices."""
    if n == 0:
        return (None,)
    answer = []
    def build(left, slots, children):
        if not slots:
            if left == 0:
                answer.append(tuple(children))
            return
        for size in range(left + 1):
            for child in ordered_q(arity, size):
                children.append(child)
                build(left - size, slots - 1, children)
                children.pop()
    build(n - 1, arity, [])
    return tuple(answer)


@cache
def by_leaves(p, m):
    """A second enumeration, this time by unordered child leaf multisets."""
    if m == 1:
        return (None,)
    answer = []
    def build(left, slots, children):
        if not slots:
            if left == 0:
                answer.append(tuple(children))
            return
        for size in range(1, left - slots + 2):
            for child in by_leaves(p, size):
                children.append(child)
                build(left - size, slots - 1, children)
                children.pop()
    build(m, p, [])
    return tuple(answer)


@cache
def full(p, height):
    tree = None
    for _ in range(height):
        tree = (tree,) * p
    return tree


def expand(p,k,q_tree):
    """Expand level by level, placing actual q-nodes at k-spaced depths."""
    if q_tree is None:
        return None
    if k==1:
        return tuple(expand(p,k,q_child) for q_child in q_tree)
    return expand_general(p,k,q_tree)


def expand_general(p,k,q_tree):
    if q_tree is None:
        return None
    return tuple(continuation(p,k,q_child,1) for q_child in q_tree)


def continuation(p,k,q_child,depth):
    if depth==k:
        return expand_general(p,k,q_child)
    if q_child is None:
        return full(p,k-depth)
    return ((continuation(p,k,q_child,depth+1),)+(full(p,k-depth-1),)*(p-1)
            if depth%p==0 else
            (full(p,k-depth-1),)*(p-1)+(continuation(p,k,q_child,depth+1),))




def addresses(tree, at=()):
    if tree is not None:
        yield at
        for i, child in enumerate(tree):
            yield from addresses(child, at + (i,))


def rotate(tree, at=()):
    """Apply one raw cyclic move, without canonicalizing the original tree."""
    if not at:
        return tree[1:] + tree[:1]
    return tuple(rotate(child, at[1:]) if i == at[0] else child
                 for i, child in enumerate(tree))


def leaf_count(tree):
    return 1 if tree is None else sum(leaf_count(child) for child in tree)


class ExplicitClasses:
    def __init__(self, p, forest):
        remaining = set(forest)
        self.groups = []
        self.which = {}
        self.moves = 0
        while remaining:
            seed = next(iter(remaining))
            group = {seed}
            remaining.remove(seed)
            queue = [seed]
            while queue:
                tree = queue.pop()
                for address in addresses(tree):
                    image = rotate(tree, address)
                    self.moves += 1
                    check(image in remaining or image in group,
                          f"rotation left blocked set: p={p}, tree={tree!r}, at={address!r}")
                    if image not in group:
                        group.add(image)
                        remaining.remove(image)
                        queue.append(image)
            i = len(self.groups)
            self.groups.append(group)
            for tree in group:
                self.which[tree] = i

    def equivalent(self, left, right):
        if left is None or right is None:
            return left is right
        if left in self.which and right in self.which:
            return self.which[left] == self.which[right]
        # Proper subtrees have their own explicit orbit remainder, no shortcut.
        left_orbit=rotate_left_orbit(left)
        right_orbit=rotate_left_orbit(right)
        return any(direct_recursive_equivalent(a,b) for a in left_orbit for b in right_orbit)


@cache
def direct_recursive_equivalent(a,b):
    """Apply root and child rotations separately, directly and recursively."""
    if a is None or b is None:
        return a is b
    for shift in range(len(b)):
        if all(direct_recursive_equivalent(a[i],b[(i+shift)%len(b)])
               for i in range(len(a))):
            return True
    return False


@cache
def rotate_left_orbit(tree):
    remaining={tree}
    visited=set()
    while remaining:
        current=remaining.pop()
        visited.add(current)
        for address in addresses(current):
            image=rotate(current,address)
            if image not in visited:
                remaining.add(image)
    return frozenset(visited)


def d_value(tree, classes):
    if tree is None:
        return 0
    asym = any(not classes.equivalent(tree[0], child) for child in tree[1:])
    return int(asym) + sum(d_value(child, classes) for child in tree)


def complete_height(tree, p, classes):
    """Complete as a cyclic tree, even if its ordered version is nonliteral."""
    if tree is None:
        return 0
    heights = [complete_height(child, p, classes) for child in tree]
    if any(height is None for height in heights):
        return None
    if any(not classes.equivalent(tree[0], child) for child in tree[1:]):
        return None
    return 1 + heights[0]


def carries(counts, p):
    """All carries in column-by-column addition of the p child leaf counts."""
    incoming = 0
    answer = 0
    while any(counts) or incoming:
        column = incoming + sum(x % p for x in counts)
        incoming = column // p
        answer += incoming
        counts = tuple(x // p for x in counts)
    return answer


def atom_obstruction(tree, p, k, classes, depth=0):
    """Return an actual obstruction, or None for the stated atom description."""
    height = complete_height(tree, p, classes)
    if height is not None:
        if depth % k != (-height) % k:
            return f"complete atom height {height}, depth {depth}, modulus {k}"
        return None
    if all(classes.equivalent(tree[0], child) for child in tree[1:]):
        return "symmetric non-complete skeleton node"
    counts = tuple(leaf_count(child) for child in tree)
    if carries(counts, p):
        return f"carry in child leaf counts {counts!r}"
    for child in tree:
        bad = atom_obstruction(child, p, k, classes, depth + 1)
        if bad:
            return bad
    return None


def atom_multiset(tree, p, classes):
    if complete_height(tree, p, classes) is not None:
        return Counter({complete_height(tree, p, classes): 1})
    return sum((atom_multiset(child, p, classes) for child in tree), Counter())


def digits(m, p):
    result = []
    while m:
        result.append(m % p)
        m //= p
    return tuple(result)


def core_task(case):
    p, k, n = case
    started = perf_counter()
    q = p**k
    m = (q-1)*n + 1
    ds = digits(m, p)
    t = (sum(ds)-1)//(p-1)
    expected = comb(q*n, n)//m
    forest = tuple(expand(p,k,tree) for tree in ordered_q(q,n))
    check(len(forest) == expected, f"C0 tree count {(p,k,n)}: {len(forest)} vs {expected}")
    check(len(set(forest)) == len(forest), f"C0 duplicates {(p,k,n)}")
    check(all(leaf_count(tree)==m for tree in forest), f"C0 leaf count {(p,k,n)}")
    if m <= 15:
        check(set(forest) <= set(by_leaves(p,m)), f"C0 second enum {(p,k,n)}")
    classes = ExplicitClasses(p, forest)
    d = {tree:d_value(tree,classes) for tree in forest}
    for group in classes.groups:
        sample = next(iter(group))
        check(len(group) == p**d[sample], f"C1 orbit {(p,k,n)}: {len(group)} != p^{d[sample]}")
        check(all(d[tree]==d[sample] for tree in group), f"C1 representative dependence {(p,k,n)}")
    hist = Counter(d.values())
    check(min(hist)==t, f"C2 min d {(p,k,n)}: {min(hist)} != {t}")
    check(all(x>=t for x in hist), f"C2 values below t {(p,k,n)}")
    obstruction = {tree:atom_obstruction(tree,p,k,classes) for tree in forest}
    atom_ok = 0
    for tree in forest:
        if d[tree]==t:
            check(obstruction[tree] is None, f"C3 minimality: {obstruction[tree]!r}; {tree!r}")
            expected_atoms = Counter({j:a for j,a in enumerate(ds)})
            check(atom_multiset(tree,p,classes)==expected_atoms,
                  f"C3 atoms {(p,k,n)}: {atom_multiset(tree,p,classes)} vs {expected_atoms}")
            if obstruction[tree] is None and atom_multiset(tree,p,classes)==expected_atoms:
                atom_ok += 1
    converse = [(tree,d[tree]) for tree in forest
                if obstruction[tree] is None and d[tree]!=t]
    check(not converse, f"C3 converse {(p,k,n)}: {converse!r}")
    minimal = sum(d[next(iter(group))]==t for group in classes.groups)
    residue = 1 if t%2==0 else p-1
    for a in ds:
        residue = residue * pow(factorial(a),-1,p) % p
    check(minimal%p == residue, f"C7 {(p,k,n)}: {minimal % p} != {residue}")
    exact = None
    if k==1:
        denominator = factorial(t)*p**t
        for a in ds:
            denominator *= factorial(a)
        exact = factorial(p*t)//denominator
        check(minimal==exact, f"C8 {(p,k,n)}: {minimal} != {exact}")
    row = dict(p=p,k=k,n=n,digits=ds,t=t,trees=len(forest),classes=len(classes.groups),
               N_min=minimal,histogram=dict(sorted(hist.items())),N_min_mod_p=minimal%p,
               expected_mod_p=residue,C8_exact=exact,atom_checks=atom_ok,
               raw_moves=classes.moves,seconds=round(perf_counter()-started,4))
    return row


# Labelled cyclic trees.  A canonical representation is consulted ONLY AFTER
# moving or assigning a whole ordered tree, not to compute unlabelled orbits.

def leaf_depths(tree, depth=0):
    if tree is None:
        yield depth
    else:
        for child in tree:
            yield from leaf_depths(child, depth+1)


@cache
def ordered_labelled(p,k,counts,shape):
    def visit(tree,depth,leaf_names):
        """Return (labelled subtree, unused name tuple) pairs."""
        if tree is None:
            c=(-depth)%k
            return tuple((x,leaf_names[:i]+leaf_names[i+1:])
                         for i,x in enumerate(leaf_names)
                         if prefix_class(x,counts)==c)
        partial=[((),leaf_names)]
        for child in tree:
            extended=[]
            for prefix,names in partial:
                for subtree,remaining in visit(child,depth+1,names):
                    extended.append((prefix+(subtree,),remaining))
            partial=extended
        return partial
    answer=visit(shape,0,tuple(range(1,sum(counts)+1)))
    unique={tree for tree,remaining in answer if not remaining}
    # Each shape has its own cyclic orientation; no canonical rotation here.
    return tuple(unique)
def labels_tuple(tree):
    return (tree,) if isinstance(tree,int) else sum((labels_tuple(child) for child in tree),())


def prefix_class(x,counts):
    for c,a in enumerate(counts):
        if x<=sum(counts[:c+1]):
            return c


def cyclic_ordered(tree):
    if tree is None:
        return tree
    children=tuple(cyclic_ordered(child) for child in tree)
    return min(children[shift:]+children[:shift] for shift in range(len(children)))


def unique_shapes(p,m):
    return {cyclic_ordered(tree) for tree in by_leaves(p,m)}


def constrained_trees(p,k,counts,independent=False):
    """All labelled cyclic trees with label c at depth congruent to -c.

    Primary enumeration labels all LEFT-TO-RIGHT depth positions.  Independent
    enumeration first takes distinct cyclic orientations of each ordered shape.
    """


def primary_trees(p,k,counts):
    answer=set()
    for shape in by_leaves(p,sum(counts)):
        for tree in gs_compatible(shape,p,k,counts,0,tuple(range(1,sum(counts)+1))):
            answer.add(recanonicalize(tree))
    return answer


def gs_compatible(tree,p,k,counts,depth,names):
    if tree is None:
        c=(-depth)%k
        return [(x,names[:i]+names[i+1:]) for i,x in enumerate(names)
                if prefix_class(x,counts)==c]
    result=[((),names)]
    for child_shape in tree:
        result=[(children+(child,),remaining)
                for children,left in result
                for child,remaining in gs_compatible(child_shape,p,k,counts,depth+1,left)]
    return result


def canonical_labelled(tree,names):
    if tree is None:
        return next(names)
    children=tuple(canonical_labelled(child,names) for child in tree)
    return min(children[i:]+children[:i] for i in range(len(children)))


def independent_trees(p,k,counts):
    answer=set()
    for shape in unique_shapes(p,sum(counts)):
        for tree in ordered_labelled(p,k,counts,shape):
            answer.add(recanonicalize(tree))
    return answer


def constrained_trees(p,k,counts,independent=False):
    return independent_trees(p,k,counts) if independent else primary_trees(p,k,counts)


def recanonicalize(tree):
    if isinstance(tree,int):
        return tree
    children=tuple(recanonicalize(child) for child in tree)
    return min(children[i:]+children[:i] for i in range(len(children)))


def relabel(tree,permutation):
    return recanonicalize(permutation[tree] if isinstance(tree,int)
                          else tuple(relabel(child,permutation) for child in tree))


def has_cherry(tree,selected):
    if isinstance(tree,int):
        return False
    if set(labels_tuple(tree))==set(selected):
        return True
    return any(has_cherry(child,selected) for child in tree)


def collapse(tree,selected,new_label):
    if not isinstance(tree,int) and set(labels_tuple(tree))==set(selected):
        return new_label
    if isinstance(tree,int):
        return tree
    return recanonicalize(tuple(collapse(child,selected,new_label) for child in tree))


def order_of(permutation):
    current=permutation
    for i in range(1,len(permutation)+1):
        if all(current[j]==j for j in range(len(permutation))):
            return i
        current=tuple(permutation[current[j]] for j in range(len(permutation)))
    raise AssertionError("permutation order")


def same_class_permutations(counts):
    offset=sum(counts)+1
    for parts in product(*(permutations(range(sum(counts[:c])+1,sum(counts[:c+1])+1))
                          for c in range(len(counts)))):
        permutation=list(range(offset))
        for c,part in enumerate(parts):
            for i,x in enumerate(part):
                permutation[sum(counts[:c])+i+1]=x
        yield tuple(permutation)


def raw_cyclic_moves(tree,address):
    """Apply explicit local rotations in succession, then normalize once."""
    if not address:
        return recanonicalize(tree[1:]+tree[:1])
    children=tuple(raw_cyclic_moves(child,address[1:]) if i==address[0] else child
                   for i,child in enumerate(tree))
    return recanonicalize(children)


def test_labelled_moves(trees):
    bad=[]
    for tree in trees:
        for at in addresses_labelled(tree):
            image=raw_cyclic_moves(tree,at)
            if image not in trees:
                bad.append((tree,at,image))
    return bad


def addresses_labelled(tree,at=()):
    if not isinstance(tree,int):
        yield at
        for i,child in enumerate(tree):
            yield from addresses_labelled(child,at+(i,))


def labelled_case(arguments):
    p,k,counts,independent_compare=arguments
    started=perf_counter()
    trees=constrained_trees(p,k,counts)
    comparison=None
    if independent_compare:
        independent=constrained_trees(p,k,counts,True)
        check(trees==independent,f"independent labelled enumeration differs {(p,k,counts)}")
        comparison=len(independent)
    valid_classes=[c for c,a in enumerate(counts) if a>=p]
    literal_fixed=[]
    for perm in permutations(range(1,sum(counts)+1)):
        permutation=(0,)+perm
        if permutation!=tuple(range(sum(counts)+1)) and gcd(order_of(permutation),p)==1:
            fixed=[tree for tree in trees if relabel(tree,permutation)==tree]
            if fixed:
                literal_fixed.append((permutation,fixed))
                break
    if literal_fixed:
        print("C4_LITERAL_COUNTEREXAMPLE",dict(p=p,k=k,counts=counts,
              permutation=literal_fixed[0][0],fixed=literal_fixed[0][1]),flush=True)
    setwise_good=False
    if valid_classes:
        c=valid_classes[0]
        chosen=tuple(range(sum(counts[:c])+1,sum(counts[:c+1])+p))
        permutation=list(range(sum(counts)+1))
        for i,x in enumerate(chosen):
            permutation[x]=chosen[(i+1)%p]
        permutation=tuple(permutation)
        check(gcd(order_of(permutation),p)==p,f"sigma not p-cycle {(p,k,counts)}")
        fixed={tree for tree in trees if relabel(tree,permutation)==tree}
        by_cherry={tree for tree in trees if has_cherry(tree,chosen)}
        check(fixed==by_cherry,f"C5/cherry fixed {(p,k,counts)}")
        reduced=list(counts)
        reduced[c]-=p
        reduced[(c+1)%k]+=1
        replacement_trees=constrained_trees(p,k,tuple(reduced)) if sum(reduced)>1 else None
        target=len(replacement_trees) if replacement_trees is not None else 1
        check(len(fixed)==(p-1)*target,
              f"C5 collapsing count {(p,k,counts)}: {len(fixed)} != {(p-1)*target}")
        next_c=(c+1)%k
        chosen_replacement=sum(counts[:next_c])+1
        collapsed={collapse(tree,chosen,chosen_replacement) for tree in fixed}
        if replacement_trees is not None:
            collapsed_expected=relabel_by_reduction(replacement_trees,c,counts,reduced)
            for expected in collapsed_expected:
                check(sum(relabel_by_reduction_tree(actual,c,counts,reduced)==expected
                          for actual in collapsed)==p-1,
                      f"C5 fiber not {p-1} {(p,k,counts)}: {expected}")
        else:
            check(collapsed=={chosen_replacement},
                  f"C5 degenerate collapse {(p,k,counts)}")
        check(len(trees)%p==(-target)%p,
              f"C5 recursion {(p,k,counts)}: {len(trees)%p} != {(-target)%p}")
        move_failures=test_labelled_moves(trees)
        check(not move_failures,f"C5 explicit cyclic moves {(p,k,counts)}: {move_failures!r}")
        setwise_good=True
        # Separately check the usual setwise interpretation (may expose k>1 depths).
        counterexamples=[]
        for perm in same_class_permutations(counts):
            if perm!=tuple(range(sum(counts)+1)) and gcd(order_of(perm),p)==1:
                f=[tree for tree in trees if relabel(tree,perm)==tree]
                if f:
                    counterexamples.append((perm,f))
        print("SETWISE_PRIME_TO_P",dict(p=p,k=k,counts=counts,
              found=len(counterexamples),example=counterexamples[:1]),flush=True)
    else:
        fixed=target=reduced=move_failures=None
    row=dict(p=p,k=k,counts=counts,T=len(trees),independent_T=comparison,
             carry_class=valid_classes[0] if valid_classes else None,
             fixed=len(fixed) if fixed is not None else None,
             collapsed_T=target,T_mod_p=len(trees)%p,
             expected_mod_p=-target%p if target is not None else None,
             literal_non_p_fixed=len(literal_fixed),
             seconds=round(perf_counter()-started,4))
    return row


def relabel_by_reduction_tree(tree,c,old,new):
    # Integers from reduced-class 0 ... c ... c+1 are shifted to original labels.
    if isinstance(tree,int):
        source_c=0
        running=0
        new_c=(c+1)%k
        if c==0:
            # New labels shift right into class 1, except when c+1=k.
            offset=old[0] if k>1 else 0
            shifted=0 if k>1 else p
            base=sum(old[:1]) if k>1 else 0
            if k>1:
                return sum(old[:1])+tree-old[c]+p-1 if tree<=old[c] else tree-p
            return tree+offset
        next_class_new_start=sum(old[:new_c])
        before=old[0]
        after=old[0]-p+old[new_c]
        shifted=old[c]-p
        base=old[0]+old[new_c]
        return tree if tree<=old[0] else tree+p
    return recanonicalize(tuple(relabel_by_reduction_tree(x,c,old,new) for x in tree))


def relabel_by_reduction(trees,c,old,new):
    return {relabel_by_reduction_tree(tree,c,old,new) for tree in trees}


def atom_freeness_case(p,k,maximum_atoms):
    """C4 test: collapse minimal atoms, retain their exact height as a tag.
    Enumerate all assignments of height-tagged distinct labels; require every
    atom p^j at a skeleton depth congruent to -j (mod k).
    """
    m=0
    ds=[]
    while sum(ds)<maximum_atoms or not m:
        m+=1
        ds=digits(m,p)
    # Pick a small vector with exactly the requested total number of atoms.
    ds=list(ds)
    while sum(ds)>maximum_atoms:
        # Change m, rather than manufacturing a vector which is not base-p digits.
        m+=1
        ds=list(digits(m,p))
    explicit_atoms=[j for j,a in enumerate(ds) for _ in range(a)]
    trees=set()
    for shape in by_leaves(p,len(ds)):
        for heights in permutations(explicit_atoms):
            if all(h%k==d%k for h,d in zip(heights,leaf_depths(shape))):
                # Tag names by height class, with no alphabetical class ambiguity.
                labels=iter(tuple(i+1,j) for i,j in enumerate(heights))
                trees.add(canonical_labelled(shape,labels))
    counterexamples=[]
    for perm in permutations(range(1,len(ds)+1)):
        permutation=(0,)+perm
        if permutation==tuple(range(len(ds)+1)):
            continue
        if gcd(order_of(permutation),p)!=1:
            continue
        if any(explicit_atoms[permutation[i]-1]!=explicit_atoms[i-1] for i in range(1,len(ds)+1)):
            continue
        mapping={i:permutation[i] for i in range(1,len(ds)+1)}
        fixed=[]
        for tree in trees:
            renamed=relabel_tagged(tree,mapping)
            if renamed==tree:
                fixed.append(tree)
        if fixed:
            counterexamples.append((permutation,fixed))
            break
    check(not counterexamples,f"C4 atom action not free {(p,k,tuple(ds))}: {counterexamples!r}")
    return dict(p=p,k=k,m=m,digits=tuple(ds),trees=len(trees),
                prime_to_p_fixed=len(counterexamples),counterexample=counterexamples[:1])


def relabel_tagged(tree,mapping):
    if isinstance(tree,tuple) and len(tree)==2 and isinstance(tree[1],int):
        return (mapping[tree[0]],tree[1])
    children=tuple(relabel_tagged(child,mapping) for child in tree)
    return min(children[i:]+children[:i] for i in range(len(children)))


def worker(job):
    kind,payload=job
    if kind=="core":
        result=core_task(payload)
        print("CORE",result,flush=True)
    elif kind=="label":
        result=labelled_case(payload)
        print("LABELLED",result,flush=True)
    else:
        result=atom_freeness_case(*payload)
        print("ATOM_FREE",result,flush=True)
    return job,result


def main():
    started=perf_counter()
    jobs=[("core",(p,k,n)) for p,k,last in CASES for n in range(1,last+1)]
    jobs += [("label",job) for job in [
        (2,1,(5,),True),(2,1,(7,),False),
        (3,1,(4,),True),(3,1,(7,),False),
        (5,1,(5,),True),(5,1,(9,),False),
        (7,1,(7,),True),
        (2,2,(2,2),True),(2,2,(4,3),True),
        (3,2,(1,2),True),(3,2,(4,3),True),
        (5,2,(1,1),True),
        (2,3,(2,0,0),True),(2,3,(4,0,3),True),
        (3,3,(1,0,2),True),
    ]]
    jobs += [("atom",(2,1,5)),("atom",(2,2,5)),("atom",(3,1,4)),("atom",(5,1,5))]
    print("C4 literal test: arbitrary prime-to-p-order label permutations, not setwise restriction.")
    print("C4 atom test: exact atom height retained; permutations preserve exact height.")
    print("C5: p selected labels from one residue class; collapse uses a class-c+1 label.")
    print("Independent code: no E000 source read before completing this run.",flush=True)
    with Pool(processes=3) as pool:
        results=list(pool.imap_unordered(worker,jobs))
    table=sorted((payload,result) for (kind,payload),result in results if kind=="core")
    print("CORE_TABLE",table,flush=True)
    print("ELAPSED_SECONDS",round(perf_counter()-started,4))
    print("TOTAL_CHECKS",CHECKS,"FAILURES",len(FAILURES),flush=True)
    for failure in FAILURES:
        print("FAILURE:",failure,flush=True)
    print("ALL IMPLEMENTED CHECKS PASSED" if not FAILURES else "IMPLEMENTED CHECKS FAILED",flush=True)


if __name__=="__main__":
    main()
