#!/bin/bash
# restore-skill.sh — Skill lifecycle manager for skill-manager-pro
# Usage:
#   --search {keyword}          List archived skills matching keyword
#   --list                      List all archived skills
#   --restore {skill} --temp    Copy from archive to active (temp, re-archived on cleanup)
#   --restore {skill} --perm    Move from archive to active (permanent)
#   --archive {skill}           Move from active to archive
#   --cleanup                   Re-archive all temp-restored skills

SKILLS_DIR="$HOME/.claude/skills"
ARCHIVE_DIR="$HOME/.claude/skills-archive"
TEMP_TRACKING="$ARCHIVE_DIR/.temp-restored"

# Ensure dirs exist
mkdir -p "$SKILLS_DIR" "$ARCHIVE_DIR"

# Update .last-access timestamp for a skill
update_last_access() {
  local skill_name="$1"
  local skill_path="$SKILLS_DIR/$skill_name"
  if [ -d "$skill_path" ]; then
    local last_access_file="$skill_path/.last-access"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"timestamp\": \"$timestamp\"}" > "$last_access_file"
  fi
}

ACTION=""
SKILL_NAME=""
MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --search)   ACTION="search";  SKILL_NAME="$2"; shift 2 ;;
    --list)     ACTION="list";    shift ;;
    --restore)  ACTION="restore"; SKILL_NAME="$2"; shift 2 ;;
    --archive)  ACTION="archive"; SKILL_NAME="$2"; shift 2 ;;
    --cleanup)  ACTION="cleanup"; shift ;;
    --temp)     MODE="temp"; shift ;;
    --perm)     MODE="perm"; shift ;;
    *) shift ;;
  esac
done

case "$ACTION" in

  search)
    echo "Searching archived skills for: $SKILL_NAME"
    RESULTS=$(ls "$ARCHIVE_DIR" 2>/dev/null | grep -v '^\.' | grep -i "$SKILL_NAME")
    if [ -z "$RESULTS" ]; then
      echo "No archived skills matching '$SKILL_NAME'."
    else
      echo "Matches:"
      echo "$RESULTS" | while read -r s; do echo "  - $s"; done
    fi
    ;;

  list)
    echo "All archived skills:"
    SKILLS=$(ls "$ARCHIVE_DIR" 2>/dev/null | grep -v '^\.')
    if [ -z "$SKILLS" ]; then
      echo "  (none)"
    else
      echo "$SKILLS" | while read -r s; do echo "  - $s"; done
    fi
    ;;

  restore)
    if [ -z "$SKILL_NAME" ]; then echo "Error: skill name required."; exit 1; fi
    SRC="$ARCHIVE_DIR/$SKILL_NAME"
    DEST="$SKILLS_DIR/$SKILL_NAME"
    if [ ! -d "$SRC" ]; then echo "Error: '$SKILL_NAME' not found in archive."; exit 1; fi
    if [ "$MODE" = "temp" ]; then
      cp -r "$SRC" "$DEST"
      echo "$SKILL_NAME" >> "$TEMP_TRACKING"
      update_last_access "$SKILL_NAME"
      echo "Restored '$SKILL_NAME' temporarily. Will re-archive on cleanup."
    else
      mv "$SRC" "$DEST"
      update_last_access "$SKILL_NAME"
      echo "Restored '$SKILL_NAME' permanently."
    fi
    ;;

  archive)
    if [ -z "$SKILL_NAME" ]; then echo "Error: skill name required."; exit 1; fi
    SRC="$SKILLS_DIR/$SKILL_NAME"
    DEST="$ARCHIVE_DIR/$SKILL_NAME"
    if [ ! -d "$SRC" ]; then echo "Error: '$SKILL_NAME' not found in active skills."; exit 1; fi
    mv "$SRC" "$DEST"
    # Update last-access timestamp in archive
    update_last_access "$SKILL_NAME"
    # Remove from temp tracking if present
    if [ -f "$TEMP_TRACKING" ]; then
      grep -v "^${SKILL_NAME}$" "$TEMP_TRACKING" > "${TEMP_TRACKING}.tmp" && mv "${TEMP_TRACKING}.tmp" "$TEMP_TRACKING"
    fi
    echo "Archived '$SKILL_NAME'."
    ;;

  cleanup)
    if [ ! -f "$TEMP_TRACKING" ] || [ ! -s "$TEMP_TRACKING" ]; then
      echo "No temp-restored skills to clean up."
      exit 0
    fi
    echo "Re-archiving temp-restored skills:"
    while IFS= read -r skill; do
      [ -z "$skill" ] && continue
      SRC="$SKILLS_DIR/$skill"
      DEST="$ARCHIVE_DIR/$skill"
      if [ -d "$SRC" ]; then
        rm -rf "$DEST"
        mv "$SRC" "$DEST"
        echo "  - Re-archived: $skill"
      fi
    done < "$TEMP_TRACKING"
    > "$TEMP_TRACKING"
    echo "Cleanup complete."
    ;;

  *)
    echo "Usage: restore-skill.sh [--search keyword] [--list] [--restore name --temp|--perm] [--archive name] [--cleanup]"
    exit 1
    ;;
esac
