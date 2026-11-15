# Written by Claude Fable 5.2 (AI; a fresh-context agent, brief W054, second task), 2026-11-15.
# Not human-reviewed.
"""
Corrected copies of six figures, for talk/slides_v2.tex.

    uv run python talk/figures/make_figures_v2.py

This script changes neither talk/figures/make_figures.py nor any existing figure. It imports that
script, draws six of its figures again with a few strings replaced as they are drawn, and saves them
under new names: fig_<name>_v2.pdf and fig_<name>_v2.png. Nothing else differs: the trees, the numbers
and the checks (assert statements) are those of make_figures.py.

Why each string is replaced (see talk/SLIDES_VS_REPORT.md, items B-M3, B-M15, B-R3, B-R6, B-R12):
  fig_butyl         "asymmetric carbon" is the chemists' word for a carbon with four different groups;
                    the report (Section 5, item 3) and the review of the chemistry statements say
                    "lopsided" for a carbon whose three further branches are not all alike.
  fig_bits          the report gives the class sizes under all permutations as "such as 6 and 12".
  fig_atoms         there are three most symmetric trees with 13 leaves, so "a", not "the"; the value
                    of C_12 is not in the report.
  fig_carry_budget  there are three most symmetric trees with 7 leaves, so "a", not "the".
  fig_fusion        "a binary counter" and "a buddy memory allocator" are not in the report.
  fig_dendrimer     there are two most symmetric trees with 39 ends, so "a", not "the".
"""
import os
import sys

sys.dont_write_bytecode = True                      # no __pycache__ folder next to the figures
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import make_figures as mf                           # noqa: E402  (draws nothing when imported)
import matplotlib.pyplot as plt                     # noqa: E402
from matplotlib.axes import Axes                    # noqa: E402

REPLACE = {
    # fig_butyl
    "symmetric carbon": "balanced carbon",
    "asymmetric carbon": "lopsided carbon",
    "0 asymmetric": "0 lopsided",
    "2 asymmetric": "2 lopsided",
    "3 asymmetric": "3 lopsided",
    # fig_bits
    "24 moves; classes of 1, 4, 6, 12 or 24": "24 moves; classes of sizes such as 6 and 12",
    # fig_atoms
    "The most symmetric tree with 13 leaves": "A most symmetric tree with 13 leaves",
    "= the power of 2 in $C_{12} = 208012$": "= the power of 2 in $C_{12}$",
    # fig_carry_budget
    "the most symmetric tree with 7 leaves": "a most symmetric tree with 7 leaves",
    # fig_fusion
    "The same bookkeeping: a binary counter, a binomial heap, a buddy memory allocator, "
    "sand that topples in pairs.": "The same bookkeeping: merging binomial queues; sand that topples in pairs.",
    # fig_dendrimer
    "the most symmetric one": "a most symmetric one",
}
used = set()
_original_text = Axes.text


def _text(self, x, y, s, *args, **kwargs):
    """Axes.text with the replacements above; every other string is drawn unchanged."""
    if isinstance(s, str) and s in REPLACE:
        used.add(s)
        s = REPLACE[s]
    return _original_text(self, x, y, s, *args, **kwargs)


def _save(fig, name):
    """As make_figures.save, with '_v2' appended to the name, so that no existing file is touched."""
    name = name + "_v2"
    fig.savefig(os.path.join(HERE, name + ".pdf"), bbox_inches="tight", pad_inches=0.04, transparent=True)
    fig.savefig(os.path.join(HERE, name + ".png"), bbox_inches="tight", pad_inches=0.08, dpi=230,
                facecolor="white")
    plt.close(fig)
    print("wrote", name)


if __name__ == "__main__":
    Axes.text = _text
    mf.save = _save
    try:
        mf.fig_butyl()
        mf.fig_bits()
        mf.fig_atoms()
        mf.fig_carry_budget()
        mf.fig_fusion()
        mf.fig_dendrimer()
    finally:
        Axes.text = _original_text
    missing = set(REPLACE) - used
    assert not missing, f"strings that were expected in the figures and not found: {missing}"
    print("replaced", len(used), "strings")
