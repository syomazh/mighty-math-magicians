# W011b — Finish the study guide and the Q&A sheet

A previous worker was carrying out `briefs/W011_qa_and_study_guide.md`. It wrote `notes/study_guide_check.py` (about 17 KB) and then stopped before writing either document. Neither `notes/study_guide.md` nor `talk/QA.md` exists. The check script also takes more than two minutes to run, which is too slow.

Finish that brief. Read `briefs/W011_qa_and_study_guide.md` in full first; all its requirements apply. In addition:

1. Make `notes/study_guide_check.py` finish in under 30 seconds: restrict labelled-tree enumerations to the small cases the exercises actually use (for example a = (3) and (4) with p = 2; a = (5) with p = 3; a = (2,1) with p = 2, k = 2). Run it and keep its output for the numbers in the guide.
2. Write `notes/study_guide.md` and `talk/QA.md` as specified. **Do not end your turn until both files exist and are complete.** Write each file in sections and save after every section.
3. Use the corrected arguments from `paper/reviews/ADJUDICATION_round1.md` items A2 (why permuting equal atoms acts freely) and A4/A5 (why the carries end at a single leaf); do not repeat the flawed versions.
4. You may also read `notes/2026-11-13_new_ideas.md` and add to the Q&A sheet a short final group "Other ways to see it" (the accounting view, sand on a ring, the chemistry and biology readings), each answer marked "(idea, not yet verified)".

Touch only `notes/study_guide.md`, `notes/study_guide_check.py` and `talk/QA.md`.
