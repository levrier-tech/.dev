# Claude Code — Lévrier Tech workspace

Full org-wide rules (commit format, restrictions) live in [AGENTS.md](AGENTS.md).
This file adds Claude Code-specific context.

## Workspace layout

All repos are bind-mounted at `/workspaces/<name>` and open together in
`levrier-tech.code-workspace`:

| Path | Repo | Role |
| ---- | ---- | ---- |
| `/workspaces/levrier-tech-dev` | `.dev` | Orchestration — canonical AGENTS.md, devcontainer, scripts |
| `/workspaces/.github` | `.github` | Org-wide GitHub config |
| `/workspaces/brigid` | `brigid` | Main project repository |

This is a bootstrap-stage organization — only 2 sibling repos exist today. Expect this
table to grow as new repos are added under `levrier-tech`.

## Cross-repo commands (run from `/workspaces/levrier-tech-dev`)

```bash
pnpm run status:all   # git status -sb in every repo
pnpm run fetch:all    # git fetch --all --prune in every repo
pnpm run pull:all     # git pull --rebase in every repo
pnpm run branch:all   # show active branch in every repo
```

## Common gotchas

**Commit scopes**: always read `scopes.json` at the active repo root before choosing a scope.
Never invent a scope that isn't listed. Full type→emoji mapping: `/workspaces/levrier-tech-dev/commit-convention.json`.
Use `/commit` (Claude Code slash command) to auto-generate a message from staged changes.

**pnpm install on rebuild**: handled by the `package-auto-install` devcontainer feature with
`autoDiscover` (parses `levrier-tech.code-workspace`) and the `pnpm-store` feature's own shared
volume — not by a manual loop in `setup-container.sh`.

**Adding a sibling repo**: update `repos.json`, `levrier-tech.code-workspace`, and
`.devcontainer/devcontainer.json` (mounts + `LT_REPOS`) together.

**Git workflow**: `main` and `dev/*` are protected — never push directly. Branch from `dev/*`
(`feat/*`/`bug/*`) or from `main` for an urgent prod fix (`hotfix/*`). Every merge is rebase +
fast-forward only — rebase onto the target's tip before merging, no merge commits, no squash.
The agent never merges (including the fast-forward step) — that's always a human action. See
AGENTS.md's Git Workflow section.

## AI persistence

`~/.claude` is bind-mounted from a **per-devcontainer** volume and symlinked at every container
start by `claude-dev` — isolated to this project, not shared with any other org's devcontainer.
Memory, credentials, and settings survive rebuilds of this same devcontainer.
