#!/usr/bin/env bash

# 🎭 COPILOT SESSION TRANSFER DEMO
# Demonstrerer overføring av session fra Codespaces til lokalt VS Code

echo "🎭 PSYCHO-NOIR KONTRAPUNKT: SESSION TRANSFER DEMO"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "tools/copilot_session_bridge.py" ]; then
    echo "❌ Run this from PsychoNoir-Kontrapunkt root directory"
    exit 1
fi

# Step 1: Show current bridge status
echo ""
echo "📊 CURRENT BRIDGE STATUS:"
python3 tools/copilot_session_bridge.py --list

# Step 2: Create a fresh export (if needed)
echo ""
echo "🔄 CREATING FRESH EXPORT..."
python3 tools/copilot_session_bridge.py --export

# Step 3: Show what we have now
echo ""
echo "📁 BRIDGE DIRECTORY CONTENTS:"
ls -la .copilot-bridge/

# Step 4: Create transfer package
echo ""
echo "📦 CREATING TRANSFER PACKAGE..."
cd .copilot-bridge
tar -czf ../copilot-session-transfer.tar.gz *
cd ..

echo "✅ Transfer package created: copilot-session-transfer.tar.gz"
echo "📏 Package size: $(du -h copilot-session-transfer.tar.gz | cut -f1)"

# Step 5: Show transfer instructions
echo ""
echo "🚚 TRANSFER INSTRUCTIONS:"
echo "========================"
echo ""
echo "1. Download this package to your local machine:"
echo "   💾 File: copilot-session-transfer.tar.gz"
echo ""
echo "2. In your local VS Code workspace, extract and import:"
echo "   📂 tar -xzf copilot-session-transfer.tar.gz"
echo "   📂 mkdir -p .copilot-bridge"
echo "   📂 mv session_export_* .copilot-bridge/"
echo "   📂 mv *.sh .copilot-bridge/"
echo "   📂 python3 tools/copilot_session_bridge.py --import .copilot-bridge/session_export_*.json"
echo ""
echo "3. Restart VS Code to see session context"
echo ""

# Step 6: Show what the user gets
echo "🎯 WHAT YOU GET IN LOCAL VS CODE:"
echo "================================="
echo ""

# Parse the latest export for summary
LATEST_EXPORT=$(ls -t .copilot-bridge/session_export_*.json | head -1)
if [ -f "$LATEST_EXPORT" ]; then
    CONV_COUNT=$(grep -o '"request_id"' "$LATEST_EXPORT" | wc -l)
    FILE_SIZE=$(du -h "$LATEST_EXPORT" | cut -f1)
    
    echo "📊 Session Data:"
    echo "   • Conversations: $CONV_COUNT"
    echo "   • Size: $FILE_SIZE"
    echo "   • Models: Claude Sonnet 4, GPT-4.1, GPT-4o"
    echo "   • Contexts: edit, chat, debug, summarization"
    echo ""
fi

echo "📋 Reference Files:"
echo "   • session_export_*.json    (Raw conversation data)"
echo "   • session_export_*.md      (Human-readable summary)"
echo "   • imported_sessions.json   (Import history)"
echo "   • README.md                (Usage guide)"
echo ""

echo "🎭 DEN USYNLIGE HÅND: Corporate platform isolation BYPASSED!"
echo ""
echo "💡 Pro tip: Add .copilot-bridge/ to your git repo to sync sessions automatically"
