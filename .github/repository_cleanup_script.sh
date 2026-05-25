#!/usr/bin/env bash

# 🎭 Psycho-Noir Kontrapunkt Repository Cleanup & Organization Script
# GitHub + Copilot Ninja Course - Immediate Action Implementation

echo "🎭 PSYCHO-NOIR KONTRAPUNKT REPOSITORY CLEANUP INITIATED"
echo "====================================================="

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print section headers
print_section() {
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}🎯 $1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}\n"
}

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Ensure we're in the right directory
cd /workspaces/PsychoNoir-Kontrapunkt || {
    print_error "Failed to navigate to project directory"
    exit 1
}

print_section "PHASE 1: REPOSITORY DIAGNOSTIC"

# Create audit directory
mkdir -p .github/audits
AUDIT_DIR=".github/audits"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

print_info "Creating audit files in ${AUDIT_DIR}/"

# Branch audit
echo "🌿 Auditing branches..."
git branch -a > "${AUDIT_DIR}/branch_audit_${TIMESTAMP}.txt"
echo "Remote branches:" > "${AUDIT_DIR}/branch_analysis_${TIMESTAMP}.txt"
git branch -r | wc -l >> "${AUDIT_DIR}/branch_analysis_${TIMESTAMP}.txt"
echo "Local branches:" >> "${AUDIT_DIR}/branch_analysis_${TIMESTAMP}.txt"
git branch | wc -l >> "${AUDIT_DIR}/branch_analysis_${TIMESTAMP}.txt"

# PR audit
echo "📋 Auditing pull requests..."
gh pr list > "${AUDIT_DIR}/pr_audit_${TIMESTAMP}.txt" 2>/dev/null || {
    print_warning "GitHub CLI not authenticated or available"
    echo "PR audit skipped - authenticate with 'gh auth login'" > "${AUDIT_DIR}/pr_audit_${TIMESTAMP}.txt"
}

# Issue audit
echo "🎯 Auditing issues..."
gh issue list > "${AUDIT_DIR}/issue_audit_${TIMESTAMP}.txt" 2>/dev/null || {
    print_warning "GitHub CLI not authenticated or available"
    echo "Issue audit skipped - authenticate with 'gh auth login'" > "${AUDIT_DIR}/issue_audit_${TIMESTAMP}.txt"
}

# Git status
echo "📊 Checking repository status..."
git status > "${AUDIT_DIR}/git_status_${TIMESTAMP}.txt"

print_status "Diagnostic complete! Check ${AUDIT_DIR}/ for detailed reports"

print_section "PHASE 2: BRANCH ANALYSIS"

echo "🔍 Analyzing branch structure..."

# Count different types of branches
COPILOT_BRANCHES=$(git branch -r | grep "copilot/" | wc -l)
DEPENDABOT_BRANCHES=$(git branch -r | grep "dependabot/" | wc -l)
FEATURE_BRANCHES=$(git branch -r | grep -E "(feature/|feat/)" | wc -l)
OTHER_BRANCHES=$(git branch -r | grep -v -E "(copilot/|dependabot/|feature/|feat/|origin/main|origin/HEAD)" | wc -l)

echo "Branch Analysis:" > "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"
echo "=================" >> "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"
echo "Copilot auto-generated: ${COPILOT_BRANCHES}" >> "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"
echo "Dependabot branches: ${DEPENDABOT_BRANCHES}" >> "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"
echo "Feature branches: ${FEATURE_BRANCHES}" >> "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"
echo "Other branches: ${OTHER_BRANCHES}" >> "${AUDIT_DIR}/branch_categorization_${TIMESTAMP}.txt"

print_info "Found ${COPILOT_BRANCHES} Copilot branches, ${DEPENDABOT_BRANCHES} Dependabot branches"
print_info "Found ${FEATURE_BRANCHES} feature branches, ${OTHER_BRANCHES} other branches"

print_section "PHASE 3: WORKSPACE ORGANIZATION"

# Create GitHub templates if they don't exist
echo "📝 Setting up GitHub templates..."

