# Lévrier Tech `.dev`

Dev workspace orchestrator for the [Lévrier Tech](https://levrier.tech/) organization.

## What's in here

| File / folder | Purpose |
| --- | --- |
| `.devcontainer/` | Unified DevContainer (`org-workspace` clones the org repos) |
| `.vscode/settings.json` | Shared editor settings |
| `levrier-tech.code-workspace` | Multi-root VS Code workspace |
| `AGENTS.md` | Canonical AI / agent rules for all levrier-tech repos |

## Quick start

```bash
mkdir levrier-tech && cd levrier-tech
gh repo clone levrier-tech/.dev
gh repo clone levrier-tech/.github
gh repo clone levrier-tech/brigid
code .dev/levrier-tech.code-workspace
```

Or open `.dev` in VS Code and **Reopen in Container** — missing repos are cloned automatically.

## Host setup

Export a GitHub token scoped to levrier-tech before opening the devcontainer:

```bash
export GH_TOKEN_FOR_LEVRIER_TECH=<your-token>
```
