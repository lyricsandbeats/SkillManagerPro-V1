#!/bin/bash
# session-start.sh — Injected at SessionStart to prime Claude for skill suggestions

ARCHIVE_DIR="$HOME/.claude/skills-archive"
INDEX="$HOME/.claude/plugins/cache/skill-manager-pro/skill-manager-pro/2.0.0/index.json"

# Fallback index location for dev installs
[ ! -f "$INDEX" ] && INDEX="$HOME/.claude/plugins/skill-manager-pro/index.json"

echo "=== SKILL MANAGER PRO — Session Context ==="
echo ""

# Show archived skills
ARCHIVED=$(ls "$ARCHIVE_DIR" 2>/dev/null | grep -v '^\.')
if [ -n "$ARCHIVED" ]; then
  echo "Archived skills available to restore:"
  echo "$ARCHIVED" | while read -r s; do echo "  /restore-skill → $s"; done
else
  echo "No skills currently archived."
fi

echo ""

# Show index categories if available
if [ -f "$INDEX" ]; then
  echo "Skill categories (match against user's first prompt):"
  python3 -c "
import json, sys
try:
    with open('$INDEX') as f:
        data = json.load(f)
    for cat in data.get('categories', []):
        name = cat.get('name', '')
        keywords = ', '.join(cat.get('keywords', []))
        skills = ', '.join(cat.get('skills', []))
        print(f'  {name}: keywords=[{keywords}] → skills=[{skills}]')
except Exception as e:
    print('  (could not read index.json)')
" 2>/dev/null
fi

echo ""
echo "INSTRUCTION: If the user's session intent matches any category keywords above,"
echo "proactively suggest restoring the relevant skill with /restore-skill."
echo "If skills-auto mode is 'session', restore automatically. If 'ask', prompt first."
echo "==========================================="
