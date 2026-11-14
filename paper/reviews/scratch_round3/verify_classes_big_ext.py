"""Extension of verify_classes_big.py to reach more k >= 2 cases with several minimal classes."""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_classes_big import ClassWorld, check
from verify_classes import World

plan = [(2, 2, range(13, 16)), (2, 3, range(9, 13)), (2, 4, range(7, 10)),
        (3, 2, range(8, 11)), (3, 3, range(5, 7)), (5, 2, range(5, 9)), (3, 1, range(12, 15)), (5, 1, range(9, 12))]
start = time.time()
total = 0
for p, k, rng in plan:
    CW, SW = ClassWorld(p, k), World(p, k)
    for n in rng:
        if time.time() - start > 420:
            print("time budget reached; stopping before", (p, k, n), flush=True)
            break
        check(p, k, n, CW, SW)
        total += 1
print(f"EXTENSION: {total} CLASS-LEVEL CASES PASSED")
