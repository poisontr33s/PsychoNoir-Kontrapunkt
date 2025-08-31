#!/bin/bash
set -e

echo "🎭 Setting up PsychoNoir-Kontrapunkt Development Environment..."

# Install system dependencies
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  git \
  curl \
  wget \
  jq \
  tree \
  htop \
  python3-venv \
  python3-pip

# Setup Node.js environment and fix failing runners
echo "📦 Installing Node.js dependencies..."
npm install

# Add missing jest-junit for failing tests
echo "🧪 Adding missing test dependencies..."
npm install --save-dev jest-junit

# Setup Python environment
echo "🐍 Setting up Python environment..."
pip3 install --user --upgrade pip
pip3 install --user -r backend/requirements.txt || echo "Requirements file not found, continuing..."

# Install additional Python packages for ML siphoning
pip3 install --user \
  scikit-learn \
  pandas \
  numpy \
  matplotlib \
  seaborn \
  jupyter \
  notebook

# Fix git submodule issues
echo "🔧 Fixing git submodule configuration..."
git config --global --add safe.directory /workspace
git submodule update --init --recursive || echo "Submodule update failed, continuing..."

# Create graveyard analysis tools
echo "🏴‍☠️ Setting up graveyard ML siphoning tools..."
mkdir -p scripts/ml_siphon

# Create graveyard scanner script
cat > scripts/ml_siphon/graveyard_scanner.py << 'EOF'
#!/usr/bin/env python3
"""
🏴‍☠️ PsychoNoir Graveyard ML Siphoning Scanner
MODUS: JÆVLIG CODING-AGGRESSIVE - Digital Necromancy Observatory System

Scans the graveyard for ML-ready artifacts that can be pre-siphoned.
"""

import os
import json
import glob
import datetime
from pathlib import Path

