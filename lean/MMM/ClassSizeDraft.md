# Plan for the Lean files on rotation equivalence and class size (Step 1)

Written by Claude Fable 5.2 (orchestrator), 2026-11-14. A working note for whoever writes the Lean files; not a proof.

All statements are about `MMM.PTree p`, `PTree.Rot`, `PTree.Symmetric`, `PTree.d` from `MMM/Trees.lean`.

## File `MMM/RotEquiv.lean` (needs only `[NeZero p]`)

1. `Rot.refl : ∀ T, Rot T T` (induction on T; shift 0).
2. `Rot.symm : Rot S T → Rot T S` (induction on the relation; shift −r; `sub_add_cancel`).
3. `Rot.trans : Rot S T → Rot T U → Rot S U` (induction on the first, cases on the second; shift r' + r).
4. `Rot.d_eq : Rot S T → S.d = T.d` (induction; the sum is reindexed by `i ↦ i + r`; `Symmetric f ↔ Symmetric g` from 2 and 3).
5. `Rot.nodes_eq`, and `Rot.leaves_eq` already exists.

## File `MMM/ClassSize.lean` (needs `[Fact p.Prime]`)

Goal: `theorem card_class (T : PTree p) : Nat.card {S : PTree p // Rot S T} = p ^ T.d`.

Induction on T.

- **leaf.** `{S // Rot S leaf}` has exactly one element.
- **node f.** Every `S` with `Rot S (node f)` is `node g` with `∃ r, ∀ i, Rot (g (i + r)) (f i)`.
  For a fixed shift r let `A r := {g : Fin p → PTree p // ∀ i, Rot (g (i + r)) (f i)}`. The map `g ↦ fun i => g (i + r)` is an equivalence `A r ≃ ((i : Fin p) → {S // Rot S (f i)})`, so by the induction hypothesis `Nat.card (A r) = ∏ i, p ^ (f i).d = p ^ ∑ i, (f i).d` (and all these types are finite).
  - **Symmetric f.** Then `g ∈ A r ↔ g ∈ A 0` for every r (use `Rot.symm`, `Rot.trans` and `hs`). So the class is in bijection with `A 0`, and `(node f).d = ∑ i, (f i).d`.
  - **Not symmetric.** The sets `A r` are pairwise disjoint: if `g` lies in `A r` and `A r'` with `r ≠ r'`, then `Rot (f i) (f (i + (r - r')))` for all i (up to the direction of the shift), and since `r - r' ≠ 0` generates `ZMod p` (p prime), all `f i` are equivalent: contradiction. So the class is in bijection with `Σ r : Fin p, A r`, of cardinality `p * p ^ ∑ i, (f i).d = p ^ ((∑ i, (f i).d) + 1)`, and `(node f).d = (∑ i, (f i).d) + 1`.

Useful Mathlib facts to look for (names may differ; search the sources): `Nat.card_congr`, `Nat.card_pi`, `Nat.card_sigma`, `Nat.card_eq_fintype_card`, `Finite.of_equiv`, `Equiv.piCongrLeft`, `Equiv.addRight`, `Fin` as an additive group when `NeZero p`, `ZMod.natCast_self`, the fact that a nonzero element of `ZMod p` (p prime) generates the additive group (`ZMod.intCast_zmod_cast`, `IsUnit`, `mul_inv_cancel₀` in the field `ZMod p`): to reach `j` from `i` by steps of `s ≠ 0`, take `n = (j - i) * s⁻¹`.

## Then, file `MMM/Divisibility.lean`

`theorem pow_t_dvd_card (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) : p ^ t ∣ Nat.card {T : PTree p // T.leaves = m}`.

- The set of trees with m leaves is finite (strong induction on m: a node with m leaves has p children with fewer leaves each, since p ≥ 2 and every tree has at least one leaf).
- It is a disjoint union of rotation classes (`Rot` is an equivalence relation preserving `leaves`), each of cardinality `p ^ d` with `d ≥ t` by `PTree.t_le_d`. Hence the divisibility.

This is the divisibility half of the theorem ("p^t divides the number of p-ary trees with m leaves"), proved from tree symmetries, with the number of trees taken as the definition of the Fuss–Catalan number.
