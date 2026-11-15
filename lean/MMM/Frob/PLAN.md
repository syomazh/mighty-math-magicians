# Frobenius proof — Lean plan (workers W025 and W027)

Written by Kimi K3.1 Pro, 2026-11-14; not human-reviewed.
The source note is `paper/frobenius_proof.tex`.

## Representation and Mathlib survey

Λ is represented in `Basic.lean` as `PowerSeries (Polynomial ℤ)`.  This directly
codes `Z[y][[x]]`.  `Polynomial.expand ℤ p` is the map `P(y) ↦ P(y^p)`, and
`PowerSeries.expand p hp` is substitution `x ↦ x^p`.  Their composition
`frobeniusLiftRingHom` is an explicit `RingHom`.  The variable formulas are
checked.  A mismatch between `MvPowerSeries.instAlgebra` and
`PowerSeries.algebraPolynomial` in this checkout was avoided by defining the
ring hom by its fields.

Relevant APIs: `Mathlib.RingTheory.PowerSeries.Expand`,
`Mathlib.Algebra.Polynomial.Expand`, `PowerSeries.map`,
`PowerSeries.coeff_map`, and `Mathlib.FieldTheory.Finite.Basic`.  Witt vectors
are in `Mathlib/RingTheory/WittVector/*`.  No δ-ring or power-series Hurwitz
formalization was used.  Reduction modulo p is `PowerSeries.map
(Polynomial.mapRingHom (Int.castRingHom (ZMod p)))`, coefficientwise.

## Table of statements of the note

| label in note | one-line statement | proposed Lean statement | Mathlib objects | depends on | difficulty | status |
|---|---|---|---|---|---|---|
| E1 | digit sums and carry-free sums | `Nat.digits`, `Nat.sum_digits`, carry predicates; finite sums | `Nat.digits`, Finset | — | medium | not done |
| E2 | nonconstant p-tuples form p-cycles | cyclic permutation on `Fin p → α`; fixed tuples constant | `ZMod p`, group actions | — | medium | not done |
| E3 | Fermat and Wilson | `Int.ModEq.pow_prime_eq_self`; Wilson factorial congruence | `ZMod`, Wilson | — | easy/medium | Fermat located; not done as files |
| definition Λ, φ | `φ(x^m y^d)=x^(pm)y^(pd)` | `frobeniusLiftRingHom`; `frobeniusLift_X`, `frobeniusLift_coeff_X` | `PowerSeries`, `Polynomial.expand` | — | easy | done |
| Lemma θ, congruence | `(f^p−φf)/p ∈ Λ` | `exists_frobenius_sub_eq_natCast_mul`, `theta_spec` | `PowerSeries.mk`, `ZMod` | congruence | medium | done |
| Lemma system | unique cyclic family Fδ; F0(x,p)=G | `F : ZMod k → Lambda`; coefficient recursion on x-degree | `PowerSeries.coeff`, `Fin` induction | θ | hard | existence and uniqueness done in `Existence.lean`; value at y=p in `Special.lean` |
| weight definition | `w(x^m y^d)=(p−1)d−s_p(m)` | integer-valued weight on monomials | `Nat.digits` | E1 | easy | not done |
| (wprod) | weight of products; carry-free equality | weight product inequality | `Nat.digits` | E1 | medium | not done |
| (wphi) | weight under φ | weight formula for φ | `PowerSeries.expand` | E1 | easy | not done |
| Lemma lower | Fδ coefficients have weight ≥−1 | coefficientwise lower bound | recursion, weight | system, wprod, wphi | medium | not done |
| Cor. div | y^t divides coefficient; p^t divides C | `Polynomial` divisibility and evaluation | `Polynomial` | lower | medium | not done |
| carry-free algebra A | functions N→Q with carry-free convolution | `add_monoid`, `Semiring` on carry-aware convolutions | `Finset`, convolution | E1 | hard | not done |
| Lemma lead (i) | Fδ(x,0)=sum x^(p^j) | evaluate y=0; unique recursion | `Polynomial.eval`, `PowerSeries` | system | medium | y=0 cyclic recursion and Frobenius-as-expansion done in `Special.lean`; explicit closed form not done |
| Lemma lead (ii) | ℓδ=αδ+(1/p)ℓδ+1^cf p | sequence convolution identity | carry algebra | lower, E1 | hard | not done |
| Lemma H | unique labelled exponential system | `MvPowerSeries (ZMod k) ℚ` with zero constant term | `MvPowerSeries` | — | medium | not done |
| Lemma subst | ℓ relates to T | substitution and base-p digits | `MvPowerSeries`, `Polynomial` | H, lead | hard | not done |
| Hurwitz subring H | integral exponential coefficients and derivatives | `MvPowerSeries`, derivative maps | `MvPowerSeries` | E2/E3 | hard | not done |
| Lemma hur (i)–(iv) | closure, p-power/derivative formulas | coefficientwise polynomial identities | `Finset`, multinomial | E2/E3 | hard | not done |
| Prop carry | carry-congruence and integrality | `(Derivative)` identities mod p | `ZMod`, `MvPowerSeries` | H, hur | hard | not done |
| Prop eval | induction on total digit weight | finite induction over `Fin k` | `ZMod`, Nat | carry | medium | not done |
| Theorem thm | coefficient congruence modulo p^(t+1) | valuation coefficient theorem | all above | all | hard | not done |
| tree dictionary | optional interpreting lemmas | none required for algebra | — | — | not pursued |

