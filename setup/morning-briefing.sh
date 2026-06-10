#!/usr/bin/env bash
# Morning Briefing — runs daily via a scheduler (e.g. macOS LaunchAgent).
# Invokes the claude CLI to write a Daily note into the Obsidian vault.
#
# Placeholders below ({{VAULT_PATH}}, {{CLAUDE_CLI_PATH}}) are filled in by the /setup
# command before this file is copied to ~/.local/bin/morning-briefing.sh.

VAULT="{{VAULT_PATH}}"
CLAUDE_CLI="{{CLAUDE_CLI_PATH}}"            # e.g. /Users/you/.local/bin/claude  (output of `which claude`)
PROMPT_FILE="$HOME/.local/bin/morning-briefing-prompt.txt"
LOG="$HOME/.local/share/morning-briefing.log"
TODAY=$(date '+%Y-%m-%d')
BRIEFING_FILE="$VAULT/Daily/$TODAY.md"
MAX_ATTEMPTS=3
RETRY_DELAY=60  # seconds between retries

mkdir -p "$(dirname "$LOG")"

# Skip if briefing already ran today
if [ -f "$BRIEFING_FILE" ]; then
  echo "$(date): Briefing already exists for $TODAY, skipping." >> "$LOG"
  exit 0
fi

echo "$(date): Starting morning briefing for $TODAY..." >> "$LOG"

cd "$VAULT" || { echo "$(date): ERROR — vault not found at $VAULT" >> "$LOG"; exit 1; }

for attempt in $(seq 1 $MAX_ATTEMPTS); do
  if [ $attempt -gt 1 ]; then
    echo "$(date): Retry attempt $attempt of $MAX_ATTEMPTS (waiting ${RETRY_DELAY}s)..." >> "$LOG"
    sleep "$RETRY_DELAY"
  fi

  "$CLAUDE_CLI" \
    --dangerously-skip-permissions \
    --model sonnet \
    --add-dir "$VAULT" \
    -p "$(cat "$PROMPT_FILE")" \
    >> "$LOG" 2>&1

  EXIT_CODE=$?

  # Success = briefing file was written to disk
  if [ -f "$BRIEFING_FILE" ]; then
    echo "$(date): Briefing complete (attempt $attempt)." >> "$LOG"
    exit 0
  fi

  echo "$(date): Attempt $attempt failed (exit code: $EXIT_CODE, briefing file not found)." >> "$LOG"
done

echo "$(date): ERROR — All $MAX_ATTEMPTS attempts failed. Briefing not generated for $TODAY." >> "$LOG"
exit 1
