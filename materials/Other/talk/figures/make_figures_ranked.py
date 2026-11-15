# Written by Claude Fable 5.2 (AI, a forked instance of the orchestrator), 2026-11-14. Not human-reviewed.
"""
Draft figures for the top five connections of notes/2026-11-14_connections_ranked.md.

    uv run python talk/figures/make_figures_ranked.py

writes fig_symmetry_number, fig_phylo_cherry, fig_sylow, fig_feynman and fig_mobile_plan as PDF and
PNG into talk/figures/. Helpers, colours and conventions are imported from make_figures.py
(blue circle = symmetric node, orange square = asymmetric node, small ring = leaf, green = atom).
Every number drawn is asserted from an enumeration next to the drawing code; the same statements
are checked independently in experiments/E015_connections_ranked/run.py and in E012, E013.
"""
import itertools
import os
import sys
from fractions import Fraction
from math import comb, factorial, prod

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import make_figures as mf  # noqa: E402  (guarded by __main__: importing draws nothing)

import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import Polygon, Rectangle  # noqa: E402

BLUE, ORANGE, AQUA = mf.BLUE, mf.ORANGE, mf.AQUA
AQUA_SOFT, INK, INK2, MUTED, AXIS = mf.AQUA_SOFT, mf.INK, mf.INK2, mf.MUTED, mf.AXIS
NEUTRAL = "#f1f0ec"


def kinds(t):
    """(number of symmetric nodes, number of asymmetric nodes) of a tree."""
    nodes, _, _ = mf.layout(t)
    return (sum(nd["kind"] == "sym" for nd in nodes), sum(nd["kind"] == "asym" for nd in nodes))


def strip(t):
    """the same tree with unlabelled leaves"""
    return () if mf.is_leaf(t) else tuple(strip(c) for c in t)


def classes_of(p, n):
    """rotation classes of the plane p-ary trees with n nodes: key -> list of trees"""
    out = {}
    for t in mf.plane_trees(p, n):
        out.setdefault(mf.key(t), []).append(t)
    return out


# ------------------------------------------------------------------------------------------
# 1. the five butyl groups: ordered trees and symmetry numbers (note, section 3.1)
# ------------------------------------------------------------------------------------------
def fig_symmetry_number():
    H = "H"
    M = (H, H, H)
    E = (H, H, M)
    groups = [
        ("tert-butyl", (M, M, M)),
        ("isobutyl", (H, H, (H, M, M))),
        ("sec-butyl", (H, M, E)),
        ("sec-butyl (mirror)", (H, E, M)),
        ("n-butyl", (H, H, (H, H, E))),
    ]
    classes = classes_of(3, 4)
    n_all = sum(len(v) for v in classes.values())
    assert n_all == 55 == comb(12, 4) // 9 and len(classes) == 5
    assert len({mf.key(strip(t)) for _, t in groups}) == 5          # the five drawn are the five classes

    fig, ax = plt.subplots(figsize=(6.3, 2.95))
    mf.clean(ax)
    x, gap = 0.0, 3.4
    y_row = {"trees": -6.8, "number": -7.7, "product": -8.6}
    sizes, numbers = [], []
    for name, t in groups:
        nodes, w = mf.draw_tree(ax, t, x0=x, y0=0.0, sx=1.0, sy=1.25, node_size=40, leaf_size=9, lw=0.9)
        n_sym, n_asym = kinds(t)
        assert n_sym + n_asym == 4 and n_asym == mf.d_of(t)
        size = len(classes[mf.key(strip(t))])
        number = 3 ** n_sym                       # the internal symmetry number, in the tree model
        assert size == 3 ** n_asym and size * number == 81 == 3 ** 4
        sizes.append(size)
        numbers.append(number)
        root = [nd for nd in nodes if nd["path"] == ()][0]
        ax.plot([root["X"], root["X"]], [root["Y"], root["Y"] + 0.75], color=INK2, lw=0.9, zorder=1)
        ax.scatter([root["X"]], [root["Y"] + 0.75], s=7, color=INK2, zorder=2)
        cx = x + w / 2
        ax.text(cx, -5.45, name, ha="center", va="top", fontsize=8, color=INK, fontweight="bold")
        ax.text(cx, y_row["trees"], f"{size}", ha="center", va="center", fontsize=9.5, color=INK)
        ax.text(cx, y_row["number"], f"{number}", ha="center", va="center", fontsize=9.5, color=INK)
        ax.text(cx, y_row["product"], f"${size} \\times {number} = 81$", ha="center", va="center", fontsize=7.6,
                color=INK2)
        x += w + gap
    total_w = x - gap
    assert sizes == [1, 9, 9, 9, 27] and numbers == [81, 9, 9, 9, 3] and sum(sizes) == 55 and 55 % 3 != 0
    for k, lab in (("trees", "ordered trees"), ("number", "symmetry number"), ("product", "product")):
        ax.text(-1.5, y_row[k], lab, ha="right", va="center", fontsize=7.8, color=INK2)
    x_left = -11.6
    mid = (x_left + total_w + 1.4) / 2
    ax.text(mid, -9.85,
            "A factor 3 for each symmetric carbon.   Ordered trees $\\times$ symmetry number "
            "$= 81 = 3^4$ for every group.", ha="center", va="center", fontsize=8, color=INK)
    ax.text(mid, -10.75,
            f"${sizes[0]} + {sizes[1]} + {sizes[2]} + {sizes[3]} + {sizes[4]} = 55$ is not divisible by 3, "
            "because tert-butyl has the full symmetry number 81.", ha="center", va="center", fontsize=8, color=INK)
    mf.legend_nodes(ax, total_w / 2 - 20.5, 1.75, 16.0,
                    [("sym", "symmetric carbon"), ("asym", "asymmetric carbon"), ("leaf", "hydrogen")], off=1.1)
    ax.set_xlim(x_left, total_w + 1.4)
    ax.set_ylim(-11.4, 2.4)
    mf.save(fig, "fig_symmetry_number")


