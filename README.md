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

Secrets (`GH_TOKEN`, …) come from OpenBao — `kv/orgs/levrier-tech`, plus `kv/shared/*` — through the
[`openbao-env`](https://github.com/helpers4/devcontainer/tree/main/src/openbao-env) feature, into
every process of the container (VS Code included). On fajro, `devc up levrier-tech` hands the
container its credentials. In GitHub Codespaces, set the Codespaces secrets `BAO_ROLE_ID` and
`BAO_SECRET_ID` (AppRole `levrier-tech`) and give the codespace Tailscale access: OpenBao is only
reachable on the tailnet.
