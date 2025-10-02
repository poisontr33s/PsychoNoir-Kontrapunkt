#!/usr/bin/env bash
set -euo pipefail

# Controller script: iterate Codespaces for repo and run DRY_RUN=1
# Requires: gh CLI authenticated on controller machine

REPO="poisontr33s/PsychoNoir-Kontrapunkt"
OUT_DIR="collected_summaries"
mkdir -p "${OUT_DIR}"

echo "Listing Codespaces for ${REPO}..."
codespaces=$(gh codespace list --repo "${REPO}" --limit 200 --json name -q '.[].name')

if [ -z "${codespaces}" ]; then
  echo "No Codespaces found or gh query returned empty."
  exit 0
fi

echo "Found codespaces: ${codespaces}"

for cs in ${codespaces}; do
  echo "Running DRY_RUN on ${cs}..."
  # Run script in Codespace (DRY_RUN=1)
  gh codespace ssh --codespace "${cs}" -- bash -lc 'DRY_RUN=1 bash -s' < ./scripts/prepare_for_deletion.sh || {
    echo "DRY_RUN failed for ${cs}"; continue
  }
  # Copy summary back
  echo "Copying summary from ${cs}..."
  gh codespace scp --codespace "${cs}":/tmp/prepare_for_deletion_summary.json "${OUT_DIR}/${cs}-prepare_for_deletion_summary.json" || echo "Failed to copy summary from ${cs}"
done

echo "All done. Summaries are in ${OUT_DIR}"
