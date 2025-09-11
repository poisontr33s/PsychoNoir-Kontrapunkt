# 🎯 GitHub + Copilot Ninja Quick Reference Card

## 🚨 EMERGENCY COMMANDS (When Things Go Wrong)

### Lost in Branches? 🌿
```bash
git checkout main                    # Go to safety
git status                          # Check current state
git branch                          # See local branches
git log --oneline --graph --all     # Visualize history
```

### Too Many PRs? 📋
```bash
gh pr list                          # List all PRs
gh pr view [number]                 # Review specific PR
gh pr close [number]                # Close if obsolete
gh pr merge [number] --squash       # Merge if ready
```

### Branch Chaos? 🌪️
```bash
git branch --merged main            # See merged branches
git branch -d branch-name           # Delete local branch
git push origin --delete branch     # Delete remote branch
git remote prune origin             # Clean up dead references
```

---

## ⚡ DAILY WORKFLOW COMMANDS

### Start Your Day
```bash
cd /workspaces/PsychoNoir-Kontrapunkt
git checkout main
git pull origin main
gh pr list                          # Check pending PRs
gh issue list                       # Check open issues
```

### Create New Feature
```bash
git checkout -b feature/your-feature-name
# ... work on your code ...
git add .
git commit -m "✨ Add: Your feature description"
git push origin feature/your-feature-name
gh pr create --title "✨ Your Feature" --body "Description"
```

### Update Existing PR
```bash
git checkout your-branch
# ... make changes ...
git add .
git commit -m "🔧 Update: Changes made"
git push origin your-branch
# PR automatically updates
```

---

## 🎭 PSYCHO-NOIR SPECIFIC PATTERNS

### Thematic Branch Names
```bash
# Features
feature/skyskraper-astrid-milf-enhancement
feature/rustbelt-iron-maiden-resistance
feature/neural-interface-quantum-enhancement

# Bugfixes
bugfix/den-usynlige-hand-corruption-fix
hotfix/temporal-stability-critical

# Experiments
experiment/eva-green-aerospace-psychology
experiment/raven-bytes-digital-warfare
```

### Character-Based Commit Messages
```bash
git commit -m "💋 MILF: Enhance Astrid's psychological warfare algorithms"
git commit -m "⚔️ Iron Maiden: Implement guerrilla resistance protocols"
git commit -m "🧠 Neural: Upgrade quantum consciousness interface"
git commit -m "👻 Usynlige Hånd: Add chaos manifestation engine"
```

---

## 🤖 COPILOT OPTIMIZATION

### Best Practices
```typescript
// Good: Specific context comments
// Generate Astrid Møller's psychological profile analysis
function analyzeTarget(person: any) {
    // Copilot will suggest relevant implementation
}

// Better: Include expected behavior
/**
 * Analyzes psychological vulnerabilities for MILF matriarchy operations.
 * Returns: {vulnerabilities: string[], manipulation_vectors: string[], confidence: number}
 */
function generatePsychologicalProfile(target: Person): PsychProfile {
    // Copilot generates more accurate code
}
```

### Managing Copilot Branches
```bash
# List Copilot branches
git branch -r | grep "copilot/"

# Review before merging
git checkout copilot/fix-specific-id
git log --oneline
git diff main

# Clean up after review
git checkout main
git branch -D copilot/fix-specific-id
git push origin --delete copilot/fix-specific-id
```

---

## 📊 MONITORING & MAINTENANCE

### Weekly Cleanup
```bash
# Every Monday
git checkout main
git pull origin main
git branch --merged main | grep -v "main" | xargs git branch -d
git remote prune origin

# Review PRs
gh pr list --state open

# Review issues
gh issue list --state open
```

### Monthly Audit
```bash
# Run the cleanup script
./.github/repository_cleanup_script.sh

# Review audit reports
ls -la .github/audits/

# Update documentation
# Review and update README.md
# Update .github/GITHUB_COPILOT_NINJA_COURSE.md if needed
```

---

## 🔧 TROUBLESHOOTING

### Authentication Issues
```bash
gh auth login                       # Authenticate GitHub CLI
gh auth status                      # Check auth status
```

### Merge Conflicts
```bash
git status                          # See conflicted files
# Edit files to resolve conflicts
git add .                          # Stage resolved files
git commit                         # Complete merge
```

### Accidental Commits
```bash
git reset --soft HEAD~1            # Undo last commit (keep changes)
git reset --hard HEAD~1            # Undo last commit (lose changes)
git revert HEAD                    # Create new commit that undoes last one
```

### Lost Work
```bash
git reflog                         # See command history
git checkout [commit-hash]         # Recover lost commits
git branch recovery [commit-hash]  # Save recovered work
```

---

## 🎯 PRODUCTIVITY SHORTCUTS

### Git Aliases (Add to ~/.gitconfig)
```bash
[alias]
    st = status -s
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --all
    last = log -1 HEAD
    unstage = reset HEAD --
```

### VS Code Shortcuts
- `Ctrl+Shift+P` → Command palette
- `Ctrl+Shift+G` → Git panel
- `Ctrl+Shift+E` → Explorer
- `Ctrl+`` → Terminal

### GitHub CLI Shortcuts
```bash
# Create aliases
alias gpr="gh pr create"
alias gpl="gh pr list"
alias gil="gh issue list"
alias gic="gh issue create"
```

---

## 🏆 SUCCESS METRICS

### Weekly Goals
- [ ] < 5 open PRs at any time
- [ ] < 10 active branches
- [ ] All PRs reviewed within 3 days
- [ ] All critical issues labeled and prioritized

### Monthly Goals
- [ ] Clean commit history
- [ ] Documentation up to date
- [ ] No stale branches > 30 days
- [ ] CI/CD pipeline working smoothly

---

## 📞 HELP & RESOURCES

### Documentation
- [GitHub Docs](https://docs.github.com)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Copilot Documentation](https://docs.github.com/en/copilot)

### Your Project Resources
- Course: `.github/GITHUB_COPILOT_NINJA_COURSE.md`
- Cleanup Script: `.github/repository_cleanup_script.sh`
- Audits: `.github/audits/`

### Emergency Help
```bash
# If totally lost:
git status                         # Where am I?
git branch                         # What branches exist?
git log --oneline -10             # What happened recently?
git stash                         # Save current work
git checkout main                 # Go to safety
```

---

**Remember:** You're not just managing code - you're orchestrating the digital manifestation of the Psycho-Noir Kontrapunkt universe! 🎭✨

*"In the neural interface between chaos and order, systematic GitHub mastery becomes the quantum bridge that transforms complexity into organized power."* - The GitHub Ninja Way 🥷💻
