#!/bin/bash
# Install the silent prompt gate into Cursor.
#   ./scripts/install.sh --plugin            local plugin for this computer (recommended for Cursor desktop)
#   ./scripts/install.sh --project <repo>    into a repo's .cursor/ folder (needed for Cloud Agents and Grok Bot)
#   ./scripts/install.sh --user              loose files in ~/.cursor (skill, agents, hooks); paste the User Rule it prints
# Safe to run again. Existing hooks.json entries are kept; ours are added once.
set -euo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)"
NAME=prompt-improver-silent-cursor
command -v python3 >/dev/null || { echo "python3 is needed (macOS: xcode-select --install)"; exit 1; }

merge_hooks() { # merge_hooks <target hooks.json> <script dir as Cursor should call it>
  python3 - "$1" "$2" "$SRC/hooks/hooks.json" <<'PY'
import json, sys, os
target, prefix, ours_path = sys.argv[1:4]
cur = {"version": 1, "hooks": {}}
if os.path.exists(target):
    cur = json.load(open(target)); cur.setdefault("hooks", {}); cur.setdefault("version", 1)
ours = json.load(open(ours_path))["hooks"]
for ev, items in ours.items():
    lst = cur["hooks"].setdefault(ev, [])
    for it in items:
        it = dict(it); it["command"] = it["command"].replace("./scripts", prefix)
        if not any(x.get("command") == it["command"] for x in lst):
            lst.append(it)
os.makedirs(os.path.dirname(target), exist_ok=True)
json.dump(cur, open(target, "w"), indent=2)
print("hooks:", target)
PY
}

case "${1:-}" in
  --plugin)
    DEST="$HOME/.cursor/plugins/local/$NAME"
    mkdir -p "$DEST"
    cp -R "$SRC/.cursor-plugin" "$SRC/rules" "$SRC/skills" "$SRC/agents" "$SRC/commands" "$SRC/hooks" "$SRC/scripts" "$SRC/assets" "$DEST/"
    echo "Installed plugin at $DEST. In Cursor run: Developer: Reload Window."
    ;;
  --project)
    REPO="${2:?give the repo path}"; C="$REPO/.cursor"
    mkdir -p "$C/skills" "$C/rules" "$C/agents" "$C/hooks/conductor" "$C/conductor"
    rm -rf "$C/skills/$NAME"; cp -R "$SRC/skills/$NAME" "$C/skills/"
    cp "$SRC/rules/prompt-conductor.mdc" "$C/rules/"
    cp "$SRC/agents/"*.md "$C/agents/"
    cp "$SRC/scripts/"_lib.sh "$SRC/scripts/"session-start.sh "$SRC/scripts/"stop.sh "$SRC/scripts/"subagent-stop.sh "$C/hooks/conductor/"
    chmod +x "$C/hooks/conductor/"*.sh
    merge_hooks "$C/hooks.json" ".cursor/hooks/conductor"
    printf '%s\n' "log.jsonl" "state.json" "config.json" > "$C/conductor/.gitignore"
    echo "Installed into $C. Commit .cursor/ and push so Cloud Agents load it."
    ;;
  --user)
    C="$HOME/.cursor"
    mkdir -p "$C/skills" "$C/agents" "$C/hooks/conductor" "$C/conductor"
    rm -rf "$C/skills/$NAME"; cp -R "$SRC/skills/$NAME" "$C/skills/"
    cp "$SRC/agents/"*.md "$C/agents/"
    cp "$SRC/scripts/"_lib.sh "$SRC/scripts/"session-start.sh "$SRC/scripts/"stop.sh "$SRC/scripts/"subagent-stop.sh "$C/hooks/conductor/"
    chmod +x "$C/hooks/conductor/"*.sh
    merge_hooks "$C/hooks.json" "./hooks/conductor"
    echo "Installed into $C."
    echo "Last step: Cursor > Settings > Rules > User Rules, paste this:"
    echo "----"
    awk 'n>=2{print} /^---$/{n++}' "$SRC/rules/prompt-conductor.mdc"
    echo "----"
    ;;
  *) sed -n '2,6p' "$0"; exit 1 ;;
esac
