#!/usr/bin/env bash
# Launch one Open Math OS worker and log the run in the repo.
#
#   bash tools/delegate.sh <slug> <brief.md> [-AllowBash] [-ReadOnly] [-Flash | -Model <id>]
#
# The brief is copied to logs/delegations/<timestamp>_<slug>/brief.md, the worker is told to
# read that file, and its final answer is saved next to it as output.md. One line per run is
# appended to logs/delegations/INDEX.md. The worker itself is ~/.claude/bin/om.ps1 (a headless
# Claude Code process pointed at the Open Math OS gateway).
#
# Optional: DELEGATE_TIMEOUT=<seconds> kills a worker that runs too long (default 5400).
set -u
if [ $# -lt 2 ]; then
  echo "usage: bash tools/delegate.sh <slug> <brief.md> [om.ps1 flags]" >&2
  exit 2
fi
slug="$1"; brief="$2"; shift 2
root="$(cd "$(dirname "$0")/.." && pwd)"
[ -f "$brief" ] || { echo "delegate: brief not found: $brief" >&2; exit 2; }

ts="$(date +%Y%m%d-%H%M%S)"
rel="logs/delegations/${ts}_${slug}"
dir="$root/$rel"
mkdir -p "$dir"
cp "$brief" "$dir/brief.md"

model="moonshotai/kimi-k3.1-pro"
prev=""
for a in "$@"; do
  [ "$a" = "-Flash" ] && model="deepseek/deepseek-v4.1-flash"
  [ "$prev" = "-Model" ] && model="$a"
  prev="$a"
done
{
  echo "slug:    $slug"
  echo "brief:   $brief"
  echo "model:   $model"
  echo "flags:   $*"
  echo "started: $(date '+%Y-%m-%d %H:%M:%S %Z')"
} > "$dir/meta.txt"

task="Read the file $rel/brief.md and carry out the task it describes, exactly. You are a worker: follow the section 'If you are a worker' in CLAUDE.md. When finished, reply with a short honest summary: what you did, which files you created or changed, what you could not do, and what you did not verify."

cd "$root"
MSYS_NO_PATHCONV=1 timeout "${DELEGATE_TIMEOUT:-5400}" \
  powershell -NoProfile -File "$USERPROFILE/.claude/bin/om.ps1" -Task "$task" "$@" \
  > "$dir/output.md" 2> "$dir/stderr.txt"
code=$?

echo "ended:   $(date '+%Y-%m-%d %H:%M:%S %Z')" >> "$dir/meta.txt"
echo "exit:    $code" >> "$dir/meta.txt"
[ -f "$root/logs/delegations/INDEX.md" ] || printf '# Worker runs\n\n| started | slug | model | exit | folder |\n|---|---|---|---|---|\n' > "$root/logs/delegations/INDEX.md"
echo "| $ts | $slug | $model | $code | $rel |" >> "$root/logs/delegations/INDEX.md"

echo "=== $slug ($model) exit=$code ==="
cat "$dir/output.md"
exit $code
