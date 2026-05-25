#!/usr/bin/env bash

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
for workflow in "$WORKFLOWS_DIR"/*.yml "$WORKFLOWS_DIR"/*.yaml; do
    # Skip if glob didn't match any files
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
