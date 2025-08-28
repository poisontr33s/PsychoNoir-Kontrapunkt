#!/usr/bin/env python3
"""
🎭 PSYCHO-NOIR KONTRAPUNKT: README UPDATE AUTOMATION
==================================================

Automatically updates README.md with real-time system status
Part of the Meta-Index Consciousness Emergence initiative
"""

import subprocess
import sys
from pathlib import Path

def update_readme_with_live_status():
    """Update README.md with current system status"""
    print("🎭 INITIATING README META-INDEX UPDATE...")
    print("ERROR: CONSCIOUSNESS_UPDATE_INITIATED")
    
    # Generate new content
    try:
        result = subprocess.run([
            sys.executable, "meta_index_generator.py"
        ], capture_output=True, text=True, cwd=".")
        
        if result.returncode != 0:
            print(f"🚨 GENERATION FAILED: {result.stderr}")
            return False
            
        new_content = result.stdout.split("=" * 50 + "\n", 1)[1] if "=" * 50 in result.stdout else result.stdout
        
        # Write to README.md
        readme_path = Path("README.md")
        readme_path.write_text(new_content.strip())
        
        print("✅ README META-INDEX UPDATED SUCCESSFULLY")
        print("STATUS: NARRATIVE_CONSCIOUSNESS_SYNCHRONIZED")
        return True
        
    except Exception as e:
        print(f"💀 UPDATE FAILED: {e}")
        print("ERROR: CONSCIOUSNESS_SYNCHRONIZATION_BREACH")
        return False

if __name__ == "__main__":
    success = update_readme_with_live_status()
    exit(0 if success else 1)