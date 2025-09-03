#!/usr/bin/env python3
"""
🕷️ META-Cross-Repository ML Orchestrator
MODUS: DIGITAL NECROMANCY OBSERVATORY - Cross-Dimensional Surveillance

Master orchestrator for managing ML operations across multiple repositories
and branch networks with instance variation tracking capabilities.
"""

import os
import json
import git
import datetime
import subprocess
from pathlib import Path
from typing import Dict, List, Any, Optional
import hashlib

class MetaCrossRepoOrchestrator:
    """
    META-level orchestrator for cross-repository ML operations.
    Maintains awareness of repository networks, branch genealogies, and instance variations.
    """
    
    def __init__(self, config_path: str = "meta_config.json"):
        self.config_path = config_path
        self.repo_network = {}
        self.branch_genealogy = {}
        self.instance_registry = {}
        self.correlation_matrix = {}
        self.load_or_create_config()
        
    def load_or_create_config(self):
        """Load existing configuration or create new META-level configuration"""
        if Path(self.config_path).exists():
            with open(self.config_path, 'r') as f:
                config = json.load(f)
                self.repo_network = config.get('repo_network', {})
                self.branch_genealogy = config.get('branch_genealogy', {})
                self.instance_registry = config.get('instance_registry', {})
        else:
            self.initialize_default_network()
    
    def initialize_default_network(self):
        """Initialize default PsychoNoir repository network topology"""
        self.repo_network = {
            "primary": {
                "name": "PsychoNoir-Kontrapunkt",
                "path": ".",
                "role": "central_nexus",
                "surveillance_level": "maximum",
                "character_domains": ["astrid_moller", "iron_maiden", "usynlige_hand"]
            },
            "satellites": {
                "arkiv_gamle_ruby_prosjekter": {
                    "path": "./arkiv_gamle_ruby_prosjekter",
                    "role": "archaeological_archive",
                    "surveillance_level": "moderate",
                    "character_domains": ["historical_echoes"]
                },
                "graveyard_sessions": {
                    "path": "./.graveyard/sessions",
                    "role": "digital_necromancy_vault",
                    "surveillance_level": "deep_scan",
                    "character_domains": ["archived_consciousness"]
                }
            },
            "shadow_repos": {
                # Repositories discovered through Usynlige Hånd signatures
                "detection_signatures": [
                    "0xDEADBEEF",
                    "ERROR: SOUL_NOT_FOUND", 
                    "PANIC: REALITY_MISMATCH",
                    "psycho_noir_kontrapunkt"
                ]
            }
        }
        
        # Initialize character instance baseline signatures
        self.instance_registry = {
            "astrid_moller": {
                "base_signature": self.generate_character_signature("astrid_moller"),
                "variations": [],
                "surveillance_keywords": [
                    "overvåkningspuls", "informasjonsfluks", "kausalitets_arkitekten",
                    "syntetiske_synapser", "e_tjenesten", "skyskraperen"
                ],
                "corruption_resistance": 0.9
            },
            "iron_maiden": {
                "base_signature": self.generate_character_signature("iron_maiden"),
                "variations": [],
                "survival_keywords": [
                    "skrap_symfoni", "improvisasjonens_kunst", "gatas_æreskodeks",
                    "rustbeltet", "resiliens", "kretskort_sjamanisme"
                ],
                "corruption_resistance": 0.7
            },
            "usynlige_hand": {
                "base_signature": self.generate_character_signature("usynlige_hand"),
                "variations": [],
                "manifestation_keywords": [
                    "glitcher", "kildekode_kadaver", "kompilerings_spøkelser",
                    "kausal_kjedet", "skjulte_noder", "digital_forbannelser"
                ],
                "corruption_signature": "source"
            }
        }
    
    def generate_character_signature(self, character_name: str) -> str:
        """Generate unique signature for character instance tracking"""
        base_data = f"{character_name}_psychonoir_kontrapunkt_base"
        return f"0x{hashlib.sha256(base_data.encode()).hexdigest()[:16].upper()}"
    
    def scan_repository_network(self) -> Dict[str, Any]:
        """
        Perform comprehensive scan of the repository network.
        Maps branches, commits, and ML artifacts across all repositories.
        """
        scan_results = {
            "scan_timestamp": datetime.datetime.now().isoformat(),
            "repositories": {},
            "cross_repo_patterns": [],
            "instance_variations": {},
            "corruption_signatures": []
        }
        
        # Scan primary repository
        primary_repo = self.repo_network["primary"]
        scan_results["repositories"]["primary"] = self.scan_single_repository(
            primary_repo["path"], primary_repo
        )
        
        # Scan satellite repositories
        for repo_name, repo_config in self.repo_network["satellites"].items():
            if Path(repo_config["path"]).exists():
                scan_results["repositories"][repo_name] = self.scan_single_repository(
                    repo_config["path"], repo_config
                )
        
        # Analyze cross-repository patterns
        scan_results["cross_repo_patterns"] = self.analyze_cross_repo_patterns(
            scan_results["repositories"]
        )
        
        # Track instance variations across repositories
        scan_results["instance_variations"] = self.track_instance_variations(
            scan_results["repositories"]
        )
        
        # Detect corruption signatures
        scan_results["corruption_signatures"] = self.detect_corruption_signatures(
            scan_results["repositories"]
        )
        
        return scan_results
    
    def scan_single_repository(self, repo_path: str, repo_config: Dict) -> Dict[str, Any]:
        """Scan individual repository for ML artifacts and patterns"""
        repo_data = {
            "path": repo_path,
            "config": repo_config,
            "branches": {},
            "ml_artifacts": [],
            "character_instances": {},
            "corruption_patterns": [],
            "temporal_markers": []
        }
        
        try:
            repo = git.Repo(repo_path)
            
            # Map all branches
            for branch in repo.branches:
                repo_data["branches"][branch.name] = self.analyze_branch(
                    repo, branch, repo_config
                )
            
            # Scan for ML artifacts
            repo_data["ml_artifacts"] = self.scan_ml_artifacts(repo_path)
            
            # Track character instances
            repo_data["character_instances"] = self.track_character_instances(
                repo_path, repo_config
            )
            
            # Detect corruption patterns
            repo_data["corruption_patterns"] = self.detect_repo_corruption(
                repo_path, repo_config
            )
            
        except git.InvalidGitRepositoryError:
            # Handle non-git directories (like graveyard sessions)
            repo_data["branches"] = {"main": "non_git_directory"}
            repo_data["ml_artifacts"] = self.scan_directory_artifacts(repo_path)
            repo_data["character_instances"] = self.track_character_instances(
                repo_path, repo_config
            )
        
        return repo_data
    
    def analyze_branch(self, repo: git.Repo, branch: git.Head, repo_config: Dict) -> Dict[str, Any]:
        """Analyze individual branch for ML potential and character presence"""
        branch_data = {
            "name": branch.name,
            "commit_count": 0,
            "latest_commit": None,
            "ml_potential": "unknown",
            "character_presence": {},
            "corruption_level": 0.0
        }
        
        try:
            # Switch to branch and analyze
            repo.git.checkout(branch.name)
            commits = list(repo.iter_commits(branch.name, max_count=50))
            branch_data["commit_count"] = len(commits)
            
            if commits:
                latest = commits[0]
                branch_data["latest_commit"] = {
                    "sha": latest.hexsha,
                    "message": latest.message.strip(),
                    "timestamp": latest.committed_datetime.isoformat()
                }
                
                # Analyze commit messages for character presence
                branch_data["character_presence"] = self.analyze_character_presence_in_commits(commits)
                
                # Assess ML potential based on commit patterns
                branch_data["ml_potential"] = self.assess_branch_ml_potential(commits, repo_config)
                
                # Detect corruption level
                branch_data["corruption_level"] = self.assess_branch_corruption(commits)
        
        except Exception as e:
            branch_data["error"] = str(e)
        
        return branch_data
    
    def analyze_character_presence_in_commits(self, commits: List) -> Dict[str, int]:
        """Analyze character presence in commit messages and changes"""
        character_presence = {}
        
        for character_name, character_data in self.instance_registry.items():
            presence_count = 0
            keywords = character_data.get('surveillance_keywords', []) + \
                      character_data.get('survival_keywords', []) + \
                      character_data.get('manifestation_keywords', [])
            
            for commit in commits:
                commit_text = (commit.message + " " + str(commit.stats)).lower()
                for keyword in keywords:
                    if keyword.lower() in commit_text:
                        presence_count += 1
                        break
            
            if presence_count > 0:
                character_presence[character_name] = presence_count
        
        return character_presence
    
    def assess_branch_ml_potential(self, commits: List, repo_config: Dict) -> str:
        """Assess branch's ML training potential"""
        if len(commits) > 20:
            return "high"
        elif len(commits) > 10:
            return "medium"
        elif len(commits) > 5:
            return "low"
        else:
            return "minimal"
    
    def assess_branch_corruption(self, commits: List) -> float:
        """Assess corruption level in branch based on Usynlige Hånd signatures"""
        corruption_indicators = [
            "0xdeadbeef", "error:", "panic:", "soul_not_found",
            "reality_mismatch", "kompilerings_spøkelser", "kildekode_kadaver"
        ]
        
        corruption_count = 0
        total_commits = len(commits)
        
        for commit in commits:
            commit_text = commit.message.lower()
            for indicator in corruption_indicators:
                if indicator in commit_text:
                    corruption_count += 1
                    break
        
        return corruption_count / total_commits if total_commits > 0 else 0.0
    
    def scan_ml_artifacts(self, repo_path: str) -> List[Dict[str, Any]]:
        """Scan repository for ML training artifacts"""
        artifacts = []
        ml_extensions = ['.py', '.js', '.md', '.txt', '.json', '.log']
        
        for file_path in Path(repo_path).rglob("*"):
            if file_path.is_file() and file_path.suffix in ml_extensions:
                artifact = self.analyze_file_artifact(file_path)
                if artifact["ml_potential"] != "none":
                    artifacts.append(artifact)
        
        return artifacts
    
    def scan_directory_artifacts(self, dir_path: str) -> List[Dict[str, Any]]:
        """Scan non-git directory for ML artifacts (like graveyard sessions)"""
        return self.scan_ml_artifacts(dir_path)
    
    def analyze_file_artifact(self, file_path: Path) -> Dict[str, Any]:
        """Analyze individual file for ML training potential"""
        artifact = {
            "path": str(file_path),
            "size": file_path.stat().st_size,
            "type": file_path.suffix,
            "ml_potential": "none",
            "character_signatures": [],
            "corruption_signatures": []
        }
        
        try:
            if file_path.stat().st_size < 1024 * 1024:  # Only read files < 1MB
                content = file_path.read_text(encoding='utf-8', errors='ignore').lower()
                
                # Check for character signatures
                for character_name, character_data in self.instance_registry.items():
                    keywords = character_data.get('surveillance_keywords', []) + \
                              character_data.get('survival_keywords', []) + \
                              character_data.get('manifestation_keywords', [])
                    
                    for keyword in keywords:
                        if keyword.lower() in content:
                            artifact["character_signatures"].append(character_name)
                            break
                
                # Check for corruption signatures
                corruption_patterns = [
                    "0xdeadbeef", "error:", "panic:", "soul_not_found",
                    "kompilerings_spøkelser", "kildekode_kadaver"
                ]
                
                for pattern in corruption_patterns:
                    if pattern in content:
                        artifact["corruption_signatures"].append(pattern)
                
                # Assess ML potential
                if len(artifact["character_signatures"]) > 0 or len(artifact["corruption_signatures"]) > 0:
                    if file_path.suffix in ['.py', '.js']:
                        artifact["ml_potential"] = "high"
                    elif file_path.suffix in ['.md', '.txt']:
                        artifact["ml_potential"] = "medium"
                    else:
                        artifact["ml_potential"] = "low"
        
        except Exception:
            pass
        
        return artifact
    
    def track_character_instances(self, repo_path: str, repo_config: Dict) -> Dict[str, Any]:
        """Track character instance variations across repository"""
        instances = {}
        
        for character_name in self.instance_registry:
            instances[character_name] = {
                "base_presence": False,
                "variations": [],
                "manifestation_strength": 0.0
            }
        
        # Analyze character presence in repository
        ml_artifacts = self.scan_ml_artifacts(repo_path)
        
        for artifact in ml_artifacts:
            for character_name in artifact["character_signatures"]:
                instances[character_name]["base_presence"] = True
                instances[character_name]["manifestation_strength"] += 0.1
        
        return instances
    
    def detect_repo_corruption(self, repo_path: str, repo_config: Dict) -> List[Dict[str, Any]]:
        """Detect corruption patterns in repository (Usynlige Hånd signatures)"""
        corruption_patterns = []
        
        # This would be enhanced with actual pattern detection logic
        # For now, return placeholder structure
        return [{
            "pattern_type": "baseline_scan",
            "severity": "low",
            "signature": "0x00000000",
            "manifestation": "digital_archaeology_preparation"
        }]
    
    def analyze_cross_repo_patterns(self, repositories: Dict) -> List[Dict[str, Any]]:
        """Analyze patterns that span across multiple repositories"""
        patterns = []
        
        # Character presence correlation across repositories
        character_correlation = {}
        for repo_name, repo_data in repositories.items():
            for character_name, instance_data in repo_data.get("character_instances", {}).items():
                if character_name not in character_correlation:
                    character_correlation[character_name] = []
                
                if instance_data["base_presence"]:
                    character_correlation[character_name].append(repo_name)
        
        for character_name, repo_list in character_correlation.items():
            if len(repo_list) > 1:
                patterns.append({
                    "type": "character_cross_presence",
                    "character": character_name,
                    "repositories": repo_list,
                    "correlation_strength": len(repo_list) / len(repositories)
                })
        
        return patterns
    
    def track_instance_variations(self, repositories: Dict) -> Dict[str, Any]:
        """Track instance variations across the repository network"""
        variations = {}
        
        for character_name in self.instance_registry:
            variations[character_name] = {
                "total_instances": 0,
                "repository_distribution": {},
                "variation_signatures": []
            }
            
            for repo_name, repo_data in repositories.items():
                character_instances = repo_data.get("character_instances", {})
                if character_name in character_instances:
                    instance_data = character_instances[character_name]
                    if instance_data["base_presence"]:
                        variations[character_name]["total_instances"] += 1
                        variations[character_name]["repository_distribution"][repo_name] = \
                            instance_data["manifestation_strength"]
        
        return variations
    
    def detect_corruption_signatures(self, repositories: Dict) -> List[Dict[str, Any]]:
        """Detect corruption signatures across the repository network"""
        signatures = []
        
        for repo_name, repo_data in repositories.items():
            repo_corruption = repo_data.get("corruption_patterns", [])
            for pattern in repo_corruption:
                pattern["source_repository"] = repo_name
                signatures.append(pattern)
        
        return signatures
    
    def save_scan_results(self, scan_results: Dict, output_path: str = "meta_scan_results.json"):
        """Save comprehensive scan results"""
        with open(output_path, 'w') as f:
            json.dump(scan_results, f, indent=2)
        return output_path
    
    def save_config(self):
        """Save current configuration state"""
        config = {
            "repo_network": self.repo_network,
            "branch_genealogy": self.branch_genealogy,
            "instance_registry": self.instance_registry,
            "correlation_matrix": self.correlation_matrix
        }
        
        with open(self.config_path, 'w') as f:
            json.dump(config, f, indent=2)


def main():
    print("🕷️ Initializing META-Cross-Repository ML Orchestrator...")
    print("MODUS: DIGITAL NECROMANCY OBSERVATORY - Cross-Dimensional Surveillance")
    print()
    
    orchestrator = MetaCrossRepoOrchestrator()
    
    print("📊 Scanning repository network...")
    scan_results = orchestrator.scan_repository_network()
    
    results_path = orchestrator.save_scan_results(scan_results)
    orchestrator.save_config()
    
    print(f"✅ Network scan complete: {results_path}")
    print()
    print("📋 Scan Summary:")
    print(f"  Repositories scanned: {len(scan_results['repositories'])}")
    print(f"  Cross-repo patterns: {len(scan_results['cross_repo_patterns'])}")
    print(f"  Instance variations: {len(scan_results['instance_variations'])}")
    print(f"  Corruption signatures: {len(scan_results['corruption_signatures'])}")
    print()
    print("🎭 META-level surveillance network operational")
    print("🕸️ Ready for cross-dimensional ML backtracking operations")


if __name__ == "__main__":
    main()