# ------------------------------------------------------------------------------------------
# 2. fifteen evolutionary trees of four species; exchange a and b (note, section 3.2)
# ------------------------------------------------------------------------------------------
def fig_phylo_cherry():
    species = "abcd"

    def fill(t, it):
        return next(it) if mf.is_leaf(t) else tuple(fill(c, it) for c in t)

    ordered = [fill(s, iter(perm)) for s in mf.plane_trees(2, 3) for perm in itertools.permutations(species)]
    assert len(ordered) == 5 * 24
    classes = {}
    for t in ordered:
        classes.setdefault(mf.key(t), []).append(t)
    assert len(classes) == 15 and all(len(v) == 8 for v in classes.values())

    def leafset(t):
        return [t] if isinstance(t, str) else [x for c in t for x in leafset(c)]

    def nice(t):                                   # a tidy drawing: the larger branch on the left
        if isinstance(t, str):
            return t
        kids = sorted((nice(c) for c in t), key=lambda c: (-len(leafset(c)), min(leafset(c))))
        return tuple(kids)

    swap = {"a": "b", "b": "a", "c": "c", "d": "d"}

    def relabel(t):
        return swap[t] if isinstance(t, str) else tuple(relabel(c) for c in t)

    def has_cherry(t, pair):
        if isinstance(t, str):
            return False
        if all(isinstance(c, str) for c in t) and set(t) == set(pair):
            return True
        return any(has_cherry(c, pair) for c in t)

    reps = {k: nice(v[0]) for k, v in classes.items()}
    assert all(mf.key(reps[k]) == k for k in reps)
    image = {k: mf.key(relabel(reps[k])) for k in reps}
    fixed = sorted((k for k in reps if image[k] == k), key=lambda k: repr(reps[k]))
    moved = [k for k in reps if image[k] != k]
    assert len(fixed) == 3 and len(moved) == 12
    assert all(has_cherry(reps[k], "ab") for k in fixed) and not any(has_cherry(reps[k], "ab") for k in moved)
    pairs = sorted({tuple(sorted((k, image[k]), key=lambda q: repr(reps[q]))) for k in moved},
                   key=lambda pr: repr(reps[pr[0]]))
    assert len(pairs) == 6 and all(image[a] == b and image[b] == a for a, b in pairs)

    def dfact(n):
        return 1 if n <= 0 else n * dfact(n - 2)

    assert dfact(2 * 4 - 3) == 5 * 3 * 1 == 15 == len(classes) and dfact(2 * 4 - 5) == 3 * 1 == 3 == len(fixed)
    assert 15 == 3 + 2 * 6 and 15 % 2 == 1

    def draw_species(t, x0, y0, sx, sy):
        nodes, edges, w = mf.layout(t)
        for (xa, ya, xb, yb, _) in edges:
            ax.plot([x0 + xa * sx, x0 + xb * sx], [y0 + ya * sy, y0 + yb * sy], color=INK2, lw=0.9,
                    solid_capstyle="round", zorder=2)
        for nd in nodes:
            X, Y = x0 + nd["x"] * sx, y0 + nd["y"] * sy
            if nd["kind"] == "leaf":
                lab = nd["obj"]
                ax.text(X, Y - 0.16, lab, ha="center", va="top", fontsize=8,
                        fontweight="bold" if lab in "ab" else "normal", color=INK if lab in "ab" else INK2,
                        zorder=4)
            else:
                ax.scatter([X], [Y], s=9, color=INK2, zorder=3)
            if nd["path"] == ():
                ax.plot([X, X], [Y, Y + 0.4 * sy], color=INK2, lw=0.9, zorder=2)
        return w * sx

    fig, ax = plt.subplots(figsize=(6.3, 3.75))
    mf.clean(ax)
    sx, sy, row_h = 0.8, 0.8, 3.75
    tw = 4 * sx
    arrow = 2.1
    x_pair = [6.9, 6.9 + 2 * tw + arrow + 2.0]
    x_last = x_pair[1] + 2 * tw + arrow                     # right edge of the last tree
    bottom = -(2 * row_h + 3.25)
    height = 2 * row_h + 4.0
    rect_fix = (-1.7, tw + 1.7)
    rect_pair = (x_pair[0] - 1.0, x_last + 1.0)
    ax.add_patch(Rectangle((rect_fix[0], bottom), rect_fix[1] - rect_fix[0], height, facecolor=AQUA_SOFT,
                           edgecolor="none", zorder=0))
    ax.add_patch(Rectangle((rect_pair[0], bottom), rect_pair[1] - rect_pair[0], height, facecolor=NEUTRAL,
                           edgecolor="none", zorder=0))
    for r in range(3):
        y0 = -r * row_h
        draw_species(reps[fixed[r]], 0.0, y0, sx, sy)
        for c in range(2):
            a, b = pairs[2 * r + c]
            xa = x_pair[c]
            draw_species(reps[a], xa, y0, sx, sy)
            draw_species(reps[b], xa + tw + arrow, y0, sx, sy)
            ax.annotate("", xy=(xa + tw + arrow + 0.15, y0 - 1.2), xytext=(xa + tw + 0.15, y0 - 1.2),
                        arrowprops=dict(arrowstyle="<|-|>", color=MUTED, lw=1.1, mutation_scale=9))
    mid = (rect_fix[0] + rect_pair[1]) / 2
    ax.text(sum(rect_fix) / 2, 1.55, "a and b form a cherry:\nnothing changes (3 trees)", ha="center", va="center",
            fontsize=7.6, linespacing=1.1)
    ax.text(sum(rect_pair) / 2, 1.55, "the other 12 trees trade places in pairs (6 pairs)",
            ha="center", va="center", fontsize=7.6)
    ax.text(mid, 2.95, "The fifteen evolutionary trees of four species.  Exchange a and b.",
            ha="center", va="center", fontsize=9, fontweight="bold")
    ax.text(mid, bottom - 0.8,
            r"$15 = 3 + 2 \times 6$ is odd.     $(2 \cdot 4 - 3)$!! $= 5 \times 3 \times 1 = 15$ trees,   "
            r"$(2 \cdot 4 - 5)$!! $= 3 \times 1 = 3$ with the cherry.", ha="center", va="center", fontsize=8)
    ax.set_xlim(rect_fix[0] - 0.3, rect_pair[1] + 0.3)
    ax.set_ylim(bottom - 1.4, 3.5)
    mf.save(fig, "fig_phylo_cherry")


