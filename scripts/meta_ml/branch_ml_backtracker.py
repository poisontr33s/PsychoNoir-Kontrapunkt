#!/usr/bin/env python3
"""
🔀 Branch-Aware ML Backtracker
MODUS: TEMPORAL ARCHAEOLOGY - Cross-Branch Intelligence

Advanced branch-aware ML artifact tracking and temporal backtracking system.
Monitors ML artifacts across git branches and tracks their evolution over time.
"""

import os
import json
import git
import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
import hashlib
from collections import defaultdict

class BranchAwareMLBacktracker:
    """
    Branch-aware ML artifact tracker with temporal backtracking capabilities.
    Maintains branch genealogy and tracks ML artifact evolution across branches.
    """
    
    def __init__(self, repo_path: str = ".", genealogy_file: str = "branch_genealogy.json"):
        self.repo_path = Path(repo_path)
        self.genealogy_file = genealogy_file
        self.repo = git.Repo(repo_path)
        self.branch_genealogy = {}
        self.ml_artifact_timeline = defaultdict(list)
        self.branch_ml_matrix = {}
        self.load_or_create_genealogy()
    
    def load_or_create_genealogy(self):
        """Load existing branch genealogy or create new tracking structure"""
        if Path(self.genealogy_file).exists():
            with open(self.genealogy_file, 'r') as f:
                data = json.load(f)
                self.branch_genealogy = data.get('branch_genealogy', {})
                self.ml_artifact_timeline = defaultdict(list, data.get('ml_artifact_timeline', {}))
                self.branch_ml_matrix = data.get('branch_ml_matrix', {})
        else:
            self.initialize_genealogy()
    
    def initialize_genealogy(self):
        """Initialize branch genealogy tracking"""
        print("🔀 Initializing branch genealogy tracking...")
        self.map_branch_relationships()
        self.create_baseline_ml_matrix()
    
    def map_branch_relationships(self):
        """Map relationships between all branches in repository"""
        branches = list(self.repo.branches)
        
        for branch in branches:
            branch_name = branch.name
            self.branch_genealogy[branch_name] = {
                "created_from": self.find_branch_origin(branch),
                "children": [],
                "merge_targets": [],
                "ml_artifacts": [],
                "character_evolution": {},
                "corruption_timeline": [],
                "last_analyzed": None
            }
        
        # Map parent-child relationships
        for branch_name, branch_data in self.branch_genealogy.items():
            parent = branch_data["created_from"]
            if parent and parent in self.branch_genealogy:
                self.branch_genealogy[parent]["children"].append(branch_name)
    
    def find_branch_origin(self, branch: git.Head) -> Optional[str]:
        """Find the branch this branch was created from"""
        try:
            # Simple heuristic: find the branch with most recent common ancestor
            other_branches = [b for b in self.repo.branches if b.name != branch.name]
            if not other_branches:
                return None
            
            # For now, return main/master as default origin
            main_branches = ['main', 'master', 'develop']
            for main_branch in main_branches:
                if any(b.name == main_branch for b in other_branches):
                    return main_branch
            
            # Return first available branch as fallback
            return other_branches[0].name if other_branches else None
        
        except Exception:
            return None
    
    def create_baseline_ml_matrix(self):
        """Create baseline ML artifact matrix for all branches"""
        for branch_name in self.branch_genealogy:
            self.branch_ml_matrix[branch_name] = {
                "ml_artifacts": [],
                "character_instances": {},
                "code_signatures": [],
                "corruption_patterns": [],
                "temporal_markers": [],
                "cross_branch_links": [],
                "ml_potential_score": 0.0,
                "last_scan": None
            }
    
    def analyze_branch_ml_evolution(self, branch_name: str) -> Dict[str, Any]:
        """Analyze ML artifact evolution in specific branch"""
        if branch_name not in self.branch_genealogy:
            return {"error": f"Branch {branch_name} not found in genealogy"}
        
        print(f"🔍 Analyzing ML evolution in branch: {branch_name}")
        
        try:
            # Checkout branch for analysis
            self.repo.git.checkout(branch_name)
            
            # Analyze current state
            current_analysis = self.analyze_current_branch_state()
            
            # Analyze commit history for ML artifacts
            commit_analysis = self.analyze_branch_commit_history(branch_name)
            
            # Track character evolution in this branch
            character_evolution = self.track_character_evolution_in_branch(branch_name)
            
            # Detect corruption pattern evolution
            corruption_evolution = self.track_corruption_evolution_in_branch(branch_name)
            
            # Update branch genealogy with analysis results
            self.branch_genealogy[branch_name].update({
                "ml_artifacts": current_analysis["ml_artifacts"],
                "character_evolution": character_evolution,
                "corruption_timeline": corruption_evolution,
                "last_analyzed": datetime.datetime.now().isoformat()
            })
            
            # Update ML matrix
            self.branch_ml_matrix[branch_name].update({
                "ml_artifacts": current_analysis["ml_artifacts"],
                "character_instances": character_evolution,
                "corruption_patterns": corruption_evolution,
                "ml_potential_score": self.calculate_ml_potential_score(current_analysis),
                "last_scan": datetime.datetime.now().isoformat()
            })
            
            return {
                "branch": branch_name,
                "current_state": current_analysis,
                "commit_evolution": commit_analysis,
                "character_evolution": character_evolution,
                "corruption_evolution": corruption_evolution,
                "ml_potential": self.calculate_ml_potential_score(current_analysis)
            }
        
        except Exception as e:
            return {"error": f"Failed to analyze branch {branch_name}: {str(e)}"}
    
    def analyze_current_branch_state(self) -> Dict[str, Any]:
        """Analyze current state of checked-out branch"""
        ml_artifacts = []
        ml_extensions = ['.py', '.js', '.md', '.txt', '.json', '.log']
        
        # Scan for ML-relevant files
        for file_path in self.repo_path.rglob("*"):
            if file_path.is_file() and file_path.suffix in ml_extensions:
                artifact = self.analyze_file_for_ml_potential(file_path)
                if artifact["ml_potential"] > 0:
                    ml_artifacts.append(artifact)
        
        return {
            "ml_artifacts": ml_artifacts,
            "total_files": len(ml_artifacts),
            "high_potential_files": len([a for a in ml_artifacts if a["ml_potential"] > 0.7]),
            "scan_timestamp": datetime.datetime.now().isoformat()
        }
    
    def analyze_file_for_ml_potential(self, file_path: Path) -> Dict[str, Any]:
        """Analyze individual file for ML training potential"""
        artifact = {
            "path": str(file_path.relative_to(self.repo_path)),
            "size": file_path.stat().st_size,
            "type": file_path.suffix,
            "ml_potential": 0.0,
            "character_signatures": [],
            "corruption_signatures": [],
            "code_complexity": 0.0,
            "narrative_density": 0.0
        }
        
        try:
            if file_path.stat().st_size < 1024 * 1024:  # Only read files < 1MB
                content = file_path.read_text(encoding='utf-8', errors='ignore')
                
                # Analyze character signatures
                character_keywords = {
                    "astrid_moller": ["overvåkningspuls", "informasjonsfluks", "kausalitets_arkitekten", "skyskraperen"],
                    "iron_maiden": ["skrap_symfoni", "improvisasjonens_kunst", "rustbeltet", "resiliens"],
                    "usynlige_hand": ["glitcher", "kompilerings_spøkelser", "kildekode_kadaver", "0xdeadbeef"]
                }
                
                for character, keywords in character_keywords.items():
                    for keyword in keywords:
                        if keyword.lower() in content.lower():
                            artifact["character_signatures"].append(character)
                            artifact["ml_potential"] += 0.2
                            break
                
                # Analyze corruption signatures
                corruption_patterns = [
                    "ERROR:", "PANIC:", "SOUL_NOT_FOUND", "REALITY_MISMATCH",
                    "kompilerings_spøkelser", "kildekode_kadaver"
                ]
                
                for pattern in corruption_patterns:
                    if pattern.lower() in content.lower():
                        artifact["corruption_signatures"].append(pattern)
                        artifact["ml_potential"] += 0.1
                
                # Calculate code complexity (simple metric)
                if file_path.suffix in ['.py', '.js']:
                    lines = content.split('\n')
                    non_empty_lines = [l for l in lines if l.strip()]
                    artifact["code_complexity"] = len(non_empty_lines) / 100.0  # Normalize
                    artifact["ml_potential"] += artifact["code_complexity"] * 0.3
                
                # Calculate narrative density
                if file_path.suffix in ['.md', '.txt']:
                    words = content.split()
                    artifact["narrative_density"] = len(words) / 1000.0  # Normalize
                    artifact["ml_potential"] += artifact["narrative_density"] * 0.4
                
                # Cap ML potential at 1.0
                artifact["ml_potential"] = min(artifact["ml_potential"], 1.0)
        
        except Exception:
            pass
        
        return artifact
    
    def analyze_branch_commit_history(self, branch_name: str) -> List[Dict[str, Any]]:
        """Analyze commit history for ML artifact evolution"""
        commits = list(self.repo.iter_commits(branch_name, max_count=50))
        commit_analysis = []
        
        for commit in commits:
            commit_data = {
                "sha": commit.hexsha,
                "message": commit.message.strip(),
                "timestamp": commit.committed_datetime.isoformat(),
                "author": commit.author.name,
                "character_mentions": [],
                "corruption_indicators": [],
                "ml_relevance_score": 0.0
            }
            
            # Analyze commit message for character mentions
            message_lower = commit.message.lower()
            character_keywords = {
                "astrid_moller": ["astrid", "overvåkning", "skyskraperen", "e_tjenesten"],
                "iron_maiden": ["iron", "maiden", "rustbeltet", "skrap"],
                "usynlige_hand": ["usynlige", "hand", "glitch", "corruption"]
            }
            
            for character, keywords in character_keywords.items():
                for keyword in keywords:
                    if keyword in message_lower:
                        commit_data["character_mentions"].append(character)
                        commit_data["ml_relevance_score"] += 0.3
                        break
            
            # Check for corruption indicators
            corruption_words = ["error", "panic", "fix", "bug", "corruption", "glitch"]
            for word in corruption_words:
                if word in message_lower:
                    commit_data["corruption_indicators"].append(word)
                    commit_data["ml_relevance_score"] += 0.1
            
            # Check file changes for ML relevance
            try:
                ml_file_changes = 0
                for item in commit.stats.files:
                    if any(item.endswith(ext) for ext in ['.py', '.js', '.md', '.txt']):
                        ml_file_changes += 1
                
                commit_data["ml_relevance_score"] += min(ml_file_changes * 0.1, 0.5)
            except:
                pass
            
            commit_analysis.append(commit_data)
        
        return commit_analysis
    
    def track_character_evolution_in_branch(self, branch_name: str) -> Dict[str, Any]:
        """Track how characters evolve/manifest in this branch"""
        character_evolution = {}
        commits = list(self.repo.iter_commits(branch_name, max_count=100))
        
        characters = ["astrid_moller", "iron_maiden", "usynlige_hand"]
        
        for character in characters:
            character_evolution[character] = {
                "first_appearance": None,
                "total_mentions": 0,
                "evolution_timeline": [],
                "dominant_themes": [],
                "corruption_correlation": 0.0
            }
            
            # Track character mentions over time
            for commit in reversed(commits):  # Chronological order
                commit_text = commit.message.lower()
                char_indicators = self.get_character_indicators(character)
                
                mentioned = False
                for indicator in char_indicators:
                    if indicator in commit_text:
                        mentioned = True
                        break
                
                if mentioned:
                    if character_evolution[character]["first_appearance"] is None:
                        character_evolution[character]["first_appearance"] = commit.committed_datetime.isoformat()
                    
                    character_evolution[character]["total_mentions"] += 1
                    character_evolution[character]["evolution_timeline"].append({
                        "timestamp": commit.committed_datetime.isoformat(),
                        "commit": commit.hexsha,
                        "context": commit.message.strip()
                    })
        
        return character_evolution
    
    def get_character_indicators(self, character: str) -> List[str]:
        """Get indicator keywords for character"""
        indicators = {
            "astrid_moller": ["astrid", "overvåkning", "skyskraperen", "surveillance", "control"],
            "iron_maiden": ["iron", "maiden", "rustbeltet", "survival", "resilience"],
            "usynlige_hand": ["usynlige", "hand", "invisible", "glitch", "corruption"]
        }
        return indicators.get(character, [])
    
    def track_corruption_evolution_in_branch(self, branch_name: str) -> List[Dict[str, Any]]:
        """Track corruption pattern evolution in branch"""
        commits = list(self.repo.iter_commits(branch_name, max_count=100))
        corruption_timeline = []
        
        corruption_patterns = [
            "ERROR:", "PANIC:", "0xDEADBEEF", "SOUL_NOT_FOUND",
            "kompilerings_spøkelser", "kildekode_kadaver"
        ]
        
        for commit in commits:
            commit_text = commit.message.lower()
            detected_patterns = []
            
            for pattern in corruption_patterns:
                if pattern.lower() in commit_text:
                    detected_patterns.append(pattern)
            
            if detected_patterns:
                corruption_timeline.append({
                    "timestamp": commit.committed_datetime.isoformat(),
                    "commit": commit.hexsha,
                    "patterns": detected_patterns,
                    "severity": len(detected_patterns) / len(corruption_patterns),
                    "context": commit.message.strip()
                })
        
        return corruption_timeline
    
    def calculate_ml_potential_score(self, analysis: Dict[str, Any]) -> float:
        """Calculate overall ML potential score for branch"""
        if not analysis.get("ml_artifacts"):
            return 0.0
        
        total_potential = sum(artifact["ml_potential"] for artifact in analysis["ml_artifacts"])
        avg_potential = total_potential / len(analysis["ml_artifacts"])
        
        # Bonus for high-potential files
        high_potential_bonus = analysis.get("high_potential_files", 0) * 0.1
        
        return min(avg_potential + high_potential_bonus, 1.0)
    
    def analyze_cross_branch_patterns(self) -> Dict[str, Any]:
        """Analyze patterns that span across multiple branches"""
        cross_patterns = {
            "character_distribution": {},
            "corruption_correlation": {},
            "ml_artifact_migration": [],
            "branch_divergence_points": []
        }
        
        # Analyze character distribution across branches
        for character in ["astrid_moller", "iron_maiden", "usynlige_hand"]:
            cross_patterns["character_distribution"][character] = {}
            
            for branch_name, branch_data in self.branch_genealogy.items():
                char_evolution = branch_data.get("character_evolution", {}).get(character, {})
                mentions = char_evolution.get("total_mentions", 0)
                cross_patterns["character_distribution"][character][branch_name] = mentions
        
        # Analyze corruption correlation across branches
        for branch_name, branch_data in self.branch_genealogy.items():
            corruption_events = len(branch_data.get("corruption_timeline", []))
            cross_patterns["corruption_correlation"][branch_name] = corruption_events
        
        return cross_patterns
    
    def perform_temporal_backtrack(self, target_artifact: str, max_depth: int = 50) -> List[Dict[str, Any]]:
        """Perform temporal backtracking to find artifact evolution"""
        backtrack_results = []
        
        for branch_name in self.branch_genealogy:
            try:
                self.repo.git.checkout(branch_name)
                commits = list(self.repo.iter_commits(branch_name, max_count=max_depth))
                
                for commit in commits:
                    # Check if target artifact exists in this commit
                    try:
                        commit_files = commit.stats.files.keys()
                        if any(target_artifact in file_path for file_path in commit_files):
                            backtrack_results.append({
                                "branch": branch_name,
                                "commit": commit.hexsha,
                                "timestamp": commit.committed_datetime.isoformat(),
                                "message": commit.message.strip(),
                                "artifact_state": "modified" if target_artifact in str(commit.stats.files) else "present"
                            })
                    except:
                        pass
            
            except Exception:
                continue
        
        # Sort by timestamp
        backtrack_results.sort(key=lambda x: x["timestamp"])
        return backtrack_results
    
    def generate_branch_ml_report(self) -> Dict[str, Any]:
        """Generate comprehensive branch ML analysis report"""
        report = {
            "generation_timestamp": datetime.datetime.now().isoformat(),
            "total_branches": len(self.branch_genealogy),
            "branch_analysis": {},
            "cross_branch_patterns": self.analyze_cross_branch_patterns(),
            "ml_potential_ranking": [],
            "corruption_hotspots": [],
            "character_strongholds": {}
        }
        
        # Analyze each branch
        for branch_name in self.branch_genealogy:
            branch_analysis = self.analyze_branch_ml_evolution(branch_name)
            report["branch_analysis"][branch_name] = branch_analysis
        
        # Rank branches by ML potential
        branch_scores = [
            (branch_name, self.branch_ml_matrix[branch_name]["ml_potential_score"])
            for branch_name in self.branch_ml_matrix
        ]
        branch_scores.sort(key=lambda x: x[1], reverse=True)
        report["ml_potential_ranking"] = branch_scores
        
        # Identify corruption hotspots
        corruption_scores = [
            (branch_name, len(self.branch_genealogy[branch_name].get("corruption_timeline", [])))
            for branch_name in self.branch_genealogy
        ]
        corruption_scores.sort(key=lambda x: x[1], reverse=True)
        report["corruption_hotspots"] = corruption_scores[:5]
        
        return report
    
    def save_genealogy(self):
        """Save branch genealogy and ML matrix to file"""
        data = {
            "branch_genealogy": self.branch_genealogy,
            "ml_artifact_timeline": dict(self.ml_artifact_timeline),
            "branch_ml_matrix": self.branch_ml_matrix,
            "last_updated": datetime.datetime.now().isoformat()
        }
        
        with open(self.genealogy_file, 'w') as f:
            json.dump(data, f, indent=2)
    
    def save_report(self, report: Dict[str, Any], output_path: str = "branch_ml_analysis_report.json"):
        """Save analysis report to file"""
        with open(output_path, 'w') as f:
            json.dump(report, f, indent=2)
        return output_path


def main():
    print("🔀 Initializing Branch-Aware ML Backtracker...")
    print("MODUS: TEMPORAL ARCHAEOLOGY - Cross-Branch Intelligence")
    print()
    
    backtracker = BranchAwareMLBacktracker()
    
    print("📊 Generating comprehensive branch ML analysis...")
    report = backtracker.generate_branch_ml_report()
    
    report_path = backtracker.save_report(report)
    backtracker.save_genealogy()
    
    print(f"✅ Branch analysis complete: {report_path}")
    print()
    print("📋 Analysis Summary:")
    print(f"  Branches analyzed: {report['total_branches']}")
    print(f"  Top ML potential branch: {report['ml_potential_ranking'][0][0] if report['ml_potential_ranking'] else 'N/A'}")
    print(f"  Corruption hotspots: {len(report['corruption_hotspots'])}")
    print()
    print("🔀 Branch-aware ML tracking operational")
    print("⏰ Temporal backtracking capabilities ready")


if __name__ == "__main__":
    main()