# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
Figures for the motivation and the cross-field connections.

    uv run python talk/figures/make_figures.py

writes every figure as PDF (vector, for the slides) and PNG (for the notes) into talk/figures/.
All numbers drawn here are computed in this script or asserted against known values; the same
statements are checked independently in experiments/E012_connections/run.py.

Visual conventions (kept the same in every figure and on the slides):
    blue circle    = symmetric node (its p subtrees are equivalent)
    orange square  = asymmetric node
    small ring     = leaf
    green wedge    = an "atom": a complete tree hanging below the skeleton
Colours are the first three slots of a palette validated for colour-vision deficiency
(all pairs); shape always carries the same distinction as colour.
"""
import itertools
import os
from math import comb

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyArrowPatch, Polygon, Rectangle

HERE = os.path.dirname(os.path.abspath(__file__))

BLUE, ORANGE, AQUA = "#2a78d6", "#eb6834", "#1baf7a"
AQUA_SOFT, BLUE_SOFT, ORANGE_SOFT = "#d9f2e8", "#dbe9fa", "#fbe3d8"
INK, INK2, MUTED, GRID, AXIS = "#0b0b0b", "#52514e", "#898781", "#e1e0d9", "#c3c2b7"

plt.rcParams.update({
    "font.family": ["Segoe UI", "DejaVu Sans"],
    "font.size": 8,
    "text.color": INK,
    "axes.edgecolor": AXIS,
    "axes.labelcolor": INK2,
    "xtick.color": MUTED,
    "ytick.color": MUTED,
    "mathtext.fontset": "dejavusans",
    "pdf.fonttype": 42,
})


# ------------------------------------------------------------------------------------------
# trees
# ------------------------------------------------------------------------------------------
class Atom:
    """A complete tree drawn as one wedge (used as a leaf of a skeleton)."""

    def __init__(self, height, p=2):
        self.height, self.p = height, p


def is_leaf(t):
    return (not isinstance(t, tuple)) or len(t) == 0


def key(t):
    """Canonical form under cyclic rotation of the children at every node."""
    if isinstance(t, Atom):
        return ("L", f"atom{t.height}")
    if not isinstance(t, tuple):
        return ("L", str(t))
    if len(t) == 0:
        return ("L", "")
    ks = tuple(key(c) for c in t)
    return ("N",) + min(ks[i:] + ks[:i] for i in range(len(ks)))


def n_leaves(t):
    if isinstance(t, Atom):
        return t.p ** t.height
    return 1 if is_leaf(t) else sum(n_leaves(c) for c in t)


def d_of(t):
    if is_leaf(t):
        return 0
    return sum(d_of(c) for c in t) + (0 if len({key(c) for c in t}) == 1 else 1)


def complete(h, p=2):
    return () if h == 0 else tuple(complete(h - 1, p) for _ in range(p))


def plane_trees(p, n, _memo={}):
    if (p, n) in _memo:
        return _memo[(p, n)]
    if n == 0:
        res = [()]
    else:
        res = []

        def comps(total, parts):
            if parts == 1:
                yield (total,)
                return
            for a in range(total + 1):
                for rest in comps(total - a, parts - 1):
                    yield (a,) + rest

        for comp in comps(n - 1, p):
            for kids in itertools.product(*[plane_trees(p, c) for c in comp]):
                res.append(tuple(kids))
    _memo[(p, n)] = res
    return res


def layout(t, leaf_width=lambda u: 1.0):
    """Leaves left to right, a parent centred over its first and last child, y = -depth."""
    nodes, edges = [], []
    cursor = [0.0]

    def rec(u, depth, path):
        if is_leaf(u):
            w = leaf_width(u)
            x = cursor[0] + w / 2
            cursor[0] += w
            nodes.append(dict(path=path, kind="leaf", obj=u, x=x, y=-depth))
            return x
        xs = [rec(c, depth + 1, path + (i,)) for i, c in enumerate(u)]
        x = (xs[0] + xs[-1]) / 2
        sym = len({key(c) for c in u}) == 1
        nodes.append(dict(path=path, kind="sym" if sym else "asym", obj=u, x=x, y=-depth))
        for i, xc in enumerate(xs):
            edges.append((x, -depth, xc, -(depth + 1), path + (i,)))
        return x

    rec(t, 0, ())
    return nodes, edges, cursor[0]


def draw_tree(ax, t, x0=0.0, y0=0.0, sx=1.0, sy=1.0, node_size=34, leaf_size=10, lw=1.0,
              leaf_width=lambda u: 1.0, show_leaves=True, zorder=3):
    """Draws t with its root at height y0; returns the laid-out nodes in data coordinates."""
    nodes, edges, width = layout(t, leaf_width)
    for (xa, ya, xb, yb, _) in edges:
        ax.plot([x0 + xa * sx, x0 + xb * sx], [y0 + ya * sy, y0 + yb * sy], color=INK2, lw=lw,
                solid_capstyle="round", zorder=zorder - 1)
    for nd in nodes:
        nd["X"], nd["Y"] = x0 + nd["x"] * sx, y0 + nd["y"] * sy
        if nd["kind"] == "sym":
            ax.scatter([nd["X"]], [nd["Y"]], s=node_size, marker="o", color=BLUE, edgecolors="white",
                       linewidths=0.8, zorder=zorder)
        elif nd["kind"] == "asym":
            ax.scatter([nd["X"]], [nd["Y"]], s=node_size, marker="s", color=ORANGE, edgecolors="white",
                       linewidths=0.8, zorder=zorder)
        elif show_leaves and not isinstance(nd["obj"], Atom):
            ax.scatter([nd["X"]], [nd["Y"]], s=leaf_size, marker="o", color="white", edgecolors=INK2,
                       linewidths=0.8, zorder=zorder)
    return nodes, width * sx


def clean(ax):
    ax.set_xticks([])
    ax.set_yticks([])
    for s in ax.spines.values():
        s.set_visible(False)


def legend_nodes(ax, x, y, dx, items, fs=7.5, off=None):
    """A one-row legend: marker + label, in ink (never in the series colour).
    dx = distance between entries, off = distance from marker to text (data units)."""
    off = dx * 0.06 if off is None else off
    for kind, label in items:
        if kind == "sym":
            ax.scatter([x], [y], s=34, marker="o", color=BLUE, edgecolors="white", linewidths=0.8, zorder=5)
        elif kind == "asym":
            ax.scatter([x], [y], s=34, marker="s", color=ORANGE, edgecolors="white", linewidths=0.8, zorder=5)
        elif kind == "leaf":
            ax.scatter([x], [y], s=12, marker="o", color="white", edgecolors=INK2, linewidths=0.8, zorder=5)
        elif kind == "atom":
            ax.scatter([x], [y], s=46, marker="^", color=AQUA, edgecolors="white", linewidths=0.8, zorder=5)
        ax.text(x + off, y, label, va="center", ha="left", fontsize=fs, color=INK2)
        x += dx


def save(fig, name):
    fig.savefig(os.path.join(HERE, name + ".pdf"), bbox_inches="tight", pad_inches=0.04, transparent=True)
    fig.savefig(os.path.join(HERE, name + ".png"), bbox_inches="tight", pad_inches=0.08, dpi=230,
                facecolor="white")
    plt.close(fig)
    print("wrote", name)


def sp(m, p):
    s = 0
    while m:
        s += m % p
        m //= p
    return s


def vp(x, p):
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


# ------------------------------------------------------------------------------------------
# 1. the pattern
# ------------------------------------------------------------------------------------------
def fig_pattern():
    fig, axes = plt.subplots(2, 1, figsize=(6.2, 3.0), gridspec_kw=dict(hspace=0.62))
    panels = [
        (2, 64, "Power of 2 in the Catalan number $C_n$  (binary trees with $n$ nodes)",
         lambda n: comb(2 * n, n) // (n + 1), "odd exactly at $n = 2^j - 1$"),
        (3, 41, "Power of 3 in the number of ternary trees with $n$ nodes",
         lambda n: comb(3 * n, n) // (2 * n + 1), "prime to 3 exactly at $n = (3^j - 1)/2$"),
    ]
    for ax, (p, nmax, title, count, note) in zip(axes, panels):
        ns = list(range(1, nmax + 1))
        vals = [vp(count(n), p) for n in ns]
        for n, v in zip(ns, vals):                       # the formula of the theorem
            assert v == (sp((p - 1) * n + 1, p) - 1) // (p - 1)
        ax.bar(ns, vals, width=0.62, color=BLUE, zorder=3)
        zeros = [n for n, v in zip(ns, vals) if v == 0]
        ax.scatter(zeros, [0] * len(zeros), s=26, marker="o", color="white", edgecolors=INK, linewidths=1.0,
                   zorder=4, clip_on=False)
        ax.set_xlim(0, nmax + 1)
        ax.set_ylim(0, max(vals) + 0.6)
        ax.set_yticks(range(0, max(vals) + 1))
        ax.set_xticks(zeros)
        ax.set_xticklabels([str(z) for z in zeros], color=INK, fontsize=7.5)
        ax.tick_params(axis="both", length=0, pad=3)
        ax.yaxis.grid(True, color=GRID, lw=0.6, zorder=0)
        ax.set_axisbelow(True)
        for s in ("top", "right", "left"):
            ax.spines[s].set_visible(False)
        ax.spines["bottom"].set_color(AXIS)
        ax.set_title(title, loc="left", fontsize=8.5, color=INK, pad=5)
        ax.text(1.0, 1.04, note, transform=ax.transAxes, ha="right", va="bottom", fontsize=7.5, color=INK2)
    axes[1].set_xlabel("$n$   (rings: the count is not divisible by the prime)", fontsize=7.5, labelpad=3)
    save(fig, "fig_pattern")


# ------------------------------------------------------------------------------------------
# 2. the five butyl groups
# ------------------------------------------------------------------------------------------
def fig_butyl():
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
    all_trees = plane_trees(3, 4)
    classes = {}
    for t in all_trees:
        classes.setdefault(key(t), 0)
        classes[key(t)] += 1
    assert len(all_trees) == 55 and len(classes) == 5

    def strip(t):                       # same tree with unlabelled leaves, to look up its class
        return () if is_leaf(t) else tuple(strip(c) for c in t)

    fig, ax = plt.subplots(figsize=(6.3, 2.75))
    clean(ax)
    x = 0.0
    gap = 3.4
    sizes = []
    for name, t in groups:
        d = d_of(t)
        size = classes[key(strip(t))]
        assert size == 3 ** d
        sizes.append(size)
        nodes, w = draw_tree(ax, t, x0=x, y0=0.0, sx=1.0, sy=1.25, node_size=40, leaf_size=9, lw=0.9)
        root = [nd for nd in nodes if nd["path"] == ()][0]
        ax.plot([root["X"], root["X"]], [root["Y"], root["Y"] + 0.75], color=INK2, lw=0.9, zorder=1)
        ax.scatter([root["X"]], [root["Y"] + 0.75], s=7, color=INK2, zorder=2)
        cx = x + w / 2
        ax.text(cx, -5.45, name, ha="center", va="top", fontsize=8, color=INK, fontweight="bold")
        ax.text(cx, -6.25, f"{d} asymmetric", ha="center", va="top", fontsize=7.4, color=INK2)
        ax.text(cx, -7.0, f"$3^{d} = {size}$ tree" + ("s" if size != 1 else ""), ha="center", va="top",
                fontsize=8, color=INK)
        x += w + gap
    total_w = x - gap
    ax.text(total_w / 2, -8.35, f"${sizes[0]} + {sizes[1]} + {sizes[2]} + {sizes[3]} + {sizes[4]} = 55$"
            "   ordered ternary trees with 4 nodes. Not divisible by 3, because tert-butyl is alone in its class.",
            ha="center", va="top", fontsize=8, color=INK)
    legend_nodes(ax, total_w * 0.2, 1.75, total_w * 0.24,
                 [("sym", "symmetric carbon"),
                  ("asym", "asymmetric carbon"),
                  ("leaf", "hydrogen")], off=1.1)
    ax.set_xlim(-1.4, total_w + 1.4)
    ax.set_ylim(-9.2, 2.4)
    save(fig, "fig_butyl")


# ------------------------------------------------------------------------------------------
# 3. the eleven shapes with 7 leaves, as energy levels
# ------------------------------------------------------------------------------------------
def fig_levels():
    shapes = {}
    for t in plane_trees(2, 6):
        shapes.setdefault(key(t), [0, t])
        shapes[key(t)][0] += 1
    by_d = {}
    for k, (cnt, t) in shapes.items():
        d = d_of(t)
        assert cnt == 2 ** d
        by_d.setdefault(d, []).append(min(tt for tt in plane_trees(2, 6) if key(tt) == k))
    assert {d: len(v) for d, v in by_d.items()} == {2: 3, 3: 3, 4: 4, 5: 1}

    fig, ax = plt.subplots(figsize=(6.3, 3.3))
    clean(ax)
    row_h = 5.2
    tree_w = 6.0
    gapx = 2.2
    x_left = 7.5
    ds = sorted(by_d)
    for r, d in enumerate(ds):
        y_top = r * row_h
        if d == ds[0]:
            ax.add_patch(Rectangle((-1.5, y_top - 4.55), 61.5, 5.0, color=AQUA_SOFT, zorder=0, lw=0))
        ax.plot([x_left - 1.2, x_left + 4 * (tree_w + gapx) - gapx + 0.6], [y_top - 4.3, y_top - 4.3],
                color=AXIS, lw=0.8, zorder=1)
        ax.text(-0.6, y_top - 2.0, f"$d = {d}$", ha="left", va="center", fontsize=9, color=INK)
        for i, t in enumerate(sorted(by_d[d], key=repr)):
            draw_tree(ax, t, x0=x_left + i * (tree_w + gapx), y0=y_top, sx=1.0, sy=0.78, node_size=17,
                      leaf_size=5, lw=0.7)
        g = len(by_d[d])
        ax.text(41.5, y_top - 2.0, f"{g} shape" + ("s" if g > 1 else " "), ha="left", va="center", fontsize=8,
                color=INK2)
        ax.text(48.0, y_top - 2.0, f"$\\times\\ 2^{d} \\;=\\; {g * 2 ** d}$ trees", ha="left", va="center",
                fontsize=8.5, color=INK)
    top = (len(ds) - 1) * row_h
    ax.annotate("", xy=(3.9, top + 0.3), xytext=(3.9, -4.2),
                arrowprops=dict(arrowstyle="-|>", color=MUTED, lw=0.9))
    ax.text(3.9, top + 0.75, "more\nasymmetric", fontsize=6.6, color=MUTED, ha="center", va="bottom",
            linespacing=1.0)
    ax.text(41.5, -3.55, "the most symmetric shapes", fontsize=7.5, color=INK2, ha="left", va="center")
    ax.text(29.0, -6.3, r"$132 \;=\; 12 + 24 + 64 + 32 \;=\; 2^2 \times 33$" +
            "      The lowest row decides the power of 2, because it has an odd number of shapes.",
            ha="center", va="top", fontsize=8, color=INK)
    legend_nodes(ax, 12.0, top + 2.6, 13.5, [("sym", "symmetric node"), ("asym", "asymmetric node"), ("leaf", "leaf")],
                 off=1.0)
    ax.set_xlim(-1.6, 60.2)
    ax.set_ylim(-7.8, top + 3.6)
    save(fig, "fig_levels")


# ------------------------------------------------------------------------------------------
# 4. the carry budget
# ------------------------------------------------------------------------------------------
def fig_carry_budget():
    o = ()
    K1 = (o, o)
    K2 = (K1, K1)
    minimal = (K2, (K1, o))
    cater = (o, (o, (o, (o, (o, (o, o))))))

    fig, ax = plt.subplots(figsize=(6.3, 3.05))
    clean(ax)

    def panel(t, x0, title, sx, sy):
        nodes, w = draw_tree(ax, t, x0=x0, y0=0.0, sx=sx, sy=sy, node_size=46, leaf_size=13, lw=1.0)
        total, wasted = 0, 0
        for nd in nodes:
            if nd["kind"] == "leaf":
                continue
            ls = [n_leaves(c) for c in nd["obj"]]
            c = sum(sp(v, 2) for v in ls) - sp(sum(ls), 2)
            total += c
            wasted += c if nd["kind"] == "asym" else 0
            lab = format(sum(ls), "b")
            note = "" if c == 0 else f"  {c} carr" + ("y" if c == 1 else "ies")
            cherry = all(is_leaf(c) for c in nd["obj"])
            if cherry:                      # label under the two leaves
                ax.text(nd["X"], nd["Y"] - sy - 0.3, lab + note, ha="center", va="top", fontsize=7.0, color=INK)
                continue
            if nd["path"] == ():
                hx, ha, dy = 0.0, "center", 0.34
            elif nd["path"][-1] == 0:
                hx, ha, dy = -0.42 * sx, "right", 0.12
            else:
                hx, ha, dy = 0.42 * sx, "left", 0.12
            ax.text(nd["X"] + hx, nd["Y"] + dy, lab + note, ha=ha, va="bottom", fontsize=7.2, color=INK)
        d = d_of(t)
        ax.text(x0 + w / 2, 1.25, title, ha="center", va="bottom", fontsize=8.5, color=INK, fontweight="bold")
        return total, wasted, d, x0 + w / 2

    tot1, w1, d1, c1 = panel(minimal, 0.0, "the most symmetric tree with 7 leaves", 1.45, 1.05)
    tot2, w2, d2, c2 = panel(cater, 13.6, "a lopsided tree with 7 leaves", 1.45, 0.74)
    assert (tot1, w1, d1) == (4, 0, 2) and (tot2, w2, d2) == (4, 3, 5)
    y = -4.95
    for cx, tot, wst, d in ((c1, tot1, w1, d1), (c2, tot2, w2, d2)):
        ax.text(cx, y, f"{tot} carries in all", ha="center", va="top", fontsize=8, color=INK)
        ax.text(cx, y - 0.62, ("none wasted" if wst == 0 else f"{wst} wasted at asymmetric nodes"),
                ha="center", va="top", fontsize=7.6, color=INK2)
        ax.text(cx, y - 1.24, f"{d} asymmetric nodes" + ("  (the minimum, $t = 2$)" if wst == 0 else ""),
                ha="center", va="top", fontsize=7.6, color=INK2)
    ax.text(12.0, -7.2, "Leaf counts are written in binary. Adding them up always costs "
            r"$(7 - 3)/1 = 4$ carries; a symmetric node always uses at least one.",
            ha="center", va="top", fontsize=7.8, color=INK)
    legend_nodes(ax, 4.6, 2.55, 6.6, [("sym", "symmetric node"), ("asym", "asymmetric node"), ("leaf", "leaf")],
                 off=0.5)
    ax.set_xlim(-1.4, 25.4)
    ax.set_ylim(-7.9, 3.0)
    save(fig, "fig_carry_budget")


# ------------------------------------------------------------------------------------------
# 5. atoms: the most symmetric tree with 13 leaves
# ------------------------------------------------------------------------------------------
def fig_atoms():
    o = ()
    K2, K3 = complete(2), complete(3)
    t = (K3, (K2, o))
    assert n_leaves(t) == 13 and d_of(t) == 2

    fig, ax = plt.subplots(figsize=(6.3, 2.7))
    clean(ax)
    nodes, w = draw_tree(ax, t, x0=0.0, y0=0.0, sx=1.0, sy=1.0, node_size=40, leaf_size=11, lw=1.0)

    def wedge(path, height, label, digit):
        nd = [n for n in nodes if n["path"] == path][0]
        lv = [n for n in nodes if n["kind"] == "leaf" and n["path"][:len(path)] == path]
        xs = [n["X"] for n in lv]
        yb = min(n["Y"] for n in lv)
        pad = 0.55
        if height == 0:
            ax.add_patch(Circle((nd["X"], nd["Y"]), 0.5, color=AQUA_SOFT, zorder=0, lw=0))
        else:
            ax.add_patch(Polygon([(nd["X"], nd["Y"] + pad + 0.1), (min(xs) - pad, yb - pad * 0.7),
                                  (max(xs) + pad, yb - pad * 0.7)], closed=True, color=AQUA_SOFT, zorder=0, lw=0))
        cx = (min(xs) + max(xs)) / 2
        ax.text(cx, -4.75, label, ha="center", va="top", fontsize=8, color=INK)
        ax.text(cx, -5.45, digit, ha="center", va="top", fontsize=8, color=INK2)

    wedge((0,), 3, "8 leaves", "$2^3$")
    wedge((1, 0), 2, "4 leaves", "$2^2$")
    wedge((1, 1), 0, "1 leaf", "$2^0$")
    bx = w + 2.2
    ax.text(bx, 0.1, r"$13 = 8 + 4 + 1 = 1101_2$", ha="left", va="center", fontsize=10.5, color=INK)
    ax.text(bx, -1.0, "The most symmetric tree with 13 leaves", ha="left", va="center", fontsize=8, color=INK)
    ax.text(bx, -1.6, "has 12 nodes:", ha="left", va="center", fontsize=8, color=INK)
    ax.scatter([bx + 0.25], [-2.4], s=34, marker="o", color=BLUE, edgecolors="white", linewidths=0.8)
    ax.text(bx + 0.75, -2.4, "10 symmetric, inside the complete trees", ha="left", va="center", fontsize=7.6,
            color=INK2)
    ax.scatter([bx + 0.25], [-3.1], s=34, marker="s", color=ORANGE, edgecolors="white", linewidths=0.8)
    ax.text(bx + 0.75, -3.1, "2 asymmetric, joining them", ha="left", va="center", fontsize=7.6, color=INK2)
    ax.text(bx, -4.15, "2 = (number of ones in 1101) $-$ 1", ha="left", va="center", fontsize=8, color=INK)
    ax.text(bx, -4.8, "= the power of 2 in $C_{12} = 208012$", ha="left", va="center", fontsize=8, color=INK)
    assert vp(comb(24, 12) // 13, 2) == 2 and comb(24, 12) // 13 == 208012
    ax.set_xlim(-0.9, w + 13.2)
    ax.set_ylim(-6.1, 0.9)
    save(fig, "fig_atoms")


# ------------------------------------------------------------------------------------------
# 6. one object, three pictures: tree, intervals, balls
# ------------------------------------------------------------------------------------------
def fig_balls():
    o = ()
    t = ((o, o), (o, (o, o)))
    fig, axes = plt.subplots(1, 3, figsize=(6.3, 2.45), gridspec_kw=dict(width_ratios=[1.0, 1.25, 1.0], wspace=0.08))
    for ax in axes:
        clean(ax)

    # (a) the tree, with code words
    ax = axes[0]
    nodes, edges, w = layout(t)
    for (xa, ya, xb, yb, path) in edges:
        ax.plot([xa, xb], [ya, yb], color=INK2, lw=1.0, zorder=1)
        ax.text((xa + xb) / 2 + (-0.2 if path[-1] == 0 else 0.2), (ya + yb) / 2 + 0.08, str(path[-1]),
                ha="center", va="center", fontsize=7, color=INK2)
    words = []
    for nd in nodes:
        if nd["kind"] == "leaf":
            word = "".join(str(i) for i in nd["path"])
            words.append((word, nd["x"], nd["y"]))
            ax.scatter([nd["x"]], [nd["y"]], s=16, marker="o", color="white", edgecolors=INK2, linewidths=0.9, zorder=3)
            ax.text(nd["x"], nd["y"] - 0.3, word, ha="center", va="top", fontsize=7.5, family="DejaVu Sans Mono")
        else:
            ax.scatter([nd["x"]], [nd["y"]], s=22, marker="o", color=INK2, zorder=3)
    ax.set_xlim(-0.3, w + 0.3)
    ax.set_ylim(-4.4, 0.9)
    ax.text(0.5, 1.0, "a binary tree with 5 leaves", transform=ax.transAxes, ha="center", va="bottom",
            fontsize=8.2)

    # (b) intervals
    ax = axes[1]
    words.sort()
    x = 0.0
    for i, (word, _, _) in enumerate(words):
        wdt = 2.0 ** (-len(word))
        ax.add_patch(Rectangle((x + 0.004, 0.0), wdt - 0.008, 0.34, color=BLUE_SOFT if i % 2 == 0 else AQUA_SOFT, lw=0))
        ax.text(x + wdt / 2, 0.17, word, ha="center", va="center", fontsize=7.5, family="DejaVu Sans Mono")
        frac = {2: r"$\frac{1}{4}$", 3: r"$\frac{1}{8}$", 1: r"$\frac{1}{2}$"}[len(word)]
        ax.text(x + wdt / 2, -0.12, frac, ha="center", va="center", fontsize=9, color=INK2)
        x += wdt
    assert abs(x - 1.0) < 1e-12
    ax.text(0.5, -0.42, "the sizes add up to 1", ha="center", va="center", fontsize=7.6, color=INK2)
    ax.text(0.5, -0.78, "code words  ·  blocks of addresses", ha="center", va="center", fontsize=7.4, color=INK2)
    ax.text(0.5, -1.02, "notes in a bar of music", ha="center", va="center", fontsize=7.4, color=INK2)
    ax.set_xlim(-0.04, 1.04)
    ax.set_ylim(-1.25, 0.72)
    ax.text(0.5, 1.0, "the same thing as a cut of an interval", transform=ax.transAxes, ha="center",
            va="bottom", fontsize=8.2)

    # (c) balls
    ax = axes[2]
    ax.set_aspect("equal")

    def ball(u, cx, cy, r, depth, k=0):
        if is_leaf(u):
            ax.add_patch(Circle((cx, cy), r * 0.94, facecolor=BLUE_SOFT if k % 2 == 0 else AQUA_SOFT,
                                edgecolor=INK2, lw=0.7, zorder=2 + depth))
            return k + 1
        ax.add_patch(Circle((cx, cy), r * 0.97, facecolor="white", edgecolor=AXIS, lw=0.8, zorder=1 + depth))
        k = ball(u[0], cx - r / 2, cy, r / 2, depth + 1, k)
        return ball(u[1], cx + r / 2, cy, r / 2, depth + 1, k)

    ball(t, 0, 0, 1.0, 0)
    ax.set_xlim(-1.08, 1.08)
    ax.set_ylim(-1.5, 1.42)
    ax.text(0, -1.25, "5 balls filling the 2-adic integers", ha="center", va="center", fontsize=7.6, color=INK2)
    ax.text(0, 1.3, "and as a cut into balls", ha="center", va="center", fontsize=8.2)
    save(fig, "fig_balls")


# ------------------------------------------------------------------------------------------
# 7. bits and bytes: one 4-ary node is two levels of binary nodes
# ------------------------------------------------------------------------------------------
def fig_bits():
    fig, ax = plt.subplots(figsize=(6.3, 2.5))
    clean(ax)
    labels = ["A", "B", "C", "D"]

    def boxes(xs, y):
        for x, lab in zip(xs, labels):
            ax.add_patch(Rectangle((x - 0.42, y - 0.36), 0.84, 0.72, facecolor="white", edgecolor=INK2, lw=0.9, zorder=3))
            ax.text(x, y, lab, ha="center", va="center", fontsize=8.5, zorder=4)

    # left: one 4-ary node
    xs = [0.0, 1.3, 2.6, 3.9]
    for x in xs:
        ax.plot([1.95, x], [2.0, 0.36], color=INK2, lw=1.0, zorder=1)
    ax.scatter([1.95], [2.0], s=70, marker="D", color=INK2, zorder=3)
    boxes(xs, 0.0)
    ax.text(1.95, 2.75, "one node with 4 branches", ha="center", va="bottom", fontsize=8.5, fontweight="bold")
    ax.text(1.95, -0.85, "reorder the 4 branches in any way:", ha="center", va="top", fontsize=7.6, color=INK2)
    ax.text(1.95, -1.42, "24 moves; classes of 1, 4, 6, 12 or 24", ha="center", va="top", fontsize=8, color=INK)
    ax.text(1.95, -2.02, "6 and 12 are not powers of 2", ha="center", va="top", fontsize=7.6, color=INK2)

    # arrow
    ax.add_patch(FancyArrowPatch((4.9, 1.0), (6.4, 1.0), arrowstyle="-|>", mutation_scale=11, color=MUTED, lw=1.1))
    ax.text(5.65, 1.25, "read as", ha="center", va="bottom", fontsize=7.4, color=MUTED)

    # right: two binary levels
    x0 = 7.4
    xs2 = [x0 + v for v in xs]
    mids = [(xs2[0] + xs2[1]) / 2, (xs2[2] + xs2[3]) / 2]
    root = (mids[0] + mids[1]) / 2
    for m in mids:
        ax.plot([root, m], [2.0, 1.15], color=INK2, lw=1.0, zorder=1)
    for m, pair in zip(mids, (xs2[:2], xs2[2:])):
        for x in pair:
            ax.plot([m, x], [1.15, 0.36], color=INK2, lw=1.0, zorder=1)
    ax.scatter([root] + mids, [2.0, 1.15, 1.15], s=44, marker="o", color=INK2, zorder=3)
    for (cx, cy) in [(root, 2.0), (mids[0], 1.15), (mids[1], 1.15)]:
        ax.annotate("", xy=(cx + 0.62, cy + 0.02), xytext=(cx - 0.62, cy + 0.02),
                    arrowprops=dict(arrowstyle="<|-|>", color=ORANGE, lw=1.1, shrinkA=7, shrinkB=7,
                                    connectionstyle="arc3,rad=-0.55"), zorder=2)
    boxes(xs2, 0.0)
    ax.text(root, 2.75, "two levels of nodes with 2 branches", ha="center", va="bottom", fontsize=8.5, fontweight="bold")
    ax.text(root, -0.85, "swap the two branches at any of the 3 nodes:", ha="center", va="top", fontsize=7.6, color=INK2)
    ax.text(root, -1.42, "8 moves; classes of 1, 2, 4 or 8", ha="center", va="top", fontsize=8, color=INK)
    ax.text(root, -2.02, "always a power of 2", ha="center", va="top", fontsize=7.6, color=INK2)
    ax.set_xlim(-0.9, x0 + 4.8)
    ax.set_ylim(-2.5, 3.3)
    save(fig, "fig_bits")


# ------------------------------------------------------------------------------------------
# 8. one tree, four dialects
# ------------------------------------------------------------------------------------------
def fig_dialects():
    o = ()
    K1, K2 = (o, o), ((o, o), (o, o))
    t = (K1, K2)                                   # 6 leaves; 6 = 110 in binary; one asymmetric node
    assert d_of(t) == 1 and n_leaves(t) == 6
    nodes, edges, w = layout(t)
    fig, axes = plt.subplots(1, 4, figsize=(6.3, 2.35), gridspec_kw=dict(wspace=0.16))
    for ax in axes:
        clean(ax)

    def mark(ax, x, y, kind, s=30):
        if kind == "sym":
            ax.scatter([x], [y], s=s, marker="o", color=BLUE, edgecolors="white", linewidths=0.8, zorder=4)
        elif kind == "asym":
            ax.scatter([x], [y], s=s, marker="s", color=ORANGE, edgecolors="white", linewidths=0.8, zorder=4)

    byp = {nd["path"]: nd for nd in nodes}

    # (a) evolution: rectangular tree, tips at the bottom
    ax = axes[0]
    for nd in nodes:
        if nd["kind"] != "leaf":
            kids = [byp[nd["path"] + (i,)] for i in range(2)]
            ax.plot([kids[0]["x"], kids[1]["x"]], [nd["y"], nd["y"]], color=INK2, lw=1.0, zorder=1)
            for kd in kids:
                yb = kd["y"] if kd["kind"] != "leaf" else -3.0
                ax.plot([kd["x"], kd["x"]], [nd["y"], yb], color=INK2, lw=1.0, zorder=1)
            mark(ax, nd["x"], nd["y"], nd["kind"])
    root = byp[()]
    ax.plot([root["x"], root["x"]], [0, 0.6], color=INK2, lw=1.0)
    for i, nd in enumerate(sorted([n for n in nodes if n["kind"] == "leaf"], key=lambda n: n["x"])):
        ax.text(nd["x"], -3.3, "ABCDEF"[i], ha="center", va="top", fontsize=7.5)
    ax.set_xlim(-0.2, w + 0.2)
    ax.set_ylim(-4.6, 1.2)
    ax.set_title("evolution", fontsize=8.5, pad=2, fontweight="bold")
    ax.text(w / 2, -4.25, "6 species", ha="center", va="center", fontsize=7.4, color=INK2)

    # (b) tournament: players on the left, final on the right
    ax = axes[1]
    for nd in nodes:
        if nd["kind"] != "leaf":
            kids = [byp[nd["path"] + (i,)] for i in range(2)]
            X = 3.0 + nd["y"]                      # root at x = 3
            ax.plot([X, X], [kids[0]["x"], kids[1]["x"]], color=INK2, lw=1.0, zorder=1)
            for kd in kids:
                xb = 3.0 + kd["y"] if kd["kind"] != "leaf" else 0.0
                ax.plot([xb, X], [kd["x"], kd["x"]], color=INK2, lw=1.0, zorder=1)
            mark(ax, X, nd["x"], nd["kind"])
    ax.plot([3.0, 3.7], [root["x"], root["x"]], color=INK2, lw=1.0)
    ax.text(3.75, root["x"], "winner", ha="left", va="center", fontsize=6.8, color=INK2)
    ax.set_xlim(-0.3, 5.3)
    ax.set_ylim(-0.7, w + 0.2)
    ax.set_title("sport", fontsize=8.5, pad=2, fontweight="bold")
    ax.text(2.5, -0.38, "6 players", ha="center", va="center", fontsize=7.4, color=INK2)

    # (c) code
    ax = axes[2]
    for (xa, ya, xb, yb, path) in edges:
        ax.plot([xa, xb], [ya, yb], color=INK2, lw=1.0, zorder=1)
    for nd in nodes:
        if nd["kind"] == "leaf":
            ax.scatter([nd["x"]], [nd["y"]], s=12, marker="o", color="white", edgecolors=INK2, linewidths=0.8, zorder=3)
            ax.text(nd["x"], nd["y"] - 0.28, "".join(map(str, nd["path"])), ha="center", va="top", fontsize=6.3,
                    family="DejaVu Sans Mono", rotation=90)
        else:
            mark(ax, nd["x"], nd["y"], nd["kind"])
    ax.set_xlim(-0.3, w + 0.3)
    ax.set_ylim(-4.6, 1.2)
    ax.set_title("computing", fontsize=8.5, pad=2, fontweight="bold")
    ax.text(w / 2, -4.25, "6 code words", ha="center", va="center", fontsize=7.4, color=INK2)

    # (d) music / intervals
    ax = axes[3]
    leaves_sorted = sorted([n for n in nodes if n["kind"] == "leaf"], key=lambda n: n["x"])
    x = 0.0
    for i, nd in enumerate(leaves_sorted):
        wdt = 2.0 ** (-len(nd["path"]))
        ax.add_patch(Rectangle((x + 0.006, 0.0), wdt - 0.012, 0.3, color=BLUE_SOFT if i % 2 == 0 else AQUA_SOFT, lw=0))
        ax.text(x + wdt / 2, 0.15, r"$\frac{1}{%d}$" % (2 ** len(nd["path"])), ha="center", va="center", fontsize=8)
        x += wdt
    assert abs(x - 1.0) < 1e-12
    ax.plot([0, 0], [-0.05, 0.35], color=INK2, lw=1.0)
    ax.plot([1, 1], [-0.05, 0.35], color=INK2, lw=1.0)
    ax.set_xlim(-0.06, 1.06)
    ax.set_ylim(-0.92, 0.62)
    ax.set_title("music", fontsize=8.5, pad=2, fontweight="bold")
    ax.text(0.5, -0.82, "6 notes in one bar", ha="center", va="center", fontsize=7.4, color=INK2)
    save(fig, "fig_dialects")


# ------------------------------------------------------------------------------------------
# 9. a carry is two equal blocks fusing (counter, heap, sand)
# ------------------------------------------------------------------------------------------
def fig_fusion():
    m = 13
    fig, ax = plt.subplots(figsize=(6.3, 2.55))
    clean(ax)
    # state after fusing all equal pairs up to level r: list of block sizes, largest first
    rows = []
    counts = [m]                      # counts[j] = number of blocks of size 2^j
    rows.append(([1] * m, None))
    carries_total = 0
    level = 0
    while counts[level] >= 2:
        c = counts[level] // 2
        counts[level] -= 2 * c
        counts.append(c)
        carries_total += c
        level += 1
        blocks = []
        for j in range(len(counts) - 1, -1, -1):
            blocks += [2 ** j] * counts[j]
        rows.append((blocks, c))
    assert carries_total == (m - sp(m, 2)) and rows[-1][0] == [8, 4, 1]
    unit = 1.0
    for r, (blocks, c) in enumerate(rows):
        y = -r * 1.25
        x = 0.0
        last = r == len(rows) - 1
        for b in blocks:
            col = AQUA_SOFT if last else (BLUE_SOFT if b > 1 else "#eeeeea")
            ax.add_patch(Rectangle((x + 0.07, y), b * unit - 0.14, 0.72, facecolor=col,
                                   edgecolor=AQUA if last else AXIS, lw=0.9))
            ax.text(x + b * unit / 2, y + 0.36, str(b), ha="center", va="center", fontsize=7.6,
                    color=INK if b > 1 or last else INK2)
            x += b * unit
        if c is None:
            ax.text(13.6, y + 0.36, "13 single leaves", ha="left", va="center", fontsize=8, color=INK)
        else:
            ax.text(13.6, y + 0.36, f"equal blocks fuse in pairs:  {c} carr" + ("y" if c == 1 else "ies"),
                    ha="left", va="center", fontsize=8, color=INK)
    yb = -(len(rows) - 1) * 1.25
    ax.text(6.5, yb - 0.45, r"nothing left to fuse:   $13 = 8 + 4 + 1 = 1101_2$", ha="center", va="top", fontsize=8.5)
    ax.text(13.6, yb - 0.45, f"{carries_total} carries in all  $= (13 - 3)/(2 - 1)$", ha="left", va="top",
            fontsize=8, color=INK)
    ax.text(11.6, yb - 1.25, "The same bookkeeping: a binary counter, a binomial heap, a buddy memory allocator, "
            "sand that topples in pairs.", ha="center", va="top", fontsize=7.6, color=INK2)
    ax.set_xlim(-0.3, 23.8)
    ax.set_ylim(yb - 1.9, 1.0)
    save(fig, "fig_fusion")


# ------------------------------------------------------------------------------------------
# 10. dendrimer against hyperbranched molecule (radial trees, p = 3)
# ------------------------------------------------------------------------------------------
def radial(ax, t, cx, cy, dr=1.0, node_size=20, leaf_size=6, shade_atoms=False):
    """Root at the centre, depth = radius, each leaf gets an equal angular slot."""
    import math
    from matplotlib.patches import Wedge

    m = n_leaves(t)
    pts, edges, wedges = [], [], []
    cursor = [0]

    def rec(u, depth):
        if is_leaf(u):
            a0 = cursor[0]
            cursor[0] += 1
            ang = (a0 + 0.5) / m * 2 * math.pi
            pts.append((depth, ang, "leaf"))
            return ang, a0, a0 + 1, depth
        res = [rec(c, depth + 1) for c in u]
        lo, hi = res[0][1], res[-1][2]
        ang = (lo + hi) / 2 / m * 2 * math.pi
        sym = len({key(c) for c in u}) == 1
        pts.append((depth, ang, "sym" if sym else "asym"))
        for (ca, _, _, cd) in res:
            edges.append((depth, ang, depth + 1, ca))
        deepest = max(r[3] for r in res)
        if shade_atoms and d_of(u) == 0 and depth > 0:
            wedges.append((depth, lo, hi, deepest))
        return ang, lo, hi, deepest

    rec(t, 0)
    xy = lambda r, a: (cx + r * dr * math.cos(a + math.pi / 2), cy + r * dr * math.sin(a + math.pi / 2))
    if shade_atoms:
        # keep only maximal complete subtrees (smallest depth for a given angular range)
        wedges.sort()
        kept = []
        for w in wedges:
            if not any(k[1] <= w[1] and w[2] <= k[2] for k in kept):
                kept.append(w)
        for (depth, lo, hi, deepest) in kept:
            th1 = 90 + lo / m * 360
            th2 = 90 + hi / m * 360
            ax.add_patch(Wedge((cx, cy), (deepest + 0.45) * dr, th1, th2, width=(deepest + 0.45 - depth + 0.45) * dr,
                               facecolor=AQUA_SOFT, edgecolor="none", zorder=0))
    for (r1, a1, r2, a2) in edges:
        (x1, y1), (x2, y2) = xy(r1, a1), xy(r2, a2)
        ax.plot([x1, x2], [y1, y2], color=INK2, lw=0.7, zorder=1)
    for (r, a, kind) in pts:
        x, y = xy(r, a)
        if kind == "sym":
            ax.scatter([x], [y], s=node_size, marker="o", color=BLUE, edgecolors="white", linewidths=0.6, zorder=3)
        elif kind == "asym":
            ax.scatter([x], [y], s=node_size, marker="s", color=ORANGE, edgecolors="white", linewidths=0.6, zorder=3)
        else:
            ax.scatter([x], [y], s=leaf_size, marker="o", color="white", edgecolors=INK2, linewidths=0.6, zorder=3)


def fig_dendrimer():
    import random

    p, m = 3, 39                                  # 39 = 1110 in base 3 = 27 + 9 + 3
    best = (complete(3, 3), complete(2, 3), complete(1, 3))
    assert n_leaves(best) == m and d_of(best) == 1 == (sp(m, 3) - 1) // 2

    rng = random.Random(7)

    def grow(n_nodes):
        t = ["leaf"]

        def expand(path_tree):
            return path_tree

        # represent as nested lists while growing
        tree = []
        leaves_list = [tree]                      # each leaf is an empty list; expanding fills it with 3 lists
        for _ in range(n_nodes):
            i = rng.randrange(len(leaves_list))
            lf = leaves_list.pop(i)
            kids = [[], [], []]
            lf.extend(kids)
            leaves_list.extend(kids)

        def freeze(u):
            return tuple(freeze(c) for c in u)

        return freeze(tree)

    rand = grow((m - 1) // 2)
    assert n_leaves(rand) == m
    n_nodes = (m - 1) // 2
    fig, axes = plt.subplots(1, 2, figsize=(6.3, 3.05), gridspec_kw=dict(wspace=0.02))
    for ax in axes:
        clean(ax)
        ax.set_aspect("equal")
    depth = lambda u: 0 if is_leaf(u) else 1 + max(depth(c) for c in u)
    for ax, t, title, shade in ((axes[0], rand, "grown at random", False),
                                (axes[1], best, "the most symmetric one", True)):
        R = depth(t)
        radial(ax, t, 0, 0, dr=1.0 / R, node_size=24, leaf_size=7, shade_atoms=shade)
        d = d_of(t)
        ax.set_xlim(-1.18, 1.18)
        ax.set_ylim(-1.5, 1.32)
        ax.text(0, 1.26, title, ha="center", va="center", fontsize=8.5, fontweight="bold")
        ax.text(0, -1.25, f"{n_nodes} junctions:  {n_nodes - d} symmetric,  {d} asymmetric", ha="center",
                va="center", fontsize=7.8, color=INK)
    axes[1].text(0, -1.43, r"three perfect branches with 27, 9 and 3 ends:  $39 = 1110_3$", ha="center",
                 va="center", fontsize=7.6, color=INK2)
    axes[0].text(0, -1.43, "39 ends, 3 branches at every junction", ha="center", va="center", fontsize=7.6,
                 color=INK2)
    save(fig, "fig_dendrimer")


# ------------------------------------------------------------------------------------------
# 11. sand on a line and on a ring (q = 4: two sites)
# ------------------------------------------------------------------------------------------
def fig_sand():
    m = 7
    # line
    line = [m, 0, 0, 0]
    topples_line = 0
    for i in range(3):
        c = line[i] // 2
        line[i] -= 2 * c
        line[i + 1] += c
        topples_line += c
    # ring of two sites
    ring = [m, 0]
    topples_ring = 0
    while max(ring) >= 2:
        for i in range(2):
            c = ring[i] // 2
            ring[i] -= 2 * c
            ring[(i + 1) % 2] += c
            topples_ring += c
    assert line == [1, 1, 1, 0] and topples_line == 4 and ring == [1, 0] and topples_ring == 6
    assert comb(8, 2) // 7 == 4 and vp(4, 2) == topples_ring - topples_line

    fig, ax = plt.subplots(figsize=(6.3, 2.45))
    clean(ax)

    def pile(x, y, n, label):
        ax.plot([x - 0.42, x + 0.42], [y, y], color=INK2, lw=1.2)
        for i in range(n):
            ax.add_patch(Circle((x - 0.26 + 0.26 * (i % 3), y + 0.16 + 0.27 * (i // 3)), 0.115, facecolor=AQUA,
                                edgecolor="white", lw=0.5, zorder=3))
        ax.text(x, y - 0.2, label, ha="center", va="top", fontsize=7, color=INK2)

    # line: before / after
    ax.text(2.2, 2.95, "on a line", ha="center", va="center", fontsize=8.5, fontweight="bold")
    for i, n in enumerate([m, 0, 0, 0]):
        pile(0.6 + i * 1.05, 1.6, n, f"site {i}")
    ax.annotate("", xy=(2.2, 0.55), xytext=(2.2, 1.05), arrowprops=dict(arrowstyle="-|>", color=MUTED, lw=1.0))
    for i, n in enumerate(line):
        pile(0.6 + i * 1.05, -0.2, n, f"site {i}")
    ax.text(2.2, -0.95, f"{topples_line} topplings; what is left is $7 = 111_2$", ha="center", va="top", fontsize=7.8)

    # ring
    ax.text(7.6, 2.95, "on a ring of 2 sites", ha="center", va="center", fontsize=8.5, fontweight="bold")
    for i, n in enumerate([m, 0]):
        pile(7.0 + i * 1.2, 1.6, n, f"site {i}")
    ax.annotate("", xy=(7.6, 0.55), xytext=(7.6, 1.05), arrowprops=dict(arrowstyle="-|>", color=MUTED, lw=1.0))
    for i, n in enumerate(ring):
        pile(7.0 + i * 1.2, -0.2, n, f"site {i}")
    ax.text(8.85, 1.85, "site 1 passes\nback to site 0", ha="left", va="center", fontsize=6.6, color=MUTED,
            linespacing=1.05)
    ax.text(7.6, -0.95, f"{topples_ring} topplings; one grain is left", ha="center", va="top", fontsize=7.8)

    ax.text(12.6, 1.9, "rule: 2 grains on a site", ha="center", va="center", fontsize=7.8, color=INK2)
    ax.text(12.6, 1.52, "become 1 grain on the next", ha="center", va="center", fontsize=7.8, color=INK2)
    ax.text(12.6, 0.6, f"${topples_ring} - {topples_line} = 2$", ha="center", va="center", fontsize=11)
    ax.text(12.6, 0.05, "= power of 2 in the number", ha="center", va="center", fontsize=7.8)
    ax.text(12.6, -0.33, "of 4-ary trees with 7 leaves", ha="center", va="center", fontsize=7.8)
    ax.text(12.6, -0.71, "(there are 4 of them)", ha="center", va="center", fontsize=7.8, color=INK2)
    ax.set_aspect("equal")
    ax.set_xlim(-0.2, 15.0)
    ax.set_ylim(-1.5, 3.3)
    save(fig, "fig_sand")


# ------------------------------------------------------------------------------------------
# 12. quadtrees (q = 4): the 22 subdivisions with three quarterings
# ------------------------------------------------------------------------------------------
def quad_to_binary(t):
    """A 4-ary node (c0, c1, c2, c3) read as two binary levels ((c0, c1), (c2, c3)).
    Children: c0 = south-west, c1 = north-east (one diagonal), c2 = south-east, c3 = north-west."""
    if is_leaf(t):
        return ()
    b = [quad_to_binary(c) for c in t]
    return ((b[0], b[1]), (b[2], b[3]))


def draw_quad(ax, t, x, y, size, lw=0.7):
    if is_leaf(t):
        return
    h = size / 2
    ax.plot([x, x + size], [y + h, y + h], color=INK, lw=lw, solid_capstyle="butt")
    ax.plot([x + h, x + h], [y, y + size], color=INK, lw=lw, solid_capstyle="butt")
    for c, (dx, dy) in zip(t, [(0, 0), (h, h), (h, 0), (0, h)]):       # SW, NE, SE, NW
        draw_quad(ax, c, x + dx, y + dy, h, lw=lw * 0.85)


def fig_quadtree():
    trees = plane_trees(4, 3)
    assert len(trees) == 22
    fam = {}
    for t in trees:
        fam.setdefault(key(quad_to_binary(t)), []).append(t)
    sizes = sorted(len(v) for v in fam.values())
    assert sizes == [2, 4, 16]
    for k, v in fam.items():
        assert len(v) == 2 ** d_of(quad_to_binary(v[0]))
    groups = sorted(fam.values(), key=len)

    def where(t):
        """(outer quadrant index, inner quadrant index or None) for sorting pictures."""
        idx = [i for i, c in enumerate(t) if not is_leaf(c)]
        inner = None
        if len(idx) == 1:
            inner = [i for i, c in enumerate(t[idx[0]]) if not is_leaf(c)]
            inner = inner[0] if inner else None
        return idx, inner

    pos = {0: (0, 0), 1: (1, 1), 2: (1, 0), 3: (0, 1)}                 # quadrant -> (column, row)
    fig, ax = plt.subplots(figsize=(6.3, 3.0))
    clean(ax)
    ax.set_aspect("equal")
    S, G = 1.0, 0.28

    def frame(x0, y0, cols, rows, soft):
        w, h = cols * S + (cols - 1) * G, rows * S + (rows - 1) * G
        ax.add_patch(Rectangle((x0 - 0.22, y0 - 0.22), w + 0.44, h + 0.44, facecolor=soft, edgecolor="none", zorder=0))
        return w, h

    def put(t, x, y):
        ax.add_patch(Rectangle((x, y), S, S, facecolor="white", edgecolor=INK, lw=0.9, zorder=1))
        draw_quad(ax, t, x, y, S)

    # family of 2
    x0, ybase = 0.0, 1.9
    w, h = frame(x0, ybase, 1, 2, AQUA_SOFT)
    for i, t in enumerate(sorted(groups[0], key=repr)):
        put(t, x0, ybase + i * (S + G))
    ax.text(x0 + w / 2, ybase - 0.5, "2 pictures", ha="center", va="top", fontsize=8.2)
    ax.text(x0 + w / 2, ybase - 0.95, "opposite\nquarters cut", ha="center", va="top", fontsize=7, color=INK2, linespacing=1.05)
    # family of 4
    x1 = 2.6
    w, h = frame(x1, ybase, 2, 2, "#f1f0ec")
    for t in groups[1]:
        idx, _ = where(t)
        missing = [i for i in range(4) if i not in idx]                 # the uncut pair; place by one of them
        cx = sum(pos[i][0] for i in idx) / 2
        cy = sum(pos[i][1] for i in idx) / 2
        col = 0 if cx < 0.5 or (cx == 0.5 and cy < 0.5) else 1
        row = 0 if cy < 0.5 or (cy == 0.5 and cx > 0.5) else 1
        put(t, x1 + col * (S + G), ybase + row * (S + G))
    ax.text(x1 + w / 2, ybase - 0.5, "4 pictures", ha="center", va="top", fontsize=8.2)
    ax.text(x1 + w / 2, ybase - 0.95, "neighbouring\nquarters cut", ha="center", va="top", fontsize=7, color=INK2, linespacing=1.05)
    # family of 16
    x2 = 6.5
    y2 = 0.0
    w, h = frame(x2, y2, 4, 4, "#f1f0ec")
    for t in groups[2]:
        idx, inner = where(t)
        ox, oy = pos[idx[0]]
        ix, iy = pos[inner]
        put(t, x2 + (2 * ox + ix) * (S + G), y2 + (2 * oy + iy) * (S + G))
    ax.text(x2 + w + 0.55, y2 + h - 0.3, "16 pictures", ha="left", va="center", fontsize=8.2)
    ax.text(x2 + w + 0.55, y2 + h - 0.95, "a quarter cut,\nand a quarter\nof it cut again", ha="left", va="center", fontsize=7,
            color=INK2, linespacing=1.05)
    ax.text(x2 + w + 0.55, 1.75, r"$22 = 2 + 4 + 16$", ha="left", va="center", fontsize=10.5)
    ax.text(x2 + w + 0.55, 1.05, "smallest family: $2^1$", ha="left", va="center", fontsize=8)
    ax.text(x2 + w + 0.55, 0.45, r"so $22 = 2 \times 11$", ha="left", va="center", fontsize=8)
    ax.text(x2 + w + 0.55, -0.15, "10 cells, $10 = 1010_2$", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.text(2.6, 5.05, "Turn or mirror any cut square in place:\nyou stay inside the family.", ha="center", va="center",
            fontsize=8, linespacing=1.15)
    ax.set_xlim(-0.6, x2 + w + 3.6)
    ax.set_ylim(-0.6, 5.6)
    save(fig, "fig_quadtree")


# ------------------------------------------------------------------------------------------
# 13. triangles (p = 3): stacked triangulations with three inner points
# ------------------------------------------------------------------------------------------
def draw_tri(ax, t, A, B, C, lw=0.7):
    if is_leaf(t):
        return
    Gx, Gy = (A[0] + B[0] + C[0]) / 3, (A[1] + B[1] + C[1]) / 3
    for P in (A, B, C):
        ax.plot([Gx, P[0]], [Gy, P[1]], color=INK, lw=lw, solid_capstyle="round")
    G = (Gx, Gy)
    draw_tri(ax, t[0], A, B, G, lw * 0.85)
    draw_tri(ax, t[1], B, C, G, lw * 0.85)
    draw_tri(ax, t[2], C, A, G, lw * 0.85)


def fig_triangles():
    import math

    trees = plane_trees(3, 3)
    assert len(trees) == 12
    fam = {}
    for t in trees:
        fam.setdefault(key(t), []).append(t)
    groups = sorted(fam.values(), key=len)
    assert [len(g) for g in groups] == [3, 9]
    perfect = complete(2, 3)                                         # 4 inner points, 9 faces
    assert len({key(t) for t in plane_trees(3, 4)}) == 5

    fig, ax = plt.subplots(figsize=(6.3, 2.75))
    clean(ax)
    ax.set_aspect("equal")
    S = 1.0
    hgt = S * math.sqrt(3) / 2

    def put(t, x, y, s=S, lw=0.7):
        A, B, C = (x, y), (x + s, y), (x + s / 2, y + s * math.sqrt(3) / 2)
        ax.add_patch(Polygon([A, B, C], closed=True, facecolor="white", edgecolor=INK, lw=0.9, zorder=1))
        draw_tri(ax, t, A, B, C, lw=lw)

    # family of 3
    ax.add_patch(Rectangle((-0.2, 1.75), 3 * S + 2 * 0.25 + 0.4, hgt + 0.4, facecolor=AQUA_SOFT, edgecolor="none", zorder=0))
    for i, t in enumerate(sorted(groups[0], key=repr)):
        put(t, i * (S + 0.25), 1.95)
    ax.text(1.75, 1.55, "3 pictures:  two of the three parts cut", ha="center", va="top", fontsize=7.6)
    # family of 9
    x1 = 4.6
    ax.add_patch(Rectangle((x1 - 0.2, -0.2), 3 * S + 2 * 0.25 + 0.4, 3 * hgt + 2 * 0.22 + 0.4, facecolor="#f1f0ec",
                           edgecolor="none", zorder=0))
    for i, t in enumerate(sorted(groups[1], key=repr)):
        put(t, x1 + (i % 3) * (S + 0.25), (i // 3) * (hgt + 0.22))
    ax.text(x1 + 1.75, -0.4, "9 pictures:  a part cut,\nand a part of it cut again", ha="center", va="top", fontsize=7.6,
            linespacing=1.1)
    ax.text(1.75, 0.75, r"$12 = 3 + 9$", ha="center", va="center", fontsize=10.5)
    ax.text(1.75, 0.2, "Turn the inside of any cut triangle\nby a third of a turn: same family.", ha="center", va="center",
            fontsize=7.6, color=INK2, linespacing=1.1)
    # the perfect one with 4 inner points
    x2 = 9.6
    put(perfect, x2, 1.05, s=2.3, lw=0.9)
    ax.text(x2 + 1.15, 0.8, "4 inner points,\nall three parts cut:", ha="center", va="top", fontsize=7.6, linespacing=1.1)
    ax.text(x2 + 1.15, 0.05, "alone in its family", ha="center", va="top", fontsize=8.2)
    ax.text(x2 + 1.15, -0.4, r"$55 = 1 + 9 + 9 + 9 + 27$", ha="center", va="top", fontsize=8.6)
    ax.set_xlim(-0.5, x2 + 2.9)
    ax.set_ylim(-1.2, 3.35)
    save(fig, "fig_triangles")


# ------------------------------------------------------------------------------------------
# 14. a mobile and its photographs (p = 2)
# ------------------------------------------------------------------------------------------
def draw_mobile(ax, t, x0, y0, sx=1.0, sy=1.0):
    nodes, edges, width = layout(t)
    byp = {nd["path"]: nd for nd in nodes}
    for nd in nodes:
        X, Y = x0 + nd["x"] * sx, y0 + nd["y"] * sy
        if nd["kind"] == "leaf":
            ax.plot([X, X], [Y + 0.55 * sy, Y + 0.12 * sy], color=INK2, lw=0.7, zorder=1)
            ax.scatter([X], [Y], s=38, marker="o", color="#c9c8c1", edgecolors=INK2, linewidths=0.7, zorder=3)
            continue
        kids = [byp[nd["path"] + (i,)] for i in range(2)]
        xs = [x0 + k["x"] * sx for k in kids]
        yb = Y - 0.45 * sy
        ax.plot([X, X], [Y + (0.55 * sy if nd["path"] else 0.5 * sy), yb], color=INK2, lw=0.7, zorder=1)   # string
        ax.plot(xs, [yb, yb], color=INK, lw=1.6, solid_capstyle="round", zorder=2)                          # bar
        ax.scatter([X], [yb], s=30, marker="o" if nd["kind"] == "sym" else "s",
                   color=BLUE if nd["kind"] == "sym" else ORANGE, edgecolors="white", linewidths=0.7, zorder=4)
    return width * sx


def fig_mobile():
    o = ()
    c = (o, o)
    base = (c, (o, c))                              # 5 leaves, two lopsided bars
    assert d_of(base) == 2
    swap_root = lambda t: (t[1], t[0])
    swap_inner = lambda t: (t[0], (t[1][1], t[1][0]))
    photos = [base, swap_inner(base), swap_root(base), swap_root(swap_inner(base))]
    assert len({repr(t) for t in photos}) == 4 and len({key(t) for t in photos}) == 1
    all5 = [t for t in plane_trees(2, 4) if key(t) == key(base)]
    assert len(all5) == 4
    fig, ax = plt.subplots(figsize=(6.3, 2.5))
    clean(ax)
    x = 0.0
    for i, t in enumerate(photos):
        w = draw_mobile(ax, t, x, 0.0, sx=0.8, sy=1.0)
        ax.text(x + w / 2, -4.15, f"photograph {i + 1}", ha="center", va="top", fontsize=7.6, color=INK2)
        x += w + 1.3
    total = x - 1.3
    ax.text(total / 2, 1.2, "One mobile, four photographs", ha="center", va="center", fontsize=9.5, fontweight="bold")
    ax.scatter([total * 0.04], [-5.2], s=30, marker="s", color=ORANGE, edgecolors="white", linewidths=0.7)
    ax.text(total * 0.04 + 0.3, -5.2, "lopsided bar: spin it, new photograph", ha="left", va="center",
            fontsize=7.6, color=INK2)
    ax.scatter([total * 0.54], [-5.2], s=30, marker="o", color=BLUE, edgecolors="white", linewidths=0.7)
    ax.text(total * 0.54 + 0.3, -5.2, "balanced bar: spinning changes nothing", ha="left", va="center",
            fontsize=7.6, color=INK2)
    ax.text(total / 2, -6.1, r"2 lopsided bars, $2^2 = 4$ photographs.   A shape of tree is a mobile; an ordered tree is "
            "a photograph of it.", ha="center", va="center", fontsize=8)
    ax.set_xlim(-0.6, total + 0.6)
    ax.set_ylim(-6.6, 1.7)
    save(fig, "fig_mobile")


# ------------------------------------------------------------------------------------------
# 15. laser harmonics: two recipes for the fifth harmonic
# ------------------------------------------------------------------------------------------
def fig_laser():
    o = ()
    A = (complete(2), o)                           # 4 + 1
    B = (((o, o), o), (o, o))                      # 3 + 2
    assert (d_of(A), d_of(B)) == (1, 2) and n_leaves(A) == n_leaves(B) == 5
    nm = {1: "1064 nm", 2: "532 nm", 3: "355 nm", 4: "266 nm", 5: "213 nm"}
    for k, v in nm.items():
        assert abs(1064 / k - float(v.split()[0])) < 0.6
    fig, ax = plt.subplots(figsize=(6.3, 2.75))
    clean(ax)

    def panel(t, x0, title, sub):
        nodes, w = draw_tree(ax, t, x0=x0, y0=0.0, sx=1.25, sy=1.0, node_size=50, leaf_size=0, lw=1.0,
                             show_leaves=False)
        for nd in nodes:
            if nd["kind"] == "leaf":
                ax.scatter([nd["X"]], [nd["Y"]], s=34, marker="o", color="#c9c8c1", edgecolors=INK2, linewidths=0.7,
                           zorder=4)
                continue
            k = n_leaves(nd["obj"])
            left = nd["path"] != () and nd["path"][-1] == 0
            hx, ha = (-0.42, "right") if left else (0.42, "left")
            if nd["path"] == ():
                hx, ha = 0.42, "left"
            ax.text(nd["X"] + hx, nd["Y"] + 0.12, f"{k}$\\omega$  {nm[k]}", ha=ha, va="bottom", fontsize=7.2)
        ax.text(x0 + w / 2, 1.15, title, ha="center", va="bottom", fontsize=8.6, fontweight="bold")
        ax.text(x0 + w / 2, -3.75, sub, ha="center", va="top", fontsize=7.8)
        return w

    wA = panel(A, 0.0, "recipe 4 + 1", "one mixing step: the minimum")
    wB = panel(B, wA + 4.4, "recipe 3 + 2", "two mixing steps")
    xr = wA + 4.4 + wB + 3.3
    ax.scatter([xr], [0.4], s=34, marker="o", color="#c9c8c1", edgecolors=INK2, linewidths=0.7)
    ax.text(xr + 0.45, 0.4, "pump photon, 1064 nm", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.scatter([xr], [-0.25], s=44, marker="o", color=BLUE, edgecolors="white", linewidths=0.8)
    ax.text(xr + 0.45, -0.25, "doubling: equal photons fuse", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.scatter([xr], [-0.9], s=44, marker="s", color=ORANGE, edgecolors="white", linewidths=0.8)
    ax.text(xr + 0.45, -0.9, "mixing: different photons fuse", ha="left", va="center", fontsize=7.4, color=INK2)
    ax.text(xr - 0.1, -1.95, r"$5 = 101_2$: two ones, so one", ha="left", va="center", fontsize=8)
    ax.text(xr - 0.1, -2.45, "mixing step cannot be avoided.", ha="left", va="center", fontsize=8)
    ax.set_xlim(-1.6, xr + 7.0)
    ax.set_ylim(-4.4, 1.75)
    save(fig, "fig_laser")


if __name__ == "__main__":
    fig_quadtree()
    fig_triangles()
    fig_mobile()
    fig_laser()
    fig_dendrimer()
    fig_sand()
    fig_fusion()
    fig_pattern()
    fig_butyl()
    fig_levels()
    fig_carry_budget()
    fig_atoms()
    fig_balls()
    fig_bits()
    fig_dialects()
