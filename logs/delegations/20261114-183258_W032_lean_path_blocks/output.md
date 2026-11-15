No errors, no `sorry`. (`rc=1` is just grep finding no matches.)

## Summary

**Done — all four targets.**

Files created (all mine, no others touched):
- `lean/MMM/Path/Block.lean` — definitions `Blk`, `cntE`, `Eqv`, `Sym`, `d`, `cntS`; equivalence-relation lemmas; `cntE_le`; `cntE_eq_of_eqv`, `cntS_eq_of_eqv`, `d_eq_of_eqv`, `sym_iff_of_eqv`.
- `lean/MMM/Path/ClassSize.lean` — `card_class : Nat.card {v : Blk p h // Eqv h u v} = p ^ d h u` for `p` prime, plus helpers `sym_of_shift` and `classEquiv`. Mirrors `MMM/ClassSize.lean`.
- `lean/MMM/Path/Bound.lean` — `lower_bound : ds p (cntE h u) + ds p (p^h - cntE h u) ≤ (p-1)*d h u + 1` for `2 ≤ p`, and the optional `pow_dvd_card`.
- `lean/MMM/Path/PLAN.md` — status table and notes.

All three `.lean` files compile with `lake env lean` and produce `.olean` files under `.lake/build/lib/lean/MMM/Path/`.

**Axioms** for `card_class`, `lower_bound`, `pow_dvd_card`, `cntE_eq_of_eqv`, `d_eq_of_eqv`: `[propext, Classical.choice, Quot.sound]` only.

**Deviations from the brief** (also in PLAN.md):
- `Blk` and `cntE` are marked `@[reducible]` so `Blk p 0` unifies with `Bool`. `Eqv` is *not* reducible (reducibility broke structural recursion on `h`); instead I added `Eqv_zero` and `Eqv_succ` exposing the defining equations and used them in proofs. Statements unchanged.
- `lower_bound` carries `[NeZero p]` as an instance binder (the brief's section already supplied it implicitly); `pow_dvd_card` carries `[Fact p.Prime]`. `hn : n ≤ p^h` is stated as the brief demanded but is unused by the proof.

**Not verified:** I did not run `lake build` (forbidden) and did not check integration with the rest of `MMM.lean`'s import graph — I compiled each file individually with `lake env lean` only. No independent review of the proofs beyond Lean's kernel.
