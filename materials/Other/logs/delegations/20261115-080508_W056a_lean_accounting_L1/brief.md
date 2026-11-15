# W056a — Lean: Lemma L1 of the accounting proof, by labelled trees

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 08:10. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". **Time limit: 50 minutes. Report back with whatever compiles.** The submission deadline is today at 12:00; anything later than 09:15 will not be used.

## What this is

The accounting proof is Appendix C of `report/report.tex` (source `paper/accounting_proof.tex`; read Lemma L1 and its proof, nothing more). Lemma L1: label the m leaves of a k-blocked p-ary tree with m distinct labels. There are m!·C such labelled plane trees (C = the number of blocked trees with m leaves), and Lean already knows the number of labelled trees modulo a power of p (`labelled_congruence_blocked`, from the cherry collapse). So m!·C ≡ (−p)^N modulo p^(N+1), where N = (m − 1)/(p − 1).

## What exists (read first; change nothing)

- `lean/MMM/ExactCount.lean`: `LTree.shape`, `LTree.labels`, and
  ```lean
  theorem LTree.card_good_lab_eq [DecidableEq α] (S : Finset α) :
      Nat.card {T : LTree p α // T.Good ∧ T.lab = S} =
        Nat.card {U : PTree p // U.leaves = S.card} * S.card.factorial
  ```
  with its proof (a labelled tree with distinct labels is a shape together with the list of its labels: `eq_of_shape_labels`, `exists_of_shape_labels`, `card_nodup_lists`). Your second theorem is the same proof with one more condition carried along.
- `lean/MMM/LBlocked.lean`: `LTree.BlockedL k κ δ T` (`leaf a ↦ k ∣ δ + κ a`, `node f ↦ ∀ i, BlockedL k κ (δ + 1) (f i)`). `lean/MMM/Blocked.lean`: `PTree.BlockedAt k δ T` (`leaf ↦ k ∣ δ`, node likewise).
- `lean/MMM/ResidueB.lean`:
  ```lean
  theorem labelled_congruence_blocked {p : ℕ} [hp : Fact p.Prime] {α : Type} [DecidableEq α]
      (k : ℕ) (hk : 0 < k) (κ : α → ℕ) (t : ℕ) (S : Finset α) (hS : S.card = (p - 1) * t + 1)
      (hI : (∑ x ∈ S, p ^ κ x) ≡ 1 [MOD p ^ k - 1]) :
      (Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} : ℤ) ≡ (-(p : ℤ)) ^ t
        [ZMOD (p : ℤ) ^ (t + 1)]
  ```

## File you own

`lean/MMM/AccountingL1.lean` (new). Nothing else. Imports: `MMM.ExactCount`, `MMM.ResidueB` (and what they need).

## Statements (inside `namespace MMM`)

```lean
/-- With all labels of class 0, a labelled tree is blocked exactly when its shape is. -/
theorem LTree.blockedL_zero_iff_shape {p : ℕ} {α : Type} (k δ : ℕ) (T : LTree p α) :
    T.BlockedL k (fun _ => 0) δ ↔ PTree.BlockedAt k δ T.shape

theorem LTree.card_good_lab_blocked_eq {p : ℕ} {α : Type} [DecidableEq α] (k : ℕ) (S : Finset α) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k (fun _ => 0) 0} =
      Nat.card {U : PTree p // U.leaves = S.card ∧ PTree.BlockedAt k 0 U} * S.card.factorial

/-- **Lemma L1 of the accounting proof.** -/
theorem factorial_mul_card_blocked_modEq (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m N : ℕ)
    (hN : (p - 1) * N + 1 = m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (m.factorial : ℤ) * (Nat.card {U : PTree p // U.leaves = m ∧ PTree.BlockedAt k 0 U} : ℤ) ≡
      (-(p : ℤ)) ^ N [ZMOD (p : ℤ) ^ (N + 1)]
```

## Plan

1. `blockedL_zero_iff_shape`: induction on `T` generalizing `δ` (leaf: `k ∣ δ + 0`; node: the induction hypothesis for each child; `shape_node`).
2. `card_good_lab_blocked_eq`: copy the proof of `card_good_lab_eq` and carry the blocked condition through the bijection with lemma 1 (the shape of the tree rebuilt by `exists_of_shape_labels U l _` is `U`).
3. `factorial_mul_card_blocked_modEq`: `α := Fin m`, `S := Finset.univ` (`Finset.card_univ`, `Fintype.card_fin`), `κ := fun _ => 0`; `hI` is `m ≡ 1` after `simp` (`pow_zero`, `Finset.sum_const`, `smul_eq_mul`, `mul_one`); `hS` is `hN.symm`; then rewrite the count with theorem 2 and push the casts (`Nat.cast_mul`, `mul_comm`).

## Rules

- Lean is not on the PATH. Compile only your own file: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/AccountingL1.lean -o .lake/build/lib/lean/MMM/AccountingL1.olean`. **Never run `lake build`, `lake update`, `lake exe cache` or anything that downloads. Never edit, move or delete an existing file.** Other workers compile on this laptop at the same time and memory is short: one compile at a time, and read the error output fully before the next one.
- The project is on **Lean v4.35.0 with Mathlib v4.35.0**. Check every Mathlib lemma name with grep in `lean/.lake/packages/mathlib/Mathlib` before using it; do not trust memory.
- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. No Mathlib theorem about valuations of factorials or binomial coefficients (`padicValNat`, `multiplicity`, `emultiplicity`, Legendre, Kummer), no Lucas, no `Nat.Prime.dvd_choose_pow`, and not Mathlib's `frobenius`, `add_pow_char`, `add_pow_expChar`.
- The file starts with a comment: `Written by an Open Math OS worker (model recorded in logs/delegations/INDEX.md, brief W056a), 2026-11-15. Not human-reviewed.` and two lines on what the file proves.
- No git command that changes anything. Do not launch other workers.
- Keep the file compiling as you go; if a theorem is not finished in time, remove it and say so. Do not change a statement silently: if you must change one, say exactly how and why.

## Report

For each statement: done or not, the exact statement as in the file, the last compile result (errors and warnings), and the output of `#print axioms MMM.factorial_mul_card_blocked_modEq` (add the command at the end of the file).
