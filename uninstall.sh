#!/usr/bin/env bash
# Remove everything install.sh / enable-autosync.sh added on THIS machine.
# Leaves the cloned repo, ~/.config/ai-memory, and your Notion data untouched.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

unlink_if_link() { if [ -L "$1" ]; then rm "$1"; echo "removed symlink $1"; fi; }
unlink_if_link "$HOME/.claude/skills/notion-memory"
unlink_if_link "$HOME/.codex/skills/notion-memory"
unlink_if_link "$HOME/.claude/commands/sync-memory.md"

SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.bak-$STAMP"
  REPO="$REPO" SETTINGS="$SETTINGS" python3 - <<'PY'
import json, os
sp = os.environ["SETTINGS"]; repo = os.environ["REPO"]
data = json.load(open(sp))
hooks = data.get("hooks", {})
for ev in ("SessionStart", "SessionEnd"):
    new = []
    for g in hooks.get(ev, []):
        hs = [h for h in g.get("hooks", [])
              if repo not in h.get("command", "") and "auto-sync.sh" not in h.get("command", "")]
        if hs:
            new.append({**g, "hooks": hs})
    if new:
        hooks[ev] = new
    else:
        hooks.pop(ev, None)
if not hooks:
    data.pop("hooks", None)
json.dump(data, open(sp, "w"), indent=2)
print("cleaned ai-memory hooks from settings.json")
PY
fi
rm -f "$HOME/.config/ai-memory/autosync.enabled"
echo "Uninstalled. (Repo, ~/.config/ai-memory/config, and your Notion data left intact.)"