class GraveyardMLSiphon:
    def __init__(self, graveyard_path=".graveyard"):
        self.graveyard_path = Path(graveyard_path)
        self.siphon_manifest = {
            "scan_timestamp": datetime.datetime.now().isoformat(),
            "artifacts": {},
            "ml_ready_sessions": [],
            "code_fragments": [],
            "session_logs": [],
            "corrupted_datasets": []
        }
    
    def scan_sessions(self):
        """Scan graveyard sessions for ML training data"""
        sessions_path = self.graveyard_path / "sessions"
        if sessions_path.exists():
            for session_dir in sessions_path.glob("*"):
                if session_dir.is_dir():
                    session_data = self.analyze_session(session_dir)
                    if session_data:
                        self.siphon_manifest["ml_ready_sessions"].append(session_data)
    
    def analyze_session(self, session_path):
        """Analyze individual session for ML potential"""
        session_info = {
            "path": str(session_path),
            "name": session_path.name,
            "files": [],
            "ml_potential": "unknown",
            "corruption_signature": None
        }
        
        # Scan for interesting files
        for file_path in session_path.rglob("*"):
            if file_path.is_file():
                file_info = {
                    "name": file_path.name,
                    "size": file_path.stat().st_size,
                    "type": file_path.suffix,
                    "psycho_noir_potential": self.assess_psycho_noir_potential(file_path)
                }
                session_info["files"].append(file_info)
        
        # Assess ML readiness
        session_info["ml_potential"] = self.assess_ml_potential(session_info)
        return session_info
    
    def assess_psycho_noir_potential(self, file_path):
        """Assess if file contains PsychoNoir narrative/code artifacts"""
        psycho_noir_keywords = [
            "astrid", "iron_maiden", "skyskraperen", "rustbeltet",
            "usynlige_hand", "kausalitets_arkitekten", "ERROR:", "PANIC:",
            "0xDEADBEEF", "psycho_noir", "kontrapunkt"
        ]
        
        try:
            if file_path.suffix in ['.py', '.js', '.md', '.txt', '.log']:
                content = file_path.read_text(encoding='utf-8', errors='ignore').lower()
                matches = sum(1 for keyword in psycho_noir_keywords if keyword in content)
                return "high" if matches > 3 else "medium" if matches > 0 else "low"
        except:
            pass
        return "unknown"
    
    def assess_ml_potential(self, session_info):
        """Assess session's potential for ML training"""
        total_files = len(session_info["files"])
        high_potential_files = sum(1 for f in session_info["files"] 
                                 if f["psycho_noir_potential"] == "high")
        
        if high_potential_files > 5 and total_files > 10:
            return "excellent"
        elif high_potential_files > 2:
            return "good"
        elif total_files > 5:
            return "moderate"
        else:
            return "low"
    
    def generate_siphon_manifest(self):
        """Generate ML siphon manifest"""
        self.scan_sessions()
        
        # Sort by ML potential
        self.siphon_manifest["ml_ready_sessions"].sort(
            key=lambda x: {"excellent": 4, "good": 3, "moderate": 2, "low": 1}.get(x["ml_potential"], 0),
            reverse=True
        )
        
        return self.siphon_manifest
    
    def save_manifest(self, output_path="ml_siphon_manifest.json"):
        """Save siphon manifest to file"""
        manifest = self.generate_siphon_manifest()
        with open(output_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        return output_path

if __name__ == "__main__":
    print("🏴‍☠️ Initializing PsychoNoir Graveyard ML Siphon Scanner...")
    print("MODUS: JÆVLIG CODING-AGGRESSIVE Digital Necromancy")
    
    siphon = GraveyardMLSiphon()
    manifest_path = siphon.save_manifest()
    
    print(f"✅ ML Siphon Manifest generated: {manifest_path}")
    print("🎭 Ready for ML data extraction and model training preparation")
EOF

chmod +x scripts/ml_siphon/graveyard_scanner.py

# Run initial graveyard scan
echo "🔍 Running initial graveyard scan for ML siphoning..."
python3 scripts/ml_siphon/graveyard_scanner.py

# Create quick fix for failing tests
echo "🧪 Creating quick fixes for failing GitHub Actions..."

# Fix jest.config.js to handle missing jest-junit
cat > jest.config.js << 'EOF'
module.exports = {
  testEnvironment: 'node',
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  testMatch: [
    '**/__tests__/**/*.js',
    '**/?(*.)+(spec|test).js'
  ],
  // Only use jest-junit if it's available
  ...((() => {
    try {
      require('jest-junit');
      return {
        reporters: [
          'default',
          ['jest-junit', {
            outputDirectory: 'test-results/jest',
            outputName: 'junit.xml'
          }]
        ]
      };
    } catch (e) {
      console.warn('jest-junit not available, using default reporter');
      return {};
    }
  })())
};
EOF

# Create a runner fix script
cat > scripts/fix_runners.sh << 'EOF'
#!/bin/bash
echo "🔧 Fixing GitHub Actions runner issues..."

# Add missing jest-junit
npm install --save-dev jest-junit

# Fix Python build structure
mkdir -p backend/python
cd backend/python

# Create minimal pyproject.toml if missing
if [ ! -f pyproject.toml ]; then
cat > pyproject.toml << 'PYPROJECT'
[build-system]
requires = ["setuptools>=45", "wheel", "setuptools_scm[toml]>=6.2"]
build-backend = "setuptools.build_meta"

[project]
name = "psychonoir-kontrapunkt"
version = "0.1.0"
description = "PsychoNoir Kontrapunkt Digital Necromancy Observatory System"
authors = [{name = "PoisonTr33s", email = "dev@psychonoir.kontrapunkt"}]
dependencies = [
    "flask",
    "requests",
    "psutil"
]

[tool.setuptools]
packages = ["psychonoir_kontrapunkt"]
PYPROJECT
fi

cd ../..

echo "✅ Runner fixes applied"
EOF

chmod +x scripts/fix_runners.sh

# Apply fixes
./scripts/fix_runners.sh

echo "✅ PsychoNoir-Kontrapunkt Development Environment Ready!"
echo "🎭 Codespace configured for failing runner resolution and ML siphoning"
echo ""
echo "📋 Available commands:"
echo "  ./start.sh                           - Start the application"
echo "  ./stop.sh                            - Stop the application" 
echo "  python3 scripts/ml_siphon/graveyard_scanner.py - Scan graveyard for ML artifacts"
echo "  scripts/fix_runners.sh               - Apply GitHub Actions fixes"
echo ""
echo "🏴‍☠️ ML Siphon Mode: ENABLED"
echo "🎯 Ready for Digital Necromancy Operations"