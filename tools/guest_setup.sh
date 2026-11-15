#!/usr/bin/env bash
# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
# One-time setup of a guest's clone (see AGENTS.md):
#   - switches to the guest's own branch  guest/<tag>
#   - creates the guest's own folder      guests/<tag>/
#   - turns on the guards in tools/githooks/, which refuse a commit outside that
#     folder or branch and a push to any other branch.
# Usage:  bash tools/guest_setup.sh <name>-<tool>      e.g.  bash tools/guest_setup.sh alex-chatgpt
set -euo pipefail

tag="${1:-}"
if ! [[ "$tag" =~ ^[a-z0-9]+-[a-z0-9]+$ ]]; then
  echo "usage: bash tools/guest_setup.sh <name>-<tool> [--keep-branch]"
  echo "       --keep-branch: only in a cloud session that already put you on its own branch"
  echo "       lower-case letters and digits, one hyphen, for example: alex-chatgpt"
  exit 1
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

if [ -f .orchestrator ]; then
  echo "This is the orchestrator's working folder. Do not set up a guest here."
  echo "Clone the repository into another folder and run this script there."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "This clone has uncommitted changes. Start from a fresh clone, or undo them first:"
  git status --short
  exit 1
fi

git fetch origin
git config core.hooksPath tools/githooks
git config mmm.guesttag "$tag"
chmod +x tools/githooks/pre-commit tools/githooks/pre-push 2>/dev/null || true

branch="guest/$tag"
if [ "${2:-}" = "--keep-branch" ]; then
  # Cloud sessions (Claude Code on the web, the Code tab with Cloud selected) start on a branch
  # of their own, and their "Create PR" button belongs to that branch. Keep it instead of
  # switching, and tell the guards that this is the guest's branch.
  cur="$(git symbolic-ref --short -q HEAD || true)"
  if [ -z "$cur" ] || [ "$cur" = "main" ] || [ "$cur" = "master" ]; then
    echo "--keep-branch: you are on '${cur:-no branch}'. A guest never works on the main branch."
    echo "Run again without --keep-branch; that puts you on guest/$tag."
    exit 1
  fi
  branch="$cur"
  git config mmm.guestbranch "$branch"
else
  git config --unset mmm.guestbranch 2>/dev/null || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git switch "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git switch -c "$branch" --track "origin/$branch"
  else
    git switch -c "$branch" --no-track origin/main
  fi
fi

mkdir -p "guests/$tag"
if [ ! -f "guests/$tag/README.md" ]; then
  cat > "guests/$tag/README.md" << EOF
# guests/$tag

Fill in: which model and tool wrote the files in this folder, who started it, the date.
Nothing here is human-reviewed or part of the team's record (see AGENTS.md).

## Asked to do

## Done

## Not done, not verified
EOF
fi
if [ ! -f "guests/$tag/JOURNAL.md" ]; then
  cat > "guests/$tag/JOURNAL.md" << EOF
# Journal of guests/$tag

Append-only, newest at the bottom, one entry per work block (AGENTS.md, "Keep a record").
First line of every entry: date, time, model and tool. Then: asked, done, failed, open.
Not human-reviewed.
EOF
fi
if [ ! -f "guests/$tag/CLAIMS_PROPOSED.md" ]; then
  cat > "guests/$tag/CLAIMS_PROPOSED.md" << EOF
# Claims proposed by guests/$tag

Not part of the team's ledger (CLAIMS.md) until reviewed and carried over. Not human-reviewed.
Grades as in CLAUDE.md, rule 2: conjecture, computed, ai-proved, ai-reviewed. A guest cannot give human-signed.

| ID | Claim | Grade | Evidence (file in this folder) | Model | Date |
|---|---|---|---|---|---|
EOF
fi
if [ ! -f "guests/$tag/PROPOSALS.md" ]; then
  cat > "guests/$tag/PROPOSALS.md" << EOF
# Changes proposed by guests/$tag to files outside this folder

One entry per change: the file and the place, what is wrong or missing, the exact replacement
text (or a patch file in this folder), and the evidence (AGENTS.md, "How to propose a change").
Not human-reviewed.
EOF
fi

echo
echo "Ready."
echo "  branch : $branch"
echo "  folder : guests/$tag/     (the only place you write)"
echo "  record : guests/$tag/JOURNAL.md, CLAIMS_PROPOSED.md, PROPOSALS.md  (update after every work block)"
echo "  save   : git add guests/$tag && git commit -m \"...\""
echo "  send   : git push -u origin $branch"
echo "  update : git fetch origin && git merge origin/main"
echo "Rules: AGENTS.md"