# ------------------------------------------------------------------------------------------
# 3. the most symmetric trees with 7 leaves and the Sylow 2-subgroup of S_7 (note, section 3.3)
# ------------------------------------------------------------------------------------------
def fig_sylow():
    o = ()
    K1, K2 = mf.complete(1), mf.complete(2)
    atoms = [K2, K1, o]
    leaves = [mf.n_leaves(a) for a in atoms]
    sym_nodes = [kinds(a)[0] for a in atoms]
    syms = [2 ** s for s in sym_nodes]
    assert leaves == [4, 2, 1] and sum(leaves) == 7 and bin(7) == "0b111"
    assert sym_nodes == [3, 1, 0] and syms == [8, 2, 1] and prod(syms) == 16 == 2 ** mf.vp(factorial(7), 2)
    assert factorial(7) == 5040 and 5040 == 16 * 315 and 315 % 2 == 1
    t = (K2, (K1, o))
    n_sym, n_asym = kinds(t)
    classes = classes_of(2, 6)
    versions = len(classes[mf.key(t)])
    assert mf.n_leaves(t) == 7 and (n_sym, n_asym) == (4, 2) and versions == 4 == 2 ** n_asym
    assert 2 ** n_sym == 16 and 16 * versions == 64 == 2 ** 6
    best = max(2 ** kinds(v[0])[0] for v in classes.values())
    n_best = sum(1 for v in classes.values() if 2 ** kinds(v[0])[0] == best)
    catalan = comb(12, 6) // 7
    assert best == 16 and n_best == 3 and n_best % 2 == 1
    assert catalan == 132 == sum(len(v) for v in classes.values()) == 2 ** 2 * 33 and mf.vp(catalan, 2) == 2

    def blob(x, y):                                           # the green disc behind a single leaf
        ax.scatter([x], [y], s=330, color=AQUA_SOFT, zorder=0, linewidths=0)

    fig, ax = plt.subplots(figsize=(6.3, 3.1))
    mf.clean(ax)
    # left: the three atoms
    x = 0.0
    centres = []
    for a, nl, sn in zip(atoms, leaves, sym_nodes):
        w = max(mf.n_leaves(a), 1) * 1.0
        if mf.is_leaf(a):
            blob(x + 0.5, -2.0)
            ax.scatter([x + 0.5], [-2.0], s=11, marker="o", color="white", edgecolors=INK2, linewidths=0.8, zorder=3)
            cx = x + 0.5
        else:
            h = 2 if nl == 4 else 1
            nodes, w = mf.draw_tree(ax, a, x0=x, y0=-2.0 + h, sx=1.0, sy=1.0, node_size=40, leaf_size=11, lw=1.0)
            xs = [nd["X"] for nd in nodes if nd["kind"] == "leaf"]
            top = [nd for nd in nodes if nd["path"] == ()][0]
            ax.add_patch(Polygon([(top["X"], top["Y"] + 0.65), (min(xs) - 0.5, -2.4), (max(xs) + 0.5, -2.4)],
                                 closed=True, color=AQUA_SOFT, zorder=0, lw=0))
            cx = (min(xs) + max(xs)) / 2
        centres.append(cx)
        ax.text(cx, -2.95, f"{nl} lea" + ("ves" if nl > 1 else "f"), ha="center", va="top", fontsize=7.6, color=INK2)
        ax.text(cx, -3.6, f"$2^{sn}$", ha="center", va="top", fontsize=9, color=INK)
        x += w + 1.9
    left_w = x - 1.9
    for i in range(2):
        ax.text((centres[i] + centres[i + 1]) / 2 + (0.35 if i == 0 else 0.1), -3.6, r"$\times$", ha="center",
                va="top", fontsize=9, color=INK)
    lc = left_w / 2 + 0.3
    ax.text(lc, 1.35, r"$7 = 4 + 2 + 1$   (111 in binary)", ha="center", va="center", fontsize=10)
    ax.text(lc, -4.85, r"symmetries:  $8 \times 2 \times 1 = 16$", ha="center", va="center", fontsize=8.4)
    ax.text(lc, -5.6, r"the largest power of 2 dividing $7! = 5040$,", ha="center", va="center",
            fontsize=7.6, color=INK2)
    ax.text(lc, -6.3, r"the order of a Sylow 2-subgroup of $S_7$", ha="center", va="center",
            fontsize=7.6, color=INK2)
    # middle: a most symmetric tree with 7 leaves
    x0 = left_w + 3.6
    nodes, w = mf.draw_tree(ax, t, x0=x0, y0=1.0, sx=1.0, sy=1.0, node_size=40, leaf_size=11, lw=1.0)

    def wedge(path, height):
        nd = [n for n in nodes if n["path"] == path][0]
        lv = [n for n in nodes if n["kind"] == "leaf" and n["path"][:len(path)] == path]
        xs = [n["X"] for n in lv]
        yb = min(n["Y"] for n in lv)
        if height == 0:
            blob(nd["X"], nd["Y"])
        else:
            ax.add_patch(Polygon([(nd["X"], nd["Y"] + 0.65), (min(xs) - 0.45, yb - 0.4), (max(xs) + 0.45, yb - 0.4)],
                                 closed=True, color=AQUA_SOFT, zorder=0, lw=0))

    wedge((0,), 2)
    wedge((1, 0), 1)
    wedge((1, 1), 0)
    ax.text(x0 + w / 2, -2.95, "a most symmetric tree", ha="center", va="top", fontsize=7.6, color=INK2)
    ax.text(x0 + w / 2, -3.6, "with 7 leaves", ha="center", va="top", fontsize=7.6, color=INK2)
    # right: what the tree has
    bx = x0 + w + 1.6
    ax.scatter([bx + 0.25], [0.55], s=34, marker="o", color=BLUE, edgecolors="white", linewidths=0.8)
    ax.text(bx + 0.8, 0.55, f"{n_sym} symmetric nodes:", ha="left", va="center", fontsize=7.8, color=INK)
    ax.text(bx + 0.8, -0.15, r"$2^4 = 16$ symmetries", ha="left", va="center", fontsize=7.8, color=INK2)
    ax.scatter([bx + 0.25], [-1.15], s=34, marker="s", color=ORANGE, edgecolors="white", linewidths=0.8)
    ax.text(bx + 0.8, -1.15, f"{n_asym} asymmetric nodes:", ha="left", va="center", fontsize=7.8, color=INK)
    ax.text(bx + 0.8, -1.85, r"$2^2 = 4$ ordered versions", ha="left", va="center", fontsize=7.8, color=INK2)
    ax.text(bx, -2.95, r"$16 \times 4 = 64 = 2^6$", ha="left", va="center", fontsize=8.4, color=INK)
    ax.text(bx, -3.6, "(6 nodes, 2 positions each)", ha="left", va="center", fontsize=7.4, color=INK2)
    x_min, x_max = -1.9, bx + 10.2
    mid = (x_min + x_max) / 2
    ax.text(mid, -7.6, f"A tree with 7 leaves has at most 16 symmetries, and exactly {n_best} shapes have 16.",
            ha="center", va="center", fontsize=8)
    ax.text(mid, -8.4,
            rf"Those {n_best}, an odd number, decide the power of 2 in the number of ordered trees: "
            r"$132 = 2^2 \times 33$.", ha="center", va="center", fontsize=8)
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(-8.95, 2.0)
    mf.save(fig, "fig_sylow")


