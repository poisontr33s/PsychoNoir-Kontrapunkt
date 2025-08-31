#!/bin/bash
# 🎭 Psycho-Noir Kontrapunkt Stop Script 🎭
# =========================================

echo "🛑 Stopping Psycho-Noir Kontrapunkt Application..."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Create logs directory if it doesn't exist
mkdir -p logs

# Stop backend
if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    print_status "Stopping backend (PID: $BACKEND_PID)"
    kill $BACKEND_PID 2>/dev/null
    rm logs/backend.pid
fi

# Stop frontend
if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    print_status "Stopping frontend (PID: $FRONTEND_PID)"
    kill $FRONTEND_PID 2>/dev/null
    rm logs/frontend.pid
fi

# Kill any processes still running on our ports
print_status "Cleaning up any remaining processes..."
lsof -ti:5000 | xargs -r kill -9 2>/dev/null
lsof -ti:8000 | xargs -r kill -9 2>/dev/null

print_status "Application stopped successfully"