# W047 — Lean: rotation-closed families (claim C11) and level profiles (claim C10)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## What this is

The main proof shows that every rotation class of p-ary trees has p^d members and that d ≥ t. So **every family of trees that is closed under rotation** has a number of members divisible by p^t. Two consequences are in the ledger of claims and are not yet in Lean in their natural form:

- **C11:** for a rotation-closed family F of trees with m leaves, |F| ≡ p^t · (number of rotation classes in F with d = t) modulo p^(t+1).
- **C10 (so far a conjecture supported by computation):** fix the number n_i of internal nodes at each depth i of a q-ary tree, q = p^k (the "level profile"). The number of q-ary trees with this profile is ∏_i binom(q·n_i, n_(i+1)), and it is divisible by p^t, where t = (s_p((q − 1)n + 1) − 1)/(p − 1), n = Σ n_i. Reason: rotations do not change the depth of any node, so the trees with a given profile form a rotation-closed family.

The final statement uses Mathlib's definitions only. It was tested for 2797 profiles (p = 2, 3, 5; k up to 3): no failure.

## What exists (read these files first; change none)

`lean/MMM/Trees.lean` (`PTree p` with `leaf` and `node : (Fin p → PTree p) → PTree p`; `leaves`, `nodes`), `RotEquiv.lean` (`Rot`, `Rot.d_eq`, `Rot.symm`, `Rot.trans`, the number `d`), `ClassSize.lean` (`card_class : Nat.card {S // Rot S T} = p ^ T.d`), `Divisibility.lean` (`lower_bound`: the bound d ≥ t for a tree with m leaves; find its exact form), `Counting.lean` (`card_eq_sum_classes`, `dvd_card_of_classes`), `Reduction.lean`:

```lean
def rotSetoidOn (P : PTree p → Prop) : Setoid {T : PTree p // P T}
theorem pow_dvd_card_of_closed (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S)
    [Finite {T : PTree p // P T}] (e : ℕ) (he : ∀ T, P T → e ≤ T.d) : p ^ e ∣ Nat.card {T : PTree p // P T}
theorem card_minimal_eq (m t : ℕ) : Nat.card {T : PTree p // IsMinimal m t T} =
    p ^ t * Nat.card (Quotient (rotSetoidOn (IsMinimal (p := p) m t)))        -- via card_eq_pow_mul_classes
```

`ReductionB.lean` (`card_modEq_minimal_of_closed`), `Blocked.lean` (`BlockedAt k δ T`: every leaf of T, seen from offset δ, is at a depth divisible by k; `Rot.blockedAt`), `BlockedForm.lean` (`expand k : PTree (p ^ k) → PTree p`, `build`, `leaves_expand`, `blockedAt_expand`, `card_pow_ary_eq_card_blocked`: the q-ary trees with m leaves are the blocked p-ary trees with m leaves), `ExactB.lean` (`card_nodes_eq_card_leaves`: n nodes ↔ (q − 1)n + 1 leaves), `Exact.lean`/`Digits.lean` (`ds`, `ds_modEq`), `FussFormula.lean` (a count of forests by a step-by-step bijection, `Forest`, `forestStep`, `forest_card`: a model for part 3), `Frob/Problem137.lean` (how a statement with `Nat.digits` and `multiplicity` is derived from one with `ds`).

The project is on **Lean v4.35.0 with Mathlib v4.35.0**; lemma names must be checked in `lean/.lake/packages/mathlib/Mathlib`.

## Files you own

`lean/MMM/Closed.lean` (part 1), `lean/MMM/Profile.lean` (parts 2 to 4; split into `Profile1.lean`, `Profile2.lean` if it grows). New files; nothing else.

## Part 1 (`Closed.lean`): the congruence for closed families (C11)

```lean
theorem card_closed_modEq_classes [Fact p.Prime] (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S)
    [Finite {T : PTree p // P T}] (t : ℕ) (ht : ∀ T, P T → t ≤ T.d) :
    Nat.card {T : PTree p // P T} ≡
      p ^ t * Nat.card (Quotient (rotSetoidOn (fun T : PTree p => P T ∧ T.d = t))) [MOD p ^ (t + 1)]
```

From `card_modEq_minimal_of_closed` and the lemma behind `card_minimal_eq` (`card_eq_pow_mul_classes` in `Reduction.lean`; the family `P T ∧ T.d = t` is closed because `Rot.d_eq`).

## Part 2 (`Profile.lean`): the profile and rotations

```lean
/-- The number of internal nodes of a tree at depth i. -/
def prof : PTree p → ℕ → ℕ
  | leaf, _ => 0
  | node _, 0 => 1
  | node f, i + 1 => ∑ j, prof (f j) i
theorem Rot.prof_eq [NeZero p] {S T : PTree p} (h : Rot S T) : prof S = prof T
```

(Induction on `Rot`; a rotation at the root re-indexes the sum: `Equiv.sum_comp` with `Equiv.addRight r`.)

