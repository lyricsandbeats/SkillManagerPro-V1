---
name: skill-manager-auto
description: Enable/disable automatic archive and restore suggestions. When enabled, Claude surfaces relevant suggestions at session start with confirmation prompts.
aliases: ["skill-manager-auto", "skill-auto", "auto suggestions", "restore suggestions", "archive suggestions"]
user-invocable: true
---

# Skill Manager Auto

Controls automatic archive and restore suggestions for this session.

## Commands

- `/skill-manager-auto on` — enable automatic archive/restore suggestions with confirmation prompts at session start
- `/skill-manager-auto off` — disable automatic suggestions (you'll need to manually invoke archive/restore)
- `/skill-manager-auto status` — show current auto-suggestion status

## Behavior

### When Enabled

At session start, Claude checks your initial prompt against archived skills and matches keywords. If a match is found, you'll receive a suggestion prompt like:

> "I noticed you're working in [category]. Restore [skill-name] for this task?"

You can accept or reject the suggestion. No automatic archiving or restoration happens—all operations require your explicit confirmation.

### When Disabled

Auto suggestions are off. Use `/restore-skill` or manual commands to restore archived skills.

### How It Works

- Suggestions are based on keyword matching against `~/.claude/plugins/skill-manager-pro/index.json`
- All suggestions are confirmation prompts—nothing happens silently
- Restored skills stay active until you manually archive them with `/archive-skill`
