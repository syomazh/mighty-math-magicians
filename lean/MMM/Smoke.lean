/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
A smoke test: the project compiles against Mathlib.
-/
import Mathlib

theorem smoke_test : (2 : ℕ) + 2 = 4 := by norm_num
