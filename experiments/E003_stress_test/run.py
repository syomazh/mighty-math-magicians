# Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13.
"""E003: literal exact implementation of the class-counting recursion."""
import argparse
import csv
import math
import platform
import re
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
E000 = ROOT.parent / "E000_first_sanity_check" / "output.txt"
CASES = ([(p,1) for p in (2,3,5,7,11,13)] + [(p,2) for p in (2,3,5)]
         + [(2,3),(3,3),(2,4)])
KINDS = ("E000","Catalan","vanishing","min","residue","exact")
FIELDS = ("p","k","q","n","m","t","min_d","N_min","N_t_plus_1","N_t_plus_2",
          "N_min_mod_p","predicted_mod_p","classes_at_y_1","fuss_catalan")


def tvalue(m,p):
    s=0
    while m:
        s+=m%p
        m//=p
    return (s-1)//(p-1)


def fuss(n,q):
    return math.comb(q*n,n)//((q-1)*n+1)


def tuple_product(children,m,p,y=None,D=None):
    """Coefficient of the p-fold power, with F(0)=1, at m excess leaves."""
    poly = D is not None
    assert poly == (y is None)
    partial = {0: [1]+[0]*D if poly else 1}
    for _ in range(p):
        following = {}
        for used,left in partial.items():
            if (used,m) == (m,m):
                dest = following.setdefault(m,[0]*(D+1) if poly else 0)
                if not poly:
                    dest += left
                else:
                    for d in range(D+1):
                        dest[d] += left[d]
            for leaves,value in children.items():
                total = used+leaves
                if total > m:
                    continue
                if poly:
                    dest = following.setdefault(total,[0]*(D+1))
                    for d in range(D+1):
                        dest[d] += sum(left[e]*value[d-e] for e in range(d+1))
                elif value:
                    following[total] = following.get(total,0)+left*value
        partial = following
        if not partial:
            break
    return partial.get(m,[0]*(D+1) if poly else 0)


def substituted(c,p,y=None,D=None):
    if D is None:
        return c
    result = [0]*(D+1)
    for d,v in enumerate(c):
        if p*d <= D:
            result[p*d] = v
    return result


def build(p,k,M,D=None,y=None):
    """All F_delta through M, keyed by their actual number of leaves."""
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


