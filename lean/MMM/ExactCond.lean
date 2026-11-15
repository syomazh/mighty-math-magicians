/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **The exact valuation, given Step 4.**

`Step4 p` is the statement about labelled trees that the cherry collapse proves
(`MMM/Cherry.lean`): the number of `p`-ary trees whose leaves are labelled, without repetition,
by a set of `(p - 1) * t + 1` labels is not divisible by `p ^ (t + 1)`.

Everything in this file is proved *from* `Step4 p` as a hypothesis, by Steps 1, 2 and 3:
if the base-`p` digits of `m` are all 0 or 1, then `p ^ t` is the exact power of `p` in the
number of `p`-ary trees with `m` leaves. For `p = 2` every `m` qualifies.
The unconditional statements are in `MMM/Exact.lean`.
-/
import MMM.Atoms
import MMM.Catalan
import Mathlib.Data.Nat.PadicValNat

namespace MMM

/-- **Step 4, as a statement** about trees with distinctly labelled leaves. -/
def Step4 (p : ℕ) : Prop :=
  ∀ (t : ℕ) (S : Finset ℕ), S.card = (p - 1) * t + 1 →
    ¬ p ^ (t + 1) ∣ Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = S}

/-- "`p ^ t` divides `c` and `p ^ (t + 1)` does not" says that the valuation of `c` is `t`. -/
theorem multiplicity_eq_of_exact {p : ℕ} [hp : Fact p.Prime] {c t : ℕ} (h1 : p ^ t ∣ c)
    (h2 : ¬ p ^ (t + 1) ∣ c) : multiplicity p c = t := by
  have hc : c ≠ 0 := fun h => h2 (h ▸ dvd_zero _)
  have hfin : FiniteMultiplicity p c :=
    Nat.finiteMultiplicity_iff.mpr ⟨hp.out.ne_one, Nat.pos_of_ne_zero hc⟩
  have e1 := hfin.pow_dvd_iff_le_multiplicity.mp h1
  have e2 : ¬ t + 1 ≤ multiplicity p c := fun h =>
    h2 (hfin.pow_dvd_iff_le_multiplicity.mpr h)
  omega

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- Exact valuation for `m = ∑_{j ∈ D} p ^ j`. -/
theorem exact_of_sum_pow (h4 : Step4 p) (D : Finset ℕ) (t : ℕ) (hD : D.card = (p - 1) * t + 1) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = ∑ j ∈ D, p ^ j} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = ∑ j ∈ D, p ^ j} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have ht : (p - 1) * t + 1 = ds p (∑ j ∈ D, p ^ j) := by rw [ds_sum_pow hp2, hD]
  refine exact_of_minimal _ t ht ?_
  -- Step 3: the minimal trees are the labelled trees
  have e1 := Nat.card_congr (LTree.minimalEquiv hp2 (∑ j ∈ D, p ^ j) t ht)
  have e2 : Nat.card {U : LTree p ℕ // U.Good ∧ U.lab = D} =
      Nat.card {U : LTree p ℕ // U.CarryFree ∧ U.wt = ∑ j ∈ D, p ^ j} :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => LTree.good_lab_iff hp2 D U))
  rw [← e1, ← e2]
  exact h4 t D hD

/-- **Exact valuation when the digits of `m` are 0 or 1.** -/
theorem exact_of_digits_le_one (h4 : Step4 p) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (h01 : ∀ j, dig p j m ≤ 1) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  obtain ⟨D, rfl⟩ := exists_sum_pow hp2 m h01
  exact exact_of_sum_pow h4 D t (by rw [ht, ds_sum_pow hp2])

/-- The same, as a valuation. -/
theorem multiplicity_card_trees_of_digits_le_one (h4 : Step4 p) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m)
    (h01 : ∀ j, dig p j m ≤ 1) :
    multiplicity p (Nat.card {T : PTree p // T.leaves = m}) = t :=
  multiplicity_eq_of_exact (exact_of_digits_le_one h4 m t ht h01).1
    (exact_of_digits_le_one h4 m t ht h01).2

end PTree

/-- **Catalan numbers, exact power of 2**, given Step 4 for `p = 2`:
`v_2(C_n) = s_2(n + 1) - 1`. -/
theorem multiplicity_two_catalan_of_step4 (h4 : Step4 2) (n : ℕ) :
    multiplicity 2 (catalan n) = (Nat.digits 2 (n + 1)).sum - 1 := by
  have hpos : 0 < ds 2 (n + 1) := ds_pos (by omega) (n + 1) (Nat.succ_pos n)
  have ht : (2 - 1) * (ds 2 (n + 1) - 1) + 1 = ds 2 (n + 1) := by
    simp only [Nat.add_one_sub_one, Nat.one_mul]
    omega
  have h01 : ∀ j, dig 2 j (n + 1) ≤ 1 := fun j => by
    have := dig_lt (p := 2) (by omega) j (n + 1)
    omega
  obtain ⟨h1, h2⟩ := PTree.exact_of_digits_le_one h4 (n + 1) _ ht h01
  rw [PTree.card_binary_trees] at h1 h2
  exact multiplicity_eq_of_exact h1 h2

end MMM
