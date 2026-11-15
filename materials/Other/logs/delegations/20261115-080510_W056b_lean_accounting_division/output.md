Both theorems compile cleanly with **only the allowed axioms** (no `sorryAx`).

---

## Summary

**File created:** `lean/MMM/AccountingDiv.lean` (only file touched, as required by the brief).

### `nodes_eq_nu_add` — **done, compiles**

```lean
theorem nodes_eq_nu_add (p : ℕ) [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    (p - 1) * (nu p m + t) + 1 = m
```
Proof uses `ds_le`, `ds_modEq`, and the explicit decomposition `m = (p-1)k + ds p m`.

### `residue_of_L1_of_legendre` — **done, compiles**

Statement is exactly as specified in the brief (unchanged). Proof outline:
1. From `hLeg`, get `m! = p^ν · D · u` in ℤ and `u = (-1)^ν + p·w` via `ZMod.intCast_zmod_eq_zero_iff_dvd`.
2. Use `Int.modEq_iff_dvd` to turn `hL1` into divisibility, substitute `hfact'`, split `(-p)^(ν+t) = p^ν · ((-1)^ν · (-p)^t)`, factor out `p^ν`, and cancel via `mul_left_cancel₀` (using `p^ν ≠ 0`).
3. mtp `p^t ∣ D·u·C` from `p^t ∣ (-p)^t` and `p^t ∣ p^(t+1)·e`.
4. Lift `u` coprime to `p` to `IsCoprime (p:ℤ) (u:ℤ)` via `ZMod.isUnit_iff_coprime` + `Nat.isCoprime_iff_coprime`, then `IsCoprime.pow_left` and `IsCoprime.dvd_of_dvd_mul_left`.
5. Substitute `hw'` into `D·u·C`, rearrange, and use that `(-1)^ν · (-1)^ν = 1` (via `mul_pow`) to cancel and finish.

### Final compile result
```
'MMM.residue_of_L1_of_legendre' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Only the three allowed axioms — **no `sorryAx`**. No warnings.

### Verified
- No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe`.
- No valuation of factorial/binomial lemmas.
- No forbidden `frobenius`/`add_pow_char`/`add_pow_expChar` lemmas.

### Not verified
- Mathematical correctness was checked by Lean, but the proof has not been reviewed by a human.
