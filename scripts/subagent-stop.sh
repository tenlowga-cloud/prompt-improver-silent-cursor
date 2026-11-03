#!/bin/bash
# subagentStop: keeps a simple log of finished slices next to the project map.
DIR="$(cd "$(dirname "$0")" && pwd)"; . "$DIR/_lib.sh"
input=$(cat)
root=$(workspace_root "$input")
mkdir -p "$root/.cursor/conductor" 2>/dev/null
python3 - "$input" >> "$root/.cursor/conductor/log.jsonl" 2>/dev/null <<'PY'
import json, sys, time
try: d = json.loads(sys.argv[1])
except Exception: d = {}
keep = {k: d.get(k) for k in ("subagent_type","status","conversation_id","generation_id") if k in d}
keep["at"] = time.strftime("%Y-%m-%dT%H:%M:%S")
print(json.dumps(keep))
PY
echo '{}'
exit 0
