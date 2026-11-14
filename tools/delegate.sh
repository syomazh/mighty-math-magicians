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
# If the worker dies (connection error, gateway timeout, time limit) it is relaunched with an
# instruction to continue from the files already written, up to DELEGATE_RETRIES attempts.
#
# Environment:
#   DELEGATE_TIMEOUT  seconds before one attempt is killed (default 5400)
#   DELEGATE_RETRIES  maximum number of attempts (default 4)
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

tail_text="You are a worker: follow the section 'If you are a worker' in CLAUDE.md. When finished, reply with a short honest summary: what you did, which files you created or changed, what you could not do, and what you did not verify."
task="Read the file $rel/brief.md and carry out the task it describes, exactly. $tail_text"
resume="A previous worker was carrying out the brief in $rel/brief.md and was cut off by a connection error. Read that brief in full, then inspect what already exists in the paths it names, and finish the task from there instead of starting over. Work in short steps and save files often. $tail_text"

cd "$root"
attempt=1
max="${DELEGATE_RETRIES:-4}"
while :; do
  MSYS_NO_PATHCONV=1 timeout "${DELEGATE_TIMEOUT:-5400}" \
    powershell -NoProfile -File "$USERPROFILE/.claude/bin/om.ps1" -Task "$task" "$@" \
    > "$dir/output.md" 2> "$dir/stderr.txt"
  code=$?
  if [ $code -eq 0 ] && head -c 200 "$dir/output.md" | grep -q "^API Error"; then code=70; fi
  echo "attempt $attempt: exit $code at $(date '+%H:%M:%S')" >> "$dir/meta.txt"
  [ $code -eq 0 ] && break
  [ "$attempt" -ge "$max" ] && break
  cp "$dir/output.md" "$dir/output_attempt$attempt.md"
  attempt=$((attempt + 1))
  task="$resume"
  sleep 90
done

echo "ended:   $(date '+%Y-%m-%d %H:%M:%S %Z')" >> "$dir/meta.txt"
echo "exit:    $code" >> "$dir/meta.txt"
[ -f "$root/logs/delegations/INDEX.md" ] || printf '# Worker runs\n\n| started | slug | model | exit | folder |\n|---|---|---|---|---|\n' > "$root/logs/delegations/INDEX.md"
echo "| $ts | $slug | $model | $code (attempts: $attempt) | $rel |" >> "$root/logs/delegations/INDEX.md"

echo "=== $slug ($model) exit=$code attempts=$attempt ==="
cat "$dir/output.md"
exit $code
