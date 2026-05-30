#!/usr/bin/env bash
# Turn ON the experimental SessionEnd auto-sync (Claude). Reversible: disable-autosync.sh.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="$HOME/.config/ai-memory"; mkdir -p "$CFG"
STAMP="$(date +%Y%m%d-%H%M%S)"
chmod +x "$REPO/hooks/claude/auto-sync.sh"
touch "$CFG/autosync.enabled"

SETTINGS="$HOME/.claude/settings.json"
[ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak-$STAMP"
REPO="$REPO" SETTINGS="$SETTINGS" python3 - <<'PY'
import json, os
sp = os.environ["SETTINGS"]; repo = os.environ["REPO"]
try:
    data = json.load(open(sp))
except FileNotFoundError:
    data = {}
cmd = f'"{repo}/hooks/claude/auto-sync.sh"'
se = data.setdefault("hooks", {}).setdefault("SessionEnd", [])
if not any(h.get("command")==cmd for g in se for h in g.get("hooks", [])):
    se.append({"hooks": [{"type": "command", "command": cmd}]})
    json.dump(data, open(sp, "w"), indent=2)
    print("enabled SessionEnd auto-sync hook")
else:
    print("already enabled")
PY
echo "Auto-sync ON. To turn off: rm $CFG/autosync.enabled (and remove the SessionEnd hook from settings.json)."
echo "Test it first: have a short ops conversation, end the session, then check $CFG/autosync.log and your Notion."
