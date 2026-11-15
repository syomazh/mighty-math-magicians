# W039 — Lean: the Frobenius proof, part 9 (Proposition "Evaluation", from the carry congruence)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## What this is

Proposition `prop:eval` of `paper/frobenius_proof.tex` (lines 431 to 453) is an induction that uses only two facts about a function T_0 on multi-indices: the carry congruence of Proposition `prop:carry` and the value 1 at the unit vector e_0. This brief asks for that induction as a self-contained statement about an arbitrary function with these two properties. Read the proposition and its proof.

## File you own

`lean/MMM/Frob/Eval.lean` (new; it needs no import from the project). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Statements (namespace `MMM.Frob`)

Multi-indices are functions `ZMod k → ℕ` with `[NeZero k]`; `c.val` is the representative of `c : ZMod k` in {0, …, k − 1}; `Pi.single c 1` is the unit vector e_c.

```lean
/-- The weight Σ_c a_c p^c of a multi-index. -/
def wt (p k : ℕ) [NeZero k] (a : ZMod k → ℕ) : ℕ := ∑ c, a c * p ^ c.val

theorem sum_modEq_one_of_wt (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (a : ZMod k → ℕ)
    (hw : wt p k a ≡ 1 [MOD p ^ k - 1]) : (∑ c, a c) ≡ 1 [MOD p - 1]

/-- Proposition "Evaluation". -/
theorem eval_of_carry (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (T0 : (ZMod k → ℕ) → ℤ)
    (h1 : T0 (Pi.single 0 1) = 1)
    (hcarry : ∀ (b : ZMod k → ℕ) (c : ZMod k),
      (p : ℤ) ∣ T0 (b + p • Pi.single c 1) + T0 (b + Pi.single (c + 1) 1))
    (a : ZMod k → ℕ) (ha : a ≠ 0) (hw : wt p k a ≡ 1 [MOD p ^ k - 1]) :
    T0 a ≡ (-1) ^ ((∑ c, a c - 1) / (p - 1)) [ZMOD p]
```

(Here `∑ c, a c - 1` means `(∑ c, a c) - 1`; write the parentheses.)

## Proof plan

- `sum_modEq_one_of_wt`: p ≡ 1 modulo p − 1, so p^c ≡ 1 and `wt p k a ≡ ∑ c, a c` modulo p − 1; and p − 1 divides p^k − 1 (`Nat.sub_one_dvd_pow_sub_one` or `nat_sub_dvd_pow_sub_pow`; grep), so the hypothesis descends to the modulus p − 1.
- `eval_of_carry`: strong induction on `n = ∑ c, a c`, for all `a` with that sum (generalise `a`).
  - **Case: some `a c ≥ p`.** Put `b = a - p • Pi.single c 1` (so `a = b + p • Pi.single c 1`) and `a' = b + Pi.single (c + 1) 1`. Then `∑ a' = ∑ a − (p − 1) < ∑ a`, `a' ≠ 0`, and `wt a' ≡ wt a` modulo p^k − 1: the weight changes by `p ^ (c + 1).val − p · p ^ c.val`, and either `c.val + 1 < k`, where `(c + 1).val = c.val + 1` (`ZMod.val_add_one_of_lt` or compute with `ZMod.val_add`, `ZMod.val_one`; grep), so the two terms are equal; or `c.val = k − 1`, where `(c + 1).val = 0` and `p · p ^ (k − 1) = p ^ k ≡ 1 = p ^ 0`. For k = 1 only the second case occurs. By `hcarry b c`, `T0 a ≡ − T0 a'` modulo p; by induction `T0 a' ≡ (−1)^((∑ a' − 1)/(p − 1))`; and `(∑ a − 1)/(p − 1) = (∑ a' − 1)/(p − 1) + 1` because p − 1 divides `∑ a' − 1` (`sum_modEq_one_of_wt` for a', and `∑ a' ≥ 1`).
  - **Case: every `a c ≤ p − 1`.** Then `1 ≤ wt p k a ≤ (p − 1)(1 + p + … + p^(k−1)) = p^k − 1` (the map `c ↦ c.val` is a bijection of `ZMod k` with `Fin k` or `Finset.range k`; `Nat.geomSum_eq` or `Nat.pred_mul_geom_sum_le`; grep). A number in [1, p^k − 1] congruent to 1 modulo p^k − 1 equals 1 (if p^k − 1 = 1 this is immediate; otherwise it is < 1 + (p^k − 1)). So `wt p k a = 1`, which forces `a = Pi.single 0 1`: all terms `a c * p ^ c.val` with `c.val ≥ 1` are multiples of p ≥ 2, so they vanish, and `a 0 = 1`. Then `T0 a = 1` and the exponent is 0.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/Eval.lean -o .lake/build/lib/lean/MMM/Frob/Eval.olean`; never `lake build`; grep Mathlib for names, especially for `ZMod.val`; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop; header naming the model; no git changes). Several other workers compile on this machine tonight: one compile at a time, and be patient.

## Report

Done or not for each statement, the statements as they are in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `eval_of_carry` if it exists.
