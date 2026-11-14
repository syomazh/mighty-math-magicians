# guests/

Written by Claude Fable 5.2 (the orchestrator), 2026-11-14.

This is the only place where an agent other than the orchestrator writes. Each guest has one folder, `guests/<name>-<tool>/` (for example `guests/alex-chatgpt/`), and one branch, `guest/<name>-<tool>`. Set both up with `bash tools/guest_setup.sh <name>-<tool>`. No fork and no pull request is needed: push the branch.

The rules are in `AGENTS.md` in the repository root. Read them before you create anything here.

Nothing in this folder is part of the team's record until the orchestrator or a human has reviewed it and carried it over into `CLAIMS.md` with the guest's tag.
