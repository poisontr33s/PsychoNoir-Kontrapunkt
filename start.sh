#!/bin/bash
# 🎭 Psycho-Noir Kontrapunkt Simple Startup Script 🎭
# ===================================================

echo "🎭 Starting Psycho-Noir Kontrapunkt Application..."
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Python dependencies
print_status "Checking Python dependencies..."
if ! python -c "import flask, flask_cors, psutil" 2>/dev/null; then
    print_warning "Installing Python dependencies..."
    pip install -r backend/requirements.txt
fi

# Check if backend is running
if curl -s http://localhost:5000/health >/dev/null 2>&1; then
    print_warning "Backend already running on port 5000"
else
    print_status "Starting Flask backend..."
    cd backend/python
    python flask_backend_server.py &
    BACKEND_PID=$!
    echo $BACKEND_PID > ../../logs/backend.pid
    cd ../..
    
    # Wait for backend to start
    sleep 3
    if curl -s http://localhost:5000/health >/dev/null 2>&1; then
        print_status "Backend started successfully on http://localhost:5000"
    else
        print_error "Backend failed to start"
        exit 1
    fi
fi

# Start frontend
print_status "Starting frontend on port 8000..."
cd frontend
python -m http.server 8000 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../logs/frontend.pid
cd ..

sleep 2
print_status "Application started successfully!"
echo ""
echo "🌐 Frontend: http://localhost:8000"
echo "🔧 Backend API: http://localhost:5000"
echo "📊 Health Check: http://localhost:5000/health"
echo ""
echo "To stop the application, run: ./stop.sh"
echo "To see logs, check the logs/ directory"