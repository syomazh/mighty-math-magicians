Created `lean/MMM/LegendreChoose.lean`. No other source files were changed.

Both requested statements are **done, unchanged**:
```lean
theorem choose_add_prime_modEq (p : ℕ) [Fact p.Prime] (n r : ℕ) (hr : r < p) :
    Nat.choose (p + n) r ≡ Nat.choose n r [MOD p]

theorem choose_mul_add_modEq_one_action (p : ℕ) [Fact p.Prime] (a r : ℕ) (hr : r < p) :
    ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1
```

The proof uses translation on `ZMod p ⊕ Fin n`, identifies fixed `r`-subsets with subsets of `Fin n`, and applies the p-group fixed-point congruence; no forbidden shortcuts or elementary substitute proof.

Final single-file compilation succeeded with **no errors or warnings**. Required output:
```text
'MMM.choose_mul_add_modEq_one_action' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe`. The scoped `axiom` search also returned no matches. No full project build or human review was performed.
