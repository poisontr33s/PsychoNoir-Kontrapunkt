#!/usr/bin/env bash
set -euo pipefail

# prepare_for_deletion.sh
# DRY_RUN=1 (default) — set DRY_RUN=0 to execute merge/push attempts
# GIT_PUSH_SAFE=1 to allow pushing from this environment (only set if creds verified)

DRY_RUN=${DRY_RUN:-1}
GIT_PUSH_SAFE=${GIT_PUSH_SAFE:-0}

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
HEAD_SHA=$(git rev-parse --verify HEAD 2>/dev/null || echo "")

mkdir -p archive

echo "Repository root: ${REPO_ROOT}"
echo "Branch: ${BRANCH}"
echo "HEAD: ${HEAD_SHA}"

# fetch best-effort
echo "Fetching origin/main (best-effort)..."
git fetch origin main --no-tags --prune || true

# compute divergence (default to large if fetch failed)
read BEHIND AHEAD < <(git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "999 999")

# check ancestor
if git merge-base --is-ancestor origin/main HEAD 2>/dev/null; then
  IS_ANCESTOR=1
else
  IS_ANCESTOR=0
fi

HAS_UNTRACKED=0
if [ -n "$(git status --porcelain)" ]; then HAS_UNTRACKED=1; fi

TS=$(date -u +%Y%m%dT%H%M%SZ)
ARCH_TAG="archive/${BRANCH}-${TS}"
BUNDLE="archive/${BRANCH}-predelete-${TS}.bundle"
STASH_NAME="pre-archive-${TS}"

ATTEMPTED_PUSH=false
PUSH_ERROR=""

echo "Stashing work (including untracked)..."
# stash (include untracked)
git stash push -u -m "${STASH_NAME}" || true

echo "Creating annotated tag: ${ARCH_TAG}"
git tag -a "${ARCH_TAG}" -m "Archive backup for ${BRANCH} @ ${TS}" || true

echo "Creating bundle: ${BUNDLE}"
# ensure parent dir exists (branch may contain slashes)
mkdir -p "$(dirname "${BUNDLE}")"
git bundle create "${BUNDLE}" --all || true

# compute bundle sha256 if possible
BUNDLE_SHA=""
if [ -f "${BUNDLE}" ]; then
  if command -v sha256sum >/dev/null 2>&1; then
    BUNDLE_SHA=$(sha256sum "${BUNDLE}" | awk '{print $1}')
  elif command -v shasum >/dev/null 2>&1; then
    BUNDLE_SHA=$(shasum -a 256 "${BUNDLE}" | awk '{print $1}')
  fi
fi

# extra diagnostics for summary
LAST_COMMIT_MSG=""
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  LAST_COMMIT_MSG=$(git log -1 --pretty=%B HEAD | tr '\n' ' ' | sed -e 's/"/\\\"/g')
fi
REPO_SIZE_BYTES=""
if command -v du >/dev/null 2>&1; then
  REPO_SIZE_BYTES=$(du -sb "${REPO_ROOT}" 2>/dev/null | awk '{print $1}' || echo "")
fi
UNCOMMITTED_COUNT=0
UNCOMMITTED_COUNT=$(git status --porcelain | wc -l | tr -d ' ')

# create JSON summary
SUMMARY_PATH="/tmp/prepare_for_deletion_summary.json"
cat > "${SUMMARY_PATH}" <<EOF
{
  "codespace":"${CODESPACE_NAME:-}",
  "repo_path":"${REPO_ROOT}",
  "branch":"${BRANCH}",
  "head":"${HEAD_SHA}",
  "behind":${BEHIND},
  "ahead":${AHEAD},
  "is_ancestor":${IS_ANCESTOR},
  "has_untracked":${HAS_UNTRACKED},
  "tag":"${ARCH_TAG}",
  "bundle":"${BUNDLE}",
  "bundle_sha256":"${BUNDLE_SHA}",
  "last_commit_message":"${LAST_COMMIT_MSG}",
  "repo_size_bytes":"${REPO_SIZE_BYTES}",
  "uncommitted_count":${UNCOMMITTED_COUNT},
  "timestamp":"${TS}",
  "attempted_push":${ATTEMPTED_PUSH},
  "push_error":"${PUSH_ERROR}"
}
EOF

echo "Decision logic:"
if [ "${IS_ANCESTOR}" -eq 1 ]; then
  echo "origin/main is ancestor — ready for fast sync."
elif [ "${BEHIND}" -le 5 ] && [ "${AHEAD}" -le 200 ] && [ "${IS_ANCESTOR}" -eq 0 ]; then
  echo "Small divergence detected — conservative auto-merge candidate."
  if [ "${DRY_RUN}" -eq 1 ]; then
    echo "DRY_RUN=1 — skipping merge execution"
  else
    echo "Attempting conservative auto-merge of origin/main into ${BRANCH}"
    if git merge --no-edit -X ours origin/main; then
      echo "Merge succeeded"
    else
      echo "Merge had conflicts — preserved stash and bundle"
    fi
  fi
else
  echo "Large divergence or unrelated histories detected — skipping auto-merge; preserving bundle for controller push."
fi

# Attempt push only if GIT_PUSH_SAFE=1 and DRY_RUN=0
if [ "${GIT_PUSH_SAFE}" -eq 1 ] && [ "${DRY_RUN}" -eq 0 ]; then
  echo "Attempting to push archive tag and archive branch to origin..."
  ATTEMPTED_PUSH=true
  if git push origin "refs/tags/${ARCH_TAG}" && git push origin "HEAD:refs/heads/archive/${BRANCH}-${TS}"; then
    echo "Push succeeded"
  else
    PUSH_ERROR="Push failed (likely credentials); controller should fetch bundle and push from authenticated env."
    echo "${PUSH_ERROR}"
  fi
fi


echo "Artifacts:"
ls -la "$(dirname "${BUNDLE}")" || ls -la archive || true
echo "Summary path: ${SUMMARY_PATH}"
echo "NOT deleting Codespace. Mark ready-for-deletion: false"

exit 0
