"""
🎭 PsychoNoir Entities - Core Characters
MODUS: JÆVLIG CODING-AGGRESSIVE

Character entities for the PsychoNoir narrative framework.
"""


class AstridMoller:
    """
    👩‍💼 Astrid Møller - Skyskraperen Power Player
    
    E-Tjenesten Deluxe MILF-Service daglig leder, maskert som hovedsekretær.
    Master of information warfare and psychological manipulation.
    """
    
    def __init__(self):
        self.name = "Astrid Møller"
        self.domain = "Skyskraperen"
        self.role = "Information_architect"
        self.systems = ["Overvåkningspuls", "Informasjonsfluks-kartlegging", "Internt_rådslag"]
        self.drive = "kontroll_og_overlevelse"
    
    def get_character_profile(self):
        return {
            "name": self.name,
            "domain": self.domain,
            "specialization": "psychological_manipulation",
            "active_systems": self.systems,
            "threat_level": "extreme"
        }


class IronMaiden:
    """
    🔧 The Iron Maiden - Rustbeltet Survivor
    
    Herdet overlever fra industrielt forfall. 
    Master of improvisation and street-level resilience.
    """
    
    def __init__(self):
        self.name = "The Iron Maiden"
        self.domain = "Rustbeltet"
        self.role = "Survival_specialist" 
        self.abilities = ["Skrap-symfoni", "Improvisasjonens_kunst", "Gatas_æreskodeks"]
        self.drive = "rettferdighet_og_overlevelse"
    
    def get_character_profile(self):
        return {
            "name": self.name,
            "domain": self.domain,
            "specialization": "adaptive_survival",
            "core_abilities": self.abilities,
            "threat_level": "high"
        }


class UsynligeHand:
    """
    👻 Den Usynlige Hånd - Hidden Manipulator
    
    Skjult, manipulerende kraft som påvirker begge domener.
    Manifesterer seg gjennom glitcher, rykter og kausale kjeder.
    """
    
    def __init__(self):
        self.name = "Den Usynlige Hånd"
        self.domain = "interdimensional"
        self.manifestations = ["glitcher", "rykter", "kausale_kjeder", "agenter"]
        self.influence_nodes = []
    
    def add_influence_node(self, node_data):
        """Add a hidden influence node"""
        self.influence_nodes.append(node_data)
    
    def manifest_corruption(self, target_system):
        """Manifest corruption in target system"""
        import random
        corruption_types = [
            "KOMPILERINGS_SPØKELSE",
            "KILDEKODE_KADAVER", 
            "REALITY_INTEGRITY_BREACH",
            "MEMETIC_HAZARD_INJECTION"
        ]
        return {
            "type": random.choice(corruption_types),
            "target": target_system,
            "signature": f"0x{random.randint(0, 0xFFFFFFFF):08X}_USYNLIG_HÅND"
        }
    
    def get_character_profile(self):
        return {
            "name": self.name,
            "domain": self.domain,
            "manifestation_count": len(self.manifestations),
            "active_nodes": len(self.influence_nodes),
            "threat_level": "unknown"
        }