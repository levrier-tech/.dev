# AGENTS.md — Lévrier Tech organization (canonical)

This is the **canonical, org-wide** agent guidance for the Lévrier Tech organization.
Every levrier-tech repository inherits these rules. Per-repo `AGENTS.md` files only add
project-specific details on top of what is defined here.

## ⛔ CRITICAL RESTRICTIONS

- **NEVER execute `git push`** — The user pushes manually after review.
- **NEVER execute `git commit` or `git add`** — The user stages and commits manually. Fix files, then stop.
- **NEVER use GPT models** — Use Claude models only (claude-sonnet-4.x, Claude Opus 4.x+).
- **Everything in English** — Code, comments, commits, documentation, logs, PR descriptions.

## Organization Context

**Lévrier Tech** — website: <https://levrier.tech/>

Repositories in this organization:

| Repo | Purpose |
| --- | --- |
| [`.dev`](https://github.com/levrier-tech/.dev) | Orchestration workspace + unified DevContainer + canonical agent rules |
| [`.github`](https://github.com/levrier-tech/.github) | Org-wide GitHub config (community files, templates, profile) |
| [`brigid`](https://github.com/levrier-tech/brigid) | Main project repository |

## Commit Messages

All repos follow [Conventional Commits](https://www.conventionalcommits.org/) with a **gitmoji** between the scope and the description.

**Format:** `<type>(<scope>): <emoji> <description>`

**Rules:**
- Description ≤72 chars, lowercase, imperative mood, no trailing period
- Always include exactly ONE emoji
- Multiple logical changes → bullet list in body
- Allowed scopes are repo-specific — see each repo's `scopes.json`

**Type / emoji table:**

| Type | Primary | When to use |
| --- | --- | --- |
| feat | ✨ | New feature |
| fix | 🐛 | Bug fix |
| docs | 📝 | Documentation |
| refactor | ♻️ | Code refactoring |
| test | ✅ | Tests |
| chore | 🔧 | Maintenance |
| perf | ⚡️ | Performance |
| style | 💄 | Code style / UI |
| ci | 👷 | CI/CD |
| build | 📦️ | Build system / deps |
| revert | ⏪️ | Revert |

## This Repository (.dev)

**Purpose:** Orchestrate the Lévrier Tech organization — multi-root VS Code workspace, unified DevContainer, canonical agent rules, shared VS Code settings.

### Project Structure

```
.dev/
├── .devcontainer/
│   └── devcontainer.json       # Cross-repo dev environment (org-workspace clones siblings)
├── .vscode/
│   └── settings.json           # Repo-specific overrides (scopes)
├── .claude/commands/commit.md  # /commit slash command
├── commit-convention.json      # Full type→emoji mapping
├── scopes.json                 # Allowed commit scopes for this repo
├── CLAUDE.md                   # Claude Code-specific pointer
├── levrier-tech.code-workspace # Multi-root workspace + shared settings
├── AGENTS.md                   # This file (canonical org-wide rules)
├── README.md
└── LICENSE                     # MIT
```

Sibling repos (`.github`, `brigid`, …) are cloned by the `org-workspace` devcontainer feature at `/workspaces/<name>`, next to this folder.

### What NOT to do here

- Do **not** add runtime code, packages, or build outputs. This repo is configuration only.
- Do **not** duplicate per-repo agent rules — they live in their own `AGENTS.md`.
- When adding a new sibling repo, nothing to update by hand: `org-workspace` discovers the org repos and keeps `levrier-tech.code-workspace` up to date (tune its options in `.devcontainer/devcontainer.json`).
