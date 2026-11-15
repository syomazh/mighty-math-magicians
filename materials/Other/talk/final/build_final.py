# Build talk/final/final_slides.pdf: stitch the decks in the agreed order and stamp 'k / N' bottom right.
# Written by Claude Opus 5.5 (Claude Code), 2026-11-15. Run from the repo root: uv run python talk/final/build_final.py . talk/final/final_slides.pdf
import sys, io, subprocess, os, tempfile
from pypdf import PdfReader, PdfWriter, PageObject
from pypdf.generic import RectangleObject
from PIL import Image

root = sys.argv[1]; out = sys.argv[2]
parts = [("talk/final/title_slide.pdf", None),
         ("talk/final/ai_slides.pdf", None),
         ("talk/andrei_intro_slides.pdf", None),
         ("talk/josh_slides3.pdf", None),
         ("talk/slides_proof_second_half_misha_k2.pdf", None),
         ("syoma_slides/trees_as_molecules_short/trees_as_molecules_short.pdf", range(1, 7)),  # drop cover
         ("talk/andrei_outlook_slides.pdf", None),
         ("talk/final/thanks_slide.pdf", None)]
pages = []
for f, rng in parts:
    r = PdfReader(os.path.join(root, f))
    for i in (rng if rng is not None else range(len(r.pages))):
        pages.append((f, i, r.pages[i]))
N = len(pages)
tmp = tempfile.mkdtemp()
# build one-page overlays with LaTeX: patch in page colour + number, size = page size
tex = [r"\documentclass{article}\usepackage{tikz}\usepackage[scaled=0.92]{helvet}\pagestyle{empty}\begin{document}"]
for k, (f, i, p) in enumerate(pages, 1):
    w = float(p.mediabox.width); h = float(p.mediabox.height)
    # sample background colour near the corner from a render
    png = os.path.join(tmp, f"s{k}")
    subprocess.run(["pdftoppm", "-f", str(i+1), "-l", str(i+1), "-png", "-r", "40", os.path.join(root, f), png], check=True)
    im = Image.open([os.path.join(tmp, x) for x in os.listdir(tmp) if x.startswith(f"s{k}-")][0]).convert("RGB")
    W, H = im.size
    r_, g_, b_ = im.getpixel((W - 3, H - 3))
    s = w / 453.543  # scale relative to a beamer 16:9 page
    tex.append(r"\eject\pdfpagewidth=%.3fbp\pdfpageheight=%.3fbp" % (w, h))
    tex.append(r"\definecolor{bg}{RGB}{%d,%d,%d}" % (r_, g_, b_))
    tex.append(r"\noindent\begin{tikzpicture}[x=1bp,y=1bp,overlay,remember picture,shift={(current page.south west)}]"
               r"\fill[bg] (%.2f,%.2f) rectangle (%.2f,%.2f);"
               r"\node[anchor=south east,inner sep=0,text=black!55,font=\fontfamily{phv}\selectfont\fontsize{%.2f}{%.2f}\selectfont] at (%.2f,%.2f) {%d\,/\,%d};"
               r"\end{tikzpicture}" % (w - 62*s, 0, w, 26*s, 5.5*s, 6.5*s, w - 9*s, 5.5*s, k, N))
tex.append(r"\end{document}")
# position overlay from page origin
body = "\n".join(tex).replace(r"\noindent\begin{tikzpicture}", r"\vspace*{-1in}\vspace*{-\topmargin}\vspace*{-\headheight}\vspace*{-\headsep}\noindent\hspace*{-1in}\hspace*{-\oddsidemargin}\begin{tikzpicture}")
open(os.path.join(tmp, "ov.tex"), "w").write(body)
for _ in range(2): subprocess.run(["pdflatex", "-interaction=nonstopmode", "ov.tex"], cwd=tmp, stdout=subprocess.DEVNULL)
ov = PdfReader(os.path.join(tmp, "ov.pdf"))
print("overlay pages", len(ov.pages), "deck pages", N)
wr = PdfWriter()
for k, (f, i, p) in enumerate(pages):
    o = ov.pages[k + (len(ov.pages) - N)]
    np = wr.add_page(p)
    np.merge_page(o)
wr.write(out)
print(tmp)
