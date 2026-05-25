#!/usr/bin/env bash

# 🎭 PSYCHO-NOIR KONTRAPUNKT: WORKFLOW RE-ENABLER
# ================================================
# Re-enables all GitHub Actions workflows after vacation

set -e

echo "🎭 WORKFLOW RE-ENABLER: Restoring GitHub Actions"
echo "================================================="
echo ""

WORKFLOWS_DIR=".github/workflows"
ENABLED_COUNT=0

if [ ! -d "$WORKFLOWS_DIR" ]; then
    echo "❌ Error: $WORKFLOWS_DIR directory not found"
    exit 1
fi

echo "📋 Scanning for disabled workflow files..."
echo ""

# Find all .disabled files and remove the extension
for workflow in "$WORKFLOWS_DIR"/*.disabled; do
    # Skip if glob didn't match any files
    if [ ! -f "$workflow" ]; then
        echo "✅ No disabled workflows found - all workflows are already active"
        exit 0
    fi
    
    # Re-enable by removing .disabled extension
    ENABLED_NAME="${workflow%.disabled}"
    echo "✅ Re-enabling: $(basename "$ENABLED_NAME")"
    mv "$workflow" "$ENABLED_NAME"
    ENABLED_COUNT=$((ENABLED_COUNT + 1))
done

echo ""
echo "✅ WORKFLOW RE-ENABLEMENT COMPLETE"
echo "=================================="
echo "   ✅ Workflows Re-enabled: $ENABLED_COUNT"
echo ""
echo "📱 Result: GitHub Actions are now active again"
echo "🚀 Welcome back from vacation!"
echo ""
