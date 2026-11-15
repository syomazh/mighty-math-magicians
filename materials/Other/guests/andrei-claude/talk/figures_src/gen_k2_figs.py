# Written by Claude Fable 5.2 (claude-fable-5-2), 2026-11-15. Not human-reviewed.
# TikZ for the k = 2 versions of the figures on the slides "Step 5", "Step 7" and "Step 7, continued".
def save(name, lines): open(name, 'w').write("\n".join(lines) + "\n")

# ---------------- Step 5: minimal tree for q = 9, n = 2 (m = 17) and its skeleton ----------------
o = []
L = 1.0
for d in range(5):
    o.append(f"\\node[font=\\large, text=black!60] at (-0.55,{-d*L:.2f}) {{${d}$}};")
o.append("\\node[font=\\large, text=black!60] at (-0.45,0.68) {depth};")
for d in (2, 4):
    o.append(f"\\draw[black!20, line width=0.5pt, dash pattern=on 2pt off 2pt] (-0.25,{-d*L:.2f}) -- (9.35,{-d*L:.2f});")
# atoms
o += ["\\draw[cbox, fill=coralfill!40] (0.25,-2.30) rectangle (1.75,-0.70);",
      "\\draw[cbox, fill=coralfill!40] (2.15,-2.30) rectangle (3.65,-0.70);",
      "\\draw[cbox, fill=coralfill!40] (4.62,-2.27) rectangle (5.16,-1.73);",
      "\\draw[cbox, fill=coralfill!40] (5.26,-2.27) rectangle (5.80,-1.73);",
      "\\draw[cbox, fill=coralfill!40] (5.95,-4.30) rectangle (9.25,-1.70);"]
R = (3.6, 0.0); c1 = (1.0, -1.0); c2 = (2.9, -1.0); v = (6.2, -1.0); w = (7.6, -2.0)
E = lambda a, b: o.append(f"\\draw[edge] ({a[0]:.2f},{a[1]:.2f}) -- ({b[0]:.2f},{b[1]:.2f});")
leaves = []
for c in (c1, c2, v): E(R, c)
for c in (c1, c2):
    for dx in (-0.45, 0, 0.45):
        E(c, (c[0]+dx, -2.0)); leaves.append((c[0]+dx, -2.0))
for x in (4.89, 5.53):
    E(v, (x, -2.0)); leaves.append((x, -2.0))
E(v, w)
mids = [(6.5, -3.0), (7.6, -3.0), (8.7, -3.0)]
for mnode in mids:
    E(w, mnode)
    for dx in (-0.33, 0, 0.33):
        E(mnode, (mnode[0]+dx, -4.0)); leaves.append((mnode[0]+dx, -4.0))
for g in [c1, c2, w] + mids: o.append(f"\\node[gnode] at ({g[0]:.2f},{g[1]:.2f}) {{}};")
for pn in (R, v): o.append(f"\\node[pnode] at ({pn[0]:.2f},{pn[1]:.2f}) {{}};")
for l in leaves: o.append(f"\\node[leafsq] at ({l[0]:.2f},{l[1]:.2f}) {{}};")
assert len(leaves) == 17
o.append("\\node[font=\\large] at (4.5,-5.05) {minimal tree, $17$ leaves, $d=t=2$};")
# arrow and skeleton
o.append("\\draw[act] (9.75,-2.0) -- (10.95,-2.0);")
sr = (13.2, -0.5); sv = (14.5, -1.9)
for d, y in ((1, -1.9), (2, -3.3)):
    o.append(f"\\draw[black!20, line width=0.5pt, dash pattern=on 2pt off 2pt] (11.3,{y:.2f}) -- (16.15,{y:.2f});")
    o.append(f"\\node[font=\\large, text=black!60, anchor=west] at (16.2,{y:.2f}) {{depth ${d}$}};")
for x in (11.9, 13.2): E(sr, (x, -1.9))
E(sr, sv)
for x in (13.6, 14.5, 15.4): E(sv, (x, -3.3))
o.append("\\node[clab, font=\\large, minimum width=0.66cm, minimum height=0.58cm] at (11.90,-1.90) {$1$};"); o.append("\\node[clab, font=\\large, minimum width=0.66cm, minimum height=0.58cm] at (13.20,-1.90) {$1$};")
o.append("\\node[clab, font=\\large, minimum width=0.66cm, minimum height=0.58cm] at (13.60,-3.30) {$0$};"); o.append("\\node[clab, font=\\large, minimum width=0.66cm, minimum height=0.58cm] at (14.50,-3.30) {$0$};"); o.append("\\node[clab, font=\\large, minimum width=0.66cm, minimum height=0.58cm] at (15.40,-3.30) {$2$};")
o.append(f"\\node[pnode] at ({sr[0]:.2f},{sr[1]:.2f}) {{}}; \\node[pnode] at ({sv[0]:.2f},{sv[1]:.2f}) {{}};")
o.append("\\node[font=\\large] at (14.0,-5.05) {collapsed: $5$ leaves, $2$ nodes};")
save("fig_k2_step5.tex", o)

