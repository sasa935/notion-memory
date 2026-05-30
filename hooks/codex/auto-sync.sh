#!/usr/bin/env bash
# Codex Stop hook: optionally flush reusable ops knowledge to Notion via the notion-memory skill.
# DISABLED by default (opt-in flag). Once-per-session guard so it doesn't fire every turn. Always exit 0.
# Experimental: Codex also generates its own native memories; this is the cross-tool Notion layer.
set -uo pipefail
CFG="$HOME/.config/ai-memory"
[ -f "$CFG/autosync.enabled" ] || exit 0

input="$(cat 2>/dev/null || true)"
sid="$(printf '%s' "$input" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("session_id",""))' 2>/dev/null || true)"
# once-per-session: skip if we already synced this session id
marker="$CFG/synced-$sid"
[ -n "$sid" ] && [ -f "$marker" ] && exit 0

CODEX_BIN="$(command -v codex 2>/dev/null || cat "$CFG/codex_bin" 2>/dev/null || true)"
[ -n "$CODEX_BIN" ] && [ -x "$CODEX_BIN" ] || exit 0

LOG="$CFG/autosync.log"
"$CODEX_BIN" exec "Use the notion-memory skill to save any reusable operational knowledge from this session to Notion (UPSERT by task/sub-topic, never by date). If nothing is worth saving, do nothing." >>"$LOG" 2>&1 || true
[ -n "$sid" ] && touch "$marker"
exit 0
