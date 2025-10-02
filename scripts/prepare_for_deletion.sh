#!/usr/bin/env bash
set -euo pipefail

# prepare_for_deletion.sh
# Per-Codespace helper: create safe backups (stash, annotated tag, bundle)
# and write a JSON summary for controller to collect. Defaults to DRY_RUN=1.

DRY_RUN=${DRY_RUN:-1}
GIT_PUSH_SAFE=${GIT_PUSH_SAFE:-0}

main() {
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  if [ -z "${REPO_ROOT}" ]; then
    echo "ERROR: not inside a git repository. Exiting." >&2
    exit 1
  fi
  cd "${REPO_ROOT}"

  BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
  HEAD_SHA=$(git rev-parse --verify HEAD 2>/dev/null || echo "")
  mkdir -p archive

  echo "[prepare] fetch origin/main (best-effort)"
  git fetch origin main --no-tags --prune || true

  # compute divergence; if fetch failed, default to large numbers
  read -r BEHIND AHEAD < <(git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "999 999")

  # check if origin/main is ancestor
  if git merge-base --is-ancestor origin/main HEAD 2>/dev/null; then
    IS_ANCESTOR=1
  else
    IS_ANCESTOR=0
  fi

  HAS_UNTRACKED=0
  if [ -n "$(git status --porcelain)" ]; then
    HAS_UNTRACKED=1
  fi

  TS=$(date -u +%Y%m%dT%H%M%SZ)
  ARCH_TAG="archive/${BRANCH}-${TS}"
  BUNDLE="archive/${BRANCH}-predelete-${TS}.bundle"
  STASH_NAME="pre-archive-${TS}"

  echo "[prepare] creating stash (incl. untracked)"
  git stash push -u -m "${STASH_NAME}" || true

  echo "[prepare] creating annotated tag: ${ARCH_TAG}"
  git tag -a "${ARCH_TAG}" -m "Archive backup for ${BRANCH} @ ${TS}" || true

  echo "[prepare] creating bundle: ${BUNDLE}"
  git bundle create "${BUNDLE}" --all || true

  ATTEMPTED_PUSH=false
  PUSH_ERROR=null

  # Decision: try auto-merge only on small divergence (and not ancestor)
  if [ "${IS_ANCESTOR}" -eq 1 ]; then
    echo "origin/main is ancestor — ready for fast sync. (no merge needed)"
    DECISION="fast-sync-ready"
  elif [ "${BEHIND}" -le 5 ] && [ "${AHEAD}" -le 200 ] && [ "${IS_ANCESTOR}" -eq 0 ]; then
    echo "small divergence detected — conservative auto-merge candidate"
    DECISION="attempt-auto-merge"
    if [ "${DRY_RUN:-1}" -eq 1 ]; then
      echo "DRY_RUN=1 — skipping merge execution"
    else
      echo "[merge] merging origin/main into ${BRANCH} with -X ours"
      if ! git merge --no-edit -X ours origin/main; then
        echo "merge had conflicts — preserved stash and bundle"
      fi
    fi
  else
    echo "Large divergence or unrelated histories detected — skipping auto-merge"
    DECISION="archive-only"
  fi

  # Attempt push only if explicitly allowed (GIT_PUSH_SAFE=1) and not DRY_RUN
  if [ "${GIT_PUSH_SAFE:-0}" -eq 1 ] && [ "${DRY_RUN:-1}" -eq 0 ]; then
    ATTEMPTED_PUSH=true
    echo "[push] pushing tag and archive branch to origin"
    if ! git push origin "refs/tags/${ARCH_TAG}"; then
      PUSH_ERROR='"push_tag_failed"'
      echo "Push tag failed (likely credentials issue)"
    fi
    if ! git push origin "HEAD:refs/heads/archive/${BRANCH}-${TS}"; then
      PUSH_ERROR='"push_branch_failed"'
      echo "Push branch failed (likely credentials issue)"
    fi
  else
    echo "Push skipped (GIT_PUSH_SAFE!=1 or DRY_RUN!=0). Controller should fetch bundle and push from authenticated env."
  fi

  # Write JSON summary to /tmp
  SUMMARY_FILE="/tmp/prepare_for_deletion_summary.json"
  cat > "${SUMMARY_FILE}" <<EOF
{
  "repo_path": "${REPO_ROOT}",
  "branch": "${BRANCH}",
  "head": "${HEAD_SHA}",
  "behind": ${BEHIND},
  "ahead": ${AHEAD},
  "is_ancestor": ${IS_ANCESTOR},
  "has_untracked": ${HAS_UNTRACKED},
  "tag": "${ARCH_TAG}",
  "bundle": "${BUNDLE}",
  "timestamp": "${TS}",
  "decision": "${DECISION}",
  "attempted_push": ${ATTEMPTED_PUSH},
  "push_error": ${PUSH_ERROR}
}
EOF

  echo "[prepare] summary written to ${SUMMARY_FILE}"
  echo "Artifacts:"
  echo "  - tag: ${ARCH_TAG}"
  echo "  - bundle: ${BUNDLE}"
  echo "  - stash name: ${STASH_NAME}"
  echo "Decision: ${DECISION}"
  echo "Do NOT delete this Codespace — controller must collect bundle + summary and push archive refs."

  # Print summary to stdout briefly
  cat "${SUMMARY_FILE}"
}

