# Claude Code — Lévrier Tech workspace

Full canonical rules (commit format, restrictions, language) live in
[AGENTS.md](AGENTS.md). This file adds Claude Code-specific context.

## Workspace layout

Sibling repos are cloned by the `org-workspace` devcontainer feature into
`/workspaces/<repo>` (named Docker volumes, not host bind mounts) and open together in
`levrier-tech.code-workspace`. A plain "Rebuild Container" keeps uncommitted/unpushed work; only a
full teardown (`docker volume rm`, deleted Codespace) resets a volume to a fresh clone.
**This is a safety net, not a substitute for pushing.** `.dev` itself is host bind-mounted at
`/workspaces/.dev`.

## Common gotchas

**Commit scopes**: always read `scopes.json` at the active repo root before choosing a scope.
Never invent a scope that isn't listed. Full type→emoji mapping: `/workspaces/.dev/commit-convention.json`.
Use `/commit` (Claude Code slash command) to auto-generate a message from staged changes.
