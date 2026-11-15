# W034 — Lean: the Frobenius proof, part 4 (weights: the lower bound and the divisibility)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`lean/MMM/Frob/` now has, compiled: `Basic`, `Theta`, `ThetaDiv` (`theta`, `theta_spec`), `ThetaIdents`, `System`, `Uniqueness` (`cyclicRHS`, `CyclicSystem`), `Existence` (`iter`, `solution`, `coeff_solution : (solution p k δ).coeff m = (iter p k (m + 1) δ).coeff m`, `exists_unique_cyclicSystem`), `Special` (`evalY p : Lambda →+* PowerSeries ℤ`, `evalY_solution`). Read them first; do not change them. The mathematics is in `paper/frobenius_proof.tex`: the definition of the weight (line 177), Lemma `lem:lower` (line 191) and Corollary `cor:div` (line 203).

## Files you own

`lean/MMM/Frob/Weight.lean` (new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Statements (namespace `MMM.Frob`; `ds` is the digit sum of `MMM.Digits`, lemmas `ds_add_le`, `ds_base_mul`, `ds_one` there)

```lean
/-- Every monomial x^m y^d of f satisfies s_p(m) ≤ (p - 1) d + c: its weight is at least -c. -/
def WB (p c : ℕ) (f : Lambda) : Prop :=
  ∀ m d, (f.coeff m).coeff d ≠ 0 → ds p m ≤ (p - 1) * d + c

theorem WB_zero : WB p c 0
theorem WB_one : WB p 0 1
theorem WB_X (hp : 2 ≤ p) : WB p 1 (PowerSeries.X : Lambda)
theorem WB_mono (h : a ≤ b) : WB p a f → WB p b f
theorem WB_add : WB p c f → WB p c g → WB p c (f + g)
theorem WB_sub : WB p c f → WB p c g → WB p c (f - g)
theorem WB_mul (hp : 2 ≤ p) : WB p a f → WB p b g → WB p (a + b) (f * g)
theorem WB_pow (hp : 2 ≤ p) : WB p a f → ∀ n, WB p (n * a) (f ^ n)
theorem WB_frobeniusLift [Fact p.Prime] : WB p c f → WB p c (frobeniusLiftRingHom p _ f)
theorem WB_theta [Fact p.Prime] : WB p 1 f → WB p p (theta p f)
theorem WB_C_X_mul : WB p (c + (p - 1)) h → WB p c (PowerSeries.C Polynomial.X * h)
theorem WB_cyclicRHS [Fact p.Prime] (F : ZMod k → Lambda) (hF : ∀ δ, WB p 1 (F δ)) (δ : ZMod k) :
    WB p 1 (cyclicRHS p F δ)

/-- The note's Lemma "Lower bound": every monomial of F_δ has weight at least -1. -/
theorem weight_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) : WB p 1 (solution p k δ)

/-- The note's Corollary: y^t divides the coefficient of x^m, and p^t divides its value at y = p. -/
theorem X_pow_dvd_coeff_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) : (Polynomial.X : Polynomial ℤ) ^ t ∣ (solution p k δ).coeff m
theorem pow_dvd_coeff_evalY_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) : (p : ℤ) ^ t ∣ (evalY p (solution p k δ)).coeff m
```

## Proof plan

- `WB_mul`: a monomial (m, d) of f·g with nonzero coefficient comes from some (m₁, d₁) of f and (m₂, d₂) of g with m₁ + m₂ = m, d₁ + d₂ = d and both coefficients nonzero (if all such products vanished the double sum would be 0; use `PowerSeries.coeff_mul`, `Polynomial.coeff_mul`, `Finset.exists_ne_zero_of_sum_ne_zero`); then `ds_add_le`. `WB_pow` by induction.
- `WB_frobeniusLift`: the coefficient of x^M y^D in φ(f) is that of x^m y^d in f if M = p·m and D = p·d, and 0 otherwise (`PowerSeries.coeff_expand`, `Polynomial.coeff_expand`, as in `System.lean`); `ds_base_mul` gives ds (p·m) = ds m ≤ (p−1)d + c ≤ (p−1)(p·d) + c.
- `WB_theta`: `theta_spec` says p·θ(f) = f^p − φ(f). If θ(f) has a nonzero coefficient at (m, d) then so does p·θ(f) (ℤ has no zero divisors; see `coeff_natCast_mul` in `ThetaDiv.lean`), hence f^p − φ(f) does; f^p is `WB p p` by `WB_pow` (p·1 = p) and φ(f) is `WB p 1`, hence `WB p p`.
- `WB_C_X_mul`: the coefficient of y^d in y·P is that of y^(d−1) in P, and 0 for d = 0.
- `WB_cyclicRHS`: X is `WB 1`; φ(F) is `WB 1`; θ(F) is `WB p` = `WB (1 + (p − 1))`, so y·θ(F) is `WB 1`.
- `weight_solution`: `WB p 1 (iter p k n δ)` for all n, δ by induction on n; then use `coeff_solution`.
- `X_pow_dvd_coeff_solution`: `Polynomial.X_pow_dvd_iff`; for d < t a nonzero coefficient would give (p−1)t + 1 ≤ (p−1)d + 1. `pow_dvd_coeff_evalY_solution`: a coefficient of `evalY p f` is `Polynomial.eval (p : ℤ)` of the coefficient of f; X^t ∣ P gives p^t ∣ P.eval p.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/Weight.lean -o .lake/build/lib/lean/MMM/Frob/Weight.olean`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop; header naming the model; no git changes).

## Report

For each statement: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `pow_dvd_coeff_evalY_solution` if it exists.
