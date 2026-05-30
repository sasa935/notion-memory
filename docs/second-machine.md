# Add another machine (work laptop / second computer)

```bash
git clone https://github.com/sasa935/notion-memory ~/notion-memory
cd ~/notion-memory && ./install.sh
```

Then two steps (only you can do these):
1. **Connect Notion**: Claude → Settings → Connectors → Notion; Codex → enable the Notion connector.
2. **Set the memory notebook**: edit `~/.config/ai-memory/config` → `NOTION_MEMORY_ROOT`, pointing at the **same** Notion notebook as your other machines.

(Optional) `./enable-autosync.sh` to turn on end-of-session auto-sync.

## Day to day
- Edit `SKILL.md` on any machine → `git commit && git push`.
- Every machine auto-pulls it on session start (the `SessionStart` hook) → everyone runs the same skill.

## On a managed / work Mac
- Make sure your MDM policy allows cloning/pulling from GitHub (HTTPS is almost always fine).
- Whether work operational knowledge may live in personal GitHub/Notion is a **company policy** question — check first, and never store plaintext secrets.

## Uninstall
`./uninstall.sh` — removes this machine's symlinks and hooks; leaves the repo, `~/.config/ai-memory`, and your Notion data intact.