## Status / blockers

### W034: lower weight bound and the divisibility corollary

`Weight.lean` is a new compiling file (all 15 requested statements are done). It defines

```lean
def WB (p c : ℕ) (f : Lambda) : Prop :=
  ∀ m d, (f.coeff m).coeff d ≠ 0 → ds p m ≤ (p - 1) * d + c
```

and proves the closure lemmas `WB_zero`, `WB_one`, `WB_X`, `WB_mono`, `WB_add`, `WB_sub`,
`WB_mul`, `WB_pow`, `WB_frobeniusLift`, `WB_theta`, `WB_C_X_mul`, `WB_cyclicRHS`; the lower
bound `weight_solution : WB p 1 (solution p k δ)` by induction on the iterates; and the two
divisibility conclusions, `X_pow_dvd_coeff_solution` (via `Polynomial.X_pow_dvd_iff`) and
`pow_dvd_coeff_evalY_solution`. The key hypothesis `ds p m = (p - 1) * t + 1` is exactly that
of the brief (not weakened to a general bound). Product bounds use nested `antidiagonal` sums;
Frobenius uses `PowerSeries.coeff_expand` and `Polynomial.coeff_expand` together with
`ds_base_mul`. No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe` is used.

Axiom check:

```text
'MMM.Frob.pow_dvd_coeff_evalY_solution' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### W031: existence, value at y=p, and reduction at y=0

`Existence.lean` is a new compiling file. It defines `iter p k n δ`, starting at
zero and applying `cyclicRHS`; proves zero constant terms by induction; proves
`iter_stable_eq` by strong induction on coefficient degree; and derives the
brief's two-sided statement `iter_stable`. The limit is literally

```lean
noncomputable def solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) : Lambda :=
  PowerSeries.mk fun m => (iter p k (m + 1) δ).coeff m
```

The new theorems are `solution_zeroConstant`, `solution_cyclic`, and

```lean
theorem exists_unique_cyclicSystem (p : ℕ) [Fact p.Prime] (k : ℕ) :
    ∃! F : ZMod k → Lambda, (∀ δ, HasZeroConstant (F δ)) ∧ CyclicSystem p F
```

The key coefficient proof follows `cyclicSystem_unique`: the two lower-degree
lemmas for φ and θ are applied between the limit and its `(m+1)`-st iterate.

