# Lévrier Tech `.dev`

Dev workspace orchestrator for the [Lévrier Tech](https://levrier.tech/) organization.

## What's in here

| File / folder | Purpose |
| --- | --- |
| `.devcontainer/` | Unified DevContainer (mounts all sibling repos) |
| `.vscode/settings.json` | Shared editor settings |
| `scripts/` | Cross-repo helpers (`git-each`, `run-each`) |
| `levrier-tech.code-workspace` | Multi-root VS Code workspace |
| `repos.json` | Source of truth for sibling repo list |
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

## Cross-repo scripts

```bash
pnpm run status:all   # git status in every repo
pnpm run pull:all     # git pull --rebase in every repo
pnpm run branch:all   # current branch in every repo
pnpm run build:all    # pnpm build in every repo that has it
```

## Host setup

Export a GitHub token scoped to levrier-tech before opening the devcontainer:

```bash
export GH_TOKEN_FOR_LEVRIER_TECH=<your-token>
```