## Part 3 (`Profile.lean`): the number of trees with a given profile

For any arity q ≥ 1, a number of levels L and a profile `n : ℕ → ℕ`:

```lean
theorem card_prof (q : ℕ) (hq : 1 ≤ q) (L : ℕ) (n : ℕ → ℕ) (h0 : n 0 = 1) (hL : n L = 0) :
    Nat.card {T : PTree q // ∀ i, i ≤ L → prof T i = n i} =
      ∏ i ∈ Finset.range L, Nat.choose (q * n i) (n (i + 1))
```

(If `prof T L = 0` then T has no node at depth ≥ L, so the condition up to L determines the whole profile; state it in the form that is most convenient and true, and say what you chose. Finiteness of the family: these trees have Σ n_i nodes; `finite_leaves_eq` or the like in `Divisibility.lean`.)

Plan: generalise to forests. For r ≥ 0 let `F r` be the type of r-tuples of trees (`Fin r → PTree q`), with profile the sum of the profiles. Claim: the number of r-tuples with `prof i = n i` for `i ≤ L` and `n L = 0` is `r.choose (n 0) * ∏ i ∈ range L, (q * n i).choose (n (i+1))` shifted suitably, by induction on L: an r-tuple of trees is the choice of the set of positions that are internal nodes (a subset of `Fin r` of size n 0: `Finset.card_powersetCard`, `Fintype.card_fin`) together with the (q · n_0)-tuple of their subtrees (reindex `S × Fin q` as `Fin (q * n 0)`: `Fintype.equivFinOfCardEq`, `finProdFinEquiv`), whose profile is the old one shifted by one level. Make this one bijection lemma, then induct. `FussFormula.lean` does a bijection of the same kind (`forestStep`); copy its shape.

## Part 4 (`Profile.lean`): divisibility, in Mathlib's terms

```lean
/-- Claim C10: every level-profile count of q-ary trees, q = p^k, is divisible by p^t. -/
theorem pow_dvd_prod_choose_profile (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (L : ℕ) (n : ℕ → ℕ)
    (h0 : n 0 = 1) (hL : n L = 0) (t : ℕ)
    (ht : (p - 1) * t + 1 =
      (Nat.digits p ((p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1)).sum) :
    p ^ t ∣ ∏ i ∈ Finset.range L, Nat.choose (p ^ k * n i) (n (i + 1))
```

Plan. By part 3 with q = p^k the product is the number of q-ary trees with the profile; they have Σ_{i<L} n_i nodes, hence (q − 1)·Σ n_i + 1 leaves. Through `expand k` (injective; its image is the blocked trees) they correspond to the blocked p-ary trees T with that number of leaves whose **p-ary** profile at the depths k·i equals n_i: prove `prof (expand k T) (k * i) = prof T i` (a q-ary node becomes k levels of p-ary nodes, `build`; the nodes at depths k·i + j with 0 < j < k are the inner nodes of these blocks; you only need the depths that are multiples of k). The family `{U : PTree p // U.leaves = m ∧ BlockedAt k 0 U ∧ ∀ i ≤ L, prof U (k * i) = n i}` is closed under rotation (`Rot.prof_eq`, `Rot.blockedAt`, leaves are preserved), every member has `t ≤ U.d` (the lower bound for m leaves), so `pow_dvd_card_of_closed` gives the divisibility of its cardinality; and its cardinality is that of the q-ary family (restrict the equivalence of `card_pow_ary_eq_card_blocked`, or use `Nat.card_congr` with `expand` and its surjectivity onto blocked trees: `exists_expand` in `BlockedForm.lean`).

If the transfer through `expand` is the obstacle, an acceptable weaker last theorem is the same divisibility for k = 1 (q = p prime, where no `expand` is needed), named `pow_dvd_prod_choose_profile_prime`; say so.

## Order of work, and what to do if it does not all fit

Parts 1, 2, then 3 and 4. Keep every file compiling. If something cannot be proved, leave it out, keep what depends on it conditional under a different name with the missing statement as an explicit hypothesis, and say so. Do not state a theorem with the names above unless it is proved as stated.

## Environment and rules

Lean is not on the PATH: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/Closed.lean -o .lake/build/lib/lean/MMM/Closed.olean` (likewise `Profile`). **Never run `lake build`, `lake update` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean` or any existing file.** Grep Mathlib for every lemma name. No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`. **No theorem of Mathlib about valuations of factorials or binomial coefficients** (`padicValNat`, `multiplicity` of factorials or binomials, Legendre, Kummer, Lucas, `Nat.Prime.dvd_choose…`): the divisibility must come from the rotation classes. Every file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. No git command that changes anything. Other agents compile on this laptop: one compile at a time.

## Report

For each statement: done or not, the exact statement as in the file, compile results, `#print axioms` for the last theorem of each part, every change to a statement of this brief and why, what you did not verify.
