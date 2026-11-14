/-
Lemmas written by the second independent auditor (Claude Fable 5.2, a fresh instance with no
access to the orchestrator's session) in its scratch file on 2026-11-14, and adopted here by the
orchestrator (Claude Fable 5.2) with new names and no other change. Machine-checked by Lean when
this file compiles; not human-reviewed.

  **Other forms of the final statements** (audit 2, points 2 and 3):

* `problem137_exact`: by internal nodes and free of conventions: the number of `q`-ary trees with
  `n` nodes is positive, `p ^ t` divides it, `p ^ (t + 1)` does not.
* `residue_paper_form`: the residue as the paper states it: the number of trees is `p ^ t * c`
  with `c * ∏ m_j! = (-1) ^ t` in `ZMod p`.
* `prod_dig_eq_digits`, `residue_nodes`: the residue by internal nodes, with the product taken
  over Mathlib's digit list `Nat.digits p m`.
* `exact_of_residue`: the congruence of the residue statement alone implies the exact valuation.
-/
import MMM.ResidueB

namespace MMM

namespace PTree

/-- The convention-free form indexed by internal nodes: the number of trees is positive, and
`p ^ t` is the exact power of `p` in it. -/
theorem problem137_exact (p : ℕ) (hp : _root_.Nat.Prime p) (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = List.sum (_root_.Nat.digits p ((p ^ k - 1) * n + 1))) :
    0 < _root_.Nat.card {T : MMM.PTree (p ^ k) // MMM.PTree.nodes T = n} ∧
      p ^ t ∣ _root_.Nat.card {T : MMM.PTree (p ^ k) // MMM.PTree.nodes T = n} ∧
      ¬ p ^ (t + 1) ∣ _root_.Nat.card {T : MMM.PTree (p ^ k) // MMM.PTree.nodes T = n} := by
  have : Fact p.Prime := ⟨hp⟩
  have hq : 2 ≤ p ^ k := by
    calc 2 ≤ p := hp.two_le
      _ = p ^ 1 := (pow_one p).symm
      _ ≤ p ^ k := Nat.pow_le_pow_right (by have := hp.two_le; omega) hk
  have hm : (p ^ k - 1) * n + 1 ≡ 1 [MOD p ^ k - 1] := by
    have h : (p ^ k - 1) * n + 1 ≡ 0 + 1 [MOD p ^ k - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right _ _)).add_right 1
    rw [zero_add] at h
    exact h
  rw [MMM.PTree.card_nodes_eq_card_leaves hq n]
  obtain ⟨h1, h2⟩ := MMM.PTree.exact_valuation_primePower k hk _ t ht hm
  refine ⟨Nat.pos_of_ne_zero (fun h0 => h2 (h0 ▸ dvd_zero _)), h1, h2⟩

/-- Statement 3 gives the paper's form of the residue: `C / p ^ t * ∏ m_j! = (-1) ^ t` in `ZMod p`.
The product is over the digits `(m / p ^ j) % p`, `j < m`. -/
theorem residue_paper_form (p : ℕ) (hp : _root_.Nat.Prime p) (k : ℕ) (hk : 0 < k) (m t : ℕ)
    (ht : (p - 1) * t + 1 = List.sum (_root_.Nat.digits p m))
    (hm : m % (p ^ k - 1) = 1 % (p ^ k - 1)) :
    ∃ c : ℕ, _root_.Nat.card {T : MMM.PTree (p ^ k) // MMM.PTree.leaves T = m} = p ^ t * c ∧
      (c : ZMod p) * ((∏ j ∈ Finset.range m, Nat.factorial ((m / p ^ j) % p) : ℕ) : ZMod p) =
        (-1) ^ t := by
  have : Fact p.Prime := ⟨hp⟩
  obtain ⟨⟨c, hc⟩, -⟩ := MMM.PTree.exact_valuation_primePower k hk m t ht hm
  refine ⟨c, hc, ?_⟩
  have h := MMM.PTree.residue_primePower k hk m t ht hm
  rw [hc] at h
  obtain ⟨P, hPdef⟩ : ∃ P : ℕ, P = ∏ j ∈ Finset.range m, Nat.factorial ((m / p ^ j) % p) :=
    ⟨_, rfl⟩
  have hP' : (∏ j ∈ Finset.range m, (MMM.dig p j m).factorial) = P := by
    rw [hPdef]
    rfl
  rw [← hPdef]
  rw [hP'] at h
  have h2 := Int.modEq_iff_dvd.mp h
  have e : (-(p : ℤ)) ^ t - ((p ^ t * c : ℕ) : ℤ) * (P : ℤ) =
      (p : ℤ) ^ t * ((-1) ^ t - (c : ℤ) * (P : ℤ)) := by
    push_cast
    rw [neg_pow]
    ring
  rw [e, pow_succ] at h2
  have hp0 : (p : ℤ) ^ t ≠ 0 := pow_ne_zero t (by exact_mod_cast hp.ne_zero)
  have h4 : (p : ℤ) ∣ (-1) ^ t - (c : ℤ) * (P : ℤ) := (mul_dvd_mul_iff_left hp0).mp h2
  have h5 := (ZMod.intCast_zmod_eq_zero_iff_dvd _ p).mpr h4
  push_cast at h5
  exact (sub_eq_zero.mp h5).symm

theorem prod_range_getD (f : ℕ → ℕ) (hf : f 0 = 1) : ∀ (L : List ℕ) (N : ℕ), L.length ≤ N →
    ∏ j ∈ Finset.range N, f (L.getD j 0) = (L.map f).prod := by
  intro L
  induction L with
  | nil =>
    intro N _
    simp [hf]
  | cons a L ih =>
    intro N hN
    obtain ⟨N', rfl⟩ : ∃ N', N = N' + 1 := ⟨N - 1, by simp at hN; omega⟩
    rw [Finset.prod_range_succ', List.map_cons, List.prod_cons]
    have h1 : ∏ j ∈ Finset.range N', f ((a :: L).getD (j + 1) 0) = (L.map f).prod := by
      rw [← ih N' (by simpa using hN)]
      exact Finset.prod_congr rfl (fun j _ => by simp)
    rw [h1]
    simp [mul_comm]

/-- `∏ j ∈ Finset.range m, (dig p j m)!` is the product of the factorials of the entries of
`Nat.digits p m`. -/
theorem prod_dig_eq_digits (p m : ℕ) (hp : 2 ≤ p) :
    ∏ j ∈ Finset.range m, (MMM.dig p j m).factorial =
      ((_root_.Nat.digits p m).map Nat.factorial).prod := by
  have hlen : (Nat.digits p m).length ≤ m :=
    (Nat.digits_length_le_iff (by omega) m).mpr (Nat.lt_pow_self (by omega))
  rw [← prod_range_getD Nat.factorial rfl (Nat.digits p m) m hlen]
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [Nat.getD_digits m j hp]
  rfl

/-- Statement 3 indexed by internal nodes and written with Mathlib's digit list only. -/
theorem residue_nodes (p : ℕ) (hp : _root_.Nat.Prime p) (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = List.sum (_root_.Nat.digits p ((p ^ k - 1) * n + 1))) :
    (_root_.Nat.card {T : MMM.PTree (p ^ k) // MMM.PTree.nodes T = n} : ℤ) *
        (((_root_.Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have : Fact p.Prime := ⟨hp⟩
  have hq : 2 ≤ p ^ k := by
    calc 2 ≤ p := hp.two_le
      _ = p ^ 1 := (pow_one p).symm
      _ ≤ p ^ k := Nat.pow_le_pow_right (by have := hp.two_le; omega) hk
  have hm : (p ^ k - 1) * n + 1 ≡ 1 [MOD p ^ k - 1] := by
    have h : (p ^ k - 1) * n + 1 ≡ 0 + 1 [MOD p ^ k - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right _ _)).add_right 1
    rw [zero_add] at h
    exact h
  rw [MMM.PTree.card_nodes_eq_card_leaves hq n, ← prod_dig_eq_digits p _ hp.two_le]
  exact MMM.PTree.residue_primePower k hk _ t ht hm

/-- The congruence of the residue statement alone gives the exact power of `p`. -/
theorem exact_of_residue (p : ℕ) (hp : _root_.Nat.Prime p) (C m t : ℕ)
    (h : (C : ℤ) * ((∏ j ∈ Finset.range m, Nat.factorial ((m / p ^ j) % p) : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]) :
    p ^ t ∣ C ∧ ¬ p ^ (t + 1) ∣ C := by
  obtain ⟨P, hPdef⟩ : ∃ P : ℕ, P = ∏ j ∈ Finset.range m, Nat.factorial ((m / p ^ j) % p) :=
    ⟨_, rfl⟩
  rw [← hPdef] at h
  have hcop : Nat.Coprime p P := by
    rw [hPdef]
    refine Nat.Coprime.prod_right (fun j _ => ?_)
    rw [hp.coprime_iff_not_dvd, hp.dvd_factorial]
    exact not_le.mpr (Nat.mod_lt _ hp.pos)
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp h
  have hneg : (-(p : ℤ)) ^ t = (-1) ^ t * (p : ℤ) ^ t := by rw [neg_pow]
  have hCP : ((C * P : ℕ) : ℤ) = (p : ℤ) ^ t * ((-1) ^ t - p * e) := by
    push_cast
    linear_combination (-1 : ℤ) * he + hneg
  constructor
  · have h1 : ((p ^ t : ℕ) : ℤ) ∣ ((C * P : ℕ) : ℤ) := by
      rw [hCP]
      push_cast
      exact dvd_mul_right _ _
    have h2 : p ^ t ∣ C * P := Int.natCast_dvd_natCast.mp h1
    exact (Nat.Coprime.pow_left t hcop).dvd_of_dvd_mul_right h2
  · rintro ⟨c, hc⟩
    have h3 : (p : ℤ) ^ t * ((-1) ^ t - p * e) = (p : ℤ) ^ t * (p * ((c : ℤ) * (P : ℤ))) := by
      rw [← hCP, hc]
      push_cast
      ring
    have h4 : (-1 : ℤ) ^ t - p * e = p * ((c : ℤ) * (P : ℤ)) :=
      mul_left_cancel₀ (pow_ne_zero t (by exact_mod_cast hp.ne_zero)) h3
    have h5 : (p : ℤ) ∣ (-1) ^ t := ⟨(c : ℤ) * (P : ℤ) + e, by linear_combination h4⟩
    have hu : IsUnit ((-1 : ℤ) ^ t) := (isUnit_one.neg).pow t
    have hpu : IsUnit (p : ℤ) := isUnit_of_dvd_unit h5 hu
    have h1 : p = 1 := Nat.isUnit_iff.mp (Int.ofNat_isUnit.mp hpu)
    exact hp.one_lt.ne' h1

end PTree

end MMM
