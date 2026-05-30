---
description: Save anything worth remembering from this conversation to your Notion memory (via the notion-memory skill)
---

Use the **notion-memory** skill to review this conversation and save anything worth remembering long-term to Notion.

Follow the skill's rules:
- Save anything you'll plausibly want again — project info / docs / architecture / decisions, technical & ops know-how (ports, exact CLI flags, pitfalls), or non-technical things (travel, purchases, plans, preferences). Skip chit-chat / one-off / generic knowledge. **Never store secrets** — only where to find them.
- Organize by **area → sub-topic**, never by date.
- **UPSERT**: search Notion first; update the existing topic in place (no duplicates); create only if missing.
- Keep facts/commands verbatim; update the `Last-updated` / `Updated-by` provenance.

If nothing is worth saving, just say so in one line.
