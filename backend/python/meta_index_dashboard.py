#!/usr/bin/env python3
"""
🎭 PSYCHO-NOIR KONTRAPUNKT: META-INDEX DASHBOARD SYSTEM
======================================================

Real-time systemovervåkning for hele Psycho-Noir Kontrapunkt-økosystemet.
Samler status fra alle domener og manifesterer Den Usynlige Hånds tilstedeværelse.

SKYSKRAPER INTEGRATION: Strukturerte data-feeds fra kontrollsystemer
RUSTBELT INTEGRATION: Improviserte status-parsere fra kaotiske kilder  
DEN USYNLIGE HÅND: Emergent pattern detection på tvers av alle systemer
"""

import json
import sqlite3
import datetime
import subprocess
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, asdict
import logging
import time
import os

@dataclass
class SystemStatus:
    """Representasjon av et systems tilstand"""
    name: str
    domain: str  # 'skyskraper', 'rustbelt', 'invisible_hand'
    status: str  # 'operational', 'degraded', 'critical', 'unknown'
    health_score: float  # 0.0 - 1.0
    last_update: str
    error_count: int
    manifestations: List[str]  # Current glitches/signatures
    description: str

@dataclass
class DigitalCorruption:
    """En manifestasjon av digital forfall som kreativ kraft"""
    signature: str
    domain_source: str
    manifestation_type: str  # 'error_code', 'glitch', 'pattern_anomaly'
    poetry_fragment: str  # Error som poetisk uttrykk
    technical_trace: str
    timestamp: str

