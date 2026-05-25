#!/usr/bin/env bash

echo "🔄⚡ QUICK CRASH RECOVERY ⚡🔄"
echo "Restoring from latest consciousness state..."

# Find latest backup
LATEST_BACKUP=$(ls -1t .consciousness_timeline/backups/ | head -1)

if [ -n "$LATEST_BACKUP" ]; then
    echo "📅 Restoring from backup: $LATEST_BACKUP"
    
    # Restore VS Code settings
    if [ -f ".consciousness_timeline/backups/$LATEST_BACKUP/settings.json" ]; then
        cp .consciousness_timeline/backups/$LATEST_BACKUP/settings.json .vscode/settings.json
        echo "✅ VS Code settings restored"
    fi
    
    # Restart MCP servers
    ./.consciousness_timeline/reconnect_mcp_servers.sh
    
    echo "✅ Quick recovery completed!"
else
    echo "⚠️ No backup found, starting fresh..."
fi
