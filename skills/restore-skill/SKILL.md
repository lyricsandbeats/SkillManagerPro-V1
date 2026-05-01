---
name: restore-skill
description: Restore archived skills from ~/.claude/skills-archive/ back into active use.
user-invocable: true
---

# restore-skill

Restore archived skills from ~/.claude/skills-archive/ back into active use.

## When to Use

- Need a skill you archived in a previous session
- Want to browse available archived skills
- Need temporary access to a skill for this session only

## How It Works

This skill uses `${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh` to:
1. Search archived skills by keyword
2. Show matching skills
3. Restore your selection (temp or permanent)
4. Confirm restoration

---

## Interactive Restore Flow

Ask the user for a keyword to search archived skills (or "all" to list everything):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --search {keyword}
# or list all:
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --list
```

Display the matching skills. Ask:

- "Which skill(s) do you want to restore? (enter skill name(s), space-separated)"

Once you have the selection, ask:

- "Restore as temporary (auto re-archive on session exit) or permanent?"

Execute the restore:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --restore {skill-name} --temp
# or
bash "${CLAUDE_PLUGIN_ROOT}/scripts/restore-skill.sh" --restore {skill-name} --perm
```

Show the output and confirm: "Your selected skills are now active in this session."

---

## Notes

- **Temporary restore**: Skill auto re-archives on `/archive-skill --cleanup` or session end prompt.
- **Permanent restore**: Skill stays active until you manually run `/archive-skill`.
- **Search**: Case-insensitive keyword matching. Try partial names (e.g., "fire" matches "firebase").
- To archive a skill: use `/archive-skill`.
