# Lévrier Tech `.dev`

Dev workspace orchestrator for the [Lévrier Tech](https://levrier.tech/) organization.

## What's in here

| File / folder | Purpose |
| --- | --- |
| `.devcontainer/` | Unified DevContainer (named volume per sibling repo) |
| `.vscode/settings.json` | Shared editor settings |
| `levrier-tech.code-workspace` | Multi-root VS Code workspace |
| `AGENTS.md` | Canonical AI / agent rules for all levrier-tech repos |

## Quick start

Open this repo in VS Code and **Reopen in Container** (or launch a Codespace on
`levrier-tech/.dev` directly) — `setup-container.sh` clones every sibling repo listed in
`.devcontainer/devcontainer.json`'s `LT_REPOS` into its own volume automatically, nothing to
pre-clone.

## Host setup

Export a GitHub token scoped to levrier-tech before opening the devcontainer:

```bash
export GH_TOKEN_FOR_LEVRIER_PROJECT=<your-token>
```
