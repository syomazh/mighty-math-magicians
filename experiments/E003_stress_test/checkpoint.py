# Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13.
"""Temporary checkpoint of the exact passing implementation of build()."""

def build(p,k,M,D=None,y=None,tuple_product=None,substituted=None,tvalue=None):
    assert tuple_product and substituted and tvalue
    poly = D is not None
    assert poly == (y is None)
    F = [{1: (1 if not poly else [1]+[0]*D)}] + [{} for _ in range(k-1)]
    for m in range(2,M+1):
        if (m-1)%(p-1):
            continue
        for delta in range(k):
            if (m*pow(p,delta,p**k-1)-1)%(p**k-1):
                continue
            child = F[(delta+1)%k]
            constant = 0 if not poly else [0]*(D+1)
            if m%p == 0 and m//p in child:
                constant = substituted(child[m//p],p,D=D)
            if m == p:
                constant = 1 if not poly else [1]+[0]*D
            if poly:
                raw = tuple_product(child,m,p,D=D)
                numerator = [raw[d]-constant[d] for d in range(D)]
                assert all(v%p == 0 for v in numerator), (p,k,delta,m,numerator)
                result = constant[:]
                for d in range(1,D+1):
                    result[d] += numerator[d-1]//p
            else:
                numerator = tuple_product(child,m,p,y=y)-constant
                assert numerator%p == 0, (p,k,delta,m,numerator)
                result = constant+y*(numerator//p)
            F[delta][m] = result
    return F[0]
