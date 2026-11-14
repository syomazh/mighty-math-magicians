# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Side check for the "considered, overlaps with chip-firing" list:
# merge games (2048: two equal tiles -> one tile of the next level;
# match-three merge games: three equal items -> one item of the next level).
# Abstract version (no board geometry): start from m level-0 items, merge p
# equal items in any order until no merge is possible.
#
# Checked: whatever the order, the number of merges is (m - s_p(m))/(p-1)
# (Fact 5) and what is left is the base-p expansion of m (a_j items of
# level j).  For p = 2, with the 2048 convention that a level-j tile shows
# 2^(j+1) and each merge scores the value of the new tile, the final score is
# the sum over the remaining tiles of j * 2^(j+1), whatever the order.
#
#   uv run python experiments/E013_new_connections_blind/c9_merge_games.py

import random
import sys

sys.path.insert(0, __file__.rsplit("c9_merge_games.py", 1)[0])
from trees import digit_sum, digits


def play(m, p, rng):
    counts = {0: m}
    merges = 0
    score = 0
    while True:
        can = [j for j, c in counts.items() if c >= p]
        if not can:
            break
        j = rng.choice(can)
        counts[j] -= p
        counts[j + 1] = counts.get(j + 1, 0) + 1
        merges += 1
        score += 2 ** (j + 2)        # p = 2 only: new tile shows 2^(j+2)
    return merges, counts, score


def main():
    rng = random.Random(137)
    for p in (2, 3, 5):
        for m in range(1, 400):
            for _ in range(5):
                merges, counts, score = play(m, p, rng)
                assert merges * (p - 1) == m - digit_sum(m, p)
                dg = digits(m, p)
                assert all(counts.get(j, 0) == a for j, a in enumerate(dg))
                assert all(c == 0 for j, c in counts.items() if j >= len(dg))
                if p == 2:
                    assert score == sum(j * 2 ** (j + 1)
                                        for j, a in enumerate(dg) if a)
        print(f"p = {p}: m = 1..399, 5 random merge orders each: number of "
              f"merges = (m - s_p(m))/(p-1), remainder = base-{p} digits: OK")
    print("p = 2: score = sum over remaining tiles 2^(j+1) of j * 2^(j+1): OK")
    print("example: the 2048 tile (level 10, made of 1024 twos) has score "
          "contribution", 10 * 2 ** 11)


if __name__ == "__main__":
    main()
