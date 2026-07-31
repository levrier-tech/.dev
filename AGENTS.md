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
- Allowed scopes are repo-specific — see each repo's `.vscode/settings.json` (`conventionalCommits.scopes`)

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

## Git Workflow

Lévrier Tech ships to production, so branches go through an intermediate stage before `main`.
Every merge is **rebase + fast-forward only** — no merge commits, no squash merges, anywhere.

**Branches:**

| Branch | Purpose | Lifetime |
| --- | --- | --- |
| `main` | Production | Permanent |
| `dev/*` (e.g. `dev/2026-08`) | Internal/staging release train | One per cycle — deleted after merging into `main` |
| `hotfix/*` | Urgent production fix, bypasses `dev/*` | One per fix — deleted after merging into `main` |
| `feat/*`, `bug/*` | Regular work | One per change — deleted after merging into the current `dev/*` |

**Merging (always via PR, never a direct push to `main` or `dev/*`):**

- `feat/*` / `bug/*` → rebase onto the current `dev/*` tip, then fast-forward merge into `dev/*`.
- `dev/*` → rebase onto `main`'s tip, then fast-forward merge into `main`.
- `hotfix/*` → branched from `main`, rebase onto `main`'s tip, then fast-forward merge into `main`.
- If a `hotfix/*` lands on `main` while a `dev/*` is still in flight, rebase that `dev/*` onto the
  new `main` before its own merge — fast-forward tolerates no divergence.
- Releases are tracked with **tags on `main`** (there's no merge commit to mark them, since every
  merge is a fast-forward).

## This Repository (.dev)

**Purpose:** Orchestrate the Lévrier Tech organization — multi-root VS Code workspace, unified DevContainer, canonical agent rules, shared VS Code settings.

### Project Structure

```
.dev/
├── .devcontainer/
│   ├── devcontainer.json       # Cross-repo dev environment
│   └── setup-container.sh      # postCreateCommand: clone-fallback + install
├── .vscode/
│   └── settings.json           # Repo-specific overrides (scopes)
├── scripts/
│   ├── repos.mjs               # Source of truth (reads repos.json)
│   ├── run-each.mjs            # Run a pnpm script in every sibling repo
│   └── git-each.mjs            # Run a git command in every sibling repo
├── levrier-tech.code-workspace # Multi-root workspace + shared settings
├── repos.json                  # List of sibling repos
├── package.json                # Cross-repo orchestration scripts
├── AGENTS.md                   # This file (canonical org-wide rules)
├── README.md
└── LICENSE                     # MIT
```

Sibling repos (`.github`, `brigid`) live **next to** this folder on the host. The devcontainer bind-mounts each of them at `/workspaces/<name>`.

### What NOT to do here

- Do **not** add runtime code, packages, or build outputs. This repo is configuration only.
- Do **not** duplicate per-repo agent rules — they live in their own `AGENTS.md`.
- When adding a new sibling repo, update `repos.json`, `levrier-tech.code-workspace`, and `.devcontainer/devcontainer.json` together.

## Inheritance

This repo's *shape* (`CLAUDE.md`, `scopes.json`, `commit-convention.json`,
`.claude/commands/commit.md`) is ported from
[helpers4/.dev](https://github.com/helpers4/.dev)'s canonical setup. Deltas from that shape:
- **License: MIT** (not LGPL-3.0-or-later).
- **Bootstrap-stage org** — only 2 sibling repos (`.github`, `brigid`) today, no product-specific
  stack conventions yet.
