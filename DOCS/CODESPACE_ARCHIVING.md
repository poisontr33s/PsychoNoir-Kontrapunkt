# Codespace Archiving Workflow (controller + Codespace)

This document describes the automated workflow for preparing Codespaces for archival or fast sync.

Prerequisites (controller):
- GitHub CLI (`gh`) installed and authenticated (`gh auth login`).

Files in this repo:
- `scripts/prepare_for_deletion.sh` — run inside Codespace. DRY_RUN=1 by default. Creates stash, annotated tag, bundle and writes `/tmp/prepare_for_deletion_summary.json`.
- `scripts/run_dry_on_codespaces.sh` — controller-side orchestrator: lists Codespaces for the repo and runs `prepare_for_deletion.sh` in DRY_RUN=1, then copies back summaries.
- `scripts/collect_bundles.sh` — controller-side: copies bundles and summaries from Codespaces to `collected_bundles/` and `collected_summaries/`.

Basic controller flow:

1. Run dry-run across Codespaces:
```bash
./scripts/run_dry_on_codespaces.sh
```

2. Collect bundles and summaries:
```bash
./scripts/collect_bundles.sh
```

3. If DRY_RUN outputs look good, run execute-mode in selected Codespaces (creates bundles if they weren't created during dry-run):
```bash
gh codespace ssh --codespace <CODESPACE_NAME> -- bash -lc 'DRY_RUN=0 GIT_PUSH_SAFE=0 bash -s' < ./scripts/prepare_for_deletion.sh
```

4. Copy bundles back to controller and push archive refs from authenticated environment (see repository docs for controller push commands).

Security note: Do not set `GIT_PUSH_SAFE=1` in Codespaces unless you are certain non-interactive credentials are configured and safe to use.
