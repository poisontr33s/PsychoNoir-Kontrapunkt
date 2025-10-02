#!/usr/bin/env bash
set -euo pipefail

# automate_archive_controller.sh
# High-level orchestration: run DRY_RUN across Codespaces, collect bundles and summaries, and produce a consolidated report.
# Requires: gh CLI authenticated on controller machine.

REPO="poisontr33s/PsychoNoir-Kontrapunkt"
SUM_DIR="collected_summaries"
BUNDLE_DIR="collected_bundles"
mkdir -p "${SUM_DIR}" "${BUNDLE_DIR}"

echo "Listing Codespaces for ${REPO}..."
codespaces=$(gh codespace list --repo "${REPO}" --limit 200 --json name -q '.[].name')
if [ -z "${codespaces}" ]; then
  echo "No Codespaces found. Exiting."
  exit 0
fi

echo "Running DRY_RUN on ${#codespaces[@]} Codespaces..."
for cs in ${codespaces}; do
  echo "--- ${cs} ---"
  gh codespace ssh --codespace "${cs}" -- bash -lc 'DRY_RUN=1 bash -s' < ./scripts/prepare_for_deletion.sh || echo "DRY_RUN failed for ${cs}"
  # fetch summary
  gh codespace scp --codespace "${cs}":/tmp/prepare_for_deletion_summary.json "${SUM_DIR}/${cs}-prepare_for_deletion_summary.json" || echo "No summary for ${cs}"
  # fetch bundle(s)
  gh codespace scp --codespace "${cs}":./archive/*predelete*.bundle "${BUNDLE_DIR}/" 2>/dev/null || echo "No bundle for ${cs}"
done

echo "Consolidating summaries..."
jq -s '.' ${SUM_DIR}/*prepare_for_deletion_summary.json > ${SUM_DIR}/consolidated_summaries.json 2>/dev/null || echo "No summaries to consolidate"

echo "Done. Summaries in ${SUM_DIR}, bundles in ${BUNDLE_DIR}"
