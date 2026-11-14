/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

The depth condition for labelled trees (prime powers `q = p ^ k`).

Each label `a` has a *class* `κ a`. A leaf with label `a` at depth `δ` is allowed when `k` divides
`δ + κ a`. For typed trees (`α = ℕ`, `κ = id`) this says: an atom with `p ^ j` leaves hangs at a
depth `δ` with `δ + j ≡ 0 (mod k)`, so that all leaves of the realized tree are at depths
divisible by `k` (the paper's depth condition on atoms).

Only the definition shared by the files that build on it.
-/
import MMM.LTree

namespace MMM

namespace LTree

variable {p : ℕ} {α : Type}

/-- Every leaf of `T` (root at depth `δ`) is at a depth `d` with `k ∣ d + κ (label)`. -/
def BlockedL (k : ℕ) (κ : α → ℕ) : ℕ → LTree p α → Prop
  | δ, leaf a => k ∣ δ + κ a
  | δ, node f => ∀ i, BlockedL k κ (δ + 1) (f i)

@[simp] theorem blockedL_leaf (k : ℕ) (κ : α → ℕ) (δ : ℕ) (a : α) :
    BlockedL k κ δ (leaf a : LTree p α) ↔ k ∣ δ + κ a := Iff.rfl

theorem blockedL_node (k : ℕ) (κ : α → ℕ) (δ : ℕ) (f : Fin p → LTree p α) :
    BlockedL k κ δ (node f) ↔ ∀ i, BlockedL k κ (δ + 1) (f i) := Iff.rfl

end LTree

end MMM
