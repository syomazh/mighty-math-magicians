"""Auxiliary: (a) every ref / eqref / cite in main.tex has a target, and list unused labels;
(b) scan k>=2 for the smallest cases with N_min >= 3 (via the count-only recursion) to choose
additional brute-force cases."""
import os
import re
import sys
from math import factorial

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_carry import count_T  # noqa: E402
from verify_classes import digits, fuss  # noqa: E402

BS = chr(92)
here = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(here, '..', '..', 'main.tex'), encoding='utf-8').read()
labels = re.findall(re.escape(BS + 'label{') + '([^}]*)}', src)
refs = re.findall(re.escape(BS) + '(?:eq)?ref' + re.escape('{') + '([^}]*)}', src)
cites = re.findall(re.escape(BS + 'cite{') + '([^}]*)}', src)
bib = re.findall(re.escape(BS + 'bibitem{') + '([^}]*)}', src)
print('labels:', len(labels), 'duplicates:', sorted({l for l in labels if labels.count(l) > 1}))
print('refs without label:', sorted(set(refs) - set(labels)))
print('labels never referenced:', sorted(set(labels) - set(refs)))
print('cites without bibitem:', sorted(set(cites) - set(bib)), '| bibitems never cited:', sorted(set(bib) - set(cites)))
for mac in ('GAP', 'Atom', 'dep', 'leaf', 'Fix', 'rot'):
    print('macro', mac, 'occurrences incl. its definition:', len(re.findall(re.escape(BS + mac) + '(?![A-Za-z])', src)))

if __name__ == '__main__':
    for (p, k) in [(2, 2), (2, 3), (3, 2), (2, 4), (3, 3), (5, 2)]:
        q = p ** k
        T = count_T(p, k)
        found = []
        for n in range(1, 400):
            m = (q - 1) * n + 1
            ds = digits(m, p)
            if sum(ds) > (12 if p == 2 else 9):
                continue
            a = [0] * k
            prod = 1
            for j, d in enumerate(ds):
                a[j % k] += d
                prod *= factorial(d)
            N = T(tuple(a), 0) // prod
            if N >= 3:
                found.append((n, m, N, fuss(q, n)))
            if len(found) >= 3:
                break
        print(f'p={p} k={k}: first cases with N_min>=3 (n, m, N_min, #trees):', found)
