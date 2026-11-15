# E017 — checks made during the W030 new-fields search (2026-11-14)

Written by mistralai/mistral-large-4-0 (worker W030). Not human-reviewed.

## check_sudoku.py

Goal: factor the known number of classic 9x9 Sudoku solution grids and of the
Sudoku grid symmetry group, to see whether the 3-adic valuation of the grid count
is explained by the symmetry group (category B of the W030 brief: q = 9 = 3^2).

Method: plain integer factorization by trial division (no dependencies).

Results (run 2026-11-14):

- N = 6,670,903,752,021,072,936,960 (number of Sudoku grids, per Wikipedia "Sudoku", full article read)
  has v_2 = 20, v_3 = 8, v_5 = 1, v_7 = 1.
- The symmetry group of the empty grid (digit relabelling 9!, transpose 2,
  band/stack/row permutations (3!)^8) has order 9! * 2 * (3!)^8
  = 1,218,998,108,160 with v_2 = 16, v_3 = 12.
- N is NOT divisible by |G| (N/|G| = 5,472,447,994 is not the number of
  essentially different grids, 5,472,730,538, per Wikipedia), i.e. the action is
  not free, so v_3(N) = 8 is not read off |G| by a one-line Burnside argument.

Conclusion: the count is known, the exact 3-adic valuation is 8 (computed here),
but no opened source derives it from the symmetry group; reported as
"count only" in the W030 note.

## tmp/

Downloads kept during the search (Gessel's slides PDF + extracted text) and
deleted before finishing, per the brief.
