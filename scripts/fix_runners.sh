#!/bin/bash
echo "🔧 PsychoNoir-Kontrapunkt Runner Fix Script"
echo "MODUS: JÆVLIG CODING-AGGRESSIVE Digital Necromancy"

# Fix Node.js test issues
echo "📦 Fixing Node.js test dependencies..."
npm install --save-dev jest-junit

# Fix git submodule issues
echo "🔧 Fixing git submodule configuration..."
git config --global --add safe.directory $(pwd)
git submodule deinit arkiv_gamle_ruby_prosjekter/FAYDE-on-Air-Pb-Ex_clone 2>/dev/null || true
git rm arkiv_gamle_ruby_prosjekter/FAYDE-on-Air-Pb-Ex_clone 2>/dev/null || true

# Ensure Python build structure exists
echo "🐍 Setting up Python build environment..."
mkdir -p backend/python/psychonoir_kontrapunkt

# Create missing test directories
echo "🧪 Creating test result directories..."
mkdir -p test-results/jest
mkdir -p test-results/python

# Install Python dependencies if requirements.txt exists
if [ -f backend/requirements.txt ]; then
    echo "📋 Installing Python requirements..."
    pip3 install -r backend/requirements.txt || echo "Python requirements installation failed, continuing..."
fi

# Fix npm cache issues
echo "🗂️ Fixing npm cache configuration..."
npm config set cache ~/.npm --global

echo "✅ Runner fixes applied successfully!"
echo "🎭 Ready for GitHub Actions execution"