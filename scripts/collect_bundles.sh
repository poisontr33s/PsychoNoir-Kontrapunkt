#!/usr/bin/env bash
set -euo pipefail

# Controller script: collect bundles and summaries from Codespaces
# Requires gh CLI authenticated on controller machine

REPO="poisontr33s/PsychoNoir-Kontrapunkt"
OUT_BUNDLES_DIR="collected_bundles"
OUT_SUMMARIES_DIR="collected_summaries"
mkdir -p "${OUT_BUNDLES_DIR}" "${OUT_SUMMARIES_DIR}"

codespaces=$(gh codespace list --repo "${REPO}" --limit 200 --json name -q '.[].name')

for cs in ${codespaces}; do
  echo "Collecting from ${cs}..."
  # copy bundles (if any)
  gh codespace scp --codespace "${cs}":./archive/*predelete*.bundle "${OUT_BUNDLES_DIR}/" 2>/dev/null || echo "No bundle found for ${cs} or scp failed"
  # copy summary
  gh codespace scp --codespace "${cs}":/tmp/prepare_for_deletion_summary.json "${OUT_SUMMARIES_DIR}/${cs}-prepare_for_deletion_summary.json" 2>/dev/null || echo "No summary found for ${cs}"
done

echo "Collections complete. Bundles in ${OUT_BUNDLES_DIR}, summaries in ${OUT_SUMMARIES_DIR}"
