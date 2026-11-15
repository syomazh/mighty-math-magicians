/-
Written by `open-math — kimi-k3.1-pro` (model `moonshotai/kimi-k3.1-pro`), 2026-11-14; not human-reviewed.

The note's Lemma L1 (" Trees: each of the `N(m)` nodes is worth `−p` ") read off
the existing Lean.

Lemma L1 states `m! · C = p^{N(m)} · L(m)` with `L(m)` the number of cyclic
`k`-blocked `p`-ary trees whose `m` leaves are labelled `1..m`, and
`L(m) ≡ (−1)^{N(m)} (mod p)` (Lemma L0 with `a = m·e₀`). In Lean the labelled
count for `(p−1)t+1` distinct labels is `labelled_valuation` / `labelled_congruence`,
and `m = (p−1)N+1`. The identity `m!·C = p^N·L` itself is the orbit-counting
step `m!` labellings fall into `p^d` classes: `LTree.card_class` gives `p^d`
per class, and for distinct labels every node is asymmetric so `d = N`.

What we prove here: the labelled congruence implies the note's
`L(m) ≡ (−1)^{N(m)}` by dividing `labelled_congruence : |labelled| ≡ (−p)^t`
by `p^t`. For the prime-power case we use `labelled_congruence_blocked`.
No new counting is done; we reuse `MMM/Residue.lean` and `MMM/ResidueB.lean`.

Not proved here (listed as `not done` in PLAN.md): the general vector `T(a)`
statement of Lemma L0; the `m!·C = p^N·L` equality as a standalone named lemma
with `C` = `PTree (p^k)` (it follows from `Residue` + `card_class` but needs a
finiteness bridge we do not repeat).
-/
import MMM.Residue
import MMM.ResidueB
import MMM.Acct.Basic

namespace MMM.Acct

open MMM

/-- Lemma L1's consequence for the residue: dividing the existing
`labelled_congruence : |labelled| ≡ (−p)^t` by `p^t` gives `|𝔉|`-free form
`L(m)/p^t ≡ (−1)^t`, i.e. `L(m) ≡ (−1)^t · p^t`. We state it as: `L(m) ≡ (−1)^{N}` mod p
when `m = (p−1)N+1` (so `N = t` in the unblocked case).

`labelled_congruence` is `ℤ`-congruence mod `p^{t+1}`; reducing mod `p` gives the
`(−1)^N` claim. -/
theorem l1_residue_mod_p {p : ℕ} [hp : Fact p.Prime] (t : ℕ) (S : Finset ℕ)
    (hS : S.card = (p - 1) * t + 1) :
    (Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = S} : ℤ) ≡ (-1 : ℤ) ^ t * (p : ℤ) ^ t
      [ZMOD (p : ℤ) ^ (t + 1)] := by
  have h := LTree.labelled_congruence (p := p) t S hS
  -- `h : ... ≡ (−p)^t`; rewrite `(-p)^t = (-1)^t * p^t`
  have heq : (-(p : ℤ)) ^ t = (-1 : ℤ) ^ t * (p : ℤ) ^ t := by
    rw [show (-(p : ℤ)) = (-1 : ℤ) * (p : ℤ) from by ring, mul_pow]
  rw [heq] at h
  exact h

/-- The same with the depth condition (prime-power case).

`κ` is the class modulo `k` carried by each label; `S.card = (p−1)t+1` and
`∑_{x∈S} p^{κ x} ≡ 1 (mod p^k−1)` is the congruence that makes `S` correspond to
`a = m·e₀` in the note. Then the `k`-blocked labelled count is `≡ (−p)^t`. -/
theorem l1_residue_blocked {p : ℕ} [hp : Fact p.Prime] (k : ℕ) (hk : 0 < k)
    (κ : ℕ → ℕ) (t : ℕ) (S : Finset ℕ) (hS : S.card = (p - 1) * t + 1)
    (hI : (∑ x ∈ S, p ^ κ x) ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] :=
  LTree.labelled_congruence_blocked k hk κ t S hS hI

#print axioms l1_residue_mod_p

end MMM.Acct
