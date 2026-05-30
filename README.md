# notion-memory

> Your long-term memory for every AI assistant, across every machine — backed by **your own Notion**.

[中文说明 →](README.zh.md)

## The problem
You work across several AI tools (Claude Code, Claude Desktop, Cowork, Codex) and more than one computer. The things you'll want again later — project docs and architecture decisions, hard-won deploy/ops know-how (ports, configs, the exact CLI flags you never remember), even non-work things like a trip you planned or something you bought — get scattered, go stale, and vanish the moment you switch tools or machines.

This isn't your tool's short-term session memory. **notion-memory** is *your* durable knowledge base — a cross-tool, cross-machine second brain — stored in **your own Notion**, so every AI assistant reads and writes the *same* memory. The rules live in one skill: edit once, applies everywhere.

## ✨ One-prompt install (no coding needed)
Open **Claude Code**, **Claude Desktop**, or **Codex** and paste:

> Please set up the "notion-memory" system by following the AI-INSTALL.md at
> https://github.com/sasa935/notion-memory — do the steps for me, explain each in plain
> language, and only ask me when I personally need to click something (like signing into Notion).

Your AI clones it, runs the installer, wires up the hooks, and walks you through connecting Notion. See [AI-INSTALL.md](AI-INSTALL.md).

## Manual install
```bash
git clone https://github.com/sasa935/notion-memory ~/notion-memory
cd ~/notion-memory && ./install.sh
```
Then:
1. **Connect Notion** — Claude: Settings → Connectors → Notion. Codex: enable the Notion connector. No account? Sign up free at https://www.notion.so .
2. **Set your memory notebook** — edit `~/.config/ai-memory/config` (`NOTION_MEMORY_ROOT`).

`install.sh` is idempotent and backs up anything it touches. It symlinks the skill into Claude (`~/.claude/skills`) and Codex (`~/.codex/skills`), installs the `/sync-memory` command, and adds a `SessionStart` hook that auto-pulls skill updates.

## Usage
When a conversation produced something you'll want later — a project decision, a deploy step, a travel plan, anything — say **"save this to Notion"** or run **`/sync-memory`**. It files it by **area → sub-topic** into your Notion. **It never writes automatically — you stay in control.**

## What you can keep in it
- **Projects** — overview, stack, links, status, **docs, architecture & design, decisions** (a lightweight project hub).
- **Tech / ops** — deploy steps, ports, configs, exact CLI flags, pitfalls (Alibaba Cloud, Cloudflare, …).
- **Life** — travel, purchases, plans, preferences — anything worth remembering.

## How it's built
- **Memory** lives in your **Notion** — the single, cross-machine source of truth.
- **The connection** is the official **Notion MCP** (works in Claude & Codex).
- **The update policy** lives in [`skills/notion-memory/SKILL.md`](skills/notion-memory/SKILL.md): save anything worth remembering, organize by area→sub-topic (never by date), UPSERT (search → update in place, else create), keep facts verbatim, stay safe under concurrent edits from multiple machines.
- **Triggers** are event-based, never clock-based — see [docs/triggers.md](docs/triggers.md).

## Add another machine
Same `clone + ./install.sh + connect Notion`. Edit the skill anywhere → `git push`; every machine auto-pulls it on session start. See [docs/second-machine.md](docs/second-machine.md).

## Optional: full auto-sync (experimental)
`./enable-autosync.sh` turns on "sync at end of session"; `./disable-autosync.sh` turns it off. Connect Notion and test first.

## Uninstall
`./uninstall.sh` — removes this machine's symlinks and hooks; leaves the repo and your Notion data untouched.

## Privacy & security
- Nothing leaves your machine except what is written to **your own Notion**.
- The system **writes nothing automatically** — every save is triggered by you.
- **Never store secrets** (passwords, API keys, tokens) in memory — only note *where to find them*.

## License
[MIT](LICENSE). Contributions welcome.
