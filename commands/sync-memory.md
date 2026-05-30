---
description: Save this conversation's reusable operational knowledge to Notion (via the notion-memory skill)
---

Use the **notion-memory** skill to review this conversation and save any **reusable operational knowledge** to Notion.

Follow the skill's rules exactly:
- Only save genuinely reusable ops knowledge (deploy steps, ports, configs, exact CLI flags, pitfalls). Skip chit-chat / one-off / generic stuff.
- Organize by **task → sub-topic**, never by date.
- **UPSERT**: search Notion first; update the existing topic in place (no duplicates); create only if missing.
- Keep commands verbatim; update the `Last-updated` / `Updated-by` provenance fields.

If nothing is worth saving, just say so in one line.
