#!/usr/bin/env bash
# Turn OFF the SessionEnd auto-sync (reverse of enable-autosync.sh). Leaves /sync-memory + SessionStart pull intact.
set -euo pipefail
CFG="$HOME/.config/ai-memory"
STAMP="$(date +%Y%m%d-%H%M%S)"
rm -f "$CFG/autosync.enabled"

SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.bak-$STAMP"
  SETTINGS="$SETTINGS" python3 - <<'PY'
import json, os
sp = os.environ["SETTINGS"]
data = json.load(open(sp))
hooks = data.get("hooks", {})
groups = hooks.get("SessionEnd", [])
new = []
for g in groups:
    hs = [h for h in g.get("hooks", []) if "auto-sync.sh" not in h.get("command", "")]
    if hs:
        new.append({**g, "hooks": hs})
if new:
    hooks["SessionEnd"] = new
else:
    hooks.pop("SessionEnd", None)
if not hooks:
    data.pop("hooks", None)
json.dump(data, open(sp, "w"), indent=2)
print("removed SessionEnd auto-sync hook")
PY
fi
echo "Auto-sync OFF. (/sync-memory and SessionStart pull are still active.)"
