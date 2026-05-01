# SkillManagerPro

**SkillManagerPro** is a Claude Code plugin designed to optimize your development workflow. It enables and disables skills on the fly, helping you manage your context window more effectively and reduce token usage during complex tasks.

---

## Why use SkillManagerPro?
As development projects grow, so does the "noise" in your AI context window. **SkillManagerPro** allows you to toggle specific skills in and out of your active environment, ensuring Claude stays focused on the task at hand.

* **Save Tokens:** Minimizes clutter by keeping your active skill list relevant.
* **Context Window Optimization:** Auto-restores the skills you need for your current session.
* **Automated Workflow:** No manual intervention required; the plugin handles skill states based on your session intent.

## Installation

Add this repository to your Claude Code marketplace to install:

1. **Add the marketplace:**
   ```bash
   /plugin marketplace add lyricsandbeats/SkillManagerPro-V1
   ```

2. **Install the plugin:**
   ```bash
   /plugin install skillmanagerpro-v1@lyricsandbeats
   ```

## Included Skills
This plugin manages the following internal skills:

* restore-skill: Logic to bring back necessary skills into the active session.
* skills-auto: Automates the management of your skill environment.

## Local Development
If you are contributing or testing changes locally:
```bash
claude --plugin-dir ./path/to/SkillManagerPro-V1
```
## Built By
Gillian (Gill of All Things). 
I'm not a developer, I'm a builder, so I built this to help other builders and to learn more about development and code, to be the best AI builder I can be.
Follow my "build in public" journey on X: https://x.com/GillofAllThings and IG: instagram.com/gillofallthings






