Implemented and compiled all three targets. No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe`.

### Files created or changed

- `lean/MMM/Frob/Existence.lean`
- `lean/MMM/Frob/Special.lean`
- `lean/MMM/Frob/PLAN.md`
- Generated `Existence.olean` and `Special.olean` under `.lake/build`.

### Target 1 — done

`Existence.lean` contains the specified definitions and proves:

```lean
theorem iter_zeroConstant (p : ℕ) [Fact p.Prime] (n : ℕ) :
    ∀ δ : ZMod k, HasZeroConstant (iter p k n δ)
```

```lean
theorem iter_stable {p : ℕ} [Fact p.Prime] {m n n' : ℕ} (hn : m < n) (hn' : m < n')
    (δ : ZMod k) : (iter p k n δ).coeff m = (iter p k n' δ).coeff m
```

```lean
noncomputable def solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) : Lambda :=
  PowerSeries.mk fun m => (iter p k (m + 1) δ).coeff m
```

```lean
theorem solution_zeroConstant (p : ℕ) [Fact p.Prime] (δ : ZMod k) :
    HasZeroConstant (solution p k δ)
```

```lean
theorem solution_cyclic (p : ℕ) [Fact p.Prime] (k : ℕ) :
    CyclicSystem p (solution p k)
```

```lean
theorem exists_unique_cyclicSystem (p : ℕ) [Fact p.Prime] (k : ℕ) :
    ∃! F : ZMod k → Lambda, (∀ δ, HasZeroConstant (F δ)) ∧ CyclicSystem p F
```

A helper `iter_stable_eq` makes the strong induction and the repeated use of lower coefficients more convenient than directly inducting on the two-sided stability statement.

### Target 2 — done

`Special.lean` defines:

```lean
noncomputable def evalY (p : ℕ) : Lambda →+* PowerSeries ℤ :=
  PowerSeries.map (Polynomial.evalRingHom (p : ℤ))
```

and proves:

```lean
theorem evalY_cyclicRHS (p : ℕ) [Fact p.Prime] (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY p (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) +
      (evalY p (F (δ + 1))) ^ p
```

```lean
theorem evalY_solution (p : ℕ) [Fact p.Prime] (δ : ZMod k) :
    evalY p (solution p k δ) = (if δ = 0 then PowerSeries.X else 0) +
      (evalY p (solution p k (δ + 1))) ^ p
```

The proof transports `theta_system_eq` through `evalY p`; the variable coefficient becomes `p`, so the theta correction cancels.

### Target 3 — done

`Special.lean` also defines `evalY0` and proves:

```lean
theorem evalY0_frobeniusLift (p : ℕ) [Fact p.Prime] (f : Lambda) :
    evalY0 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) =
      PowerSeries.expand p (Fact.out : p.Prime).ne_zero (evalY0 f)
```

```lean
theorem evalY0_cyclicRHS (p : ℕ) [Fact p.Prime] (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY0 (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) +
      evalY0 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (F (δ + 1)))
```

It also provides the equivalent RHS-expanded form, `evalY0_cyclicRHS_expand`.

### Verification

Direct invocations of `lake env lean` completed with exit code 0 and no diagnostics for both files:

- `MMM/Frob/Existence.lean`
- `MMM/Frob/Special.lean`

Axiom checks returned:

```text
'MMM.Frob.exists_unique_cyclicSystem' depends on axioms:
[propext, Classical.choice, Quot.sound]

'MMM.Frob.evalY_solution' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

I did **not** run `lake build` or update `MMM.lean`, as the brief forbids those. Nothing outside these statements was verified—in particular, a closed form for the tree generating series or its identification with a separate established generating function was not proved.
