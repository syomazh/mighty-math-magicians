/-
Written by `open-math — kimi-k3.1-pro` (model `moonshotai/kimi-k3.1-pro`), 2026-11-14; not human-reviewed.

Digit forest of m: \S3 of accounting_proof.tex (Lemmas L3/L4) skeleton.
Definitions only. The orbit-stabiliser identity
  m! = p^\nu * (\prod_j m_j!) * |F(m)|
needs a permutation action on F(m) listed as "not done" in PLAN.md.
This file gives the numerical data: internal nodes of a complete tree
of height j is (p^j-1)/(p-1) and its automorphism count is p^{that}.
No sorry; no axiom.
-/
import MMM.Digits
import MMM.DigitsCarry
import MMM.Acct.Basic

namespace MMM.Acct

open MMM

/-- Internal nodes of a complete p-ary tree of height j: (p^j-1)/(p-1). -/
def completeNodes (p j : Nat) : Nat := (p ^ j - 1) / (p - 1)

theorem completeNodes_zero (p : Nat) : completeNodes p 0 = 0 := by simp [completeNodes]

theorem completeNodes_succ (p : Nat) (hp : 2 <= p) (j : Nat) :
    completeNodes p (j + 1) = completeNodes p j + p ^ j := by
  have hp1 : 0 < p - 1 := by omega
  have hdvd : (p - 1) ∣ (p ^ j - 1) :=
    Nat.sub_one_dvd_pow_sub_one p j
  have hpow : p ^ (j + 1) = p ^ j * p := by ring
  have hspec : p ^ (j + 1) - 1 = (p ^ j - 1) + p ^ j * (p - 1) := by
    have h1 : 1 <= p ^ j := Nat.one_le_pow _ _ (by omega)
    have hle : p ^ j <= p ^ (j + 1) := Nat.pow_le_pow_right (by omega) (Nat.le_succ _)
    have h2 : p ^ j * p = p ^ j * (p - 1) + p ^ j := by
      have hp_eq : p = (p - 1) + 1 := by omega
      calc p ^ j * p = p ^ j * ((p - 1) + 1) := by rw [<- hp_eq]
        _ = p ^ j * (p - 1) + p ^ j * 1 := by rw [Nat.mul_add]
        _ = p ^ j * (p - 1) + p ^ j := by rw [Nat.mul_one]
    calc p ^ (j + 1) - 1 = p ^ j * p - 1 := by rw [hpow]
      _ = (p ^ j * (p - 1) + p ^ j) - 1 := by rw [h2]
      _ = p ^ j * (p - 1) + (p ^ j - 1) := by omega
      _ = (p ^ j - 1) + p ^ j * (p - 1) := by rw [Nat.add_comm]
  unfold completeNodes
  calc (p ^ (j + 1) - 1) / (p - 1) = ((p ^ j - 1) + p ^ j * (p - 1)) / (p - 1) := by rw [hspec]
    _ = (p ^ j - 1) / (p - 1) + p ^ j * (p - 1) / (p - 1) := by
        rw [Nat.add_div_of_dvd_right hdvd]
    _ = (p ^ j - 1) / (p - 1) + p ^ j := by rw [Nat.mul_div_cancel _ hp1]

/-- Automorphism count of a complete p-ary tree of height j. -/
def autComplete (p j : Nat) : Nat := p ^ completeNodes p j

theorem autComplete_zero (p : Nat) : autComplete p 0 = 1 := by simp [autComplete, completeNodes]

theorem autComplete_succ (p : Nat) (hp : 2 <= p) (j : Nat) :
    autComplete p (j + 1) = autComplete p j * p ^ p ^ j := by
  unfold autComplete
  rw [completeNodes_succ p hp j, pow_add]

end MMM.Acct
