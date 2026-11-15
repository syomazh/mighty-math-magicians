# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""Negative controls for run.py: the checks must fail when the statement is altered."""
import importlib.util, os, sys
from math import comb, factorial
spec = importlib.util.spec_from_file_location("run", os.path.join(os.path.dirname(os.path.abspath(__file__)), "run.py"))
run = importlib.util.module_from_spec(spec); spec.loader.exec_module(run)
for p, r in [(3, 2), (5, 1), (5, 2), (7, 1)]:
    R, G = run.gauss_sums(p, r, r + 3)
    q = p ** r
    wrong_sign = no_fact = wrong_exp = total = 0
    for a in range(1, q - 1):
        dg = run.digits(a, p); s = sum(dg); f = 1
        for x in dg: f *= factorial(x)
        total += 1
        neg = R.scale_int(R.pi_pow(s), -1)
        wrong_sign += R.val(R.add(R.scale_int(G(a), f), neg)) >= s + 1          # G f = +pi^s ?
        if f % p != 1 % p:
            no_fact += R.val(R.add(G(a), R.pi_pow(s))) >= s + 1                  # without the factorials ?
        wrong_exp += R.val(R.add(R.scale_int(G(a), f), R.pi_pow(s + 1))) >= s + 2  # exponent s+1 ?
    print(f"p={p} q={q}: of {total} exponents, altered statements that still pass: wrong sign {wrong_sign}, "
          f"no factorials {no_fact}, exponent s+1 {wrong_exp}")
