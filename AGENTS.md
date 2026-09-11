# AGENTS.md — Lévrier Tech organization (canonical)

This is the **canonical, org-wide** agent guidance for the Lévrier Tech organization.
Every levrier-tech repository inherits these rules. Per-repo `AGENTS.md` files only add
project-specific details on top of what is defined here.

## Restrictions

- **Everything in English** — Code, comments, commits, documentation, logs, PR descriptions.

See **Git Workflow** below for the default branch/commit/push/PR policy.

## Code Comments

Write comments for someone reading the code cold — they never see the diff or the previous
version, only what's in front of them. Describe what the code *is* and *why* it's that way,
never what changed to get there.

- ❌ `contents: write # was read-only — this job now also commits X`
- ✅ `contents: write # commits X`

If a comment needs "was"/"before"/"previously"/"now" (or a timestamp: "as of writing", "since
last month") to make sense, that content belongs in the commit message or PR description, not
the code — it rots the moment someone reads the file without the diff in front of them.

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

Default policy for the agent — nuanced, not a hard rule: ask if a specific task calls for
something different, but absent other instructions — branch (create it with `git checkout -b
<name>` *before* the first commit; never commit while on `main` and rename the branch afterward,
which can leave its upstream tracking pointed at `origin/main` and let a later push land directly
on `main` unnoticed), commit by subject (Conventional Commits mandatory), push only once it looks safe (a human review of the diff first is
recommended, especially for anything non-trivial — ask if unsure), open a PR, and never merge
(including the fast-forward step below) — merging is always a human decision. A narrow,
temporary carve-out (e.g. "push straight to `main` for this one fix") may be granted in
conversation for a specific piece of work — treat it as scoped to exactly what was said, never
as a standing precedent to reuse elsewhere or later without asking again.

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
│   ├── devcontainer.json       # Cross-repo dev environment (named volumes)
│   └── setup-container.sh      # postCreateCommand: clone-if-empty per volume
├── .vscode/
│   └── settings.json           # Repo-specific overrides (scopes)
├── levrier-tech.code-workspace # Multi-root workspace + shared settings
├── AGENTS.md                   # This file (canonical org-wide rules)
├── README.md
└── LICENSE                     # MIT
```

Sibling repos (`.github`, `brigid`) each live on their own named Docker volume, not a
host bind-mount — `setup-container.sh` clones them from GitHub the first time the
volume is empty, so the devcontainer works identically on GitHub Codespaces and local
Docker Desktop/WSL2. No `repos.json`/`scripts/`/`package.json` orchestration layer —
the sibling list lives only in `devcontainer.json`'s `LT_REPOS`.

### What NOT to do here

- Do **not** add runtime code, packages, or build outputs. This repo is configuration only.
- Do **not** duplicate per-repo agent rules — they live in their own `AGENTS.md`.
- When adding a new sibling repo, update `levrier-tech.code-workspace` and
  `.devcontainer/devcontainer.json` (`mounts` + `LT_REPOS`) together.

## Inheritance

This repo's *shape* (`CLAUDE.md`, `scopes.json`, `commit-convention.json`,
`.claude/commands/commit.md`) is ported from
[helpers4/.dev](https://github.com/helpers4/.dev)'s canonical setup. Deltas from that shape:
- **License: MIT** (not LGPL-3.0-or-later).
- **Bootstrap-stage org** — only 2 sibling repos (`.github`, `brigid`) today, no product-specific
  stack conventions yet.
- **Git Workflow structure**: mirrors [brig-id/roots](https://github.com/brig-id/roots)'s
  `dev/*`/`hotfix/*` release-train model rather than helpers4's simpler default flow — Lévrier
  Tech also ships to production, so the same rebase+fast-forward discipline applies here.
- **Orchestration**: sibling repos are cloned onto named Docker volumes by
  `setup-container.sh` (matching `tuxery/.dev` and `brig-id/roots`), not tracked via
  `repos.json`/`scripts/`/`package.json`.
