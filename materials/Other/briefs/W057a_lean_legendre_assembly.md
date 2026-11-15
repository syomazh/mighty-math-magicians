# W057a — Lean: Legendre's formula as in the accounting proof (the count K(a), the recursion, Lemma L3, and Lemma L4 from two congruences)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 about 08:05. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". **Time limit: 50 minutes. Report back with whatever compiles.** The submission deadline is today at 12:00; anything later than 09:15 will not be used.

## What this is

Appendix C of `report/report.tex` (source `paper/accounting_proof.tex`): read Lemmas L3 and L4 with their proofs. They compute m! by a recursion: with m = p·a + r (r < p the last digit),

    |F(m)| = binom(m, r) · K(a) · |F(a)|,        |F(0)| = 1,

where K(a) is the number of permutations of p·a points all of whose cycles have length p (K(a) · a! · p^a = (p·a)!), and then

    m! = p^ν(m) · ∏_j (m_j)! · |F(m)|            (Lemma L3),
    |F(m)| ≡ (−1)^ν(m) (mod p)                   (Lemma L4), from binom(p·a + r, r) ≡ 1 and K(a) ≡ (−1)^a.

Lean has the conclusion already (`factorial_eq_pow_mul_prod_mul` in `lean/MMM/Dwork.lean`), proved differently (blocks of p − 1 consecutive factors and Wilson's theorem). You formalize the text's recursion, with K(a) as a real count of permutations. The two congruences are proved by group actions by two other workers in other files; you take them as hypotheses, and also give the versions that use the classical lemmas already in `Dwork.lean`.

## What exists (read first; change nothing)

- `lean/MMM/LegendreDefs.lean` (compiled):
  ```lean
  noncomputable def Kcount (p a : ℕ) : ℕ :=
    Nat.card {π : Equiv.Perm (Fin (p * a)) // π.cycleType = Multiset.replicate a p}
  ```
- `lean/MMM/Dwork.lean`: `nu`, `W`, `factorial_mul_eq (hp : 0 < p) : ∀ a, (p * a).factorial = p ^ a * a.factorial * W p a`, `W_cast : (W p a : ZMod p) = (-1) ^ a`, `choose_cast (hr : r < p) (a) : (((p * a + r).choose r : ℕ) : ZMod p) = 1`, `prod_dig_mul_add (hp : 2 ≤ p) (a r) (hr : r < p) : (∏ j ∈ Finset.range (p * a + r), (dig p j (p * a + r)).factorial) = r.factorial * ∏ j ∈ Finset.range a, (dig p j a).factorial`, `nu_mul_add (hp : 2 ≤ p) (a r) (hr : r < p) : nu p (p * a + r) = a + nu p a`, and the proof of `factorial_eq_pow_mul_prod_mul` (strong induction on m with `m = p * (m / p) + m % p`): your induction is the same bookkeeping.
- Mathlib, `Mathlib/GroupTheory/Perm/Centralizer.lean`: `Equiv.Perm.card_of_cycleType_mul_eq` and `Equiv.Perm.card_of_cycleType` (the number of permutations with a given cycle type; read the statements there, lines 675 to 725).

## File you own

`lean/MMM/LegendreSym.lean` (new). Nothing else. Imports: `MMM.LegendreDefs`, `MMM.Dwork`, `Mathlib.GroupTheory.Perm.Centralizer`.

## Statements (inside `namespace MMM`), in this order

```lean
/-- p·a points are grouped into a cyclically ordered p-sets in K(a) ways: K(a) · a! · p^a = (p a)!. -/
theorem Kcount_mul (p : ℕ) [Fact p.Prime] (a : ℕ) :
    Kcount p a * (a.factorial * p ^ a) = (p * a).factorial

/-- The number of digit-forest structures on m points, by the recursion of Lemma L3:
1 for m = 0, and binom(m, m % p) · K(m / p) · (the number for m / p) otherwise. -/
noncomputable def forestCount (p : ℕ) : ℕ → ℕ      -- by well-founded recursion on m (`m / p < m`);
                                                  -- give the value 1 when `m = 0` or `p < 2`

theorem forestCount_zero (p : ℕ) : forestCount p 0 = 1
theorem forestCount_eq (p : ℕ) (hp : 2 ≤ p) (m : ℕ) (hm : 0 < m) :
    forestCount p m = Nat.choose m (m % p) * Kcount p (m / p) * forestCount p (m / p)

/-- **Lemma L3.** -/
theorem factorial_eq_forestCount (p : ℕ) [Fact p.Prime] (m : ℕ) :
    m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * forestCount p m

/-- **Lemma L4, from its two congruences.** -/
theorem forestCount_modEq_of (p : ℕ) [Fact p.Prime]
    (hK : ∀ a, (Kcount p a : ZMod p) = (-1) ^ a)
    (hC : ∀ a r, r < p → ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1) (m : ℕ) :
    (forestCount p m : ZMod p) = (-1) ^ nu p m

/-- K(a) is the number W(a) of `Dwork.lean` (both satisfy x · a! · p^a = (p a)!), hence K(a) ≡ (-1)^a
by Wilson's theorem. This is NOT the text's argument (conjugation by a p-cycle). -/
theorem Kcount_eq_W (p : ℕ) [Fact p.Prime] (a : ℕ) : Kcount p a = W p a
theorem Kcount_modEq_wilson (p : ℕ) [Fact p.Prime] (a : ℕ) : (Kcount p a : ZMod p) = (-1) ^ a

/-- Legendre's formula with its residue, by the recursion of the accounting proof; the two
congruences are hypotheses. -/
theorem factorial_eq_pow_mul_prod_mul_sym_of (p : ℕ) [Fact p.Prime]
    (hK : ∀ a, (Kcount p a : ZMod p) = (-1) ^ a)
    (hC : ∀ a r, r < p → ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1) (m : ℕ) :
    ∃ u : ℕ, m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m
```

## Plan

1. `Kcount_mul`: `Equiv.Perm.card_of_cycleType_mul_eq (Fin (p * a)) (Multiset.replicate a p)`. For this multiset: the sum is `a * p` (`Multiset.sum_replicate`, `smul_eq_mul`), so `Fintype.card (Fin (p * a)) - sum = 0`; the product is `p ^ a` (`Multiset.prod_replicate`); every entry is `p ≥ 2`; the product over the distinct entries of the factorials of the multiplicities is `a!` (for `a = 0` the multiset is empty and the product is 1; for `a > 0` the only entry is `p`, `Multiset.count_replicate_self`, `Multiset.toFinset`/`dedup` of a replicate: grep `dedup_replicate`, `toFinset_replicate`). Convert the count of the filtered finset there into `Nat.card` of the subtype (`Nat.card_eq_fintype_card`, `Fintype.card_subtype`, or `Nat.subtype_card`). Treat `a = 0` separately if that is easier.
2. `forestCount` with `termination_by` / `decreasing_by` (`Nat.div_lt_self hm hp`), then the two equation lemmas.
3. `factorial_eq_forestCount`: strong induction on m. For `m > 0` put `a = m / p`, `r = m % p`, `m = p * a + r` (`Nat.div_add_mod`), `r < p`; `m! = choose m r * r! * (p * a)!` (`Nat.choose_mul_factorial_mul_factorial`, with `m - r = p * a`); `(p * a)! = Kcount p a * (a! * p ^ a)`; the induction hypothesis for `a < m`; `nu_mul_add`, `prod_dig_mul_add`; finish with `ring`-style rearrangement (`pow_add`).
4. `forestCount_modEq_of`: strong induction; cast the recursion into `ZMod p`; `nu_mul_add`; `pow_add`.
5. `Kcount_eq_W`: from `Kcount_mul` and `factorial_mul_eq`, cancel `a! * p ^ a > 0` (`Nat.eq_of_mul_eq_mul_right`).
6. The last theorem: `u := forestCount p m`.

Do 1 last if it resists: in that case state 3 to 6 with the extra hypothesis `(hKmul : ∀ a, Kcount p a * (a.factorial * p ^ a) = (p * a).factorial)` under names ending in `_of'`, and say so.

## Rules

- Lean is not on the PATH. Compile only your own file: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/LegendreSym.lean -o .lake/build/lib/lean/MMM/LegendreSym.olean`. **Never run `lake build`, `lake update`, `lake exe cache` or anything that downloads. Never edit, move or delete an existing file.** Other workers compile on this laptop at the same time and memory is short: one compile at a time (a compile takes a few minutes), and read the error output fully before the next one.
- The project is on **Lean v4.35.0 with Mathlib v4.35.0**. Check every Mathlib lemma name with grep in `lean/.lake/packages/mathlib/Mathlib` before using it; do not trust memory.
- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. No Mathlib theorem about valuations of factorials or binomial coefficients (`padicValNat`, `multiplicity`, `emultiplicity`, Legendre, Kummer), no Lucas, no `Nat.Prime.dvd_choose_pow`, and not Mathlib's `frobenius`, `add_pow_char`, `add_pow_expChar`.
- The file starts with a comment: `Written by an Open Math OS worker (model recorded in logs/delegations/INDEX.md, brief W057a), 2026-11-15. Not human-reviewed.` and a few lines on what the file proves and which parts are the text's argument and which are not.
- No git command that changes anything. Do not launch other workers.
- Keep the file compiling as you go; if a theorem is not finished in time, remove it and say so. Do not change a statement silently: if you must change one, say exactly how and why.

## Report

For each statement: done or not, the exact statement as in the file, the last compile result (errors and warnings), and the output of `#print axioms MMM.factorial_eq_pow_mul_prod_mul_sym_of` and of `#print axioms MMM.Kcount_mul` (add the commands at the end of the file).
