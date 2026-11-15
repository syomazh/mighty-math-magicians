# W059 — Check the report's bibliography and attributions against the project's reference list

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 about 08:10. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". You only read; your final answer is the list of findings. **Time limit: 25 minutes.**

## Why

The project's rule is: no bibliographic data from memory; every reference comes from `references/README.md`, where each entry was checked against its source. The report `report/report.tex` is scored today on Attribution among other things. A wrong year, a wrong theorem number or a citation that is in no reference list would cost us. Find every such place.

## What to read

- `references/README.md`: the checked reference list (the authority).
- `report/report.tex`: the bibliography (search `\begin{thebibliography}`) and every place in the text that cites or attributes (search `\cite`, and the names of authors that appear in `references/README.md`, and phrases like "Theorem", "Remark", "Lemma" followed by a number together with a name).

## What to do

1. For every `\bibitem` of the report: find the entry in `references/README.md`. Compare authors (spelling, order), title, journal or venue, volume, year, pages, arXiv number or DOI. List every difference, however small, quoting both versions with the line number in the report. If there is no entry in `references/README.md`, say so.
2. For every entry of `references/README.md` that the report's text relies on but that has no `\bibitem`: list it.
3. For every `\cite` key without a `\bibitem`, and every `\bibitem` never cited: list it.
4. For every attribution in the body of the report that names a specific theorem, lemma, remark, section or page of a source (for example "Konvalinka's Remark 3", "Lemmas 8 to 10"): list it with its line number, and say whether `references/README.md` records that item of that source (quote the sentence of the README) or not. Do not judge from memory whether the attribution is right; only whether our own record supports it.
5. Any sentence of the report that says something is "new", "ours", "first" or "not in the literature": list it with its line number and quote it, without judging.

## Form of the answer

Five numbered lists as above; each finding with the line number in `report/report.tex`, the quotation, and what differs. Then one paragraph: what you did not check. If a list is empty, say that you checked and found nothing. Do not edit any file.