`Special.lean` is also compiling. It defines `evalY p := PowerSeries.map
(Polynomial.evalRingHom (p : ℤ))` and proves `evalY_cyclicRHS` and
`evalY_solution`. The proof transports `theta_system_eq` through the ring
homomorphism; the coefficient-variable term becomes `p * θ`, which cancels.
At `y=0`, it additionally defines `evalY0 := PowerSeries.map
(Polynomial.evalRingHom 0)`, proves
`evalY0 (frobeniusLiftRingHom p _ f) = PowerSeries.expand p _ (evalY0 f)`, and
reduces both cyclic-RHS equations to `if δ=0 then x else 0` plus the image of the
Frobenius lift (or equivalently the expanded series). No closed form for the
tree generating series is claimed, and the identification of `F 0` with a
particular catalytic generating function remains outside these files.

Axiom checks via `lake env lean --stdin`:

```text
'MMM.Frob.exists_unique_cyclicSystem' depends on axioms: [propext, Classical.choice, Quot.sound]
'MMM.Frob.evalY_solution' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### W027, targets 1–4 (completed after resuming the interrupted run)

`Theta.lean` proves

```
modSeries_frobeniusLift (p : ℕ) [Fact p.Prime] (f : Lambda) :
  modSeries p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) =
    (modSeries p f) ^ p
```

The proof combines `Polynomial.map_frobenius_expand` and
`PowerSeries.map_frobenius_expand` with reduction commuting with expansion.
An incorrect intermediate claim `modPoly_frobenius` was removed by the earlier
worker.  `ThetaDiv.lean` proves

```
exists_frobenius_sub_eq_natCast_mul (p : ℕ) [Fact p.Prime] (f : Lambda) :
  ∃ g : Lambda, f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f =
    (p : Lambda) * g

mul_natCast_prime_cancel (p : ℕ) [Fact p.Prime] {g h : Lambda} :
  (p : Lambda) * g = (p : Lambda) * h → g = h

theta (p : ℕ) [Fact p.Prime] (f : Lambda) : Lambda

theta_spec (p : ℕ) [Fact p.Prime] (f : Lambda) :
  (p : Lambda) * theta p f =
    f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f
```

`ThetaIdents.lean` retains the zero, one, `x`, `y`, sum and product identities,
and `theta_system_eq`.  `theta_add` uses

```
∑ i ∈ Finset.Ioo 0 p, ((p.choose i / p : ℕ) : Lambda) * f^i * g^(p-i)
```

and `theta_mul` gives `φ(f)θ(g) + φ(g)θ(f) + p θ(f)θ(g)`.  The `x` and `y`
formulas show that θ vanishes on those two variables.  Optional attempts at
negation/subtraction and separate `frobenius_natCast_theta` compatibility were
not retained because their rewrites were not completed.

### W027, target 5 (not done)

`System.lean` proves lower-degree dependence of the `m`-th coefficient of `φ`
for `0 < m`, a positive-summand bound for `Fin p` tuples, conversion of
`Finset.finsuppAntidiag` membership to its sum over `Fin p`, and lower-degree
coefficient dependence of both `f^p` and θ under zero-constant hypotheses.
The unused `hm` argument in the latter makes the intended `0 < m` restriction
clear; the proof also handles zero tuples via the zero-constant hypotheses.

`Uniqueness.lean` defines `cyclicRHS` and `CyclicSystem` exactly over `ZMod k`
and proves `cyclicSystem_unique` for all `k`, with zero-constant hypotheses.
It also checks the zero coefficient of φ, theta, and RHS.  Existence and the
relation at `y=p` are now supplied by W031's `Existence.lean` and `Special.lean`.
The uniqueness of the tree generating series was not part of W031 and remains
not done here; likewise, an explicit generating-series equation beyond
`evalY_solution` remains not done. Targets 6 onward remain not started.

### State inherited from W025

`Basic.lean` proves Λ, φ as a ring hom, φ(X)=X^p and φ(C Y)=C(Y^p).
`Theta.lean` proves the mod-p reduction lemmas and Frobenius congruence listed
above.  No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe` is used in
proof files.
