#!/usr/bin/env bash
# Lévrier Tech orchestrator — devcontainer setup
#
# 1. Run `pnpm install` on each sibling that has a package.json (best effort).
set -euo pipefail

echo "✨ Setting up Lévrier Tech workspace…"

if command -v pnpm >/dev/null 2>&1; then
  PNPM_STORE_VOL="/.pnpm-store"
  if [ -d "$PNPM_STORE_VOL" ]; then
    sudo chown -R node:node "$PNPM_STORE_VOL" 2>/dev/null || true
  fi
  PNPM_RC="${HOME}/.npmrc"
  if ! grep -q "^store-dir" "$PNPM_RC" 2>/dev/null; then
    printf 'store-dir=%s\n' "$PNPM_STORE_VOL" >> "$PNPM_RC"
  fi

  # Repos are cloned by the org-workspace feature into /workspaces/<repo>.
  for target in /workspaces/*/; do
    target="${target%/}"
    repo="$(basename "${target}")"
    if [ -f "${target}/package.json" ]; then
      echo "📦 pnpm install — ${repo}"
      (cd "${target}" && pnpm install --prefer-offline) \
        || echo "⚠️  pnpm install failed in ${repo} (continuing)"
    fi
  done
fi

echo ""
echo "🎉 Lévrier Tech workspace ready."
echo "   Open levrier-tech.code-workspace to load every repo at once."
echo "   Try: pnpm run status:all | pull:all | branch:all"