def near(p,k,M):
    """Return [x^m y^(t+h)]F_0 for each admissible m and h=0,1,2."""
    F=[{} for _ in range(k)]
    for m in range(1,M+1):
        for delta in range(k):
            if (m*pow(p,delta,p**k-1)-1)%(p**k-1):
                continue
            children=F[(delta+1)%k]
            constant=[0,0,0]
            if m%p==0 and m//p in children:
                for h,v in enumerate(children[m//p]):
                    if p*h<=2:
                        constant[p*h]=v
            if m==1:
                assert delta==0
                F[delta][m]=[1,0,0]
                continue
            if m==p:
                constant=[1,0,0]
            raw=excess_product(children,p,m)
            result=constant[:]
            for h in range(1,3):
                numerator=raw[h-1]-constant[h-1]
                assert numerator%p==0,(p,k,delta,m,raw,constant)
                result[h]+=numerator//p
            F[delta][m]=result
    return F[0]


def excess_product(children,p,m):
    """y * (G^p - G(x^p,y^p))/p, before division, shifted by 1-t(m).

    Each entry of a partial portfolio records (L,S), where S is the sum
    of t(child leaf counts). Each nonempty child contributes an excess
    t(m+p)-t(L)-t(child leaves); for an empty child t(0)=0. The one is the
    asymmetric root. The symmetric zero-tuple at m=p has h=0 separately.
    """
    shift=1+tvalue(m+p,p)-tvalue(m,p)
    partial={(0,0):[1,0,0]}
    for _ in range(p):
        following={}
        for (L,S),left in partial.items():
            for leaves,value in children.items():
                if L+leaves>m:
                    continue
                correction=tvalue(L+leaves,p)-tvalue(L,p)-tvalue(leaves,p)
                dest=following.setdefault((L+leaves,S+tvalue(leaves,p)),[0,0,0])
                for a,b in ((0,0),(0,1),(0,2),(1,0),(1,1),(2,0)):
                    dest[a+b]+=left[a]*value[b]
            # An empty child has F(0)=1, no asymmetric vertices.
            correction=tvalue(L,p)-tvalue(L,p)-1
            dest=following.setdefault((L,S-1),[0,0,0])
            for h in range(3):
                dest[h]+=left[h]
        partial=following
    result=[0,0,0]
    for (L,S),left in partial.items():
        if L==m:
            h=shift-S
            assert h>=0,(m,L,S,shift)
            if h<=2:
                result[h]=left[0]
            if h+1<=2:
                result[h+1]+=left[1]
            if h+2<=2:
                result[h+2]+=left[2]
    return result


def read_e000():
    rows=[]
    pk=None
    for line in E000.read_text(encoding="utf-8").splitlines():
        matched=re.search(r"=== p=(\d+), k=(\d+), q=\d+ ===",line)
        if matched:
            pk=tuple(map(int,matched.groups()))
        elif line.endswith("all OK"):
            values=list(map(int,line.split()[:12]))
            assert len(values)==12
            fields=("n","m","s","t","C","vp","mind","orbits","Nmin",
                    "Nminmod","predmod","skeleton")
            rows.append(dict(zip(fields,values),p=pk[0],k=pk[1],source=line))
    assert len(rows)==47
    return rows


def statistics(row):
    for d,value in enumerate(row):
        if value:
            near=tuple(row[d:d+3])
            return d,near+(0,)*(3-len(near))
    return None,(0,0,0)


class Checker:
    def __init__(self):
        self.failures=[]
        self.rows=[]

    def check(self,kind,pk,good,detail):
        if not good:
            text=f"{kind} FAILURE: p={pk[0]}, k={pk[1]}: {detail}"
            self.failures.append(text)
            print(text,flush=True)

    def e000(self):
        for p,k in CASES:
            selected=[r for r in read_e000() if (r["p"],r["k"])==(p,k)]
            if not selected:
                continue
            q=p**k
            M=max(r["m"] for r in selected)
            ones=build(p,k,M,y=1)
            ps=build(p,k,M,y=p)
            for expected in selected:
                m=expected["m"]
                row=build(p,k,m,D=max(2,tvalue(m,p)+2)).get(m,[0,0,0])
                mind,near=statistics(row)
                self.check("E000",(p,k),ones.get(m,0)==expected["orbits"],
                    f"source={expected['source']!r};scalar class count={ones.get(m,0)}")
                self.check("E000",(p,k),mind==expected["mind"],
                    f"source={expected['source']!r};min d={mind};cutoff row={row}")
                self.check("E000",(p,k),near[0]==expected["Nmin"],
                    f"source={expected['source']!r};N_min={near[0]};cutoff row={row}")
                self.check("E000",(p,k),ps.get(m,0)==expected["C"],
                    f"source={expected['source']!r};value at y=p={ps.get(m,0)}")
            print(f"E000 p={p},k={k}: checked {len(selected)} rows",flush=True)

    def case(self,p,k,n,poly,ones,ps):
        q=p**k
        M=(q-1)*n+1
        for m in range(1,M+1):
            if (m-1)%(q-1):
                row=poly.get(m,[0,0,0])
                self.check("vanishing",(p,k),not any(row),
                    f"vanishing m={m}:coefficients={row};expected all zero")
        caserows=[]
        for i in range(1,n+1):
            m=(q-1)*i+1
            row=poly.get(m,[])
            mind,near=statistics(row)
            t=tvalue(m,p)
            N1,N2,N3=near
            self.check("min",(p,k),mind==t,
                f"min m={m}:actual={mind};expected={t};cutoff row={row}")
            digits=[]
            z=m
            while z:
                digits.append(z%p)
                z//=p
            product=math.prod(math.factorial(v) for v in digits)
            residue=pow((-1)**t*pow(product,-1,p),1,p)
            self.check("residue",(p,k),N1%p==residue and N1%p != 0,
                f"residue m={m}:N_min={N1};N_min mod p={N1%p};expected nonzero {residue};digits={digits}")
            if k==1:
                num=math.factorial(p*t)
                den=math.factorial(t)*p**t*product
                self.check("exact",(p,k),num%den==0 and N1==num//den,
                    f"exact N_min m={m}:actual={N1};formula=({p*t})!/({t}!*{p}^{t}*{product});numerator={num};denominator={den}")
            self.check("Catalan",(p,k),ps.get(m,0)==fuss(i,q),
                f"Catalan m={m}:actual={ps.get(m,0)};expected={fuss(i,q)}")
            caserows.append(dict(p=p,k=k,q=q,n=i,m=m,t=t,min_d=mind,N_min=N1,
                N_t_plus_1=N2,N_t_plus_2=N3,N_min_mod_p=N1%p,predicted_mod_p=residue,
                classes_at_y_1=ones.get(m,0),fuss_catalan=ps.get(m,0)))
        self.rows=[r for r in self.rows if (r["p"],r["k"])!=(p,k)]+caserows


def write_outputs(checker,results,elapsed):
    with (ROOT/"data.csv").open("w",newline="",encoding="utf-8") as out:
        writer=csv.DictWriter(out,fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(checker.rows)
    with (ROOT/"output.txt").open("w",encoding="utf-8") as out:
        out.write("E003: generating-function stress test\n")
        out.write("Model: moonshotai/kimi-k3.1-pro (Open Math OS), 2026-11-13\n")
        out.write("Command: uv run python experiments/E003_stress_test/run.py\n")
        out.write(f"Python: {sys.version.split()[0]}; platform: {platform.platform()}\n")
        out.write("Exact integers; the current implementation truncates at actual y degree max(t(m))+2.\n\n")
        out.write("p k q M_reached n_tested min_fail residue_fail exact_fail Catalan_fail vanish_fail E000_fail seconds\n")
        for (p,k),row in results.items():
            fails={kind:sum(f.startswith(f"{kind} FAILURE: p={p}, k={k}:") for f in checker.failures) for kind in KINDS}
            out.write(f"{p:2} {k} {row['q']:5} {row['M']:9} {row['n']:8} {fails['min']:8} {fails['residue']:12} {fails['exact']:10} {fails['Catalan']:12} {fails['vanishing']:11} {fails['E000']:9} {row['seconds']:10.6f}\n")
        out.write(f"CSV rows: {len(checker.rows)}\nTotal elapsed seconds: {elapsed:.3f}\nTOTAL FAILURES: {len(checker.failures)}\n")
        if checker.failures:
            out.write("\nFAILURES, VERBATIM\n"+"\n".join(checker.failures)+"\n")
        else:
            out.write("All implemented checks passed.\n")


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--smoke",action="store_true")
    parser.add_argument("--case")
    parser.add_argument("--n",type=int)
    parser.add_argument("--budget",type=float,default=1080)
    args=parser.parse_args()
    checker=Checker()
    results={}
    start=time.perf_counter()
    checker.e000()
    if args.smoke:
        cases=[(2,1,12),(3,2,2)]
    elif args.case:
        p,k=map(int,args.case.split(","))
        cases=[(p,k,args.n or 20)]
    else:
        cases=[(2,1,300),(2,2,70),(2,3,30),(2,4,20),(3,1,18),(3,2,8),
               (3,3,4),(5,1,12),(5,2,3),(7,1,8),(11,1,5),(13,1,4)]
    for p,k,n in cases:
        q=p**k
        M=(q-1)*n+1
        D=max(tvalue((q-1)*i+1,p) for i in range(1,n+1))+2
        polynomial=build(p,k,M,D=D)
        ones=build(p,k,M,y=1)
        ps=build(p,k,M,y=p)
        checker.case(p,k,n,polynomial,ones,ps)
        results[(p,k)]=dict(q=q,M=M,n=n,seconds=time.perf_counter()-start)
        print(f"RESULT p={p},k={k},M={M},n={n},failures={len(checker.failures)}",flush=True)
        write_outputs(checker,results,time.perf_counter()-start)
    print(f"TOTAL FAILURES:{len(checker.failures)}",flush=True)


if __name__ == "__main__":
    main()
