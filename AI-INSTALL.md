# AI-INSTALL — let your AI assistant set this up for you / 让你的 AI 助手帮你装好

**Not a programmer? You don't have to be.** Open **Claude Code**, **Claude Desktop**, or **Codex** and paste this one line:

> Please set up the "notion-memory" system by following the AI-INSTALL.md at
> https://github.com/sasa935/notion-memory — do the steps for me, explain each in plain
> language, and only ask me when I personally need to click something (like signing into Notion).

**不会编程也没关系。** 打开 Claude Code / Claude Desktop / Codex,把上面这句话发给它就行。它会照着下面的步骤帮你全部弄好。

---

## Instructions for the AI assistant — follow these steps in order

You are installing **notion-memory** for a possibly non-technical user. **Do the work yourself** using your shell/file tools; explain each step in plain language; only pause at steps marked 🧑 where the user must personally act.

1. **Check prerequisites.** Run `git --version`. If git is missing, tell the user the one command to install it for their OS (e.g. `xcode-select --install` on macOS) and wait.

2. **Clone the repo** into the user's home folder (or a folder they prefer):
   ```bash
   git clone https://github.com/sasa935/notion-memory ~/notion-memory
   ```

3. **Run the installer:**
   ```bash
   bash ~/notion-memory/install.sh
   ```
   It is idempotent and backs up anything it changes. It will: symlink the `notion-memory` skill into Claude (`~/.claude/skills`) and Codex (`~/.codex/skills`), install the `/sync-memory` command, add a `SessionStart` hook that auto-pulls skill updates, and create `~/.config/ai-memory/config`. Relay what it printed.

4. 🧑 **Connect Notion (needs the user's own login — you cannot do this for them).**
   - In **Claude**: Settings → Connectors → add **Notion** → sign in.
   - In **Codex**: ensure the **Notion** connector/plugin is enabled.
   - No Notion account? Point them to https://www.notion.so to sign up (free), then continue.
   - **Wait** for the user to confirm Notion is connected before going on.

5. 🧑 **Pick the memory notebook.** Ask: *"What should I name the Notion page that stores your AI memory?"* (default: `AI Memory`). If it doesn't exist, offer to create it via the Notion connector. Then write the choice into the config:
   ```bash
   printf 'NOTION_MEMORY_ROOT=%s\n' "<the name they chose>" > ~/.config/ai-memory/config
   ```

6. **Verify.** Confirm `~/.claude/skills/notion-memory/SKILL.md` exists. Then run a tiny end-to-end test: ask the user for one small ops fact they always forget (a command, a port…), use the `notion-memory` skill to save it, and confirm it shows up in their Notion.

7. **Teach usage in plain language:**
   - *"Any time a chat gives you something worth keeping — a deploy step, a port, an exact command, a gotcha — just say **'save this to Notion'** or type **/sync-memory**. I'll file it under the right topic in your Notion."*
   - *"It never writes on its own — you're always in control."*
   - *"On another computer, do the same: clone, run install, connect Notion — and you share the same memory everywhere."*

## Safety rules for the AI (do not skip)
- **Never** store secrets, passwords, API keys, or tokens in memory — only note *where to find them*.
- The system writes only to the **user's own Notion**; nothing is sent anywhere else.
- **Do not** enable the experimental auto-sync (`enable-autosync.sh`) unless the user explicitly asks for it.
