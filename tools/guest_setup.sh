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
  echo "usage: bash tools/guest_setup.sh <name>-<tool>"
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
if git show-ref --verify --quiet "refs/heads/$branch"; then
  git switch "$branch"
elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  git switch -c "$branch" --track "origin/$branch"
else
  git switch -c "$branch" --no-track origin/main
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

echo
echo "Ready."
echo "  branch : $branch"
echo "  folder : guests/$tag/     (the only place you write)"
echo "  save   : git add guests/$tag && git commit -m \"...\""
echo "  send   : git push -u origin $branch"
echo "  update : git fetch origin && git merge origin/main"
echo "Rules: AGENTS.md"
