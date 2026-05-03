---
name: archive-skill
description: Archive a skill from ~/.claude/skills/ to reduce clutter. Archived skills can be restored later with /restore-skill.
aliases: ["archive skill", "move to archive", "hide skill", "archive-skill", "clean up skills"]
user-invocable: true
---

# Archive Skill

Move an active skill to the archive so it stays available but doesn't clutter your active skill list.

## Flow

Ask the user: "Which skill do you want to archive? (Enter the skill directory name, or 'list' to see active skills)"

If they say "list", show active skills:
```bash
ls ~/.claude/skills/
```

Once you have the skill name, confirm: "Archive `{skill-name}`? It will move to ~/.claude/skills-archive/ and can be restored anytime with /restore-skill."

On confirmation, archive it:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --archive {skill-name}
```

Show the output. Confirm success.

## Cleanup Temp Skills

To re-archive all temporarily restored skills at once:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --cleanup
```

## Notes

- Archived skills remain available — they just won't appear in your active skill list
- When `/skill-manager-auto` is enabled, relevant archived skills are suggested at session start with confirmation prompts
- Use `/restore-skill` to manually browse and restore archived skills
- Use `/skill-manager-auto on` to enable automatic suggestions, or `/skill-manager-auto off` to disable them
