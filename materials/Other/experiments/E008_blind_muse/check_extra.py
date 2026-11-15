"""
Quick extra check: G mod p sparsity for general q=p^k
"""
from math import comb

def v_p(n, p):
    e=0
    while n%p==0:
        n//=p; e+=1
    return e

def is_p_power(m, p):
    if m<=0: return False
    while m%p==0:
        m//=p
    return m==1

# Check: for q=p^k, is C_n^{(q)} nonzero mod p iff m=(q-1)n+1 is a power of p?
print("C_n^{(q)} mod p nonzero iff m is p-power?")
for p,k in [(2,1),(2,2),(2,3),(3,1),(3,2),(5,1),(5,2)]:
    q=p**k
    mismatches=[]
    for n in range(1,40):
        m=(q-1)*n+1
        C=comb(q*n,n)//m
        nonzero=(C%p!=0)
        ispp=is_p_power(m,p)
        if nonzero!=ispp:
            mismatches.append((n,m,C%p,ispp))
    if mismatches:
        print(f"  p={p} k={k} q={q}: MISMATCHES {mismatches[:5]}")
    else:
        print(f"  p={p} k={k} q={q}: PATTERN HOLDS (all n=1..39)")

# Also check functional equation fix for q=2
# G(x) = x + G(x)^q with G = sum C_n x^{(q-1)n+1}
# For q=2: G = sum C_n x^{n+1}, degrees 1..infinity
# Need enough terms to verify
print("\nFunctional equation G = x + G^q (with sufficient terms):")
for q in [2,3,4]:
    max_n = 25
    max_m = (q-1)*max_n + 1
    G = [0]*(max_m+1)
    G[1] = 1  # C_0 = 1
    for n in range(1, max_n+1):
        m=(q-1)*n+1
        G[m]=comb(q*n,n)//m
    # Compute G^q
    def poly_pow(coeffs, pw, max_deg):
        res=[0]*(max_deg+1)
        res[0]=1
        for _ in range(pw):
            new=[0]*(max_deg+1)
            for i in range(max_deg+1):
                if res[i]==0: continue
                for j in range(max_deg+1-i):
                    if coeffs[j]==0: continue
                    new[i+j]+=res[i]*coeffs[j]
            res=new
        return res
    Gq=poly_pow(G,q,max_m)
    xGq=[0]*(max_m+1)
    xGq[1]=1
    for i in range(max_m+1):
        xGq[i]+=Gq[i]
    ok=all(G[i]==xGq[i] for i in range(max_m+1))
    print(f"  q={q}: G=x+G^q up to degree {max_m}? {ok}")
    if not ok:
        for i in range(max_m+1):
            if G[i]!=xGq[i]:
                print(f"    deg {i}: G={G[i]} vs {xGq[i]}")
                if i>10: break
                print(f"      (showing first few)")

# Check G mod p = sum x^{p^j}  (sparse)
print("\nG mod p sparsity: G mod p should be sum_{j} x^{p^j} ?")
for p,k in [(2,1),(3,1),(2,2),(3,2)]:
    q=p**k
    print(f"  p={p} q={q}: n, m, C mod p, is_p_power(m)?")
    for n in range(0,15):
        if n==0:
            m=1; C=1
        else:
            m=(q-1)*n+1
            C=comb(q*n,n)//m
        if C%p!=0:
            ispp=is_p_power(m,p)
            print(f"    n={n} m={m} C={C} C%p={C%p} p-power?{ispp}")

# Demonstrate G^p Frobenius mod p: (sum a_i x^i)^p = sum a_i x^{pi} mod p
# This is key for Strategy B
print("\nFrobenius mod p check: G^p mod p should have support at p*m for each m in support of G")
for p in [2,3]:
    q=p
    # Build G mod p as list of exponents with nonzero coeff
    support=set()
    for n in range(15):
        if n==0: m=1
        else: m=(q-1)*n+1
        C=comb(q*n,n)//m if n>=1 else 1
        if C%p!=0:
            support.add(m)
    print(f"  p={p} q={q} support of G mod p: {sorted(support)}")
    print(f"    Support of G^p mod p should be: {sorted([p*m for m in support])}")
    # And x + G^p mod p should recover support of G
    shifted={1} | {p*m for m in support}
    print(f"    x + G^p support: {sorted(shifted)}")
    print(f"    Match? {shifted==support}")