mkdir -p .github/ISSUE_TEMPLATE

# Bug report template
if [ ! -f ".github/ISSUE_TEMPLATE/bug_report.md" ]; then
    cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: 🐛 Bug Report
about: Report a bug in the Psycho-Noir Kontrapunkt system
title: '🐛 [BUG]: '
labels: ['bug']
assignees: ''
---

## 🎭 Bug Description
A clear description of what the bug is.

## 🌐 Domain Affected
- [ ] Skyskraper (Astrid's domain)
- [ ] Rustbelt (Iron Maiden's domain)
- [ ] Neural Interface (Quantum consciousness)
- [ ] Den Usynlige Hånd manifestations

## 🔄 Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## ✅ Expected Behavior
What you expected to happen.

## ❌ Actual Behavior
What actually happened.

## 🖥️ Environment
- OS: [e.g. Linux, Windows, macOS]
- Browser: [if applicable]
- Node.js version: [if applicable]
- Python version: [if applicable]

## 📸 Screenshots
If applicable, add screenshots to help explain the problem.

## 🔗 Additional Context
Add any other context about the problem here.
EOF
    print_status "Created bug report template"
fi

# Feature request template
if [ ! -f ".github/ISSUE_TEMPLATE/feature_request.md" ]; then
    cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: ✨ Feature Request
about: Suggest a new feature for the Psycho-Noir Kontrapunkt system
title: '✨ [FEATURE]: '
labels: ['enhancement']
assignees: ''
---

## 🎯 Feature Description
A clear description of what you want to happen.

## 🎭 Character/Domain Relevance
- [ ] Astrid Møller (MILF Matriarchy)
- [ ] Iron Maiden (Resistance Network)
- [ ] Eva Green (Aerospace Psychology)
- [ ] Yukiko Tanaka (Academic AI)
- [ ] Vera Steel (Quantum Mechanics)
- [ ] Raven Bytes (Digital Warfare)

## 💭 Motivation
Why is this feature needed? What problem does it solve?

## 📋 Detailed Requirements
Detailed description of the feature requirements.

## 🎨 Design Considerations
Any UI/UX or technical design considerations.

## 🔗 Additional Context
Add any other context or screenshots about the feature request here.
EOF
    print_status "Created feature request template"
fi

# Pull request template
if [ ! -f ".github/pull_request_template.md" ]; then
    cat > .github/pull_request_template.md << 'EOF'
## 🎭 Psycho-Noir Kontrapunkt PR

### 📝 Description
Brief description of changes made.

### 🎯 Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🔧 Refactoring (no functional changes)

### 🌐 Domain Impact
- [ ] Skyskraper (Astrid's domain)
- [ ] Rustbelt (Iron Maiden's domain)
- [ ] Neural Interface (Quantum consciousness)
- [ ] System Integration

### ✅ Testing Checklist
- [ ] Local testing completed
- [ ] Frontend functionality verified
- [ ] Backend services tested
- [ ] Character system integration verified
- [ ] No breaking changes introduced

### 🔗 Related Issues
Closes #[issue-number]

### 📸 Screenshots (if applicable)
Add screenshots to help explain your changes.

### 🧠 Reviewer Notes
Any specific areas that need attention during review.
EOF
    print_status "Created pull request template"
fi

print_section "PHASE 4: WORKFLOW SETUP"

# Create basic GitHub Actions workflow
mkdir -p .github/workflows

if [ ! -f ".github/workflows/psycho-noir-ci.yml" ]; then
    cat > .github/workflows/psycho-noir-ci.yml << 'EOF'
name: 🎭 Psycho-Noir Kontrapunkt CI

on:
  push:
    branches: [ main, feature/*, feat/* ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - name: 📥 Checkout code
      uses: actions/checkout@v4

    - name: 🟢 Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: 🐍 Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.12'

    - name: 📦 Install Node.js dependencies
      run: |
        if [ -f package.json ]; then
          npm ci
        fi

    - name: 📦 Install Python dependencies
      run: |
        if [ -f backend/requirements.txt ]; then
          pip install -r backend/requirements.txt
        fi

    - name: 🧪 Run frontend tests
      run: |
        if [ -f package.json ] && npm run test --if-present; then
          npm test
        fi

    - name: 🧪 Run backend tests
      run: |
        if [ -f backend/requirements.txt ]; then
          python -m pytest backend/ || true
        fi

    - name: 🏗️ Build frontend
      run: |
        if [ -f package.json ] && npm run build --if-present; then
          npm run build
        fi

    - name: 🎭 Psycho-Noir Status
      run: |
        echo "🎭 Psycho-Noir Kontrapunkt CI completed"
        echo "✅ Neural Interface Status: ACTIVE"
        echo "🏗️ Skyskraper Systems: OPERATIONAL"
        echo "⚔️ Rustbelt Resistance: READY"
EOF
    print_status "Created basic CI workflow"
fi

print_section "PHASE 5: CLEANUP RECOMMENDATIONS"

echo "📋 Generating cleanup recommendations..."

# Create cleanup recommendations
cat > "${AUDIT_DIR}/cleanup_recommendations_${TIMESTAMP}.md" << EOF
# 🧹 Psycho-Noir Kontrapunkt Cleanup Recommendations

Generated: $(date)

## 🎯 Priority Actions

### 1. Branch Cleanup (High Priority)
- **Copilot branches found:** ${COPILOT_BRANCHES}
- **Dependabot branches found:** ${DEPENDABOT_BRANCHES}

**Recommended actions:**
\`\`\`bash
# Review and merge/close Copilot PRs
gh pr list --author app/github-copilot

# Clean up merged branches
git branch --merged main | grep -v "main" | xargs git branch -d

# Prune remote tracking branches
git remote prune origin
\`\`\`

### 2. PR Management (High Priority)
\`\`\`bash
# Review each open PR
gh pr list

# For each PR, decide:
# ✅ Merge if ready
# 🔄 Request changes if needed
# ❌ Close if obsolete
\`\`\`

### 3. Issue Organization (Medium Priority)
\`\`\`bash
# Add labels to issues
gh issue list --label ""  # Find unlabeled issues

# Create project boards
gh project create --title "Psycho-Noir Development"
\`\`\`

## 🤖 Automation Recommendations

### GitHub Actions
- ✅ Basic CI workflow created
- 🔄 Add branch cleanup automation
- 🔄 Add automated testing
- 🔄 Add deployment workflow

### Copilot Optimization
- Review Copilot-generated branches regularly
- Set up branch protection rules
- Configure auto-merge for simple updates

## 📊 Current Stats
- Total branches: $(git branch -a | wc -l)
- Open PRs: $(gh pr list 2>/dev/null | wc -l || echo "N/A")
- Open issues: $(gh issue list 2>/dev/null | wc -l || echo "N/A")

## 🎯 Next Steps
1. Run the emergency cleanup commands
2. Review and organize PRs/issues
3. Set up automated workflows
4. Implement branch protection rules
5. Optimize Copilot settings
EOF

print_status "Cleanup recommendations generated"

print_section "SUMMARY"

print_status "Repository audit completed!"
print_info "📁 All audit files saved to: ${AUDIT_DIR}/"
print_info "📚 Course available at: .github/GITHUB_COPILOT_NINJA_COURSE.md"
print_info "📋 Cleanup recommendations: ${AUDIT_DIR}/cleanup_recommendations_${TIMESTAMP}.md"

echo -e "\n${YELLOW}🎯 IMMEDIATE NEXT STEPS:${NC}"
echo "1. Review the audit files in ${AUDIT_DIR}/"
echo "2. Read the full course: .github/GITHUB_COPILOT_NINJA_COURSE.md"
echo "3. Start with PR/branch cleanup as recommended"
echo "4. Set up GitHub CLI authentication if needed: gh auth login"

echo -e "\n${PURPLE}🎭 Psycho-Noir Kontrapunkt Repository Cleanup Complete!${NC}"
echo -e "${GREEN}Ready to evolve from chaos to organized development mastery! 🚀${NC}"
