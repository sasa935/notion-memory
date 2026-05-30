#!/usr/bin/env bash
# Claude Code SessionEnd hook: optionally flush the just-ended conversation to Notion.
# DISABLED by default. Enable with ../../enable-autosync.sh. Never fails the session (always exit 0).
# Experimental: test it interactively before relying on it.
set -uo pipefail

CFG="$HOME/.config/ai-memory"
[ -f "$CFG/autosync.enabled" ] || exit 0          # opt-in flag absent -> do nothing

input="$(cat 2>/dev/null || true)"                 # hook JSON on stdin
transcript="$(printf '%s' "$input" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("transcript_path",""))' 2>/dev/null || true)"
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

CLAUDE_BIN="$(command -v claude 2>/dev/null || cat "$CFG/claude_bin" 2>/dev/null || true)"
[ -n "$CLAUDE_BIN" ] && [ -x "$CLAUDE_BIN" ] || exit 0

LOG="$CFG/autosync.log"
"$CLAUDE_BIN" -p "Use the notion-memory skill. Review the conversation transcript at: $transcript . Save any reusable operational knowledge to Notion per the skill's rules (UPSERT by task/sub-topic, never by date). If nothing is worth saving, do nothing." \
  --permission-mode acceptEdits --allowedTools "mcp__notion__*" >>"$LOG" 2>&1 || true
exit 0
