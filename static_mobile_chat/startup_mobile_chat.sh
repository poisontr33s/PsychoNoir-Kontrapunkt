#!/bin/bash
# 🎭💬 PsychoNoir Mobile Chat Auto-Startup
echo "🎭💬 Initializing PsychoNoir Mobile Chat Integration..."

# Set environment variables
export PSYCHONOIR_MOBILE_CHAT_ACTIVE=true
export PSYCHONOIR_CHAT_URL="https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/static_mobile_chat/mobile_chat.html"
export PSYCHONOIR_MIDDLEWARE_URL="https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/vscode_chat_middleware/vscode_chat_overlay.js"

# Log the activation
echo "✅ PsychoNoir Mobile Chat URLs:"
echo "📱 Standalone Chat: $PSYCHONOIR_CHAT_URL"
echo "🔧 Middleware: $PSYCHONOIR_MIDDLEWARE_URL"
echo "🎯 Press Ctrl+Shift+C in VS Code for overlay"
echo "🎯 Press Ctrl+Alt+M for standalone mobile chat"

# Optional: Auto-open mobile chat in simple browser (commented out by default)
# code --command simpleBrowser.show $PSYCHONOIR_CHAT_URL

echo "🎭✅ PsychoNoir Mobile Chat Integration Ready!"
        