# W031 — Lean: the Frobenius proof, part 3 (existence of the family, and the value at y = p)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`lean/MMM/Frob/` contains, compiled and in the project's build: `Basic.lean` (`Lambda := PowerSeries (Polynomial ℤ)`, `frobeniusLiftRingHom`), `Theta.lean`, `ThetaDiv.lean` (`theta`, `theta_spec : (p : Lambda) * theta p f = f ^ p - frobeniusLiftRingHom p _ f`), `ThetaIdents.lean` (`theta_add`, `theta_mul`, `theta_system_eq`), `System.lean` (`HasZeroConstant`, `coeff_frobeniusLift_lower`, `coeff_pow_lower`, `coeff_theta_lower`: a coefficient of positive degree m of φ(f), f^p, θ(f) depends only on the coefficients of f of degree < m, for f with zero constant term), `Uniqueness.lean` (`cyclicRHS`, `CyclicSystem`, `zeroConstant_cyclicRHS`, `cyclicSystem_unique`). Read all of them first; do not change them.

A previous worker ran out of time on existence. Its unfinished attempt is `logs/delegations/20261114-150753_W027_lean_frobenius_theta/Existence.lean.failed` (it does not compile; you may read it, you need not follow it).

## Files you own

`lean/MMM/Frob/Existence.lean` and `lean/MMM/Frob/Special.lean` (both new), and `lean/MMM/Frob/PLAN.md` (update the status of what you do). Nothing else.

## Targets, in this order (exact statements; helper lemmas are yours)

**Target 1 (`Existence.lean`): existence by iteration.** For `p` prime and any `k : ℕ`:

```lean
/-- The n-th iterate of the right-hand side, starting from 0. -/
noncomputable def iter (p : ℕ) [Fact p.Prime] (k : ℕ) : ℕ → ZMod k → Lambda
  | 0 => fun _ => 0
  | n + 1 => fun δ => cyclicRHS p (iter p k n) δ

theorem iter_zeroConstant (n : ℕ) (δ : ZMod k) : HasZeroConstant (iter p k n δ)

/-- Coefficients stabilise: the coefficient of x^m no longer changes after m + 1 steps. -/
theorem iter_stable {m n n' : ℕ} (hn : m < n) (hn' : m < n') (δ : ZMod k) :
    (iter p k n δ).coeff m = (iter p k n' δ).coeff m

noncomputable def solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) : Lambda :=
  PowerSeries.mk fun m => (iter p k (m + 1) δ).coeff m

theorem solution_zeroConstant (δ : ZMod k) : HasZeroConstant (solution p k δ)
theorem solution_cyclic : CyclicSystem p (solution p k)

theorem exists_unique_cyclicSystem (p : ℕ) [Fact p.Prime] (k : ℕ) :
    ∃! F : ZMod k → Lambda, (∀ δ, HasZeroConstant (F δ)) ∧ CyclicSystem p F
```

Proof plan. `iter_zeroConstant`: induction on n with `zeroConstant_cyclicRHS`. `iter_stable`: it suffices to prove `(iter (n+1) δ).coeff m = (iter (m+1) δ).coeff m` for `m ≤ n`... more simply prove by strong induction on m the statement "for all n, n' > m and all δ" : for m = 0 both sides are 0 (zero constant term); for m > 0 write n = a + 1, n' = b + 1, unfold one step of `iter`, and apply `coeff_frobeniusLift_lower` and `coeff_theta_lower` (as `cyclicSystem_unique` does: copy its last lines) with the hypothesis "coefficients of degree j < m of `iter a (δ+1)` and `iter b (δ+1)` agree", which is the induction hypothesis when a, b > j; when a ≤ j or b ≤ j handle it by first showing the auxiliary fact "`(iter n δ).coeff j = (iter (j+1) δ).coeff j` for n ≥ j + 1" in the same induction, or restate `iter_stable` as `∀ m, ∀ n ≥ m + 1, ∀ δ, (iter n δ).coeff m = (iter (m+1) δ).coeff m` and note that in the step a ≥ m ≥ j + 1. (Choose whichever formulation makes the induction go through; the displayed statement must be derivable.) `solution_cyclic`: compare coefficients; coefficient m of `cyclicRHS p (solution p k) δ` equals coefficient m of `cyclicRHS p (iter p k (m+1)) δ = iter p k (m+2) δ` because `solution` and `iter (m+1)` agree in degrees < m (by `iter_stable`) and both have zero constant term; then `iter_stable` again. For m = 0 use the zero constant terms. Uniqueness is `cyclicSystem_unique`.

**Target 2 (`Special.lean`): the value at y = p.** Let `evalY (p : ℕ) : Lambda →+* PowerSeries ℤ := PowerSeries.map (Polynomial.evalRingHom (p : ℤ))` (substitute y = p in every coefficient). Prove:

```lean
theorem evalY_cyclicRHS (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY p (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) + (evalY p (F (δ + 1))) ^ p

theorem evalY_solution (δ : ZMod k) :
    evalY p (solution p k δ) =
      (if δ = 0 then PowerSeries.X else 0) + (evalY p (solution p k (δ + 1))) ^ p
```

Proof plan: `theta_system_eq` gives `φ(f) + p·θ(f) = f^p`, so `φ(f) + y·θ(f) = f^p + (y − p)·θ(f)`, and `evalY` sends `PowerSeries.C Polynomial.X - (p : Lambda)` to 0. So `G δ := evalY p (solution p k δ)` satisfies `G δ = [δ = 0]·x + (G (δ+1))^p`, the equation of the generating functions of trees with leaves at depth ≡ −δ modulo k.

**Target 3, only if time remains (`Special.lean`):** the reduction at y = 0: with `evalY0 := PowerSeries.map (Polynomial.evalRingHom 0)`, `evalY0 (cyclicRHS p F δ) = [δ = 0]·x + evalY0 (φ (F (δ+1)))`, and `evalY0 (frobeniusLiftRingHom p _ f) = PowerSeries.expand p _ (evalY0 f)` (the constant coefficient in y of f(x^p, y^p) is that of f, with x replaced by x^p).

After each target that compiles, update `PLAN.md`.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      lake env lean MMM/Frob/Existence.lean -o .lake/build/lib/lean/MMM/Frob/Existence.olean

  The `-o` output is what lets a later file `import MMM.Frob.Existence`.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean`.
- Run one compile at a time. Other workers compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed. **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one, and no theorem whose conclusion is `True`.
- A file that does not compile at the end is worse than a shorter file that does: before you stop, make sure every file you leave compiles, by cutting the unfinished part out into a comment block at the end if necessary.
- Every file starts with a comment naming the model that wrote it, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything. Do not launch other workers or agents.
- Save files often so that a restart can continue. Compile early and often; do not write 200 lines before the first compile.

## Report

For each target: done or not, the exact Lean statement as it is in the file, the compile result of each file, what blocked the first thing you could not finish, and `#print axioms` for `exists_unique_cyclicSystem` and `evalY_solution` if they exist.
