# AGENTS.md — Lévrier Tech `.dev`

This repository is the **shared workspace** for the Lévrier Tech organization. Every levrier-tech repository
inherits these rules; per-repo `AGENTS.md` files only add project-specific details.

**Lévrier Tech** — website: <https://levrier.tech/>

## Language

**All content in all Lévrier Tech repositories must be in English** — code, comments,
doc-comments, commit messages, issues, pull requests, specs, logs, and configuration.
This rule applies to every sibling repository. No exceptions.

## Restrictions

- **NEVER use GPT models** — Use Claude models only (claude-sonnet-4.x, Claude Opus 4.x+).

## Code Comments

Write comments for someone reading the code cold — they never see the diff or the previous
version, only what's in front of them. Describe what the code *is* and *why* it's that way,
never what changed to get there.

- ❌ `contents: write # was read-only — this job now also commits X`
- ✅ `contents: write # commits X`

If a comment needs "was"/"before"/"previously"/"now" (or a timestamp: "as of writing", "since
last month") to make sense, that content belongs in the commit message or PR description, not
the code — it rots the moment someone reads the file without the diff in front of them.

## Scope

- VS Code multi-root workspace (`levrier-tech.code-workspace`)
- devcontainer setup (`.devcontainer/`)
- shared AI / agent guidance

This repository contains **no product runtime code** — it is configuration and documentation only.

### Project structure

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

## Workspace structure

All repositories are cloned as siblings under `/workspaces/` by the `org-workspace` devcontainer
feature (`.devcontainer/devcontainer.json`) — only `.dev` itself is bind-mounted from the host.
This is what makes the devcontainer work identically on a local checkout (Docker Desktop/WSL2)
and on GitHub Codespaces, which only ever checks out the one repo you launch the codespace from.
`levrier-tech.code-workspace` is kept up to date by the same feature.

| Path | Repo | Purpose |
| --- | --- | --- |
| `/workspaces/.dev` | `levrier-tech/.dev` | Orchestration workspace + unified DevContainer + canonical agent rules |
| `/workspaces/.github` | `levrier-tech/.github` | Org-wide GitHub config (community files, templates, profile) |
| `/workspaces/brigid` | `levrier-tech/brigid` | Main project repository |

## Devcontainer — available tools

The container is self-contained; no host toolchain installation is needed.

- Node.js 26
- `pnpm` (via `helpers4/devcontainer/pnpm-store` + `typescript-dev`), dependencies installed on container creation (`package-auto-install`)
- `vp` (Vite+: Oxlint/Oxfmt, Vitest)
- `gh` CLI
- `git-absorb`
- Docker CLI (talks to the host Docker daemon)
- Claude Code (CLI + VS Code extension) with Remote Control enabled — `claude-rc status` inside the container
- `org-workspace`: clones the org repos into `/workspaces` and keeps the `.code-workspace` file up to date

## Rules

- Treat this repository as configuration/documentation only — no product runtime code, packages,
  or build outputs.
- Do not duplicate per-repo agent rules — they live in each repo's own `AGENTS.md`.
- Add future repositories as siblings of `.dev/`, not nested inside it. Nothing to update by hand:
  `org-workspace` discovers the org repos and keeps `levrier-tech.code-workspace` up to date (tune its
  options in `.devcontainer/devcontainer.json`).
- Do not implement the product plan here unless the task is explicitly about shared tooling.

## Commit conventions

Format: `type(scope): <emoji> description`
([Conventional Commits](https://www.conventionalcommits.org/) + [gitmoji](https://gitmoji.dev))

- Description ≤72 chars, lowercase, imperative mood, no trailing period
- Exactly ONE emoji, between the colon and the description
- Several logical changes → one dominant type in the subject, a bullet list in the body

| Type | Emoji | Alternatives | When |
| ---- | ----- | ------------ | ---- |
| `feat` | ✨ | 🚸 UX · ♿️ a11y · 🌐 i18n · 💬 text | New feature |
| `fix` | 🐛 | 🚑️ hotfix · 🔒️ security · 🩹 trivial · 🥅 errors · 🚨 warnings · ✏️ typo | Bug fix |
| `docs` | 📝 | 💡 comments · 📄 license | Documentation |
| `refactor` | ♻️ | 🎨 structure · 🔥 remove · ⚰️ dead code · 🚚 move/rename | Refactor |
| `test` | ✅ | 🧪 failing · 💚 fix CI | Tests |
| `chore` | 🔧 | 🙈 gitignore · 🔖 release · 📌 pin deps · 🩺 healthcheck | Maintenance |
| `perf` | ⚡️ | | Performance |
| `style` | 💄 | 🎨 code style | Style |
| `ci` | 👷 | 💚 fix CI | CI/CD |
| `build` | 📦️ | ➕ add · ➖ remove · ⬆️ upgrade · ⬇️ downgrade dep | Build |
| `revert` | ⏪️ | | Revert |

Machine-readable source: `commit-convention.json` at this repo's root (also read by the
`/commit` slash command).

### Allowed scopes

Scopes live in `scopes.json` at this repo's root (machine-readable source of truth, also read by
the `/commit` slash command and mirrored in `.vscode/settings.json`):

| Scope | Maps to |
| --- | --- |
| `workspace` | `levrier-tech.code-workspace`, root-level config |
| `devcontainer` | `.devcontainer/` |
| `ai` | Agent guidance (`AGENTS.md`, `CLAUDE.md`, `.claude/`), prompt files |
| `docs` | `README.md` and other documentation |
| `ci` | `.github/workflows/` (if any) |
| `deps` | Dependency bumps |

**Do not use a scope outside this list.** If a new top-level concern is added, update
`scopes.json` (and this table) and `.vscode/settings.json` together.

```text
docs(docs): 📝 document the local devcontainer quick start
chore(devcontainer): 🔧 enable claude remote control
```

## Git Workflow

Default policy — nuanced, not a hard rule: ask if a specific task calls for
something different, but absent other instructions:

1. **Branch** — work on a branch, never directly on `main`. Create the branch
   (`git checkout -b <name>`) *before* the first commit — never commit while
   on `main` and rename the branch afterward, since that can leave the
   branch's upstream tracking pointed at `origin/main` and let a later push
   land directly on `main` unnoticed. Group related changes on the same
   branch instead of opening a new one per small change.
2. **Commit** — one commit per subject, Conventional Commits format mandatory
   (see Commit conventions above).
3. **Push** — only once it looks safe to do so; a human review of the diff
   first is recommended for anything non-trivial. Ask if unsure.
4. **Pull Request** — open one once pushed.
5. **Merge** — never merge. Merging is always a human decision.

A narrow, temporary carve-out (e.g. "push straight to `main` for this one fix")
may be granted in conversation for a specific piece of work — treat it as
scoped to exactly what was said, never as a standing precedent to reuse
elsewhere or later without asking again.

## Inheritance

This repo's *shape* (`CLAUDE.md`, `scopes.json`, `commit-convention.json`,
`.claude/commands/commit.md`, `org-workspace`-based devcontainer) is ported from
[helpers4/.dev](https://github.com/helpers4/.dev) and [tuxery/.dev](https://github.com/tuxery/.dev).
License: MIT.
