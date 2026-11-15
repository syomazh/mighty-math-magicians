# W035 — Lean: the Frobenius proof, part 5 (the family at y = p is the generating function of the trees)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`lean/MMM/Frob/Special.lean` proves, for the unique family `solution p k : ZMod k → Lambda` of `Existence.lean`:

```lean
theorem evalY_solution (p : ℕ) [Fact p.Prime] (δ : ZMod k) :
    evalY p (solution p k δ) = (if δ = 0 then PowerSeries.X else 0) + (evalY p (solution p k (δ + 1))) ^ p
```

and `solution_zeroConstant`. The project's trees are in `lean/MMM/Trees.lean` (`PTree p`, `leaves`) and `lean/MMM/Blocked.lean`:

```lean
def BlockedAt (k : ℕ) : ℕ → PTree p → Prop
  | δ, leaf => k ∣ δ
  | δ, node f => ∀ i, BlockedAt k (δ + 1) (f i)
```

`lean/MMM/Reduction.lean` has `finite_of_leaves` (the trees with m leaves satisfying a predicate form a finite set), and `lean/MMM/FussFormula.lean` shows how sets of tuples of trees are counted in this project. Read these files, and `Existence.lean` and `Special.lean`, first; change none of them. The mathematics: the last sentence of Lemma `lem:system` in `paper/frobenius_proof.tex` (line 141), "F_0(x, p) = G(x)".

## Files you own

`lean/MMM/Frob/TreeGF.lean` (new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Statements (namespace `MMM.Frob`)

```lean
/-- Generating function of the p-ary trees whose leaves, seen from offset δ, all sit at a depth
divisible by k: the coefficient of x^m is the number of such trees with m leaves. -/
noncomputable def treeGF (p k δ : ℕ) : PowerSeries ℤ :=
  PowerSeries.mk fun m => (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} : ℤ)

theorem treeGF_coeff_zero (hp : 2 ≤ p) : (treeGF p k δ).coeff 0 = 0          -- no tree has 0 leaves
theorem treeGF_eq (hp : 2 ≤ p) (k δ : ℕ) :
    treeGF p k δ = (if k ∣ δ then PowerSeries.X else 0) + (treeGF p k (δ + 1)) ^ p
theorem blockedAt_add_period (k δ : ℕ) (T : PTree p) : BlockedAt k (δ + k) T ↔ BlockedAt k δ T
theorem treeGF_add_period (k δ : ℕ) : treeGF p k (δ + k) = treeGF p k δ

/-- Uniqueness for the specialised system: two families of integer power series without constant
term that satisfy G δ = [k ∣ δ] x + (G (δ + 1))^p are equal. -/
theorem treeSystem_unique (hp : 2 ≤ p) {G H : ℕ → PowerSeries ℤ}
    (hG0 : ∀ δ, (G δ).coeff 0 = 0) (hH0 : ∀ δ, (H δ).coeff 0 = 0)
    (hG : ∀ δ, G δ = (if k ∣ δ then PowerSeries.X else 0) + (G (δ + 1)) ^ p)
    (hH : ∀ δ, H δ = (if k ∣ δ then PowerSeries.X else 0) + (H (δ + 1)) ^ p) : G = H

/-- The note's "F_0(x, p) = G(x)", for every offset. -/
theorem evalY_solution_eq_treeGF (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ℕ) :
    evalY p (solution p k (δ : ZMod k)) = treeGF p k δ
```

## Proof plan

- `treeGF_eq`, coefficient by coefficient. A tree with m leaves blocked at δ is either the leaf (then m = 1 and k ∣ δ) or `node f` with every `f i` blocked at δ + 1 and `∑ i, (f i).leaves = m`. So the coefficient of x^m on the left is [m = 1 ∧ k ∣ δ] plus the number of such f. The coefficient of x^m in a p-th power of a series is a sum over the ways of writing m as an ordered sum of p parts of the product of the coefficients (`PowerSeries.coeff_pow`, or `PowerSeries.coeff_prod` with a product over `Fin p`; grep Mathlib for the exact form, it uses `Finset.finsuppAntidiag` or `Finset.Nat.antidiagonalTuple`); the product of the cardinalities is the cardinality of the set of tuples with those leaf numbers, and summing over the compositions gives all f. If this is hard to do directly, prove first the two-factor case (the coefficient of x^m in A·B counts pairs) and then induct on the number of factors, counting functions `Fin (n + 1) → PTree p` through `Fin.consEquiv` or `Fin.snocEquiv` (see how `FussFormula.lean` splits off the first tree of a forest).
- `treeSystem_unique`: strong induction on the degree m, for all δ at once: degree 0 by the hypotheses; for m > 0 the coefficient of x^m in `(G (δ + 1))^p` depends only on the coefficients of `G (δ + 1)` of degree < m, because the constant term is 0. `System.lean` proves this for `Lambda` (`coeff_pow_lower`); prove the same statement for `PowerSeries ℤ` (or for any commutative semiring) in your file by the same argument.
- `evalY_solution_eq_treeGF`: apply `treeSystem_unique` to `G δ := evalY p (solution p k (δ : ZMod k))` (use `evalY_solution`, `Nat.cast_succ`, and `(δ : ZMod k) = 0 ↔ k ∣ δ`, which is `ZMod.natCast_zmod_eq_zero_iff_dvd` or a similar name: grep) and `H δ := treeGF p k δ`.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/TreeGF.lean -o .lake/build/lib/lean/MMM/Frob/TreeGF.olean`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop; header naming the model; no git changes). If `treeGF_eq` cannot be finished, leave the other statements proved with `treeGF_eq` as an explicit hypothesis of `evalY_solution_eq_treeGF` under the different name `evalY_solution_eq_treeGF_of_eq`, and say so; do not state the unconditional theorem.

## Report

For each statement: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `evalY_solution_eq_treeGF` if it exists.