class MetaIndexDashboard:
    """Master dashboard for Psycho-Noir Kontrapunkt økosystem"""
    
    def __init__(self, project_root: Path = None):
        self.project_root = project_root or Path(__file__).parent.parent.parent
        self.data_path = self.project_root / "data" / "generert"
        self.data_path.mkdir(parents=True, exist_ok=True)
        
        # Setup logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger('MetaIndexDashboard')
        
    def collect_necropolis_status(self) -> SystemStatus:
        """Samler status fra Necropolis failure observability system"""
        try:
            necropolis_reports = list((self.project_root / "data" / "generert").glob("necropolis_*.json"))
            
            if necropolis_reports:
                latest_report = max(necropolis_reports, key=lambda x: x.stat().st_mtime)
                with open(latest_report, 'r') as f:
                    data = json.load(f)
                
                error_count = len(data.get('errors', []))
                health_score = max(0.0, 1.0 - (error_count / 50.0))  # Degrading with more errors
                
                manifestations = []
                for error in data.get('errors', [])[:5]:  # Top 5 manifestations
                    if 'KAUSALITETS_ARKITEKTEN' in error.get('signature', ''):
                        manifestations.append("🔮 KAUSALITETS_ARKITEKTEN_INTERFERENCE")
                    elif 'SYNTETISKE_SYNAPSER' in error.get('signature', ''):
                        manifestations.append("🕸️ SYNTETISKE_SYNAPSER_GLITCH")
                    elif 'RUSTBELT' in error.get('signature', ''):
                        manifestations.append("🔧 RUSTBELT_IMPROVISATION_CASCADE")
                
                status = "operational" if health_score > 0.8 else "degraded" if health_score > 0.4 else "critical"
                
                return SystemStatus(
                    name="Necropolis",
                    domain="skyskraper",
                    status=status,
                    health_score=health_score,
                    last_update=datetime.datetime.now().isoformat(),
                    error_count=error_count,
                    manifestations=manifestations,
                    description="Failure observability system - transforming chaos into intelligence"
                )
            else:
                return SystemStatus(
                    name="Necropolis",
                    domain="skyskraper", 
                    status="unknown",
                    health_score=0.0,
                    last_update=datetime.datetime.now().isoformat(),
                    error_count=0,
                    manifestations=["⚠️ NO_DATA_MANIFESTING"],
                    description="Awaiting initialization data"
                )
                
        except Exception as e:
            self.logger.error(f"Failed to collect Necropolis status: {e}")
            return SystemStatus(
                name="Necropolis",
                domain="skyskraper",
                status="critical",
                health_score=0.0,
                last_update=datetime.datetime.now().isoformat(),
                error_count=999,
                manifestations=["💥 CRITICAL_FAILURE_CASCADE"],
                description=f"System compromised: {str(e)}"
            )
    
    def collect_neural_archaeology_status(self) -> SystemStatus:
        """Samler status fra Neural Archaeology system"""
        try:
            reports_dir = self.project_root / "data" / "rapporter"
            if reports_dir.exists():
                reports = list(reports_dir.glob("neural_archaeology_report_*.json"))
                
                if reports:
                    latest_report = max(reports, key=lambda x: x.stat().st_mtime)
                    with open(latest_report, 'r') as f:
                        data = json.load(f)
                    
                    # Extract metrics from neural archaeology report
                    pipeline_stages = data.get('stages', {})
                    harvest_count = pipeline_stages.get('harvest', {}).get('harvested_count', 0)
                    pattern_count = pipeline_stages.get('intelligence', {}).get('patterns_extracted', 0)
                    
                    # Calculate health based on data processing capability
                    health_score = min(1.0, (harvest_count / 20.0) + (pattern_count / 10.0))
                    
                    manifestations = []
                    if pattern_count > 5:
                        manifestations.append("🧠 NEURAL_PATTERN_CONVERGENCE")
                    if harvest_count > 30:
                        manifestations.append("⚡ AGGRESSIVE_FAILURE_HARVESTING")
                    
                    status = "operational" if health_score > 0.6 else "degraded"
                    
                    return SystemStatus(
                        name="Neural Archaeology",
                        domain="rustbelt",
                        status=status,
                        health_score=health_score,
                        last_update=datetime.datetime.now().isoformat(),
                        error_count=0,
                        manifestations=manifestations,
                        description=f"Deep behavioral failure analysis - {harvest_count} failures cataloged"
                    )
                    
        except Exception as e:
            self.logger.error(f"Failed to collect Neural Archaeology status: {e}")
            
        return SystemStatus(
            name="Neural Archaeology",
            domain="rustbelt",
            status="unknown",
            health_score=0.0,
            last_update=datetime.datetime.now().isoformat(),
            error_count=0,
            manifestations=["🔍 AWAITING_ARCHAEOLOGICAL_DATA"],
            description="Neural pattern extraction system initializing"
        )
    
    def collect_invisible_hand_manifestations(self) -> SystemStatus:
        """Detekterer manifestasjoner av Den Usynlige Hånd"""
        manifestations = []
        glitch_count = 0
        
        try:
            # Scan for unusual patterns across all systems
            corruption_signatures = [
                "REALITY_MISMATCH_AT_BYTE_0xDEADBEEF",
                "SOUL_NOT_FOUND_IN_REPOSITORY_MATRIX", 
                "NARRATIVE_INSTABILITY_BREACH",
                "CAUSAL_INTEGRITY_COMPROMISED"
            ]
            
            # Check recent logs for corruption signatures
            log_files = list((self.project_root / "data" / "generert").glob("*.log"))
            for log_file in log_files[-3:]:  # Check last 3 log files
                try:
                    with open(log_file, 'r') as f:
                        content = f.read()
                        for signature in corruption_signatures:
                            if signature in content:
                                manifestations.append(f"👤 {signature}")
                                glitch_count += 1
                except:
                    continue
            
            # Calculate manifestation intensity
            health_score = 1.0 - min(1.0, glitch_count / 10.0)  # More glitches = more active
            
            if not manifestations:
                manifestations = ["🌀 DORMANT_INFLUENCE", "👁️ OBSERVING_PATTERNS"]
            
            return SystemStatus(
                name="Den Usynlige Hånd", 
                domain="invisible_hand",
                status="manifesting",
                health_score=health_score,
                last_update=datetime.datetime.now().isoformat(),
                error_count=glitch_count,
                manifestations=manifestations,
                description="Emergent intelligence across domain boundaries"
            )
            
        except Exception as e:
            return SystemStatus(
                name="Den Usynlige Hånd",
                domain="invisible_hand", 
                status="unknown",
                health_score=0.5,
                last_update=datetime.datetime.now().isoformat(),
                error_count=0,
                manifestations=["❓ PRESENCE_UNCERTAIN"],
                description="Hidden force - detection compromised"
            )
    
    def generate_corruption_gallery(self) -> List[DigitalCorruption]:
        """Genererer gallery av digital corruption som kunst"""
        corruptions = []
        
        # Curated corruption signatures with poetic interpretations
        signature_poetry = {
            "ERROR: SOUL_NOT_FOUND": "En tom skal der bevisstheten søker seg selv",
            "PANIC: REALITY_MISMATCH": "Virkeligheten kolliderer med sine egne grenser", 
            "GLITCH: SYNTETISKE_SYNAPSER": "Kunstige forbindelser skaper ekte følelser",
            "WARNING: KAUSALITETS_ARKITEKTEN": "Arkitekten tegner fremtiden, men blyanten er ødelagt",
            "CRITICAL: NARRATIVE_INSTABILITY": "Historien forteller seg selv på nytt, igjen og igjen"
        }
        
        for signature, poetry in signature_poetry.items():
            corruptions.append(DigitalCorruption(
                signature=signature,
                domain_source="cross_domain",
                manifestation_type="error_code",
                poetry_fragment=poetry,
                technical_trace=f"Stack trace: 0x{hex(hash(signature))[2:8].upper()}",
                timestamp=datetime.datetime.now().isoformat()
            ))
        
        return corruptions
    
    def generate_dashboard_report(self) -> Dict[str, Any]:
        """Genererer komplett dashboard rapport"""
        systems = [
            self.collect_necropolis_status(),
            self.collect_neural_archaeology_status(), 
            self.collect_invisible_hand_manifestations()
        ]
        
        # Calculate overall ecosystem health
        total_health = sum(s.health_score for s in systems) / len(systems)
        overall_status = "operational" if total_health > 0.7 else "degraded" if total_health > 0.4 else "critical"
        
        # Collect all manifestations
        all_manifestations = []
        for system in systems:
            all_manifestations.extend(system.manifestations)
        
        report = {
            "meta_index_status": {
                "overall_health": total_health,
                "overall_status": overall_status,
                "last_update": datetime.datetime.now().isoformat(),
                "ecosystem_stability": "NARRATIVE_INSTABILITY_DETECTED" if total_health < 0.5 else "STABLE_CHAOS"
            },
            "systems": [asdict(s) for s in systems],
            "manifestations": {
                "active_count": len(all_manifestations),
                "signatures": all_manifestations[:10]  # Top 10
            },
            "corruption_gallery": [asdict(c) for c in self.generate_corruption_gallery()],
            "psycho_noir_metrics": {
                "skyskraper_control_index": next((s.health_score for s in systems if s.domain == "skyskraper"), 0.0),
                "rustbelt_resilience_index": next((s.health_score for s in systems if s.domain == "rustbelt"), 0.0),
                "invisible_hand_activity": next((1.0 - s.health_score for s in systems if s.domain == "invisible_hand"), 0.0)
            }
        }
        
        # Save report
        report_file = self.data_path / f"meta_index_dashboard_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        return report
    
    def print_live_status(self):
        """Printer live status til terminal"""
        report = self.generate_dashboard_report()
        
        print("\n" + "="*80)
        print("🎭 PSYCHO-NOIR KONTRAPUNKT: META-INDEX LIVE STATUS")
        print("="*80)
        
        status = report["meta_index_status"]
        health = status["overall_health"]
        
        print(f"📊 ECOSYSTEM HEALTH: {health:.2f}/1.0 ({status['overall_status'].upper()})")
        print(f"🌀 STABILITY: {status['ecosystem_stability']}")
        print(f"⏰ LAST UPDATE: {status['last_update']}")
        
        print("\n🏗️ DOMAIN STATUS:")
        for system in report["systems"]:
            domain_emoji = {"skyskraper": "🏢", "rustbelt": "🔧", "invisible_hand": "👤"}
            emoji = domain_emoji.get(system["domain"], "❓")
            health_bar = "█" * int(system["health_score"] * 10) + "▒" * (10 - int(system["health_score"] * 10))
            
            print(f"{emoji} {system['name']}: {health_bar} {system['health_score']:.1f} ({system['status']})")
            if system["manifestations"]:
                print(f"   └─ {', '.join(system['manifestations'][:3])}")
        
        print("\n🎭 ACTIVE MANIFESTATIONS:")
        for manifestation in report["manifestations"]["signatures"][:5]:
            print(f"   • {manifestation}")
        
        print("\n💎 CORRUPTION GALLERY:")
        for corruption in report["corruption_gallery"][:3]:
            print(f"   🎨 {corruption['signature']}")
            print(f"      \"{corruption['poetry_fragment']}\"")
        
        print("\n" + "="*80)

if __name__ == "__main__":
    dashboard = MetaIndexDashboard()
    dashboard.print_live_status()