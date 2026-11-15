# W041 — Lean: the path proof, part 3 (reduction to the minimal words; when a block is minimal)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`lean/MMM/Path/` has, compiled and in the build: `Block.lean` (`Blk p h`, `cntE`, `Eqv`, `Sym`, `d`, `cntE_le`, `cntE_eq_of_eqv`, `d_eq_of_eqv`), `ClassSize.lean` (`card_class`), `Bound.lean` (`lower_bound`, `pow_dvd_card`), `Count.lean` (`card_cntE`), `Word.lean` (`Word p L`, `len`, `cntEW`, `EqvW`, `dW`, `card_classW`, `lower_boundW`, `card_cntEW`), `Kummer.lean` (`pow_dvd_choose_of_blocks`, `exists_blocks`, `kummer_dvd`). Read them and `PLAN.md` there; change none. The mathematics: `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`, the equality cases of Lemma `lem:bound` and Proposition `prop:bound`, equation (modp), and Lemma `lem:atoms`.

The divisibility half of Kummer's theorem is done. This part prepares the exactness half: (A) modulo p^(c+1) only the words with d = c matter; (B) when exactly a block attains the lower bound. As before, **no theorem of Mathlib about valuations of factorials or binomial coefficients may be used.**

## Files you own

`lean/MMM/Path/Minimal.lean` and `lean/MMM/Path/MinBlock.lean` (both new). You may append to `lean/MMM/Path/PLAN.md`. Nothing else.

## Part A (`Minimal.lean`): reduction to the minimal words

```lean
theorem card_cntEW_modEq_minimal [Fact p.Prime] (L : List ℕ) (n c : ℕ)
    (hc : ∀ w : Word p L, cntEW w = n → c ≤ dW w) :
    Nat.card {w : Word p L // cntEW w = n} ≡
      Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)]

theorem choose_modEq_minimal [Fact p.Prime] (L : List ℕ) (n c : ℕ) (hn : n ≤ len p L)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    (len p L).choose n ≡ Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)]
```

Plan: the words with `cntEW w = n` and `dW w ≠ c` form a set that is a union of `EqvW`-classes (`cntEW` and `dW` are constant on classes), and each of these classes has `p ^ dW w` elements with `dW w ≥ c + 1`; so `p ^ (c + 1)` divides the number of such words, exactly as in `pow_dvd_choose_of_blocks` (see how that proof uses `dvd_card_of_classes` from `MMM/Counting.lean`). The set of all words with `cntEW w = n` is the disjoint union of this set and the set with `dW w = c`. For the second theorem, `lower_boundW` and `hc` give the hypothesis of the first, and `card_cntEW` rewrites the left side.

## Part B (`MinBlock.lean`): when a block attains the bound

```lean
/-- Equality in `lower_bound`. -/
def MinBlk [NeZero p] (h : ℕ) (u : Blk p h) : Prop :=
  (p - 1) * d h u + 1 = ds p (cntE h u) + ds p (p ^ h - cntE h u)

/-- A block all of whose letters are equal has d = 0. -/
theorem d_eq_zero_of_mono [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h)
    (hu : cntE h u = 0 ∨ cntE h u = p ^ h) : d h u = 0
/-- Conversely. -/
theorem mono_of_d_eq_zero [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h) (hd : d h u = 0) :
    cntE h u = 0 ∨ cntE h u = p ^ h
theorem minBlk_of_mono [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h)
    (hu : cntE h u = 0 ∨ cntE h u = p ^ h) : MinBlk h u

/-- A mixed block attains the bound exactly when its p sub-blocks attain it and their numbers of
letters E, and of letters S, add up without carries. -/
theorem minBlk_succ_iff [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p (h + 1))
    (hmix : 0 < cntE (h + 1) u ∧ cntE (h + 1) u < p ^ (h + 1)) :
    MinBlk (h + 1) u ↔
      (∀ j, MinBlk h (u j)) ∧
      ∑ j, ds p (cntE h (u j)) = ds p (cntE (h + 1) u) ∧
      ∑ j, ds p (p ^ h - cntE h (u j)) = ds p (p ^ (h + 1) - cntE (h + 1) u)
```

Plan. `d_eq_zero_of_mono`: induction on h; if all letters are equal then every sub-block has all letters equal (a sum of p numbers ≤ p^h equal to 0 or to p·p^h forces each to be 0 or p^h), the sub-blocks are pairwise equivalent (two blocks with all letters E are equal; prove `cntE h u = p ^ h → cntE h v = p ^ h → u = v` and the same for 0, by induction), so the block is symmetric. `mono_of_d_eq_zero`: induction; `d = 0` forces symmetric and all sub-blocks with `d = 0`; equivalent sub-blocks have the same `cntE`, each 0 or p^h, hence all 0 or all p^h. `minBlk_succ_iff`: follow the proof of `lower_bound` in `Bound.lean` and keep track of equality. If `Sym h u` holds for a mixed u, then all `cntE h (u j)` are equal to some a₀ with 0 < a₀ < p^h, `d (h+1) u = p * d h (u 0)` with `d h (u 0) ≥ 1` (by `mono_of_d_eq_zero`), and the bound is strict: `(p - 1) * (p * d₀) + 1 > (p - 1) * d₀ + 1 ≥ ds a₀ + ds (p^h − a₀) = ds (p·a₀) + ds (p·(p^h − a₀))` (`ds_base_mul`); and on the right side of the iff the condition `∑ j, ds (cntE (u j)) = ds (cntE u)` reads `p * ds a₀ = ds a₀`, impossible for a₀ > 0 (`ds_pos`). So for symmetric mixed u both sides are false. If `¬ Sym h u`, then `d (h+1) u = ∑ j, d h (u j) + 1` and the chain of inequalities in `lower_bound` (`ds_sum_le` twice and the bound for each sub-block) is an equality exactly when each link is; use that `a ≤ b`, `a' ≤ b'` and `a + a' = b + b'` force `a = b` and `a' = b'` (omega after naming the sums).

## Environment and rules

Exactly as in `briefs/W033_lean_path_kummer_dvd.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Path/Minimal.lean -o .lake/build/lib/lean/MMM/Path/Minimal.olean`, likewise `MinBlock`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`, no valuation theorems of Mathlib; every file must compile when you stop; header naming the model; no git changes). Several other workers compile on this machine tonight: one compile at a time, and be patient.

## Report

For each statement: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `choose_modEq_minimal` and `minBlk_succ_iff` if they exist.