# ---------------- helpers for labelled trees of T(6,1) and T(3,2) ----------------
LW = [0.75]
def lab(o, x, y, style, text): o.append(f"\\node[{style}, minimum width={LW[0]}cm] at ({x:.2f},{y:.2f}) {{${text}$}};")
STY = {'x': 'cyc', 'y': 'czero', 'u': 'cone', 'z': 'cone'}
def name(l): return f"{l[0]}_{l[1]}" if len(l) > 1 else l
def tree(o, cx, y0, kids, sp=0.80, off=(-2.10, -0.35, 2.10)):
    """root at (cx, y0); kids = list of 3 items, each a label (leaf at depth 1) or a tuple of 3 labels (cherry at depth 2)."""
    o.append(f"\\fill ({cx:.2f},{y0:.2f}) circle (2.2pt);")
    for kid, dx in zip(kids, off):
        x = cx + dx
        if isinstance(kid, tuple):
            o.append(f"\\draw[edge] ({cx:.2f},{y0:.2f}) -- ({x:.2f},{y0-1.10:.2f});")
            o.append(f"\\fill ({x:.2f},{y0-1.10:.2f}) circle (2.2pt);")
            for l, d in zip(kid, (-sp, 0, sp)):
                o.append(f"\\draw[edge] ({x:.2f},{y0-1.10:.2f}) -- ({x+d:.2f},{y0-1.98:.2f});")
                lab(o, x+d, y0-2.20, STY[l[0]], name(l))
        else:
            o.append(f"\\draw[edge] ({cx:.2f},{y0:.2f}) -- ({x:.2f},{y0-0.88:.2f});")
            lab(o, x, y0-1.10, STY[kid[0]], name(kid))

# ---------------- Step 7: an orbit of size 3 in T(6,1) ----------------
o = []
cxs = [2.5, 8.6, 14.7]
A = [('x1','y1','y2'), ('x2','y1','y2'), ('x3','y1','y2')]
B = [('x2','x3','y3'), ('x3','x1','y3'), ('x1','x2','y3')]
for cx, a, b in zip(cxs, A, B): tree(o, cx, 0.0, ['u', a, b])
o.append(f"\\draw[act] ({cxs[0]+0.45:.2f},0.0) -- node[above]{{$\\sigma$}} ({cxs[1]-0.45:.2f},0.0);")
o.append(f"\\draw[act] ({cxs[1]+0.45:.2f},0.0) -- node[above]{{$\\sigma$}} ({cxs[2]-0.45:.2f},0.0);")
o.append(f"\\draw[act] ({cxs[2]:.2f},0.35) .. controls ({cxs[2]-1.0:.2f},1.25) and ({cxs[0]+1.0:.2f},1.25) .. node[above]{{$\\sigma$}} ({cxs[0]:.2f},0.35);")
save("fig_k2_orbit.tex", o)

# ---------------- Step 7, continued: fixed trees of T(6,1) collapse onto T(3,2) ----------------
o = []
sp, off = 0.70, (-1.75, -0.25, 1.90)
LW[0] = 0.62
X1, X2, Y = ('x1','x2','x3'), ('x1','x3','x2'), ('y1','y2','y3')
rows = [(0.0, [['u', X1, Y], ['u', X2, Y]], ['u', 'z', Y]), (-3.55, [['u', Y, X1], ['u', Y, X2]], ['u', Y, 'z'])]
for y0, pair, res in rows:
    for cx, kids in zip((2.1, 7.3), pair): tree(o, cx, y0, kids, sp=sp, off=off)
    o.append(f"\\draw[brace] (10.25,{y0+0.25:.2f}) -- (10.45,{y0+0.25:.2f}) -- (10.45,{y0-2.55:.2f}) -- (10.25,{y0-2.55:.2f});")
    o.append(f"\\draw[act] (10.45,{y0-1.15:.2f}) -- node[above]{{\\small collapse}} (12.05,{y0-1.15:.2f});")
    tree(o, 14.35, y0, res, sp=sp, off=off)
o.append("\\node[anchor=north west, draw=black!40, rounded corners=3pt, inner sep=3pt, font=\\normalsize] at (-0.35,0.95) {$p=3,\\ k=2$};")
save("fig_k2_fixed.tex", o)
print("ok")
