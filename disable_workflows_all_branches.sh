#!/bin/bash

# 🎭 PSYCHO-NOIR KONTRAPUNKT: MULTI-BRANCH VACATION MODE
# =======================================================
# Disables workflows across multiple branches
# USE WITH CAUTION: This will modify multiple branches

set -e

echo "🎭 MULTI-BRANCH VACATION MODE"
echo "=============================="
echo ""
echo "⚠️  WARNING: This will disable workflows on multiple branches!"
echo "⚠️  This operation will push changes to remote branches."
echo ""

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"
echo ""

# Ask for confirmation
read -p "❓ Do you want to disable workflows on OTHER branches? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Operation cancelled."
    exit 0
fi

# Get list of branches to process
echo ""
echo "📋 Available branches:"
git branch -r | grep -v HEAD | sed 's/origin\///' | nl
echo ""

read -p "🔢 Enter branch names to disable (space-separated), or 'all' for all branches: " BRANCHES_INPUT

if [ "$BRANCHES_INPUT" = "all" ]; then
    BRANCHES=$(git branch -r | grep -v HEAD | sed 's/origin\///' | xargs)
else
    BRANCHES=$BRANCHES_INPUT
fi

echo ""
echo "🎯 Branches to process: $BRANCHES"
echo ""

read -p "⚠️  Final confirmation - Proceed? (yes/no): " FINAL_CONFIRM

if [ "$FINAL_CONFIRM" != "yes" ]; then
    echo "❌ Operation cancelled."
    exit 0
fi

echo ""
echo "🚀 Starting multi-branch vacation mode activation..."
echo ""

PROCESSED=0
FAILED=0

for BRANCH in $BRANCHES; do
    # Skip current branch (already done)
    if [ "$BRANCH" = "$CURRENT_BRANCH" ]; then
        echo "⏩ Skipping current branch: $BRANCH"
        continue
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔄 Processing branch: $BRANCH"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Checkout branch
    if ! git checkout "$BRANCH" 2>/dev/null; then
        echo "❌ Failed to checkout branch: $BRANCH"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Pull latest changes
    git pull origin "$BRANCH" 2>/dev/null || echo "⚠️  Pull failed, continuing anyway..."
    
    # Check if workflows directory exists
    if [ ! -d ".github/workflows" ]; then
        echo "⚠️  No workflows directory in branch: $BRANCH"
        continue
    fi
    
    # Count workflows to disable
    WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
    
    if [ "$WORKFLOW_COUNT" -eq 0 ]; then
        echo "✅ No active workflows in branch: $BRANCH (already disabled or none exist)"
        continue
    fi
    
    echo "📋 Found $WORKFLOW_COUNT workflows to disable"
    
    # Run disable script
    if [ -f "./disable_workflows_vacation_mode.sh" ]; then
        ./disable_workflows_vacation_mode.sh
    else
        echo "⚠️  Disable script not found, manually disabling..."
        cd .github/workflows
        for workflow in *.yml *.yaml; do
            if [ -f "$workflow" ] && [[ "$workflow" != *.disabled ]]; then
                mv "$workflow" "${workflow}.disabled"
                echo "🔒 Disabled: $workflow"
            fi
        done
        cd ../..
    fi
    
    # Commit changes
    git add .github/workflows/
    git commit -m "🏖️ Vacation mode: Disable workflows on branch $BRANCH" || echo "ℹ️  No changes to commit"
    
    # Push changes
    if git push origin "$BRANCH" 2>/dev/null; then
        echo "✅ Successfully processed branch: $BRANCH"
        PROCESSED=$((PROCESSED + 1))
    else
        echo "❌ Failed to push changes to branch: $BRANCH"
        FAILED=$((FAILED + 1))
    fi
    
    echo ""
done

# Return to original branch
echo "🔙 Returning to original branch: $CURRENT_BRANCH"
git checkout "$CURRENT_BRANCH"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 MULTI-BRANCH VACATION MODE COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Summary:"
echo "   ✅ Branches processed: $PROCESSED"
echo "   ❌ Branches failed: $FAILED"
echo "   📍 Current branch: $CURRENT_BRANCH"
echo ""
echo "🏖️ Vacation mode activated across multiple branches!"
echo ""
echo "ℹ️  To re-enable workflows on all branches later:"
echo "   Run this script again with re-enable mode, or"
echo "   Manually run ./re_enable_workflows.sh on each branch"
echo ""
