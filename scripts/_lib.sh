#!/bin/bash
# Shared helpers. Needs python3 (preinstalled on macOS and most Linux).
# Every hook fails open: on any error it prints {} and exits 0 so Cursor keeps working.

json_get() { # json_get <json> <python expression on d>
  python3 -c 'import json,sys
try:
  d=json.loads(sys.argv[1]); v=eval(sys.argv[2])
  print("" if v is None else v)
except Exception: print("")' "$1" "$2" 2>/dev/null
}

workspace_root() { # first workspace root from hook input, else cwd
  local r; r=$(json_get "$1" '(d.get("workspace_roots") or [""])[0]')
  [ -n "$r" ] && echo "$r" || pwd
}
