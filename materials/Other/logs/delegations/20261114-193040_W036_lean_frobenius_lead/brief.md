# W036 — Lean: the Frobenius proof, part 6 (the leading part: Lemma "Leading part")

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`lean/MMM/Frob/` has, compiled and in the build: `Basic`, `Theta`, `ThetaDiv` (`theta`, `theta_spec`, `coeff_natCast_mul`), `ThetaIdents`, `System` (`HasZeroConstant`), `Uniqueness` (`cyclicRHS`, `CyclicSystem`), `Existence` (`solution`, `solution_zeroConstant`, `solution_cyclic`), `Special` (`evalY0`, `evalY0_cyclicRHS_expand`), `Weight` (`WB`, `WB_pow`, `WB_frobeniusLift`, `weight_solution : WB p 1 (solution p k δ)`). Read them first; change none. The mathematics is Section "The leading part: a carry-free product" of `paper/frobenius_proof.tex` (lines 208 to 278): Lemma `lem:lead`, parts (i) and (ii).

## Files you own

`lean/MMM/Frob/YZero.lean` and `lean/MMM/Frob/Lead.lean` (both new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Target 1 (`YZero.lean`): part (i), the family at y = 0

```lean
/-- α_δ: the indicator of the powers p^j with j ≡ -δ modulo k. -/
def alpha (p k : ℕ) (δ : ZMod k) (m : ℕ) : ℤ :=
  if ∃ j : ℕ, m = p ^ j ∧ (j : ZMod k) + δ = 0 then 1 else 0

theorem evalY0_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) :
    evalY0 (solution p k δ) = PowerSeries.mk (alpha p k δ)
```

Plan. By `solution_cyclic` and `evalY0_cyclicRHS_expand`, `f δ := evalY0 (solution p k δ)` satisfies `f δ = [δ = 0]·X + PowerSeries.expand p _ (f (δ + 1))` and has zero constant term. Show that `g δ := PowerSeries.mk (alpha p k δ)` satisfies the same (for m = p^j: j = 0 gives the X term, j ≥ 1 gives the coefficient of x^(p^(j−1)) of g (δ + 1), since (j − 1) + (δ + 1) = j + δ; if m is not a power of p both sides vanish; use that p ≥ 2 and `Nat.pow_right_injective`), and that such a system has at most one solution without constant terms: the coefficient of x^M in `expand p h` is the coefficient of x^(M/p) of h when p ∣ M and 0 otherwise (grep `PowerSeries.coeff_expand`), and M/p < M for M > 0; strong induction on the degree, for all δ at once.

## Target 2 (`Lead.lean`): the leading coefficients

```lean
/-- The coefficient of the monomial of weight -1 at x^m: that of x^m y^((s_p(m) - 1)/(p - 1)),
and 0 if m = 0 or p - 1 does not divide s_p(m) - 1. -/
def lead (p : ℕ) (f : Lambda) (m : ℕ) : ℤ :=
  if 0 < m ∧ (p - 1) ∣ (ds p m - 1) then (f.coeff m).coeff ((ds p m - 1) / (p - 1)) else 0

theorem lead_add : lead p (f + g) m = lead p f m + lead p g m
theorem lead_X (hp : 2 ≤ p) : lead p (PowerSeries.X : Lambda) m = if m = 1 then 1 else 0
theorem lead_frobeniusLift [Fact p.Prime] (hf : WB p 1 f) (M : ℕ) :
    lead p (frobeniusLiftRingHom p _ f) M =
      if ∃ j : ℕ, M = p ^ (j + 1) then (f.coeff (M / p)).coeff 0 else 0
```

Plan for `lead_frobeniusLift`: the coefficient of x^M y^D in φ(f) is that of x^m y^d in f when M = p·m and D = p·d and is 0 otherwise (as in `WB_frobeniusLift`). If it is nonzero at D = (s_p(M) − 1)/(p − 1), then with s_p(M) = s_p(m) (`ds_base_mul`) and `hf` one gets (p − 1)·p·d + 1 = s_p(m) ≤ (p − 1)·d + 1, so d = 0 and s_p(m) = 1, so m is a power of p (a number with digit sum 1; prove this small lemma: `ds p m = 1 → ∃ j, m = p ^ j`, by strong induction with `ds_rec`). Conversely for M = p^(j+1) the exponent D is 0 and the coefficient is that of x^(p^j) y^0 in f.

## Target 3 (`Lead.lean`): the term y·θ(f) and the carry-free product

```lean
/-- Carry-free p-fold product: the sum, over the ordered p-tuples of natural numbers with sum m
whose digit sums add up to the digit sum of m, of the products of the values. -/
def cfpow (p : ℕ) (g : ℕ → ℤ) (m : ℕ) : ℤ :=
  ∑ c ∈ (Finset.Nat.antidiagonalTuple p m).filter (fun c => ∑ i, ds p (c i) = ds p m),
    ∏ i, g (c i)

theorem lead_C_X_mul_theta [Fact p.Prime] (hf : WB p 1 f) (hf0 : HasZeroConstant f) (m : ℕ) :
    (p : ℤ) * lead p (PowerSeries.C Polynomial.X * theta p f) m = cfpow p (lead p f) m
```

Plan. Write s = `ds p`. If m = 0 or (p − 1) ∤ s(m) − 1, the left side is 0, and so is every term on the right: a term is nonzero only if every c_i ≥ 1 with s(c_i) ≡ 1 (mod p − 1), and then Σ s(c_i) ≡ p ≡ 1, so s(m) ≡ 1. Otherwise let τ = (s(m) − 1)/(p − 1). If τ = 0 the left side is the coefficient of y^0 of y·θ(f), which is 0, and the right side is empty because Σ s(c_i) ≥ p > 1 = s(m) for tuples of positive numbers (tuples with some c_i = 0 give the factor `lead p f 0 = 0`). If τ ≥ 1: the left side is p times the coefficient of x^m y^(τ−1) of θ(f), which by `theta_spec` is the coefficient of x^m y^(τ−1) of f^p − φ(f). The term φ(f) contributes 0 there: by `WB_frobeniusLift` a monomial of φ(f) has s(m) ≤ (p − 1)(τ − 1) + 1 < s(m). For f^p, expand the coefficient of x^m as a sum over p-tuples (m_i) with sum m of products of coefficients (`PowerSeries.coeff_pow` or `coeff_prod`; see `coeff_pow_lower` in `System.lean` for the form Mathlib gives) and the coefficient of y^(τ−1) of each product of p polynomials as a sum over p-tuples (d_i) with sum τ − 1. A term with all factors nonzero has s(m_i) ≤ (p − 1)d_i + 1 for every i (`hf`) and m_i ≥ 1 (`hf0`); adding up, Σ s(m_i) ≤ (p − 1)(τ − 1) + p = s(m) ≤ Σ s(m_i) (`ds_sum_le`), so equality holds everywhere: Σ s(m_i) = s(m) and d_i = (s(m_i) − 1)/(p − 1) with p − 1 dividing s(m_i) − 1. So for a tuple (m_i) in the filter exactly one tuple (d_i) contributes, with product ∏ lead p f (m_i), and for a tuple (m_i) outside the filter nothing contributes. If the double expansion is too heavy in one piece, first prove a general lemma: "the coefficient of x^m y^D of ∏_{i<p} f_i is the sum over pairs of tuples of the products of the coefficients".

## Target 4 (`Lead.lean`): part (ii) for the family

```lean
theorem lead_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m : ℕ) :
    (p : ℤ) * lead p (solution p k δ) m =
      (p : ℤ) * alpha p k δ m + cfpow p (lead p (solution p k (δ + 1))) m
```

Plan: `solution_cyclic` gives `solution δ = [δ = 0]·X + φ(F') + y·θ(F')` with `F' = solution (δ + 1)`. Use `lead_add`, `lead_X`, `lead_frobeniusLift` (with `weight_solution`), target 3 (with `weight_solution`, `solution_zeroConstant`), and target 1 to read the coefficient of x^(p^j) y^0 of F' as `alpha p k (δ + 1) (p ^ j)`; then `[δ = 0]·[m = 1] + [m = p^(j+1)]·alpha (δ + 1) (p^j) = alpha δ m`.

Do the targets in the order 1, 2, 4-assuming-3, 3: if target 3 cannot be finished, state target 4 with the conclusion of target 3 for `f = solution p k (δ + 1)` as an explicit hypothesis, under the name `lead_solution_of_theta`, and say so. Do not state the unconditional theorem unless it is proved.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/YZero.lean -o .lake/build/lib/lean/MMM/Frob/YZero.olean`, likewise `Lead`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`; every file must compile when you stop; header naming the model; no git changes).

## Report

For each target: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `evalY0_solution` and `lead_solution` if they exist.
