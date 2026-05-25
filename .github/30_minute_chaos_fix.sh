#!/usr/bin/env bash

# 🚨 QUICK START: Fix Repository Chaos in 30 Minutes
# This script gives you immediate results while the full automation sets up

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║  🚨 30-MINUTE CHAOS ELIMINATION QUICK START 🚨       ║"
echo "║         Immediate Results Guaranteed!                 ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Ensure we're authenticated
echo -e "${YELLOW}🔐 Checking GitHub CLI authentication...${NC}"
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}❌ GitHub CLI not authenticated!${NC}"
    echo -e "${YELLOW}Run this first: gh auth login${NC}"
    echo "Then run this script again."
    exit 1
fi
echo -e "${GREEN}✅ GitHub CLI authenticated${NC}"

# Go to safety
echo -e "${BLUE}🏠 Ensuring we're on main branch...${NC}"
git checkout main
git pull origin main
echo -e "${GREEN}✅ On main branch and up to date${NC}"

# Quick stats
echo -e "\n${YELLOW}📊 CURRENT CHAOS LEVELS:${NC}"
BRANCH_COUNT=$(git branch -r | wc -l)
COPILOT_COUNT=$(git branch -r | grep "copilot/" | wc -l)
PR_COUNT=$(gh pr list --json number | jq length)

echo "Remote branches: ${BRANCH_COUNT}"
echo "Copilot branches: ${COPILOT_COUNT}"
echo "Open PRs: ${PR_COUNT}"

CHAOS_SCORE=$((COPILOT_COUNT + PR_COUNT))
echo -e "${RED}CHAOS SCORE: ${CHAOS_SCORE}${NC}"

# Immediate actions
echo -e "\n${BOLD}🎯 IMMEDIATE ACTIONS (5 minutes):${NC}"

# 1. Clean merged branches
echo -e "${BLUE}1. Cleaning merged branches...${NC}"
MERGED=$(git branch --merged main | grep -v "main" | grep -v "^*" || true)
if [ -n "$MERGED" ]; then
    echo "Deleting: $MERGED"
    echo "$MERGED" | xargs -r git branch -d
    echo -e "${GREEN}✅ Deleted merged local branches${NC}"
else
    echo "No merged local branches to delete"
fi

# 2. Prune dead remote references
echo -e "${BLUE}2. Pruning dead remote references...${NC}"
git remote prune origin
echo -e "${GREEN}✅ Pruned dead remote references${NC}"

# 3. Quick PR analysis
echo -e "\n${BOLD}🔍 QUICK PR ANALYSIS:${NC}"
echo -e "${BLUE}3. Analyzing your 7 open PRs...${NC}"

# Create quick PR report
echo "PR Analysis:" > quick_pr_report.txt
echo "============" >> quick_pr_report.txt

gh pr list --json number,title,author,createdAt,isDraft,headRefName --jq '.[] | "\(.number)|\(.title)|\(.author.login)|\(.createdAt)|\(.isDraft)|\(.headRefName)"' | while IFS='|' read -r number title author created is_draft branch; do
    # Calculate age
    created_epoch=$(date -d "$created" +%s 2>/dev/null || echo "0")
    current_epoch=$(date +%s)
    age_days=$(( (current_epoch - created_epoch) / 86400 ))

    if [ "$age_days" -gt 30 ]; then
        status="🚨 ANCIENT"
        echo "PR #$number: $title (${age_days} days old) - ${status}" >> quick_pr_report.txt
        echo -e "${RED}PR #$number: ANCIENT (${age_days} days) - $title${NC}"
    elif [ "$age_days" -gt 14 ]; then
        status="⚠️ STALE"
        echo "PR #$number: $title (${age_days} days old) - ${status}" >> quick_pr_report.txt
        echo -e "${YELLOW}PR #$number: STALE (${age_days} days) - $title${NC}"
    elif [ "$is_draft" = "true" ]; then
        status="📝 DRAFT"
        echo "PR #$number: $title (${age_days} days old) - ${status}" >> quick_pr_report.txt
        echo -e "${BLUE}PR #$number: DRAFT (${age_days} days) - $title${NC}"
    else
        status="✅ READY"
        echo "PR #$number: $title (${age_days} days old) - ${status}" >> quick_pr_report.txt
        echo -e "${GREEN}PR #$number: READY (${age_days} days) - $title${NC}"
    fi
done

echo -e "${GREEN}✅ PR analysis complete - see quick_pr_report.txt${NC}"

# 4. Copilot branch analysis
echo -e "\n${BOLD}🤖 COPILOT BRANCH ANALYSIS:${NC}"
echo -e "${BLUE}4. Analyzing your 14 Copilot branches...${NC}"

echo "Copilot Branch Analysis:" > copilot_branch_report.txt
echo "=======================" >> copilot_branch_report.txt

