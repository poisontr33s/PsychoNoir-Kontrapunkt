#!/bin/bash

# 🎭 PSYCHO-NOIR KONTRAPUNKT: VACATION MODE WORKFLOW DISABLER
# ===========================================================
# Disables all GitHub Actions workflows to conserve resources
# while user is away on vacation.

set -e

echo "🎭 VACATION MODE: Disabling All GitHub Actions Workflows"
echo "========================================================="
echo ""

WORKFLOWS_DIR=".github/workflows"
DISABLED_COUNT=0
ALREADY_DISABLED=0

if [ ! -d "$WORKFLOWS_DIR" ]; then
    echo "❌ Error: $WORKFLOWS_DIR directory not found"
    exit 1
fi

echo "📋 Scanning for active workflow files..."
echo ""

# Find all .yml and .yaml files that are NOT already disabled
workflow_files=("$WORKFLOWS_DIR"/*.yml "$WORKFLOWS_DIR"/*.yaml)

# Check if any workflow files exist
if [ ! -e "${workflow_files[0]}" ]; then
    echo "⚠️  No workflow files (.yml/.yaml) found in $WORKFLOWS_DIR"
else
    for workflow in "${workflow_files[@]}"; do
        # Skip if not a regular file
        if [ ! -f "$workflow" ]; then
            continue
        fi
        
        # Check if already disabled
        if [[ "$workflow" == *.disabled ]]; then
            ALREADY_DISABLED=$((ALREADY_DISABLED + 1))
            continue
        fi
        
        # Disable the workflow by renaming
        DISABLED_NAME="${workflow}.disabled"
        echo "🔒 Disabling: $(basename "$workflow")"
        mv "$workflow" "$DISABLED_NAME"
        DISABLED_COUNT=$((DISABLED_COUNT + 1))
    done
fi
echo ""
echo "✅ VACATION MODE ACTIVATION COMPLETE"
echo "===================================="
echo "   🔒 Workflows Disabled: $DISABLED_COUNT"
echo "   ⏸️  Already Disabled: $ALREADY_DISABLED"
echo ""
echo "📱 Result: GitHub Actions will no longer consume resources"
echo "🏖️  Enjoy your vacation!"
echo ""
echo "ℹ️  To re-enable workflows when you return:"
echo "   Run: ./re_enable_workflows.sh"
echo ""
