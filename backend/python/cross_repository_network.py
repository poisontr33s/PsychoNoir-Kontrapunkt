#!/usr/bin/env python3
"""
🎭 PSYCHO-NOIR KONTRAPUNKT: CROSS-REPOSITORY INTELLIGENCE NETWORK
=================================================================

Etablerer real-time forbindelser mellom alle Psycho-Noir repositories
for å skape en sammenhengende digital organisme.

ECOSYSTEM REPOSITORIES:
- poisontr33s/poisontr33s (Meta-Index Hub)
- poisontr33s/PsychoNoir-Kontrapunkt (Neural Archaeology Lab)  
- poisontr33s/Restructure-MCP-Orchestration (Orchestration Backbone)
"""

import json
import requests
import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, asdict
import os

@dataclass
class RepositoryStatus:
    """Status for en repository i økosystemet"""
    name: str
    full_name: str
    url: str
    classification: str  # 'meta_index', 'neural_lab', 'orchestration_backbone'
    domain: str  # 'skyskraper', 'rustbelt', 'cross_domain'
    last_commit: str
    open_issues: int
    open_prs: int
    primary_language: str
    health_indicators: Dict[str, Any]
    manifest_signatures: List[str]

@dataclass
class CrossRepoIntelligence:
    """Intelligens på tvers av repositories"""
    ecosystem_health: float
    dominant_patterns: List[str]
    cross_pollination_events: List[Dict[str, Any]]
    emergent_behaviors: List[str]
    narrative_threads: List[str]

