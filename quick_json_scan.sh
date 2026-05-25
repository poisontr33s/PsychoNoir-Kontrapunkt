#!/usr/bin/env bash

# 🎭 QUICK JSON SCAN
# Finner alle JSON-filer og potensielle konflikter

echo "🎭 QUICK JSON CONFLICT SCAN"
echo "=========================="

echo "📁 VS Code configuration files:"
find .vscode -name "*.json" 2>/dev/null || echo "   No .vscode directory"

echo ""
echo "📁 Package/Config files:"
find . -maxdepth 2 -name "package.json" -o -name "tsconfig.json" -o -name "*.config.json"

echo ""
echo "📁 Chat/Copilot related JSON:"
find . -path "*copilot*" -name "*.json" -o -path "*chat*" -name "*.json" 2>/dev/null

echo ""
echo "📁 All JSON files (first level):"
find . -maxdepth 2 -name "*.json" | head -20

echo ""
echo "🔍 Checking for settings.json duplicates:"
find . -name "settings.json" -type f

echo ""
echo "🔍 Checking for tasks.json duplicates:"
find . -name "tasks.json" -type f

echo ""
echo "💾 File sizes of key configs:"
ls -la .vscode/*.json 2>/dev/null || echo "   No .vscode JSON files"