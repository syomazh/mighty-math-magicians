# Written by mistralai/mistral-large-4-0 (worker W030), 2026-11-14. Not human-reviewed.
# Factor the number of classic 9x9 Sudoku solution grids and the order of the
# symmetry group of the empty grid. See README.md in this folder.
from math import factorial

N = 6670903752021072936960  # number of Sudoku grids (Wikipedia "Sudoku")


def v_p(x, p):
    v = 0
    while x % p == 0:
        v += 1
        x //= p
    return v


print("N =", N)
for p in (2, 3, 5, 7):
    print(f"v_{p}(N) =", v_p(N, p))

G = factorial(9) * 2 * (factorial(3) ** 8)  # digit relabel * transpose * (3!)^8
print("grid symmetry group order 9! * 2 * (3!)^8 =", G)
print("v_2(G) =", v_p(G, 2), " v_3(G) =", v_p(G, 3))
print("N % G =", N % G, " N // G =", N // G, "(essentially different = 5472730538)")