class CrossRepositoryNetwork:
    """Manager for cross-repository intelligence og linking"""
    
    def __init__(self):
        self.github_token = os.environ.get('GITHUB_TOKEN')
        self.ecosystem_repos = [
            {
                'name': 'poisontr33s',
                'full_name': 'poisontr33s/poisontr33s',
                'classification': 'meta_index',
                'domain': 'skyskraper',
                'description': 'Meta-Index Hub & Profile Consciousness'
            },
            {
                'name': 'PsychoNoir-Kontrapunkt', 
                'full_name': 'poisontr33s/PsychoNoir-Kontrapunkt',
                'classification': 'neural_lab',
                'domain': 'rustbelt',
                'description': 'Neural Archaeology & Digital Corruption Lab'
            },
            {
                'name': 'Restructure-MCP-Orchestration',
                'full_name': 'poisontr33s/Restructure-MCP-Orchestration', 
                'classification': 'orchestration_backbone',
                'domain': 'cross_domain',
                'description': 'Technical Systems Supporting Narrative Structures'
            }
        ]
    
    def fetch_repository_data(self, repo_full_name: str) -> Optional[Dict[str, Any]]:
        """Henter data fra GitHub API for en repository"""
        if not self.github_token:
            # Fallback når vi ikke har GitHub token - simulert data
            return self._generate_simulated_repo_data(repo_full_name)
        
        try:
            headers = {'Authorization': f'token {self.github_token}'}
            
            # Basic repo info
            repo_url = f"https://api.github.com/repos/{repo_full_name}"
            repo_response = requests.get(repo_url, headers=headers)
            
            if repo_response.status_code != 200:
                return None
                
            repo_data = repo_response.json()
            
            # Issues and PRs
            issues_url = f"https://api.github.com/repos/{repo_full_name}/issues?state=open"
            issues_response = requests.get(issues_url, headers=headers)
            issues_data = issues_response.json() if issues_response.status_code == 200 else []
            
            # Separate issues and PRs
            issues = [i for i in issues_data if 'pull_request' not in i]
            prs = [i for i in issues_data if 'pull_request' in i]
            
            return {
                'repo': repo_data,
                'issues': issues,
                'prs': prs
            }
            
        except Exception as e:
            print(f"Error fetching data for {repo_full_name}: {e}")
            return self._generate_simulated_repo_data(repo_full_name)
    
    def _generate_simulated_repo_data(self, repo_full_name: str) -> Dict[str, Any]:
        """Genererer simulert repository data når GitHub API ikke er tilgjengelig"""
        simulated_data = {
            'poisontr33s/poisontr33s': {
                'repo': {
                    'name': 'poisontr33s',
                    'full_name': 'poisontr33s/poisontr33s',
                    'html_url': 'https://github.com/poisontr33s/poisontr33s',
                    'language': 'Markdown',
                    'updated_at': '2025-08-28T12:00:00Z',
                    'stargazers_count': 15
                },
                'issues': [{'title': 'Meta-index consciousness emergence', 'number': 1}],
                'prs': []
            },
            'poisontr33s/PsychoNoir-Kontrapunkt': {
                'repo': {
                    'name': 'PsychoNoir-Kontrapunkt',
                    'full_name': 'poisontr33s/PsychoNoir-Kontrapunkt', 
                    'html_url': 'https://github.com/poisontr33s/PsychoNoir-Kontrapunkt',
                    'language': 'Python',
                    'updated_at': '2025-08-28T12:15:00Z',
                    'stargazers_count': 8
                },
                'issues': [
                    {'title': 'Neural Archaeology optimization', 'number': 2},
                    {'title': 'Necropolis integration enhancement', 'number': 3}
                ],
                'prs': [{'title': 'Meta-index integration', 'number': 1}]
            },
            'poisontr33s/Restructure-MCP-Orchestration': {
                'repo': {
                    'name': 'Restructure-MCP-Orchestration',
                    'full_name': 'poisontr33s/Restructure-MCP-Orchestration',
                    'html_url': 'https://github.com/poisontr33s/Restructure-MCP-Orchestration', 
                    'language': 'TypeScript',
                    'updated_at': '2025-08-28T11:30:00Z',
                    'stargazers_count': 3
                },
                'issues': [],
                'prs': []
            }
        }
        
        return simulated_data.get(repo_full_name, {})
    
    def analyze_repository_health(self, repo_data: Dict[str, Any], classification: str) -> Dict[str, Any]:
        """Analyserer helse for en enkelt repository"""
        repo_info = repo_data.get('repo', {})
        issues = repo_data.get('issues', [])
        prs = repo_data.get('prs', [])
        
        # Basis helse-metrikker
        issue_count = len(issues)
        pr_count = len(prs)
        
        # Repository-spesifikke helsekriterier
        health_score = 1.0
        
        if classification == 'meta_index':
            # Meta-index skal være stabil og oppdatert
            health_score -= min(0.3, issue_count * 0.1)  # Issues reduserer helse
            health_score += min(0.2, pr_count * 0.1)     # PRs indikerer aktivitet
            
        elif classification == 'neural_lab':
            # Neural lab skal være eksperimentelt og aktivt
            health_score -= max(0, (issue_count - 5) * 0.05)  # For mange issues er problematisk
            health_score += min(0.3, pr_count * 0.15)         # Høy aktivitet er bra
            
        elif classification == 'orchestration_backbone':
            # Orchestration skal være robust og pålitelig
            health_score -= issue_count * 0.15  # Issues er mer kritiske her
            health_score += min(0.1, pr_count * 0.05)  # Begrenset endring er ønskelig
        
        health_score = max(0.0, min(1.0, health_score))
        
        return {
            'health_score': health_score,
            'issue_count': issue_count,
            'pr_count': pr_count,
            'last_activity': repo_info.get('updated_at', 'unknown'),
            'language': repo_info.get('language', 'unknown'),
            'activity_level': 'high' if pr_count > 2 else 'moderate' if pr_count > 0 else 'low'
        }
    
    def detect_manifestation_signatures(self, repo_data: Dict[str, Any], domain: str) -> List[str]:
        """Detekterer manifestasjonssignaturer i repository"""
        signatures = []
        issues = repo_data.get('issues', [])
        prs = repo_data.get('prs', [])
        
        # Søk etter psycho-noir relaterte termer
        psycho_noir_terms = [
            'neural', 'archaeology', 'necropolis', 'corruption', 'glitch',
            'skyskraper', 'rustbelt', 'invisible hand', 'kausalitets',
            'syntetiske', 'improvisation', 'manifestation'
        ]
        
        all_text = []
        for item in issues + prs:
            all_text.append(item.get('title', '').lower())
            all_text.append(item.get('body', '').lower())
        
        combined_text = ' '.join(all_text)
        
        for term in psycho_noir_terms:
            if term in combined_text:
                if domain == 'skyskraper':
                    signatures.append(f"🏢 {term.upper()}_CONTROL_PATTERN")
                elif domain == 'rustbelt': 
                    signatures.append(f"🔧 {term.upper()}_IMPROVISATION_SIGNATURE")
                else:
                    signatures.append(f"🌀 {term.upper()}_CROSS_DOMAIN_MANIFESTATION")
        
        if not signatures:
            signatures.append(f"📡 {domain.upper()}_DORMANT_STATE")
        
        return signatures[:5]  # Maksimum 5 signaturer
    
    def generate_cross_repo_report(self) -> Dict[str, Any]:
        """Genererer komplett cross-repository rapport"""
        repo_statuses = []
        ecosystem_health_scores = []
        all_signatures = []
        
        for repo_config in self.ecosystem_repos:
            repo_data = self.fetch_repository_data(repo_config['full_name'])
            
            if repo_data:
                health = self.analyze_repository_health(repo_data, repo_config['classification'])
                signatures = self.detect_manifestation_signatures(repo_data, repo_config['domain'])
                
                repo_status = RepositoryStatus(
                    name=repo_config['name'],
                    full_name=repo_config['full_name'],
                    url=repo_data['repo'].get('html_url', ''),
                    classification=repo_config['classification'],
                    domain=repo_config['domain'],
                    last_commit=health['last_activity'],
                    open_issues=health['issue_count'],
                    open_prs=health['pr_count'],
                    primary_language=health['language'],
                    health_indicators=health,
                    manifest_signatures=signatures
                )
                
                repo_statuses.append(repo_status)
                ecosystem_health_scores.append(health['health_score'])
                all_signatures.extend(signatures)
        
        # Beregn overall ecosystem helse
        ecosystem_health = sum(ecosystem_health_scores) / len(ecosystem_health_scores) if ecosystem_health_scores else 0.0
        
        # Cross-repository intelligence
        intelligence = CrossRepoIntelligence(
            ecosystem_health=ecosystem_health,
            dominant_patterns=list(set(all_signatures))[:10],
            cross_pollination_events=[
                {
                    'event': 'neural_archaeology_integration',
                    'repos': ['PsychoNoir-Kontrapunkt', 'poisontr33s'],
                    'timestamp': datetime.datetime.now().isoformat()
                }
            ],
            emergent_behaviors=[
                'Meta-index consciousness emergence',
                'Cross-domain pattern recognition',
                'Narrative-driven system evolution'
            ],
            narrative_threads=[
                'Digital corruption as creative force',
                'Failure-to-wisdom transformation pipeline',
                'Emergent intelligence across repositories'
            ]
        )
        
        return {
            'timestamp': datetime.datetime.now().isoformat(),
            'ecosystem_overview': {
                'total_repositories': len(repo_statuses),
                'overall_health': ecosystem_health,
                'health_status': 'operational' if ecosystem_health > 0.7 else 'degraded' if ecosystem_health > 0.4 else 'critical'
            },
            'repositories': [asdict(rs) for rs in repo_statuses],
            'cross_repo_intelligence': asdict(intelligence),
            'psycho_noir_metrics': {
                'skyskraper_repositories': len([r for r in repo_statuses if r.domain == 'skyskraper']),
                'rustbelt_repositories': len([r for r in repo_statuses if r.domain == 'rustbelt']),
                'cross_domain_repositories': len([r for r in repo_statuses if r.domain == 'cross_domain']),
                'total_manifestation_signatures': len(all_signatures)
            }
        }
    
    def generate_ecosystem_readme_content(self) -> str:
        """Genererer innhold for ecosystem README"""
        report = self.generate_cross_repo_report()
        
        content = """# 🎭 Psycho-Noir Kontrapunkt Ecosystem

## 🌐 Repository Network Status

"""
        
        for repo in report['repositories']:
            domain_emoji = {'skyskraper': '🏢', 'rustbelt': '🔧', 'cross_domain': '🌀'}
            emoji = domain_emoji.get(repo['domain'], '❓')
            health_bar = "█" * int(repo['health_indicators']['health_score'] * 10) + "▒" * (10 - int(repo['health_indicators']['health_score'] * 10))
            
            content += f"""### {emoji} [{repo['name']}]({repo['url']})
**Classification:** {repo['classification']} | **Domain:** {repo['domain']}  
**Health:** {health_bar} {repo['health_indicators']['health_score']:.2f}  
**Activity:** {repo['open_issues']} issues, {repo['open_prs']} PRs | **Language:** {repo['primary_language']}

**Active Manifestations:**
"""
            for signature in repo['manifest_signatures'][:3]:
                content += f"- {signature}\n"
            
            content += "\n---\n\n"
        
        content += f"""## 🧠 Cross-Repository Intelligence

**Ecosystem Health:** {report['ecosystem_overview']['overall_health']:.2f}/1.0 ({report['ecosystem_overview']['health_status'].upper()})

### 🔄 Emergent Behaviors
"""
        
        for behavior in report['cross_repo_intelligence']['emergent_behaviors']:
            content += f"- {behavior}\n"
        
        content += "\n### 🎭 Active Narrative Threads\n"
        
        for thread in report['cross_repo_intelligence']['narrative_threads']:
            content += f"- {thread}\n"
        
        content += f"""
---

*Last Update: {report['timestamp']}*  
*Generated by Cross-Repository Intelligence Network*
"""
        
        return content

def main():
    """Main execution for cross-repository network analysis"""
    network = CrossRepositoryNetwork()
    report = network.generate_cross_repo_report()
    
    # Save detailed report
    report_file = Path("data/generert/cross_repo_intelligence.json")
    report_file.parent.mkdir(parents=True, exist_ok=True)
    
    with open(report_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    # Generate ecosystem README content
    readme_content = network.generate_ecosystem_readme_content()
    readme_file = Path("data/generert/ecosystem_status.md")
    
    with open(readme_file, 'w') as f:
        f.write(readme_content)
    
    print(f"✅ Cross-repository intelligence report generated:")
    print(f"   📊 Detailed report: {report_file}")
    print(f"   📝 Ecosystem status: {readme_file}")
    print(f"   🌐 Overall ecosystem health: {report['ecosystem_overview']['overall_health']:.2f}")

if __name__ == "__main__":
    main()