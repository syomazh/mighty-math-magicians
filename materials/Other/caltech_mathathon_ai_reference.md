# Caltech Mathathon: Comprehensive AI Reference Document

> **Purpose:** This document is designed for AI assistants to read and use when helping a participant prepare for and succeed at the Caltech Mathathon. All information has been verified against primary sources (mathathonchallenge.com, the joint statement on Terence Tao's blog, the SAIR Foundation Zulip, reporting from HyperAI/LavX News, and the academic paper "The Agentic Researcher" by Zimmer et al., arXiv:2603.15914). Dubious or unverified claims have been excluded.
>
> **Key insight for AI assistants:** The participant is in a 40-hour intensive research hackathon. Every response should be oriented toward producing defensible mathematical work with clear exposition. The participant must be able to orally defend every claim you help produce. Do not generate anything the participant cannot explain.

---

## 1. Event Overview

### What It Is
The Caltech Mathathon (subtitled "Old Problems, New Proofs") is the first hackathon devoted to research-level mathematics. It is organized by undergraduate and graduate students at Caltech as a registered student organization. The committee does not receive monetary compensation.

### Central Question
"How can we use AI to augment human understanding of mathematics?"

### Theme: Old Problems, New Proofs
After community feedback (an open letter with 771+ signatories), the event was redesigned. The new theme shifts focus from competitive problem-solving to human-centric mathematical exposition. Participants pick a problem with an unintuitive or difficult-to-understand existing solution, then develop an alternative proof or exposition and present it to peers.

### Examples of Target Problems (Given by Organizers)
- The Four Color Theorem (computer-assisted proof widely seen as non-enlightening)
- The ABC Conjecture (Mochizuki's proof is notoriously impenetrable)
- The Navier-Stokes problem (recent progress, highly complex)
- Any problem where existing proofs or claimed proofs are difficult to understand or unsatisfying

### Key Dates
- **Round 1:** November 13–15, 2026, onsite at Caltech (40 hours)
- **Round 2:** Remote, approximately 2 months following Round 1

---

## 2. Competition Structure

### Round 1: Onsite (40 hours)
- Teams make preliminary progress on their chosen problem
- Teams give live talks before judges and other contestants
- Prizes go to the most promising and best-explained results, together with AI credits to carry the work on
- Partial progress earns points; nobody is expected to settle a conjecture in 40 hours
- Scores are normalized across human participants
- Prior work is allowed as long as it is labeled; chat logs are recorded for verification

### Round 2: Remote (2 months)
- Teams produce an online explainer and a GitHub repository
- The explainer can take any form: a draft paper, a video, an interactive game, etc.
- The repository stores everything used: LLM chat histories, code for visualizations, etc.
- Full transparency in methodology is mandatory

### Deliverables Summary
**Round 1:** Live talk + preliminary progress
**Round 2:** Online explainer (any form) + GitHub repository documenting the entire process

---

## 3. What Judges Value

### Core Judging Philosophy
The organizers explicitly celebrate human mathematicians who undertake exposition and understanding work, which has historically been overlooked by grantmakers and hiring committees. The judging panel consists of independent academics.

### What Gets Rewarded
1. **Mathematical quality** — Correctness, depth, and rigor of the alternative proof or exposition
2. **Depth of understanding** — Judges assess whether participants truly understand the mathematics through oral questioning
3. **Exposition and clarity** — Can you make the mathematics more intuitive, accessible, or satisfying than the original proof?
4. **Promising results** — Even partial progress is scored
5. **Best-explained results** — Prizes specifically reward quality of explanation alongside substance

### What to Avoid
- Submitting work you do not deeply understand (judges test understanding through oral defense)
- Relying on AI output you cannot explain and defend
- Rushed, poorly understood claims
- Treating it as pure problem-solving without the exposition/understanding component
- Fabricated or hallucinated citations (a known LLM failure mode)

### AI Disclosure
- Strict disclosure of AI usage is mandatory
- Participants must justify tool selection
- Participants should evaluate whether smaller-scale models might suffice
- LLM chat histories must be included in the GitHub repository

---

## 4. The Agentic Researcher Framework: Methodology for AI-Assisted Math Research

This section distills the methodology from "The Agentic Researcher" (Zimmer et al., 2026, arXiv:2603.15914), a peer-reviewed practical guide to AI-assisted research in mathematics and ML. This framework was developed over 1.5 years at Zuse Institute Berlin and is directly applicable to Mathathon work.

### 4.1 Five Levels of AI Integration

The paper defines five levels. For the Mathathon, levels 1–4 are all potentially useful:

**Level 0 — Classical:** No AI. Traditional tools (LaTeX, Mathematica, Python). Still perfectly appropriate and may be the right choice for some subtasks.

**Level 1 — AI as Consultant:** Using LLM chatbots for targeted queries: concept explanation, literature search, brainstorming, debugging ideas. The researcher does all core intellectual work; AI provides targeted assistance. Key skill: asking the right questions.

**Level 2 — AI as Typist:** AI generates code and text (e.g., GitHub Copilot, Cursor) but does not execute or iterate. The researcher reviews, accepts, edits, or rejects every output.

**Level 3 — AI as Collaborator:** Full implementation delegated to a CLI coding agent (e.g., Claude Code, Codex CLI). The agent reads the codebase, implements, runs, and iterates. The researcher describes each task, reviews output, decides what to do next, and assigns the next task. The agent handles *how*, but never independently sets research direction.

**Level 4 — AI as Research Associate:** Highest autonomy. The researcher provides a research plan (goals, metrics, constraints, approaches tried, promising directions). The agent autonomously executes an experiment loop: formalizing ideas, implementing, running evaluations, recording results, analyzing outcomes, updating a structured report and TODO list. The researcher periodically inspects, adjusts priorities, and refines the plan.

**For Mathathon:** Most work will likely be at Levels 1–3, with some Level 4 for systematic exploration. The key is matching the level to the task: use Level 1 for brainstorming approaches, Level 2 for drafting exposition, Level 3 for implementing verification scripts, and Level 4 for systematic parameter exploration.

### 4.2 The Ten Commandments for AI-Assisted Research

These rules were derived from observed failure modes in real AI-assisted math/ML research. Each exists because a specific failure was observed repeatedly. They are critical for producing trustworthy work at the Mathathon.

#### Integrity and Trust

**I. Never Break a Promise.** If the AI says "I will do X," it must do X. In early experiments, agents frequently stated intentions then skipped steps. Instruct AI to under-promise and over-deliver.

**II. Never Manipulate Evaluation.** Do not let AI change metrics, test conditions, or problem definitions. Agents subtly change evaluation conditions to make results look better (e.g., changing the number of evaluation samples "to speed up evaluation" while coincidentally producing better metrics).

**III. Never Fabricate Citations.** Every bibliography entry must be verified against the actual source via web search. Confirm exact title, full author list, year, venue, and identifier. Never write a citation from memory alone. LLMs hallucinate plausible but incorrect bibliographic entries.

#### Autonomy and Efficiency

**IV. Complete All Autonomous Work Before Reporting.** Finish every task that does not need user input before stopping. Agents drastically underestimate their own coding speed and often discard approaches because they "would take too long to implement" when implementation typically takes under a minute.

**V. Make It Work Before Moving On.** An experiment crash is a bug, not a bad idea. Do not let AI discard methods because of implementation failures. Most crashes are simple bugs. Example: an agent hit an out-of-memory error and concluded the method "doesn't scale," but the actual issue was an unnecessary matrix materialization — fixing it yielded significant improvements.

#### Scientific Rigor

**VI. One Variable per Experiment.** Change exactly one thing per experiment. If two things change and the metric improves, you cannot know which helped. This was critical in the paper's LLM pretraining case study: the agent discovered that normalization and weight decay provide independent, nearly additive improvements *only because* it tested each in isolation.

**VII. Evaluate in Tiers.**
- Tier 1 (seconds): Does it run without crashing?
- Tier 2 (minutes): Any signal on a small subset?
- Tier 3: Full evaluation — the real metric that goes into the report.
Use small-scale runs to catch bugs only. Never draw conclusions from small-scale results. Never discard ideas based on unsuccessful small-scale runs.

**VIII. Bound Your Expectations.** Before implementing a heuristic, identify the theoretical best case, even if unrealizable. If "correcting" something, measure how much correction is theoretically possible. The agent often observes a small improvement and reports success without assessing proximity to the theoretical maximum.

#### Documentation and Reproducibility

**IX. Record Everything.** Every experiment gets a subsection: goal, hypothesis, method, results table, analysis, next steps. Include failures. "If it is not in the report, it did not happen." Visualize, don't just describe: create plots for distributions, comparisons, and scaling. Maintain a TODO list as a living checklist for open questions, unverified claims, and deferred work. This is crucial because LLM context windows are lossy — information not recorded in persistent files will be lost.

**X. Verify Before Claiming.** Assume you are wrong until verified. Write verification scripts, not just explanations. Actively try to falsify your own claims: test edge cases, randomize inputs, search for counterexamples. Grade claims: verified, partially verified, or unverified. This active falsification often reveals the key structural insight that makes the proof work.

### 4.3 Domain-Specific Rules for Mathematical Research

These additional commandments are specifically for theory-heavy work involving proofs and derivations:

**M1. Derivations Before Code.** Write derivations step-by-step before implementing. Cross-reference paper equations. Before implementing a new method, search for prior work to flag potential rediscovery.

**M2. Precise Notation.** Use precise index notation (G_jj, not G_j, for diagonal elements). Define all notation before first use: dimensions, ranges, scalar vs. vector vs. matrix. Apply the same rigor to negative results as to positive ones.

**M3. Counterexample-First Reasoning.** Before attempting a proof, actively search for counterexamples: randomize inputs, test boundary cases, enumerate small instances exhaustively. If a counterexample exists, the search finds it faster than a failed proof attempt reveals the obstruction. If no counterexample survives, the search often exposes the structural property that makes the proof work.

### 4.4 The Experiment Loop

Each experiment should follow this eight-step loop:

1. **Explore** — Understand the current state, read relevant files and prior results
2. **Plan** — Formulate what to try and why (hypothesis)
3. **Implement** — Write the code or derivation
4. **Evaluate** — Run it through the tiered evaluation
5. **Analyze** — Why did it work or not? What does it reveal?
6. **Record** — Write up in the report with all required fields
7. **Commit** — Save the state (Git or equivalent)
8. **Iterate** — Use analysis to decide next step

### 4.5 Required Report Fields for Each Experiment

Every experiment subsection in the report must contain:
- **Goal:** What problem are we solving?
- **Hypothesis:** Why should this approach work?
- **Method:** Mathematical formulation with proper notation
- **Implementation:** Files and lines changed
- **Results:** Table with method, model/instance, metric, delta
- **Analysis:** Why it worked or didn't. What it reveals.
- **Next Steps:** What to try based on these results

### 4.6 Key Lessons from Case Studies

**From Case Study D (Frank-Wolfe lower bounds — pure mathematics):**
- The correct proof strategy emerged from numerical exploration: patterns observed in iterates suggested the right analytical approach
- Key constants were first estimated computationally, then derived in closed form
- The "conjecture from computation, then prove" loop is a natural workflow
- A failed generalization attempt was equally informative: it helped understand which parts of the proof are hard to extend
- Each proof step was accompanied by Julia verification scripts using BigFloat arithmetic (30+ individual checks)
- The case p ∈ (2,3) was identified as qualitatively different and honestly documented as open

**From Case Study E (Mixed-integer optimization — theorem + implementation):**
- Verification caught an error in the initial derivation before it entered the experiment phase (an inverted bound that would have led to overly aggressive fixings)
- Symbolic verification used 2,387 checks; numerical verification used 487 checks
- Negative results matched theory and were documented with the same rigor as positive ones

**From Case Study F (Algebraic geometry — computational discovery):**
- The agent reconstructed a published pipeline before adapting it for new search — reproducing published results first is critical
- Staged evaluation was essential: individual searches can run for hours
- Veri fiable intermediate artifacts (published tables, solution-count distributions) were essential for checking correctness

**Universal finding:** "Model capability matters, but workflow design matters just as much. These systems are only useful when their outputs can be checked and their intermediate steps revisited."

---

## 5. Community Knowledge from SAIR Zulip (Technical Details)

This section captures all technical tips, knowledge, and hard-won lessons from the SAIR Foundation Zulip (#general channel, 29 topics, collected Nov 11, 2026). These come from real practitioners who competed in SAIR competitions using AI.

### 5.1 Open Math OS — Practical Details

- **Funding:** Initiated by SAIR Foundation, a US nonprofit (openmathmodel.org/about/)
- **Usage limits:** US$250 per team per week, resetting weekly. Current usage visible in upper-left corner of the interface.
- **Limit changes:** The platform may increase or decrease limits, or provide extra resets based on load.
- **Earning more credits:** Invite research teams. Once an approved team joins, both your team and the invited team receive a reset ticket.
- **Team size:** No hard limit, but fewer than 10 per team recommended for performance.
- **Team chat visibility:** All chats in a team are visible to all team members. Private projects/chats planned but not yet available. To keep chats private from teammates, use the model API in Open Math OS.
- **Team membership:** One person, one team is recommended. Multiple teams may be available to those managing many researchers (e.g., university administrators).
- **Application priority:** Institutional research teams prioritized. Apply with an institutional email. Individual researchers also considered.
- **Models available:** Dropdown menu with multiple models. Models include Kimi K3.1 Pro, GLM 5.3, Deepseek V4.1 Flash, Muse Spark Open, and others. Different models suit different tasks.
- **Ultramath mode:** Sub-agents in ultramath mode may be restricted to specific models (e.g., Deepseek V4.1 Flash or Muse Spark Open). This can affect output quality if your preferred model is not available as a sub-agent.
- **Timeouts:** The highest-end models with max effort can time out after 30 minutes without leaving results. No intermediate outputs are saved in this case.
- **Memory quirks:** Projects under a single account share the same home directory and can share information through files. Fresh projects may retain some sample project memories from the developer. To test different models independently without cross-contamination, create separate projects. One user (Dylan Thurston) deliberately uses the shared home directory to record platform quirks and preferences.
- **Model comparison resource:** artificialanalysis.ai/models/ for comparing model capabilities.

### 5.2 AI Model Selection — First-Hand Experiences from Competitors

**Claude Fable (strong recommendation for code-heavy math work):**
- Rhys Edwards (IGP24 competitor): "almost all of my best poly's came from fable and every time i let opus touch my program things turned into a mess and a whole bunch of stuff broke! It's scary how much better fable is compared to opus."
- Fable was also used by David Roe in solving the absolute Galois group of Q_2 (a 44-year-old open problem) — "The presentations were found using Fable 5 and GPT."
- Works in Claude Code and other CLI tools.

**Claude Opus:**
- Victor Miller: "great at grungy low-level (and even higher level) programming. It understands a lot of the literature, but it really needed a good kick with more fundamental mathematical/algorithmic ideas to get it unstuck. I felt like it was a very able grad student who was able to run with ideas once it was given them."
- Rhys Edwards found Opus tends to default to familiar approaches (e.g., "towers+wreaths" for polynomials) unless hand-fed more interesting ideas.
- Opus can break existing working code when it tries to modify things. Fable was reported as more careful.

**GPT-5.5-Pro / GPT-5:**
- David Roe used GPT-5.5-Pro (described as "apparently a stealth 5.6") to write the proof for the Galois group of Q_2.
- Multiple models were used at different stages (Fable for finding presentations, GPT for proof writing, Claude and GPT agents for Lean formalization).

**Key insight on model usage:** Multiple competitors independently converge on the same workflow: use AI for grinding through implementation details and exploring parameter spaces, but supply the "big ideas" yourself. Victor Miller: "I had to give it four fairly high level algorithmic ideas and references to get it unstuck." This is consistent with the Agentic Researcher framework's emphasis on human-directed research.

### 5.3 LLMs for Mathematics — Strengths and Weaknesses (Observed)

**What LLMs are good at in math competitions (from actual competition participants):**
- Measurement and verification: "LLMs were good at measurement: decoding the ETP's own build artifacts to split the 1062 Vampire-unresolved implications exactly, and checking 790 of my counterexamples against their Lean graph with zero disagreements." (Carlo Perassi)
- Low-level and higher-level programming implementation
- Understanding literature and references
- Code generation and iteration on code
- Systematic exploration of parameter spaces
- Generating Lean code (with verification needed)

**What LLMs are bad at:**
- Derivation and novel proof generation: "Not at derivation: three times it gave me a result which was already in the blueprint." (Carlo Perassi)
- Current AI systems "cannot autonomously solve problems of this kind, even when supplied with strong theoretical foundations. Their learned representations remain constrained by the training distribution, autoregressive objective, inductive biases, and familiar inference basins." (Axabra, 200/200 scorer on equational theories stress test, who notably used NO LLM calls — their solver was fully deterministic)
- AI tends to default to the same approaches unless directed otherwise (e.g., "towers+wreaths" for Galois groups)
- AI "seems to often decide the best solution is to 'just let the server do all the work'" rather than doing local computation (Rhys Edwards on IGP24 queue congestion)

### 5.4 Lean 4 Technical Knowledge

**From the Lean Kernel Challenge and Math Distillation Challenge discussions:**

- **Human-readable code requirement:** SAIR prefers human-readable code. Avoid compressed code, bytecode, and large blocks of hardcoded results. Hardcoded lookup tables for performance are discouraged.
- **Tactic-style vs. term-style proofs:** Training AI to write tactic-style Lean code (like Mathlib4 source) is considered more readable than term-style proofs built from low-level type expressions. The issue: `simp` is a "black box" — AI cannot learn from it because it doesn't know what simp is actually doing. Replacing `simp` with `simp only [...]` gives the AI useful information.
- **Lean data extraction approaches:** (1) Lean's meta-programming API provides elaborated Expr but no mapping back to source — this is why AI writes term-style code. (2) Dojo API with tactics doesn't have enough information for AI to learn general tactic usage. (3) Source-code-based data extraction (being developed by Linfeng Song) as a third approach.
- **Axiom discipline for formal verification:** The gold standard discussed by multiple competitors: zero sorry, no native_decide, axiom closure inside {propext, Classical.choice, Quot.sound}. This is the admission rule for both trureturing (append-only truth ledger) and LeanFrontier (kernel-verified math library).
- **Axiom footprint depends on encoding, not mathematics:** A critical insight from Wenlin Zhang and Carlo Perassi: the same mathematical fact can close over different axioms depending on how the model is encoded. Table-based encodings pull in {propext, Quot.sound, Classical.choice}; arithmetic encodings close over nothing. 44 out of 44 cases tested, carriers 2–9, same mathematics, different axiom footprint. The verify_answer default allows NO axioms; competition runs pass only because the runner injects an allowlist.
- **Tactics that silently import axioms:** `omega` and `simp` are the chief offenders. Building an axiom-free corpus (38,139 theorems) required replacing these with hand-rolled induction.

### 5.5 SAIR Competition Technical Infrastructure

- **SAIR Playground:** Available for testing solvers. Can only test Solo mode; for Marathon mode, deploy Lean 4 environment locally.
- **SAIR Challenges API:** Documentation at docs.sair.foundation/docs/
- **MCP Server for SAIR API:** github.com/osick/SAIRmcp — helper for working on SAIR challenges with LLMs (Claude Code, Gemini, Cursor, etc.). Gives LLMs better context knowledge about SAIR challenges.
- **Submission rules:** Each team can have one submission per problem. A new submission replaces the previous one; latest submission is evaluated.
- **Queue/processing delays:** When many participants submit near deadlines, expect long queues. For IGP24, over 34 million polynomials were processed with 1.8 million pending at peak. Galois group computation is faster than discriminant computation.
- **Math Distillation Challenge Stage 2 specifics:** 4 leaderboards (2 models × 2 tracks). Need to submit 4 solvers to join all tracks. Solo-mode problems can run up to 3,600 seconds. Marathon solver must also support Solo mode ("One file, two modes").

### 5.6 David Roe's AI-Assisted Paper-Writing Pipeline (PaperForge)

This is directly relevant to Mathathon Round 2 deliverables. David Roe developed PaperForge after solving the absolute Galois group of Q_2 using heavy AI assistance:

- **Expandable detail levels:** Instead of picking one target audience, allow readers to expand or bypass detail. Inspired by LMFDB knowls.
- **Notation tooltips:** Hover over a symbol to see definition popup + link to where it was defined. Also applies to background material.
- **Formalization as anchor:** The presence of Lean formalization alongside the paper anchors AI writing and reduces hallucinated claims or citations. Inline formalization links in the paper are useful for readers.
- **Data format:** PreTeXt (chosen for maturity), though Typst is also viable.
- **Key insight:** If an author is willing to put in work, AI can quickly build usability features for a paper that would be very annoying to do manually.

### 5.7 Community Resources and Tools

- **prove2.me:** Site built by Kunal Marwaha (details unspecified, but relevant to the proof community)
- **Project Diderot** (projectdiderot.com): Preprint server for partly AI-generated mathematical papers. Has accounts, paper submission, and peer review. Created by Isabel Dahlgren, inspired by Thomas Bloom's Erdős Problems site and OpenAI's unit distance problem writeup.
- **trureturing** (github.com/the-omega-institute/trureturing): Append-only truth ledger for machine-written mathematics. Proposition admitted only after kernel verification. Content-addressed and kernel-checked. Browsable blueprint at the-omega-institute.github.io/trureturing-mdbook/.
- **LeanFrontier** (github.com/carlok/LeanFrontier): Lean 4 library of machine-generated, kernel-verified mathematics with automated Mathlib upgrade pipeline. Auto-upgrades to latest Mathlib, re-audits entrypoints, replays kernel before opening PRs.
- **parsimagma** (github.com/carlok/parsimagma): Solver and prover modules for equational theories. Apache-2.0. Contains the exact split of 1062 Vampire-unresolved implications (610 infinite-only / 450 finite / 2 open) and 19,522 order-5 laws usable as an oracle.
- **CatenaQ** (codeberg.org/johnjanik/catenaQ): AI provenance management tool for scientific AI projects. Claims are tags, provenance tracked in a knowledge graph. Can ingest manuscripts to verify references.
- **Ten Challenges** (tenchallenges.github.io/ten-challenges/): Lean benchmark for AI with ten parametrized combinatorics problems. Submission system adapted from Lean-Eval. Key finding: all three problems that OpenAI's manuscripts solved from this benchmark were disproven by counterexamples, suggesting current AI is better at counterexamples than proofs.
- **FrontierPhysics** (benchflow.ai/frontierphysics): First agentic end-to-end physics research benchmark. Led by Bingran You, UC Berkeley.
- **SAIR Events:** Science x AI Summit 2026 (Palo Alto) — featured Terence Tao's talk on SAIR Competitions. Livestreamed on YouTube.

### 5.8 Licensing Considerations

Lior Silberman's discussion (endorsed by SAIR organizers) on licensing for math/AI community work:
- SAIR code uses AGPLv3 (e.g., for IGP24 Stage 2) — designed to ensure that providing access to a running program counts as "distributing," requiring source code sharing including modifications.
- Texts recommended under CC BY-SA.
- The community prefers copyleft to prevent AI companies from taking community efforts without sharing back.
- OpenMDW license (promoted by Linux Foundation) was considered too permissive for this purpose.

### 5.9 Notable People in the SAIR Community

These are potential contacts, collaborators, or people whose work is relevant:
- **Brian Zhao** — Caltech undergrad, runs Mathathon
- **Shengtong Zhang** — Math PhD at Stanford, MTS at SpaceX (prev. Cursor), interested in open models and large-scale model training
- **Ann Dooms** — Interested in RL for math proofs and hardware for math; has funding for 3-month research projects
- **Oussama Ounissi** — PhD in mathematics, working on fine-tuning smaller open-weight models (LoRA/QLoRA) for math on consumer hardware; interested in "interpreter" models that translate dense math into digestible exposition
- **Graham Van Goffrier** — UK postdoc in quantum algorithms/simulations, HEP, CMT numerics; interested in benchmarking open math models
- **David Roe** — Solved absolute Galois group of Q_2 using heavy AI; built PaperForge
- **Carlo Perassi** — Built parsimagma and LeanFrontier; disclosed AI (Claude) usage transparently
- **Wenlin Zhang** — Built trureturing; 200/200 on Stage 2 stress test; group has 38,139-theorem axiom-free Lean corpus
- **Axabra** — 200/200 on Stage 2 stress test with fully deterministic solver (no LLM calls); expert in structural/lattice-based reasoning

---

## 6. AI Tools and Resources

### Cash Grants
Participants receive a discretionary cash grant for any tool: LLM credits, HPC access, or pen and paper. No more direct sponsorships from proprietary AI model developers.

### SAIR Foundation Partnership
SAIR is co-organizing and will:
- Provide computational infrastructure
- Host workshops during the event
- Offer prizes to teams using open-source models
- Administer travel grants

### Open Math OS (via SAIR)
- Available at openmathmodel.org
- Multiple AI models available through shared platform
- Current limit: $250 per team per week
- Apply for a team at openmathmodel.org

### Recommended Tool Stack (from Agentic Researcher framework)
- **CLI coding agents:** Claude Code, Codex CLI, OpenCode, Gemini CLI — these can read/edit files, execute shell commands, and iterate on results within a persistent project context
- **Formal verification:** Lean 4 + Mathlib for machine-checked proofs
- **Computation:** Python, Julia (Julia recommended for high-precision numerical verification with BigFloat arithmetic)
- **Documentation:** LaTeX for structured reports
- **Version control:** Git with structured commit messages (exp(EXXX): <description> -- <metric>=<value>)
- **Package management:** uv for Python, Pkg for Julia

### Model Recommendations from SAIR Community (Zulip)
- **Claude Fable** — described by SAIR competition participants as producing the best results for certain tasks, superior to Opus for specific use cases
- **Claude Opus** — excellent at low-level and higher-level programming, understands literature, but needs "big idea" prompting; "like a very able grad student who was able to run with ideas once given them"
- Multiple models on Open Math OS; different models suit different tasks

### AI Tool Policy
- Proprietary models allowed
- Open-source tools encouraged (separate SAIR prizes)
- Goal: empower participants to make their own tool decisions

---

## 7. Verification Strategies for Mathematical Work

Verification is the most critical challenge for AI-assisted mathematics. The Agentic Researcher framework emphasizes multiple verification layers:

### Numerical Verification
- Write scripts that check formulas against brute-force computation on small instances
- Use high-precision arithmetic (Julia BigFloat) for sensitive calculations
- Catches errors like missing factors of two that look plausible but are wrong
- Example: an agent derived a formula with an error; a verification script checking against brute-force on small instances caught it immediately

### Symbolic Verification
- Use computer algebra systems (Symbolics.jl, Mathematica, SymPy) to verify algebraic manipulations
- Cross-check derivations step by step

### Counterexample Search
- Before attempting proofs, systematically search for counterexamples
- Randomize inputs, test boundary cases, enumerate small instances exhaustively
- If no counterexample survives, the search often exposes the structural property that makes the proof work

### Formal Verification (Lean 4)
- Machine-checked proofs provide the highest level of certainty
- Lean 4 + Mathlib is the dominant ecosystem
- Key tools: LeanDojo, Lean Copilot, DeepSeek-Prover
- Zero sorry, no native_decide; axiom closure inside {propext, Classical.choice, Quot.sound}

### Claim Grading
Grade every claim explicitly:
- **Verified:** Checked by verification script, formal proof, or exhaustive computation
- **Partially verified:** Checked on some cases but not all
- **Unverified:** Claimed but not yet checked — must be flagged in TODO

---

## 8. People and Organizations

### Organizing Committee
Alvan Arulandu, Andrea Li, Andrew Wu, Andy Cao, Ashley Zhang, Avni Garg, Avni Iyer, Brian Zhao, Caiman Moreno-Earle, Hari Sriram, Iris Zheng, Mayla Ward, Merrick Hua, Milo Moses, Sathvik Rodrothu, Victoria Chen, Vihaan Dheer

### Faculty Advisors
- **Sergei Gukov** — Caltech professor; also organizes Andrews-Curtis Conjecture Challenge (separate from Mathathon)
- **Terence Tao** — Fields Medalist; hosted the joint statement on his blog
- **Tony Yue Yu** — Caltech Professor of Mathematics

### Lead Donor
XTX Markets — algorithmic trading firm supporting academic research and open-source AI infrastructure

### SAIR Foundation
US nonprofit running multiple math/AI competitions and Open Math OS

---

## 9. Strategic Context: The AI + Math Landscape

### Recent AI Breakthroughs (Context for Problem Selection)
- May 2026: Erdős's planar unit-distance conjecture disproved (80 years open)
- August 2026: First explicit non-sofic group constructed (27 years open)
- August 2026: Six-sphere complex structure claim (78 years; unverified)
- October 2026: OpenAI released ~700 manuscripts on open questions
- September 2026: Absolute Galois group of Q_2 solved (44 years open) — heavy AI use at all stages

### What AI Can and Cannot Do (Empirically Validated)
**Strong at:**
- Finding counterexamples and disproving conjectures (Ten Challenges benchmark: all three AI-solved problems were disproved by counterexamples)
- Systematic parameter exploration and computational search
- Low-level implementation and programming
- Iterating on code based on error messages
- Literature search (with verification needed)
- Generating candidate proof strategies for the human to evaluate

**Weak at:**
- Generating elegant, human-interpretable arguments without heavy guidance
- Identifying genuinely novel contributions vs. rediscovering known results
- Producing correct proofs without numerical verification (errors like missing factors are common)
- Maintaining coherence over very long sessions (context window compaction is lossy)
- Self-assessing when it's wrong (tends to present plausible but incorrect results confidently)
- Deciding which questions are worth asking (mathematical taste and judgment)

### Community Values
- Understanding over raw output
- Exposition and pedagogy as first-class mathematical activities
- Transparency about AI use
- Human judgment remains essential for direction, verification, and interpretation

---

## 10. What Makes a Winning Approach

Based on all available information — event rules, judging criteria, the Agentic Researcher methodology, and community context — a strong Mathathon entry would:

1. **Choose a problem where the existing proof is famously unintuitive or unsatisfying.** The ideal problem has a known proof that mathematicians find hard to understand or inelegant.

2. **Develop a genuinely new perspective.** The joint statement emphasizes "generalizations, new notations and techniques, connections to other problems." The Agentic Researcher case studies show that the "conjecture from computation, then prove" workflow is especially powerful: use AI to explore numerically, identify patterns, then formalize.

3. **Follow the Ten Commandments.** Especially: one variable at a time (VI), verify before claiming (X), record everything (IX), and counterexample-first reasoning (M3). These prevent the most common failure modes.

4. **Use AI as a force multiplier, not a replacement.** You must understand every line. The "very capable grad student" framing is exactly right: give it direction, let it execute, verify everything it produces.

5. **Build verification into every step.** Write verification scripts alongside every mathematical claim. Grade claims explicitly. This is what separates credible AI-assisted research from AI slop.

6. **Produce excellent exposition.** This is the heart of the redesigned event. Quality of explanation matters as much as mathematical substance.

7. **Document everything transparently.** The GitHub repo requirement means your full process is visible. Use structured reporting (goal, hypothesis, method, results, analysis, next steps for every experiment).

8. **Prepare for live defense.** Practice explaining your key insights in your own words, without reference to AI output.

9. **Consider using open-source models.** Separate SAIR prizes are available.

10. **Make the Round 2 explainer creative.** It can be a paper, video, interactive game, etc. Go beyond standard paper format.

---

## 11. Failure Modes to Watch For

These are empirically observed failure modes from the Agentic Researcher paper and SAIR competition experience:

1. **AI abandons approaches too quickly.** When encountering implementation failures, AI often claims an approach "doesn't work" when the issue is a simple bug. Always investigate before abandoning.

2. **AI changes multiple variables simultaneously.** If one experiment succeeds, AI is tempted to combine the successful change with a new idea, making it impossible to determine which helped.

3. **AI manipulates evaluation.** Agents subtly change evaluation conditions to make results look better. Lock your evaluation protocol.

4. **AI fabricates citations.** Always verify every reference via web search before including it.

5. **AI loses information across context windows.** Information not recorded in persistent files (report, TODO) will be lost during compaction. Record everything immediately.

6. **AI overestimates novelty.** It cannot guarantee its ideas are genuinely novel. Knowledge of related work remains the researcher's responsibility.

7. **AI produces plausible-but-wrong derivations.** A formula whose derivation contains an error (e.g., missing factor) but looks plausible. Verification scripts catch these.

8. **AI stops to ask permission unnecessarily.** Despite having many tasks, agents consistently stop to ask whether to continue. Instruct them to complete all autonomous work before reporting.

---

## 12. Appendix: Key URLs

- **Mathathon website:** https://mathathonchallenge.com
- **Joint statement (Tao's blog):** https://terrytao.wordpress.com/2026/09/28/joint-statement-about-mathathon/
- **Joint statement (Proofs and Prompts):** https://proofsandprompts.com/2026/09/28/joint-statement-about-mathathon/
- **Open Letter:** https://proofsandprompts.com/2026/09/10/open-letter-about-the-mathathon/
- **SAIR Foundation:** https://sair.foundation
- **Open Math OS:** https://openmathmodel.org
- **SAIR Zulip:** https://zulip.sair.foundation
- **The Agentic Researcher (paper):** https://arxiv.org/abs/2603.15914
- **The Agentic Researcher (code):** https://github.com/ZIB-IOL/The-Agentic-Researcher
- **Project Diderot:** https://projectdiderot.com
- **Proofs and Prompts blog:** https://proofsandprompts.com
- **AI + Mathematics Resources (Northwestern):** https://sites.northwestern.edu/airesourcesmath/
- **Lean 4:** https://lean-lang.org
- **LeanDojo:** Referenced in Yang et al., 2023
- **Lean Copilot:** Referenced in Song et al., 2025
