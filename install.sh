#!/usr/bin/env bash
# Install the shared AI memory skill + SessionStart auto-pull hook into Claude & Codex on this machine.
# Idempotent. Backs up anything it would overwrite. Safe to re-run after `git pull`.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
CFG_DIR="$HOME/.config/ai-memory"
mkdir -p "$CFG_DIR"

say()     { printf '  %s\n' "$*"; }
section() { printf '\n\033[1m%s\033[0m\n' "$*"; }   # NB: not named `head` — that would shadow the real command

# Symlink $1 -> $2, backing up an existing real file/dir first.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then ln -sfn "$src" "$dst"; say "relinked $dst"; return 0; fi
  if [ -e "$dst" ]; then mv "$dst" "$dst.bak-$STAMP"; say "backed up $dst -> $dst.bak-$STAMP"; fi
  ln -sfn "$src" "$dst"; say "linked $dst -> $src"
}

section "1) Skill -> Claude & Codex (one skill, both tools)"
if [ -d "$HOME/.claude" ]; then link "$REPO/skills/notion-memory" "$HOME/.claude/skills/notion-memory"; else say "no ~/.claude, skipping Claude skill"; fi
if [ -d "$HOME/.codex" ];  then link "$REPO/skills/notion-memory" "$HOME/.codex/skills/notion-memory";  else say "no ~/.codex, skipping Codex skill"; fi

section "2) /sync-memory command -> Claude"
if [ -d "$HOME/.claude" ]; then link "$REPO/commands/sync-memory.md" "$HOME/.claude/commands/sync-memory.md"; fi

section "3) SessionStart auto-pull hook -> Claude settings.json"
SETTINGS="$HOME/.claude/settings.json"
if [ -d "$HOME/.claude" ]; then
  if [ -f "$SETTINGS" ]; then cp "$SETTINGS" "$SETTINGS.bak-$STAMP"; say "backed up settings.json"; fi
  # run the merge as an if-condition so an invalid-JSON exit can't trip `set -e`
  if REPO="$REPO" SETTINGS="$SETTINGS" python3 - <<'PY'
import json, os, sys
sp = os.environ["SETTINGS"]; repo = os.environ["REPO"]
try:
    with open(sp) as f: data = json.load(f)
except FileNotFoundError:
    data = {}
except json.JSONDecodeError:
    sys.stderr.write("  settings.json is not valid JSON; left untouched. Add the SessionStart hook manually.\n")
    sys.exit(3)
pull = f'git -C "{repo}" pull --ff-only -q 2>/dev/null || true'
ss = data.setdefault("hooks", {}).setdefault("SessionStart", [])
if not any(h.get("command", "").startswith(f'git -C "{repo}" pull') for g in ss for h in g.get("hooks", [])):
    ss.append({"hooks": [{"type": "command", "command": pull}]})
    with open(sp, "w") as f: json.dump(data, f, indent=2)
    print("  added SessionStart pull hook")
else:
    print("  SessionStart pull hook already present")
PY
  then :; else say "skipped settings.json merge (see message above)"; fi
else
  say "no ~/.claude, skipping hook"
fi

section "4) Config"
if [ ! -f "$CFG_DIR/config" ]; then cp "$REPO/config.example" "$CFG_DIR/config"; say "created $CFG_DIR/config (edit NOTION_MEMORY_ROOT)"; else say "config exists, leaving as-is"; fi

# best-effort detect a `claude` binary for optional autosync (always returns 0 so it can't trip set -e)
detect_claude() {
  if command -v claude 2>/dev/null; then return 0; fi
  local p
  for p in "$HOME/.claude/local/claude" /Applications/Claude.app/Contents/Resources/*/claude; do
    if [ -x "$p" ]; then printf '%s\n' "$p"; return 0; fi
  done
  return 0
}
CB="$(detect_claude || true)"; CB="${CB%%$'\n'*}"
if [ -n "$CB" ]; then printf '%s\n' "$CB" > "$CFG_DIR/claude_bin"; say "found claude binary: $CB"; fi

section "Done."
say "Next: 1) connect Notion (Claude Connectors / Codex notion plugin)  2) set NOTION_MEMORY_ROOT in $CFG_DIR/config"
say "Use it: run /sync-memory at the end of a meaningful conversation. Optional full-auto: ./enable-autosync.sh"
