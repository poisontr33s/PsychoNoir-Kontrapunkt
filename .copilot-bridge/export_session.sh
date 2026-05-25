#!/usr/bin/env bash

# Copilot Session Export Script
echo "🎭 Exporting Copilot Session..."
cd "$(dirname "$0")/.."
python3 tools/copilot_session_bridge.py --export
echo "✅ Export complete! Check .copilot-bridge/ directory"
