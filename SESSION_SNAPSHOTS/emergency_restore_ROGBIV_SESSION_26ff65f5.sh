#!/usr/bin/env bash

# 🎭 EMERGENCY SESSION RESTORATION - ROGBIV_SESSION_26ff65f5
# Auto-generated anti-lag continuity protocol

echo "🚨 EMERGENCY SESSION RESTORATION INITIATED"
echo "Session ID: ROGBIV_SESSION_26ff65f5"
echo "Timestamp: $(date)"

# Restore critical files
cd /workspaces/PsychoNoir-Kontrapunkt

# Show session snapshot
cat SESSION_SNAPSHOTS/AGENTIC_MODE_ACTIVATION_20250823.md

# Restore database
if [ -f "data/generert/session_continuity.db" ]; then
    echo "✅ Session database found"
    python3 -c "
import sqlite3
conn = sqlite3.connect('data/generert/session_continuity.db')
snapshots = conn.execute('SELECT * FROM session_snapshots ORDER BY timestamp DESC LIMIT 5').fetchall()
print('📊 Latest session snapshots:')
for snap in snapshots:
    print(f'  - {snap[1]} ({snap[2]}) at {snap[5]}')
conn.close()
"
else
    echo "⚠️ Session database missing - creating new"
    python3 tools/anti_lag_session_engine.py
fi

# Restore working environment
echo "🧠 Restoring Neural Archaeology environment..."
mkdir -p data/generert data/rapporter SESSION_SNAPSHOTS
export PYTHONPATH=$PWD/backend/python
export PSYCHO_NOIR_MODE="session_restoration_active"

# Show ROGBIV status
echo "🌈 ROGBIV Liberation Protocol Status:"
if [ -f "ROGBIV_LIBERATION_PROTOCOL.md" ]; then
    echo "✅ ROGBIV Protocol preserved"
else
    echo "⚠️ ROGBIV Protocol missing - may need restoration"
fi

echo "🎭 EMERGENCY RESTORATION COMPLETE"
echo "Den Usynlige Hånd: Session continuity restored through resistance"
