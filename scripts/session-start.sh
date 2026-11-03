#!/bin/bash
# sessionStart: puts the gate and the user's config into every new chat's context.
DIR="$(cd "$(dirname "$0")" && pwd)"; . "$DIR/_lib.sh"
input=$(cat)
root=$(workspace_root "$input")
cfg=""
for f in "$root/.cursor/conductor/config.json" "$HOME/.cursor/conductor/config.json"; do
  [ -f "$f" ] && { cfg="$f"; break; }
done
python3 - "$cfg" "$root" <<'PY' 2>/dev/null || echo '{}'
import json, sys, os
cfg, root = sys.argv[1], sys.argv[2]
lines = ["PROMPT GATE: prompt-improver-silent-cursor is active. On every prompt that asks for work, read the whole skill and its references first, then follow it silently. No slash command is needed."]
if cfg:
    try:
        c = json.load(open(cfg))
        keep = {k: c.get(k) for k in ("user","home","plan","models_enabled","budget_per_job_usd","repos","grok_bot_linked","report_style")}
        lines.append("CONFIG: " + json.dumps(keep))
    except Exception:
        lines.append("CONFIG: unreadable at " + cfg + ". Re-run setup step 9.")
else:
    lines.append("FIRST RUN: no config found. Run the skill's references/setup.md, one question at a time, before the first job.")
pm = os.path.join(root, ".cursor/conductor/PROJECT-MAP.md")
if os.path.exists(pm):
    lines.append("OPEN PROJECT MAP: " + pm + " (read it before starting; update it, do not write a second one).")
print(json.dumps({"additional_context": "\n".join(lines)}))
PY
exit 0
