# TODO — Rollout: main / dev/\* / hotfix/\* workflow

One-time migration to the branch/merge model documented in [AGENTS.md](AGENTS.md)'s
"Git Workflow" section. Checked against the real state of every repo on 2026-07-31 —
nothing on GitHub has been changed yet, this is a checklist.

## ⚠️ Blocker for `brigid`

`levrier-tech/brigid` is **private**, and the `levrier-tech` org is on GitHub's **free** plan.
Classic branch protection is not available on private repos on the free plan — confirmed via
the API (`GET .../branches/main/protection` → 403 "Upgrade to GitHub Pro... or make this
repository public"). Before any protection can be configured on `brigid`, pick one:

- make `brigid` public, or
- upgrade the `levrier-tech` org to a paid plan (GitHub Team, ~$4/user/month).

`.dev` and `.github` are public, so they're unaffected by this and can be configured right away.

## Current state (as of 2026-07-31)

| Repo | Visibility | `main` protection | CI |
| --- | --- | --- | --- |
| `.dev` | public | none | no workflows |
| `.github` | public | none | no workflows |
| `brigid` | private | blocked by plan (see above) | no workflows yet |

All repos' GitHub default branch is already `main` — no rename needed.

## Per-repo checklist (once unblocked for `brigid`)

- [ ] Repo settings → Pull Requests: enable only "Allow rebase merging"; disable "Allow merge commits" and "Allow squash merging".
- [ ] Branch protection rule for `main`: require a PR before merging, no direct pushes, no force-pushes, no deletions.
- [ ] Branch protection rule (or ruleset) for pattern `dev/*`: same restrictions as `main`.
- [ ] Branch protection rule (or ruleset) for pattern `hotfix/*`: same restrictions.
- [ ] Cut the first `dev/<cycle>` (e.g. `dev/2026-08`) from `main` in every repo.

## Not yet done

Nothing on GitHub (repo settings, branch protection) has been touched for this rollout — only
this org's `AGENTS.md`/`CLAUDE.md` docs are updated so far.