# ------------------------------------------------------------------------------------------
# 4. the eleven tree diagrams with 7 sources, by symmetry factor (note, section 3.4)
# ------------------------------------------------------------------------------------------
def fig_feynman():
    classes = classes_of(2, 6)
    assert len(classes) == 11 and sum(len(v) for v in classes.values()) == 132 == comb(12, 6) // 7
    by_factor = {}
    for k, v in classes.items():
        n_sym, n_asym = kinds(v[0])
        factor = 2 ** n_sym                                   # symmetry factor of the diagram
        assert n_sym + n_asym == 6 and len(v) == 2 ** n_asym and factor * len(v) == 64
        by_factor.setdefault(factor, []).append(min(v))
    assert {f: len(v) for f, v in by_factor.items()} == {16: 3, 8: 3, 4: 4, 2: 1}
    total = sum(Fraction(len(v), f) for f, v in by_factor.items())
    assert total == Fraction(33, 16) == Fraction(132, 64) and total.denominator == 16
    assert total == Fraction(3, 16) + Fraction(3, 8) + Fraction(4, 4) + Fraction(1, 2)
    assert max(by_factor) == 16 == 2 ** mf.vp(factorial(7), 2) and len(by_factor[16]) == 3

    fig, ax = plt.subplots(figsize=(6.3, 3.45))
    mf.clean(ax)
    row_h, tree_w, gapx, x_left = 5.3, 6.0, 2.2, 8.2
    factors = sorted(by_factor, reverse=True)                 # 16 in the top row
    top = (len(factors) - 1) * row_h
    for r, f in enumerate(factors):
        y_top = top - r * row_h
        if r == 0:
            ax.add_patch(Rectangle((-1.5, y_top - 4.72), 63.5, 5.3, color=AQUA_SOFT, zorder=0, lw=0))
        ax.plot([x_left - 1.2, x_left + 4 * (tree_w + gapx) - gapx + 0.6], [y_top - 4.72, y_top - 4.72],
                color=AXIS, lw=0.8, zorder=1)
        ax.text(2.9, y_top - 2.0, f"{f}", ha="center", va="center", fontsize=10.5, color=INK)
        for i, t in enumerate(sorted(by_factor[f], key=repr)):
            nodes, _ = mf.draw_tree(ax, t, x0=x_left + i * (tree_w + gapx), y0=y_top - 0.3, sx=1.0, sy=0.7,
                                    node_size=17, leaf_size=5, lw=0.7)
            root = [nd for nd in nodes if nd["path"] == ()][0]
            ax.plot([root["X"], root["X"]], [root["Y"], root["Y"] + 0.5], color=INK2, lw=0.7, zorder=1)
        g = len(by_factor[f])
        ax.text(42.2, y_top - 2.0, f"{g} diagram" + ("s" if g > 1 else ""), ha="left", va="center", fontsize=8,
                color=INK2)
        ax.text(50.6, y_top - 2.0, f"$\\times\\ 1/{f} \\;=\\; {g}/{f}$", ha="left", va="center", fontsize=8.5,
                color=INK)
    ax.text(2.9, top + 1.45, "symmetry factor", ha="center", va="center", fontsize=7.4, color=INK2)
    ax.text(30.2, -6.3, "Each diagram counts 1/(symmetry factor):    "
            r"$3/16 + 3/8 + 4/4 + 1/2 \;=\; 33/16 \;=\; 132/64$.", ha="center", va="center", fontsize=8, color=INK)
    ax.text(30.2, -7.65, "An odd number of diagrams, three, have the largest symmetry factor, "
            "so the denominator is exactly 16.", ha="center", va="center", fontsize=8, color=INK)
    mf.legend_nodes(ax, 9.0, top + 3.2, 20.0,
                    [("sym", "symmetric vertex: a factor 2"), ("asym", "asymmetric vertex"), ("leaf", "source")],
                    off=1.0)
    ax.set_xlim(-1.6, 62.2)
    ax.set_ylim(-8.5, top + 4.1)
    mf.save(fig, "fig_feynman")


