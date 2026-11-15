# W056b — Lean: the last step of the accounting proof (dividing Lemma L1 by Legendre's formula)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 08:10. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". **Time limit: 45 minutes. Report back with whatever compiles.** The submission deadline is today at 12:00; anything later than 09:15 will not be used.

## What this is

The accounting proof is Appendix C of `report/report.tex` (source `paper/accounting_proof.tex`; read the short section "Proof of the theorem"). Its last step is arithmetic: Lemma L1 says m!·C ≡ (−p)^N modulo p^(N+1), Legendre's formula with its residue says m! = p^ν·D·u with u ≡ (−1)^ν modulo p, and N = ν + t. Dividing gives C·D ≡ (−p)^t modulo p^(t+1). Here C is any natural number (the number of trees), D the product of the factorials of the base-p digits of m, ν = `nu p m`, and (p − 1)·t + 1 is the digit sum of m. Another worker proves Lemma L1; you take it as a hypothesis.

## What exists (read first; change nothing)

`lean/MMM/Dwork.lean`: `nu p m := (m - ds p m) / (p - 1)`, `ds_le`, `nu_mul_add`, `factorial_eq_pow_mul_prod_mul`, and `dwork_form`, whose proof does the same arithmetic in the other direction (read it for the Mathlib lemmas that work). `lean/MMM/Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean`: `ds`, `dig` and the lemmas about them (look for the congruence `m ≡ ds p m` modulo `p - 1`, or prove `(p - 1) ∣ m - ds p m` by induction with `nu_mul_add`-style steps).

## File you own

`lean/MMM/AccountingDiv.lean` (new). Nothing else. Import `MMM.Dwork`.

## Statements (inside `namespace MMM`)

```lean
/-- The number of nodes: with `(p - 1) * t + 1 = ds p m`, the number `N = nu p m + t` satisfies
`(p - 1) * N + 1 = m`. -/
theorem nodes_eq_nu_add (p : ℕ) [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    (p - 1) * (nu p m + t) + 1 = m

/-- **The last step of the accounting proof.** -/
theorem residue_of_L1_of_legendre (p : ℕ) [Fact p.Prime] (m t C : ℕ)
    (ht : (p - 1) * t + 1 = ds p m)
    (hL1 : (m.factorial : ℤ) * (C : ℤ) ≡
      (-(p : ℤ)) ^ (nu p m + t) [ZMOD (p : ℤ) ^ (nu p m + t + 1)])
    (hLeg : ∃ u : ℕ, m.factorial =
        p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m) :
    (C : ℤ) * ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]
```

## Plan for the second theorem

Write ν for `nu p m`, D for the product, and work in ℤ with divisibility (`Int.modEq_iff_dvd`, `Int.emod_emod_of_dvd`):

1. From `hLeg`: `m! = p^ν * D * u`, and `(u : ℤ) = (-1)^ν + p * w` for some integer `w` (from the equation in `ZMod p`: cast to ℤ, `ZMod.intCast_eq_intCast_iff` or `(ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp` applied to `u - (-1)^ν`).
2. `hL1` says `p^(ν+t+1) ∣ (-p)^(ν+t) - p^ν * D * u * C`. Since `(-p)^(ν+t) = p^ν * ((-1)^ν * (-p)^t)` and `p^(ν+t+1) = p^ν * p^(t+1)`, cancel `p^ν ≠ 0` (`mul_dvd_mul_iff_left`): `p^(t+1) ∣ (-1)^ν * (-p)^t - D * u * C`.
3. Hence `p^t ∣ D * u * C` (because `p^t ∣ (-p)^t`), and `p` is prime to `u` (`u ≡ ±1` modulo `p`), so `p^t ∣ D * C` (`IsCoprime.dvd_of_dvd_mul_right` with `IsCoprime.pow_left`, or `Int.Prime`-style lemmas, or `(Nat.Coprime.pow_left ..).dvd_of_dvd_mul_..` after moving to ℕ).
4. `D * u * C = (-1)^ν * (D * C) + p * w * (D * C)` and `p^(t+1) ∣ p * w * (D * C)` by 3. So `p^(t+1) ∣ (-1)^ν * ((-p)^t - D * C)`, and `(-1)^ν` is a unit: `p^(t+1) ∣ (-p)^t - D * C`.

Any other correct proof is as good. The statement must stay exactly as above.

## Rules

- Lean is not on the PATH. Compile only your own file: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/AccountingDiv.lean -o .lake/build/lib/lean/MMM/AccountingDiv.olean`. **Never run `lake build`, `lake update`, `lake exe cache` or anything that downloads. Never edit, move or delete an existing file.** Other workers compile on this laptop at the same time and memory is short: one compile at a time, and read the error output fully before the next one.
- The project is on **Lean v4.35.0 with Mathlib v4.35.0**. Check every Mathlib lemma name with grep in `lean/.lake/packages/mathlib/Mathlib` before using it; do not trust memory.
- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. No Mathlib theorem about valuations of factorials or binomial coefficients (`padicValNat`, `multiplicity`, `emultiplicity`, Legendre, Kummer), no Lucas, no `Nat.Prime.dvd_choose_pow`, and not Mathlib's `frobenius`, `add_pow_char`, `add_pow_expChar`.
- The file starts with a comment: `Written by an Open Math OS worker (model recorded in logs/delegations/INDEX.md, brief W056b), 2026-11-15. Not human-reviewed.` and two lines on what the file proves.
- No git command that changes anything. Do not launch other workers.
- Keep the file compiling as you go; if a theorem is not finished in time, remove it and say so. Do not change a statement silently: if you must change one, say exactly how and why.

## Report

For each statement: done or not, the exact statement as in the file, the last compile result (errors and warnings), and the output of `#print axioms MMM.residue_of_L1_of_legendre` (add the command at the end of the file).