main "$@"
#!/usr/bin/env bash
set -euo pipefail

# prepare_for_deletion.sh
# Per-Codespace helper: create safe backups (stash, annotated tag, bundle)
# and write a JSON summary for controller to collect. Defaults to DRY_RUN=1.

DRY_RUN=${DRY_RUN:-1}
GIT_PUSH_SAFE=${GIT_PUSH_SAFE:-0}

main() {
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  if [ -z "${REPO_ROOT}" ]; then
    echo "ERROR: not inside a git repository. Exiting." >&2
    exit 1
  fi
  cd "${REPO_ROOT}"

  BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
  HEAD_SHA=$(git rev-parse --verify HEAD 2>/dev/null || echo "")
  mkdir -p archive

  echo "[prepare] fetch origin/main (best-effort)"
  git fetch origin main --no-tags --prune || true

  # compute divergence; if fetch failed, default to large numbers
  read -r BEHIND AHEAD < <(git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "999 999")

  # check if origin/main is ancestor
  if git merge-base --is-ancestor origin/main HEAD 2>/dev/null; then
    IS_ANCESTOR=1
  else
    IS_ANCESTOR=0
  fi

  HAS_UNTRACKED=0
  if [ -n "$(git status --porcelain)" ]; then
    HAS_UNTRACKED=1
  fi

  TS=$(date -u +%Y%m%dT%H%M%SZ)
  ARCH_TAG="archive/${BRANCH}-${TS}"
  BUNDLE="archive/${BRANCH}-predelete-${TS}.bundle"
  STASH_NAME="pre-archive-${TS}"

  echo "[prepare] creating stash (incl. untracked)"
  git stash push -u -m "${STASH_NAME}" || true

  echo "[prepare] creating annotated tag: ${ARCH_TAG}"
  git tag -a "${ARCH_TAG}" -m "Archive backup for ${BRANCH} @ ${TS}" || true

  echo "[prepare] creating bundle: ${BUNDLE}"
  git bundle create "${BUNDLE}" --all || true

  ATTEMPTED_PUSH=false
  PUSH_ERROR=null

  # Decision: try auto-merge only on small divergence (and not ancestor)
  if [ "${IS_ANCESTOR}" -eq 1 ]; then
    echo "origin/main is ancestor — ready for fast sync. (no merge needed)"
    DECISION="fast-sync-ready"
  elif [ "${BEHIND}" -le 5 ] && [ "${AHEAD}" -le 200 ] && [ "${IS_ANCESTOR}" -eq 0 ]; then
    echo "small divergence detected — conservative auto-merge candidate"
    DECISION="attempt-auto-merge"
    if [ "${DRY_RUN:-1}" -eq 1 ]; then
      echo "DRY_RUN=1 — skipping merge execution"
    else
      echo "[merge] merging origin/main into ${BRANCH} with -X ours"
      if ! git merge --no-edit -X ours origin/main; then
        echo "merge had conflicts — preserved stash and bundle"
      fi
    fi
  else
    echo "Large divergence or unrelated histories detected — skipping auto-merge"
    DECISION="archive-only"
  fi

  # Attempt push only if explicitly allowed (GIT_PUSH_SAFE=1) and not DRY_RUN
  if [ "${GIT_PUSH_SAFE:-0}" -eq 1 ] && [ "${DRY_RUN:-1}" -eq 0 ]; then
    ATTEMPTED_PUSH=true
    echo "[push] pushing tag and archive branch to origin"
    if ! git push origin "refs/tags/${ARCH_TAG}"; then
      PUSH_ERROR='"push_tag_failed"'
      echo "Push tag failed (likely credentials issue)"
    fi
    if ! git push origin "HEAD:refs/heads/archive/${BRANCH}-${TS}"; then
      PUSH_ERROR='"push_branch_failed"'
      echo "Push branch failed (likely credentials issue)"
    fi
  else
    echo "Push skipped (GIT_PUSH_SAFE!=1 or DRY_RUN!=0). Controller should fetch bundle and push from authenticated env."
  fi

  # Write JSON summary to /tmp
  SUMMARY_FILE="/tmp/prepare_for_deletion_summary.json"
  cat > "${SUMMARY_FILE}" <<EOF
{
  "repo_path": "${REPO_ROOT}",
  "branch": "${BRANCH}",
  "head": "${HEAD_SHA}",
  "behind": ${BEHIND},
  "ahead": ${AHEAD},
  "is_ancestor": ${IS_ANCESTOR},
  "has_untracked": ${HAS_UNTRACKED},
  "tag": "${ARCH_TAG}",
  "bundle": "${BUNDLE}",
  "timestamp": "${TS}",
  "decision": "${DECISION}",
  "attempted_push": ${ATTEMPTED_PUSH},
  "push_error": ${PUSH_ERROR}
}
EOF

  echo "[prepare] summary written to ${SUMMARY_FILE}"
  echo "Artifacts:"
  echo "  - tag: ${ARCH_TAG}"
  echo "  - bundle: ${BUNDLE}"
  echo "  - stash name: ${STASH_NAME}"
  echo "Decision: ${DECISION}"
  echo "Do NOT delete this Codespace — controller must collect bundle + summary and push archive refs."

  # Print summary to stdout briefly
  cat "${SUMMARY_FILE}"
}

main "$@"
