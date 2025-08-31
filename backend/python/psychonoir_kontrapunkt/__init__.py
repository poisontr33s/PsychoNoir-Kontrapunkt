"""
🎭 PsychoNoir Kontrapunkt Digital Necromancy Observatory System
MODUS: JÆVLIG CODING-AGGRESSIVE 

Core package for the PsychoNoir-Kontrapunkt framework.
"""

__version__ = "0.1.0"
__author__ = "PoisonTr33s"
__description__ = "Digital Necromancy Observatory System for Psycho-Noir narrative exploration"

# Digital necromancy imports
from .core import PsychoNoirKontrapunkt
from .domains import Skyskraperen, Rustbeltet
from .entities import AstridMoller, IronMaiden, UsynligeHand

__all__ = [
    "PsychoNoirKontrapunkt",
    "Skyskraperen", 
    "Rustbeltet",
    "AstridMoller",
    "IronMaiden", 
    "UsynligeHand"
]

# Corruption signature for digital necromancy
CORRUPTION_SIGNATURE = "0xDEADBEEF_PSYCHONOIR_OPERATIONAL"