# W051 — Lean: weights that rotations do not change (a weighted form of the closed-family theorem)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## What this is

`lean/MMM/Closed.lean` and `lean/MMM/Profile.lean` (read them, and `Reduction.lean`, `Counting.lean`, `ReductionB.lean`) prove: a family of p-ary trees closed under rotation has a number of members divisible by p^t, and so the number of q-ary trees with a given number of nodes at each depth is divisible by p^t. The same argument gives a weighted statement: **if a weight w(T) is not changed by rotations, the sum of w over a rotation-closed family is divisible by p^t**, because the sum over a class of size p^d is p^d·w. In particular, for q = p^k and any integers b_0, b_1, …, the "depth-weighted" Fuss–Catalan number Σ_T ∏_(nodes v of T) b_(depth of v), over the q-ary trees with n nodes, is divisible by p^t.

Tested numerically before this brief was written? No: test the last statement yourself for small cases first (`uv run python`: q-ary trees with n nodes for q in {2, 3, 4}, n ≤ 6, random integer weights b_i; t from the base-p digit sum of (q − 1)n + 1). If it fails, stop and report.

## File you own

`lean/MMM/Weighted.lean` (new; namespace `MMM.PTree` for the tree statements). Nothing else.

## Statements

```lean
/-- The sum of a rotation-invariant weight over a rotation-closed family is divisible by p^e
when every member has d ≥ e. -/
theorem pow_dvd_sum_weight_of_closed [Fact p.Prime] (P : PTree p → Prop)
    (hP : ∀ S T, Rot S T → P T → P S) [Finite {T : PTree p // P T}] (e : ℕ)
    (he : ∀ T, P T → e ≤ T.d) (w : PTree p → ℤ) (hw : ∀ S T, Rot S T → w S = w T) :
    (p : ℤ) ^ e ∣ ∑ᶠ T : {T : PTree p // P T}, w T.1

/-- The weight of a tree by the depths of its nodes: ∏_i b_i ^ (number of nodes at depth i). -/
noncomputable def depthWeight (b : ℕ → ℤ) (T : PTree p) : ℤ :=
  ∏ i ∈ Finset.range (T.nodes + 1), b i ^ prof T i

/-- Depth-weighted Fuss–Catalan numbers, q = p^k: divisible by p^t for every integer weights. -/
theorem pow_dvd_sum_depthWeight (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (n t : ℕ)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) (b : ℕ → ℤ) :
    (p : ℤ) ^ t ∣ ∑ᶠ T : {T : PTree (p ^ k) // T.nodes = n}, depthWeight b T.1
```

(A node at depth i ≥ nodes cannot exist, so `range (T.nodes + 1)` covers every non-zero `prof T i`; prove the small lemma `prof T i = 0` for `T.nodes ≤ i` or use the existing `nodes_eq_sum_prof` / `prof_eq_zero_of_le` in `Profile.lean`. If another finite range is more convenient, use it and say so. Use `Finset.sum` over a `Fintype` instead of `finsum` if that is easier, with `Fintype.ofFinite`; say what you chose.)

## Proof plan

- `pow_dvd_sum_weight_of_closed`: as `dvd_card_of_classes` in `Counting.lean`, with weights. Sum over the quotient by `rotSetoidOn P`: the sum over the fibre of a class c is `(number of members of the class) * w(any member)` because w is constant on the class (`hw`), and the number of members is `p ^ d` with `d ≥ e` (`classOnEquiv` and `card_class` in `Reduction.lean` / `ClassSize.lean`, as used in `pow_dvd_card_of_closed`). `finsum_eq_sum_of_fintype`, `Finset.sum_fiberwise` or `Fintype.sum_sigma` with `Equiv.sigmaFiberEquiv`; `Finset.dvd_sum`.
- `pow_dvd_sum_depthWeight`: through the blocked form, as `pow_dvd_card_prof` in `Profile.lean` does for the counts: transport the sum over `{T : PTree (p ^ k) // T.nodes = n}` along `expand k` to the blocked p-ary trees with `(p^k - 1) n + 1` leaves (`Equiv.sum_comp` / `finsum_comp_equiv`; the equivalence is the one behind `card_pow_ary_eq_card_blocked` and `card_nodes_eq_card_leaves`), where the weight becomes `U ↦ ∏ i, b i ^ prof U (k * i)` (by `prof_expand`), which rotations do not change (`Rot.prof_eq`); the family is closed under rotation (`Rot.blockedAt`, `Rot.leaves_eq`) and every member has `t ≤ d` (the lower bound, as in `pow_dvd_card_prof`). Alternatively, and perhaps shorter: group the q-ary trees by their profile and use `pow_dvd_card_prof` for each profile (the weight depends only on the profile); choose what you can finish.

## Order of work, and what to do if it does not all fit

The first theorem, then the second. Keep the file compiling. If the second cannot be finished, leave the first and say so.

## Environment and rules

Lean is not on the PATH: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/Weighted.lean -o .lake/build/lib/lean/MMM/Weighted.olean`. **Never run `lake build`, `lake update` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean` or any existing file.** The project is on Lean v4.35.0 with Mathlib v4.35.0: grep `lean/.lake/packages/mathlib/Mathlib` for every lemma name. No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`; no theorem of Mathlib about valuations of factorials or binomial coefficients. The file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. No git command that changes anything. Another agent compiles on this laptop: one compile at a time.

## Report

The result of your numerical test; for each statement: done or not, the exact statement as in the file, the compile result, `#print axioms` for the last theorem, every change to a statement of this brief and why, what you did not verify.
