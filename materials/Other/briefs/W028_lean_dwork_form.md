# W028 — Lean: Legendre's formula with its residue, and the Dwork form (claim C20)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Goal

Two theorems in Lean 4 with Mathlib, in one new file. Both have a classical proof, given below step by step. The statements are fixed; your work is the proof.

## Files you own (create and edit only this)

- `lean/MMM/Dwork.lean`

## What exists (read first)

- `lean/MMM/Digits.lean`: `ds p m` (digit sum), `ds_rec : ds p n = n % p + ds p (n / p)` for `2 ≤ p`.
- `lean/MMM/DigitsCarry.lean`: `dig p j m := (m / p ^ j) % p`, `dig_zero : dig p 0 n = n % p`, `dig_succ : dig p (j + 1) n = dig p j (n / p)`. `lean/MMM/DigitsFree.lean`: `dig_eq_zero_of_lt`.
- `lean/MMM/ResidueB.lean`: `PTree.residue_primePower`: for a prime p, `0 < k`, `(p - 1) * t + 1 = ds p m`, `m ≡ 1 [MOD p ^ k - 1]`:
  `(Nat.card {T : PTree (p ^ k) // T.leaves = m} : ℤ) * ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡ (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]`.
- `lean/MMM/Exact.lean`: `ds_modEq : ds p m ≡ m [MOD p - 1]`. `lean/MMM/Digits.lean`: `ds_pos`.
- Mathlib: `ZMod.wilsons_lemma : ((p - 1)! : ZMod p) = -1` (`Mathlib/NumberTheory/Wilson.lean`), `ZMod.intCast_zmod_eq_zero_iff_dvd`, `Int.modEq_iff_dvd`, `Finset.prod_range_succ`, `Nat.factorial_succ`. See how `lean/MMM/Residue.lean` uses Wilson's theorem and `linear_combination` for a congruence modulo `p ^ (t + 1)`.

All these files are compiled, so `import MMM.ResidueB` (and `import MMM.Exact`) works.

## Deliverable (exact statements, in `namespace MMM`)

```lean
/-- `ν(m) = (m - s_p(m)) / (p - 1)`: the exponent of `p` in `m!`. -/
def nu (p m : ℕ) : ℕ := (m - ds p m) / (p - 1)

/-- Legendre's formula with its residue: `m! = p ^ ν(m) * ∏ m_j! * u` with `u ≡ (-1) ^ ν(m)`. -/
theorem factorial_eq_pow_mul_prod_mul (p : ℕ) [Fact p.Prime] (m : ℕ) :
    ∃ u : ℕ, m.factorial =
        p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m

/-- The Dwork form (claim C20): `#trees * m! ≡ (-p) ^ N (mod p ^ (N + 1))`, `N = (m - 1) / (p - 1)`. -/
theorem dwork_form (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m : ℕ) (hm0 : 0 < m)
    (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : PTree (p ^ k) // T.leaves = m} : ℤ) * (m.factorial : ℤ) ≡
      (-(p : ℤ)) ^ ((m - 1) / (p - 1)) [ZMOD (p : ℤ) ^ ((m - 1) / (p - 1) + 1)]
```

Check the statements numerically before you start (Python: `uv run python ...` from the repository root; the number of q-ary trees with m = (q − 1)n + 1 leaves is binom(qn, n)/((q − 1)n + 1)). If a statement is false as written, stop and report the counterexample; do not change it.

## Proof of the first theorem (strong induction on m)

Write `m = p * a + r` with `a = m / p`, `r = m % p < p`.

1. `m! = p ^ a * a! * B`, where `B = ∏ of the i in 1..m not divisible by p`. Equivalently, without filters: prove by induction on `a` that `(p * a)! = p ^ a * a! * W a` with `W a = ∏ c ∈ range a, ∏ s ∈ range (p - 1), (p * c + s + 1)`, and then `(p * a + r)! = (p * a)! * ∏ s ∈ range r, (p * a + s + 1)`.
2. Each block `∏ s ∈ range (p - 1), (p * c + s + 1)` is `≡ (p - 1)! = -1` in `ZMod p` (Wilson), so `W a ≡ (-1) ^ a`.
3. `∏ s ∈ range r, (p * a + s + 1) = r! * binom(p * a + r, r)` (`Nat.ascFactorial` or `Nat.choose` lemmas; grep Mathlib for `ascFactorial_eq_factorial_mul_choose` or `factorial_mul_factorial_dvd_factorial`), and `binom(p * a + r, r) ≡ 1` in `ZMod p` for `r < p` (because `∏ (p * a + s + 1) ≡ r!` and `r!` is a unit in `ZMod p`).
4. Induction hypothesis for `a` (when `m ≥ p`, so `a < m`): `a! = p ^ ν(a) * ∏_j (digit_j a)! * u_a`, `u_a ≡ (-1) ^ ν(a)`.
5. Digits: `dig p 0 m = r` and `dig p (j + 1) m = dig p j a`; so `∏ j ∈ range m, (dig p j m)! = r! * ∏ j ∈ range a, (dig p j a)!` (re-index; digits beyond the length are 0 and `0! = 1`, see `dig_eq_zero_of_lt`; you will need `m < p ^ m` and `a < p ^ a`, `Nat.lt_pow_self`). And `ν(m) = a + ν(a)` (from `ds_rec` and `m = p * a + r`; `p - 1` divides `m - ds p m`).
6. Put together: `u_m = u_a * W a * binom(p * a + r, r)`, and `u_m ≡ (-1) ^ ν(a) * (-1) ^ a = (-1) ^ ν(m)`. For `m < p`: `a = 0`, `ν = 0`, the product is `m!`, `u = 1`.

## Proof of the second theorem

Let `t` with `(p - 1) * t + 1 = ds p m` (it exists: `ds_modEq`, `ds_pos`, and `m ≡ 1 (mod p - 1)` because `p - 1 ∣ p ^ k - 1`; see how `PTree.problem137_leaves` in `lean/MMM/ExactB.lean` obtains `t`). Then `(m - 1) / (p - 1) = ν(m) + t`. From the first theorem `m! = p ^ ν * P * u` with `u = (-1) ^ ν + p * w` in ℤ; from `residue_primePower`, `C * P = (-p) ^ t + p ^ (t + 1) * e`. So `C * m! = p ^ ν * u * (C * P)`, and modulo `p ^ (ν + t + 1)` this is `(-p) ^ (ν + t)` (use `Int.modEq_iff_dvd` and `linear_combination`, as in `Residue.lean`).

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      lake env lean MMM/Dwork.lean -o .lake/build/lib/lean/MMM/Dwork.olean

- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`.
- Run one compile at a time. Other agents compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed. **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`.
- **A theorem whose conclusion is `True`, or that only restates an existing theorem under a new name, is not a result and must not be in the file.** If you cannot prove a statement, leave it out and say so. If you can prove the first theorem but not the second, deliver the first.
- Keep the two deliverable statements exactly as written. Helper lemmas are yours to choose.
- Start the file with a comment that names your model, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything. Do not launch other workers or agents.
- Work in short steps and save the file often. Use the time: about 80 minutes.

## Report

Whether the file compiles (paste the compile output), which of the two theorems are proved, the numerical check you ran, and `#print axioms` for each proved theorem.
