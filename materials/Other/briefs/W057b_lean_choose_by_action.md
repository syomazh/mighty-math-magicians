# W057b — Lean: binom(p·a + r, r) ≡ 1 (mod p) for r < p, by a group of order p acting on the r-subsets

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 about 08:05. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". **Time limit: 50 minutes. Report back with whatever compiles.** The submission deadline is today at 12:00; anything later than 09:15 will not be used.

## What this is

Appendix C of `report/report.tex` (source `paper/accounting_proof.tex`), proof of Lemma L4, first claim: for a prime p and r < p,

    binom(p·(a + 1) + r, r) ≡ binom(p·a + r, r) (mod p),   hence   binom(p·a + r, r) ≡ binom(r, r) = 1.

The text's argument: a group of order p acts on a set of p·(a + 1) + r points by a p-cycle on p of the points and trivially on the others, hence on the r-subsets. A subset fixed by the group contains all or none of the p points, and it has fewer than p elements, so it contains none: the fixed subsets are the r-subsets of the other p·a + r points. The number of r-subsets is congruent modulo p to the number of fixed ones.

Lean already has the congruence by an elementary computation (`choose_cast` in `lean/MMM/Dwork.lean`). **Only the group-action proof is wanted here**; if you cannot finish it, say so and deliver the lemmas that do compile. Do not deliver the elementary proof.

## File you own

`lean/MMM/LegendreChoose.lean` (new). Nothing else. Import only the Mathlib modules you need (not the whole of Mathlib; no file of the project is needed).

## Statements (inside `namespace MMM`)

```lean
/-- One step: a group of order p acts on the r-subsets of `ZMod p ⊕ Y`; the fixed ones are the
r-subsets of `Y`. -/
theorem choose_add_prime_modEq (p : ℕ) [Fact p.Prime] (n r : ℕ) (hr : r < p) :
    Nat.choose (p + n) r ≡ Nat.choose n r [MOD p]

theorem choose_mul_add_modEq_one_action (p : ℕ) [Fact p.Prime] (a r : ℕ) (hr : r < p) :
    ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1
```

## Plan

1. Points: `X := ZMod p ⊕ Fin n` (so `Fintype.card X = p + n`). The group `G := Multiplicative (ZMod p)` (order p: `IsPGroup.of_card` with `Nat.card_eq_fintype_card`, `ZMod.card`) acts on `X` by translation on the left summand: define the permutation `σ g : Equiv.Perm X := Equiv.sumCongr (Equiv.addLeft (Multiplicative.toAdd g)) (Equiv.refl _)` and the action on `{s : Finset X // s.card = r}` by `Finset.map (σ g).toEmbedding` (the cardinality is kept: `Finset.card_map`). Give a `MulAction G {s : Finset X // s.card = r}` instance (`one_smul`, `mul_smul` by `Finset.ext` / `Finset.map_map`), or use `MulAction.compHom` from the action of `Equiv.Perm X` on finsets if Mathlib has it for the subtype.
2. `IsPGroup.card_modEq_card_fixedPoints` (`Mathlib/GroupTheory/PGroup.lean`; read its exact statement and the instances it needs): `Nat.card {s // s.card = r} ≡ Nat.card (MulAction.fixedPoints G {s // s.card = r}) [MOD p]`.
3. The fixed points are the subsets that contain no point `Sum.inl x`: if `Sum.inl x ∈ s` then all `Sum.inl (x + g) ∈ s`, giving p distinct elements of s, against `s.card = r < p` (`Finset.card_le_card` of the image of `Finset.univ : Finset (ZMod p)` under `Sum.inl`). So the fixed points are in bijection with `{s : Finset (Fin n) // s.card = r}` by `Finset.map Function.Embedding.inr`.
4. Counts: `Fintype.card_finset_len` (the number of subsets of size r of a fintype is `choose (card) r`), `Fintype.card_sum`, `ZMod.card`, `Fintype.card_fin`.
5. The second theorem: induction on `a` with `p * (a + 1) + r = p + (p * a + r)` and step 1, start `Nat.choose r r = 1`; then `(ZMod.natCast_eq_natCast_iff ..).mpr` (grep for the exact name) to go from `[MOD p]` to `ZMod p`.

## Rules

- Lean is not on the PATH. Compile only your own file: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/LegendreChoose.lean -o .lake/build/lib/lean/MMM/LegendreChoose.olean`. **Never run `lake build`, `lake update`, `lake exe cache` or anything that downloads. Never edit, move or delete an existing file.** Other workers compile on this laptop at the same time and memory is short: one compile at a time (a compile takes a few minutes), and read the error output fully before the next one.
- The project is on **Lean v4.35.0 with Mathlib v4.35.0**. Check every Mathlib lemma name with grep in `lean/.lake/packages/mathlib/Mathlib` before using it; do not trust memory.
- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. No Mathlib theorem about valuations of factorials or binomial coefficients (`padicValNat`, `multiplicity`, `emultiplicity`, Legendre, Kummer), no Lucas' theorem, no `Nat.Prime.dvd_choose_pow`, no `Nat.Prime.dvd_choose_self`-based shortcut, and not Mathlib's `frobenius`, `add_pow_char`, `add_pow_expChar`. The proof must be the group action.
- The file starts with a comment: `Written by an Open Math OS worker (model recorded in logs/delegations/INDEX.md, brief W057b), 2026-11-15. Not human-reviewed.` and two lines on what the file proves.
- No git command that changes anything. Do not launch other workers.
- Keep the file compiling as you go; if a theorem is not finished in time, remove it and say so. Do not change a statement silently: if you must change one, say exactly how and why.

## Report

For each statement: done or not, the exact statement as in the file, the last compile result (errors and warnings), and the output of `#print axioms MMM.choose_mul_add_modEq_one_action` (add the command at the end of the file).