# ------------------------------------------------------------------------------------------
# 5. the plan of the proof with two mobiles: 5 = 1 + 4 (note, section 3.5)
# ------------------------------------------------------------------------------------------
def fig_mobile_plan():
    o = ()
    c = (o, o)
    classes = classes_of(2, 3)
    n_all = sum(len(v) for v in classes.values())
    assert n_all == 5 == comb(6, 3) // 4 and sorted(len(v) for v in classes.values()) == [1, 4]
    balanced, lopsided = (c, c), (o, (o, c))
    photos_b = sorted(classes[mf.key(balanced)], key=repr)
    photos_l = sorted(classes[mf.key(lopsided)], key=repr, reverse=True)
    assert len(photos_b) == 1 == 2 ** mf.d_of(balanced) and len(photos_l) == 4 == 2 ** mf.d_of(lopsided)
    assert mf.d_of(balanced) == 0 and mf.d_of(lopsided) == 2 and 5 == 1 + 4 and 5 % 2 == 1

    fig, ax = plt.subplots(figsize=(6.3, 3.3))
    mf.clean(ax)
    sx = 0.8
    tw = 4 * sx
    gap = 1.1
    xl = 0.0                                              # left block: the balanced mobile
    xr = tw + 4.6                                         # right block: the lopsided mobile
    wr = 4 * tw + 3 * gap
    y_m, y_p = 0.0, -6.0
    rect_l = (xl - 1.4, xl + tw + 1.4)
    rect_r = (xr - 0.9, xr + wr + 0.9)
    ax.add_patch(Rectangle((rect_l[0], -10.3), rect_l[1] - rect_l[0], 12.4, facecolor=AQUA_SOFT, edgecolor="none",
                           zorder=0))
    ax.add_patch(Rectangle((rect_r[0], -10.3), rect_r[1] - rect_r[0], 12.4, facecolor=NEUTRAL, edgecolor="none",
                           zorder=0))
    mf.draw_mobile(ax, balanced, xl, y_m, sx=sx, sy=1.0)
    mf.draw_mobile(ax, lopsided, xr + (wr - tw) / 2, y_m, sx=sx, sy=1.0)
    ax.text(xl + tw / 2, 1.45, "balanced mobile", ha="center", va="center", fontsize=8.4, fontweight="bold")
    ax.text(xr + wr / 2, 1.45, "lopsided mobile", ha="center", va="center", fontsize=8.4, fontweight="bold")
    ax.text(xl + tw / 2, -4.55, "spinning a bar\nchanges nothing", ha="center", va="center", fontsize=7.2,
            color=INK2, linespacing=1.05)
    ax.text(xr + wr / 2, -4.55, "spin either of the two lopsided bars:\na new photograph each time",
            ha="center", va="center", fontsize=7.2, color=INK2, linespacing=1.05)
    mf.draw_tree(ax, photos_b[0], x0=xl, y0=y_p, sx=sx, sy=0.9, node_size=30, leaf_size=9, lw=0.9)
    for i, t in enumerate(photos_l):
        mf.draw_tree(ax, t, x0=xr + i * (tw + gap), y0=y_p, sx=sx, sy=0.9, node_size=30, leaf_size=9, lw=0.9)
    ax.text(xl + tw / 2, -9.6, "1 photograph", ha="center", va="center", fontsize=8)
    ax.text(xr + wr / 2, -9.6, r"$2^2 = 4$ photographs", ha="center", va="center", fontsize=8)
    mid = (rect_l[0] + rect_r[1]) / 2
    ax.text(mid, -11.2, r"$5 = 1 + 4$ ordered trees with 4 leaves.   The Catalan number 5 is odd because the "
            "balanced mobile stands alone.", ha="center", va="center", fontsize=8)
    ax.scatter([mid - 5.6], [-12.25], s=30, marker="s", color=ORANGE, edgecolors="white", linewidths=0.7)
    ax.text(mid - 5.25, -12.25, "lopsided bar", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.scatter([mid + 1.6], [-12.25], s=30, marker="o", color=BLUE, edgecolors="white", linewidths=0.7)
    ax.text(mid + 1.95, -12.25, "balanced bar", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.set_xlim(rect_l[0] - 0.3, rect_r[1] + 0.3)
    ax.set_ylim(-12.9, 2.4)
    mf.save(fig, "fig_mobile_plan")


if __name__ == "__main__":
    fig_symmetry_number()
    fig_phylo_cherry()
    fig_sylow()
    fig_feynman()
    fig_mobile_plan()
