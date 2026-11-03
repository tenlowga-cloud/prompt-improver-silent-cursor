#!/bin/bash
# stop: if the project map says the job is still working, send the agent back to finish it.
DIR="$(cd "$(dirname "$0")" && pwd)"; . "$DIR/_lib.sh"
input=$(cat)
root=$(workspace_root "$input")
status=$(json_get "$input" 'd.get("status")')
loops=$(json_get "$input" 'd.get("loop_count",0)')
state="$root/.cursor/conductor/state.json"
if [ "$status" = "completed" ] && [ -f "$state" ] && [ "${loops:-0}" -lt 5 ]; then
  job=$(json_get "$(cat "$state")" 'd.get("status")')
  if [ "$job" = "working" ]; then
    echo '{"followup_message": "The project map still shows open slices. Check .cursor/conductor/PROJECT-MAP.md, finish or re-assign the open slices, check the work, then set state.json status to done (or waiting if a gate needs the user)."}'
    exit 0
  fi
fi
echo '{}'
exit 0
