#!/usr/bin/env bash
# Lévrier Tech orchestrator — devcontainer setup
#
# For every sibling repo declared in $LT_REPOS, ensure it exists at
# /workspaces/<repo>. Each lives on its own named Docker volume (see
# devcontainer.json's "mounts") — this loop only actually clones on a fresh
# volume (first run, or after a full teardown), never on a plain rebuild.
# pnpm install is handled by the package-auto-install feature (autoDiscover).
set -euo pipefail

echo "✨ Setting up Lévrier Tech workspace…"

ORG="${LT_ORG:-levrier-tech}"
REPOS="${LT_REPOS:-.github brigid}"

for repo in $REPOS; do
  target="/workspaces/${repo}"
  if [ -d "${target}/.git" ] || [ -f "${target}/package.json" ] || [ -n "$(ls -A "${target}" 2>/dev/null || true)" ]; then
    echo "✓ ${repo}: already present"
    continue
  fi

  echo "→ ${repo}: cloning missing sibling repository"
  rm -rf "${target}" 2>/dev/null || true
  if command -v gh >/dev/null 2>&1; then
    gh repo clone "${ORG}/${repo}" "${target}" || echo "⚠️  ${repo}: clone failed (continuing)"
  else
    git clone "https://github.com/${ORG}/${repo}.git" "${target}" || echo "⚠️  ${repo}: clone failed (continuing)"
  fi
done

echo ""
echo "🎉 Lévrier Tech workspace ready."
echo "   Open levrier-tech.code-workspace to load every repo at once."
echo "   Try: pnpm run status:all | pull:all | branch:all"