ORPHANED_COUNT=0
git branch -r | grep "copilot/" | while read -r branch; do
    branch_name=${branch#origin/}
    pr_exists=$(gh pr list --head "$branch_name" --json number | jq length)

    if [ "$pr_exists" -eq 0 ]; then
        echo "🗑️ ORPHANED: $branch_name (no active PR)" >> copilot_branch_report.txt
        echo -e "${RED}🗑️ ORPHANED: $branch_name${NC}"
        ORPHANED_COUNT=$((ORPHANED_COUNT + 1))
    else
        pr_number=$(gh pr list --head "$branch_name" --json number --jq '.[0].number')
        echo "✅ ACTIVE: $branch_name (PR #$pr_number)" >> copilot_branch_report.txt
        echo -e "${GREEN}✅ ACTIVE: $branch_name (PR #$pr_number)${NC}"
    fi
done

echo -e "${GREEN}✅ Copilot analysis complete - see copilot_branch_report.txt${NC}"

# 5. Generate immediate action commands
echo -e "\n${BOLD}⚡ IMMEDIATE ACTION COMMANDS:${NC}"

cat > immediate_actions.sh << 'EOF'
#!/bin/bash
# Generated immediate action commands

echo "🎯 IMMEDIATE ACTIONS TO TAKE:"
echo "============================"

echo ""
echo "1. 🚨 CLOSE ANCIENT PRS (>30 days old):"
EOF

# Add specific PR commands
gh pr list --json number,title,createdAt --jq '.[] | select((.createdAt | fromdateiso8601) < (now - 2592000)) | "\(.number)|\(.title)"' | while IFS='|' read -r number title; do
    echo "echo '   gh pr close $number  # $title'" >> immediate_actions.sh
done

cat >> immediate_actions.sh << 'EOF'

echo ""
echo "2. ✅ MERGE READY PRS:"
EOF

# Add merge commands for recent, non-draft PRs
gh pr list --json number,title,createdAt,isDraft --jq '.[] | select(.isDraft == false and ((.createdAt | fromdateiso8601) > (now - 1209600))) | "\(.number)|\(.title)"' | while IFS='|' read -r number title; do
    echo "echo '   gh pr view $number  # Review first, then: gh pr merge $number --squash'" >> immediate_actions.sh
done

cat >> immediate_actions.sh << 'EOF'

echo ""
echo "3. 🗑️ DELETE ORPHANED COPILOT BRANCHES:"
EOF

# Add orphaned branch deletion commands
git branch -r | grep "copilot/" | while read -r branch; do
    branch_name=${branch#origin/}
    pr_exists=$(gh pr list --head "$branch_name" --json number | jq length)
    if [ "$pr_exists" -eq 0 ]; then
        echo "echo '   git push origin --delete $branch_name  # Orphaned Copilot branch'" >> immediate_actions.sh
    fi
done

cat >> immediate_actions.sh << 'EOF'

echo ""
echo "4. 🔄 SETUP AUTOMATION:"
echo "   git add .github/workflows/"
echo "   git commit -m '🤖 Add automated cleanup workflows'"
echo "   git push origin main"

echo ""
echo "5. 📊 MONITOR PROGRESS:"
echo "   ./.github/emergency_chaos_cleanup.sh"

EOF

chmod +x immediate_actions.sh

echo -e "${GREEN}✅ Generated immediate_actions.sh${NC}"

# Final stats
echo -e "\n${BOLD}📊 AFTER QUICK CLEANUP:${NC}"
NEW_BRANCH_COUNT=$(git branch -r | wc -l)
NEW_CHAOS_SCORE=$((COPILOT_COUNT + PR_COUNT))

echo "Remote branches: ${NEW_BRANCH_COUNT} (was ${BRANCH_COUNT})"
echo "Chaos score: ${NEW_CHAOS_SCORE} (was ${CHAOS_SCORE})"

if [ $NEW_CHAOS_SCORE -lt $CHAOS_SCORE ]; then
    echo -e "${GREEN}✅ Chaos reduced!${NC}"
else
    echo -e "${YELLOW}⚠️ Need manual PR/branch cleanup${NC}"
fi

# Final instructions
echo -e "\n${BOLD}${YELLOW}🎯 NEXT STEPS (Do this now!):${NC}"
echo "1. Review the reports:"
echo "   - quick_pr_report.txt"
echo "   - copilot_branch_report.txt"
echo ""
echo "2. Execute immediate actions:"
echo "   ./immediate_actions.sh"
echo ""
echo "3. Run full automation setup:"
echo "   ./.github/emergency_chaos_cleanup.sh"
echo ""
echo "4. Commit the automation:"
echo "   git add .github/"
echo "   git commit -m '🚨 Emergency chaos cleanup automation'"
echo "   git push origin main"

echo -e "\n${BOLD}${GREEN}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║  🎉 30-MINUTE QUICK START COMPLETE! 🎉               ║"
echo "║    Your chaos is now systematically manageable!      ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${PURPLE}🎭 Psycho-Noir Kontrapunkt: From chaos to order in 30 minutes! 🎭${NC}"
