/-
Written by Kimi K3.1 Pro (AI, worker W033), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

Kummer's divisibility bound from blockwise rotation symmetry. The proof partitions
words with n letters E into equivalence classes and uses the word bound; the block
decomposition of N is obtained by strong induction on N / p. No factorial valuation
or theorem about the valuation of a binomial coefficient is used.
-/
import MMM.Path.Word

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- Divisibility of a binomial coefficient after cutting the word into blocks. -/
theorem pow_dvd_choose_of_blocks [hp : Fact p.Prime] (L : List ℕ) (n c : ℕ) (hn : n ≤ len p L)
    (hc : (p - 1) * c + L.length ≤ ds p n + ds p (len p L - n)) :
    p ^ c ∣ (len p L).choose n := by
  rw [← card_cntEW L n]
  let s : Setoid {w : Word p L // cntEW w = n} :=
    ⟨fun a b => EqvW a.1 b.1,
      ⟨fun _ i => Eqv.refl _ _, fun h i => (h i).symm, fun h h' i => (h i).trans (h' i)⟩⟩
  refine dvd_card_of_classes s (p ^ c) (fun w => ?_)
  let e : {z : {w' : Word p L // cntEW w' = n} // s.r z w} ≃
      {w' : Word p L // EqvW w.1 w'} :=
    { toFun := fun z => ⟨z.1.1, fun i => (z.2 i).symm⟩
      invFun := fun z => ⟨⟨z.1, (cntEW_eq_of_eqv z.2).symm.trans w.2⟩, fun i => (z.2 i).symm⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Nat.card_congr e, card_classW]
  apply pow_dvd_pow
  have hb := lower_boundW hp.out.two_le w.1
  have hw : cntEW (w : Word p L) = n := w.2
  rw [hw] at hb
  have hh : (p - 1) * c + L.length ≤ (p - 1) * dW w.1 + L.length := hc.trans hb
  have hp0 : 0 < p - 1 :=
    Nat.sub_pos_of_lt hp.out.two_le
  have hh' : (p - 1) * c ≤ (p - 1) * dW w.1 := Nat.le_of_add_le_add_right hh
  exact Nat.le_of_mul_le_mul_left hh' hp0

theorem len_append (A B : List ℕ) : len p (A ++ B) = len p A + len p B := by
  simp [len]

theorem len_replicate_zero (m : ℕ) : len p (List.replicate m 0) = m := by
  simp [len]

/-- The sum of block lengths after increasing all heights is multiplied by p. -/
theorem len_map_succ (L : List ℕ) : len p (L.map (· + 1)) = p * len p L := by
  induction L with
  | nil => simp [len]
  | cons a L ih =>
      simp only [len, List.map_cons, List.sum_cons, pow_succ'] at ih ⊢
      rw [ih]
      change p * p ^ a + p * ((List.map (fun h => p ^ h)) L).sum =
        p * (p ^ a + ((List.map (fun h => p ^ h)) L).sum)
      ring

/-- The base-p digits of N as a list of block heights. -/
theorem exists_blocks (hp : 2 ≤ p) (N : ℕ) : ∃ L : List ℕ, len p L = N ∧ L.length = ds p N := by
  induction N using Nat.strong_induction_on with
  | _ N ih =>
    by_cases hN : N = 0
    · subst hN
      exact ⟨[], by simp [len], by simp [ds_zero]⟩
    · obtain ⟨L, hL, hd⟩ := ih (N / p) (Nat.div_lt_self (Nat.pos_of_ne_zero hN) hp)
      let L' := L.map (· + 1) ++ List.replicate (N % p) 0
      refine ⟨L', ?_, ?_⟩
      · dsimp only [L']
        rw [len_append, len_map_succ, len_replicate_zero, hL]
        exact Nat.div_add_mod N p
      · dsimp only [L']
        rw [List.length_append, List.length_map, List.length_replicate, ds_rec hp N, hd, add_comm]

/-- Kummer's theorem, divisibility half, from the action of rotations on words. -/
theorem kummer_dvd [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N ≤ ds p n + ds p (N - n)) : p ^ c ∣ N.choose n := by
  obtain ⟨L, hL, hd⟩ := exists_blocks (Nat.Prime.two_le (p := p) Fact.out) N
  rw [← hd, ← hL] at hc
  rw [← hL]
  exact pow_dvd_choose_of_blocks L n c (hL.symm ▸ hn) hc

end MMM.Path
