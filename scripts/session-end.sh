#!/bin/bash
# session-end.sh — Injected at SessionEnd to prompt temp-skill cleanup

TEMP_TRACKING="$HOME/.claude/skills-archive/.temp-restored"

if [ -f "$TEMP_TRACKING" ] && [ -s "$TEMP_TRACKING" ]; then
  TEMP_SKILLS=$(grep -v '^$' "$TEMP_TRACKING" | tr '\n' ', ' | sed 's/,$//')
  echo "=== SKILL MANAGER PRO — Session End ==="
  echo "Temp-restored skills still active: $TEMP_SKILLS"
  echo "INSTRUCTION: Offer to run /archive-skill --cleanup to re-archive these."
  echo "======================================="
fi
