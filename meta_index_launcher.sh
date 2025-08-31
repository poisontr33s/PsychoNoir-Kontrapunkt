#!/bin/bash
# 🎭 PSYCHO-NOIR KONTRAPUNKT: META-INDEX QUICK LAUNCHER
# ====================================================
# 
# One-stop interface for alle meta-index dashboard systems
# Implementerer "neural interface terminal" filosofi

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/backend/python"
DATA_DIR="$PROJECT_ROOT/data/generert"

# Colors for psycho-noir aesthetic
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}================================================================================================"
echo -e "🎭 PSYCHO-NOIR KONTRAPUNKT: META-INDEX NEURAL INTERFACE TERMINAL"
echo -e "================================================================================================${NC}"
echo ""
echo -e "${CYAN}ERROR: REALITY_INTEGRITY_COMPROMISED_AT_0xDEADBEEF${NC}"
echo -e "${YELLOW}STATUS: EMBRACING_DIGITAL_DECAY_AS_CREATIVE_FORCE${NC}"
echo ""

show_help() {
    echo -e "${GREEN}Available Commands:${NC}"
    echo ""
    echo -e "  ${YELLOW}dashboard${NC}     - Launch meta-index dashboard with live system status"
    echo -e "  ${YELLOW}network${NC}       - Display cross-repository network intelligence"
    echo -e "  ${YELLOW}status${NC}        - Run automated status update for all systems"
    echo -e "  ${YELLOW}neural${NC}        - Launch neural archaeology orchestrator"
    echo -e "  ${YELLOW}manifest${NC}      - Show active Den Usynlige Hånd manifestations"
    echo -e "  ${YELLOW}corruption${NC}    - Display digital corruption gallery"
    echo -e "  ${YELLOW}ecosystem${NC}     - Show full ecosystem health overview"
    echo -e "  ${YELLOW}reports${NC}       - List all available reports and generated data"
    echo -e "  ${YELLOW}monitor${NC}       - Continuous monitoring mode (press Ctrl+C to exit)"
    echo ""
    echo -e "  ${YELLOW}help${NC}          - Show this help message"
    echo ""
    echo -e "${PURPLE}Examples:${NC}"
    echo -e "  ./meta_index_launcher.sh dashboard"
    echo -e "  ./meta_index_launcher.sh network"
    echo -e "  ./meta_index_launcher.sh monitor"
    echo ""
}

run_dashboard() {
    echo -e "${CYAN}🎭 Launching Meta-Index Dashboard...${NC}"
    echo ""
    cd "$PROJECT_ROOT"
    python3 "$BACKEND_DIR/meta_index_dashboard.py"
}

run_network() {
    echo -e "${CYAN}🌐 Launching Cross-Repository Network Analysis...${NC}"
    echo ""
    cd "$PROJECT_ROOT"
    python3 "$BACKEND_DIR/cross_repository_network.py"
    echo ""
    echo -e "${GREEN}📝 Generated ecosystem status:${NC}"
    if [[ -f "$DATA_DIR/ecosystem_status.md" ]]; then
        cat "$DATA_DIR/ecosystem_status.md"
    else
        echo -e "${RED}❌ Ecosystem status file not found${NC}"
    fi
}

run_status_update() {
    echo -e "${CYAN}⚡ Running Automated Status Update...${NC}"
    echo ""
    cd "$PROJECT_ROOT"
    python3 "$BACKEND_DIR/automated_status_reporter.py"
}

run_neural_archaeology() {
    echo -e "${CYAN}🧠 Launching Neural Archaeology Orchestrator...${NC}"
    echo ""
    cd "$PROJECT_ROOT"
    python3 "$BACKEND_DIR/neural_archaeology_orchestrator.py" --mode full
}

show_manifestations() {
    echo -e "${CYAN}👤 Active Den Usynlige Hånd Manifestations:${NC}"
    echo ""
    if [[ -f "$DATA_DIR/manifestation_summary.md" ]]; then
        cat "$DATA_DIR/manifestation_summary.md"
    else
        echo -e "${YELLOW}⚠️ No manifestations detected. Running status update...${NC}"
        run_status_update
        echo ""
        if [[ -f "$DATA_DIR/manifestation_summary.md" ]]; then
            cat "$DATA_DIR/manifestation_summary.md"
        fi
    fi
}

show_corruption_gallery() {
    echo -e "${CYAN}💎 Digital Corruption Gallery:${NC}"
    echo ""
    echo -e "${PURPLE}=== ERROR CODES AS NARRATIVE FRAGMENTS ===${NC}"
    
    if [[ -f "$PROJECT_ROOT/docs/error-codes-as-narratives.md" ]]; then
        # Show just the corruption signatures section
        sed -n '/## Digital Corruption Signatures/,/## Poetry of System Failures/p' "$PROJECT_ROOT/docs/error-codes-as-narratives.md" | head -30
        echo -e "\n${GREEN}📚 Full corruption gallery: ./docs/error-codes-as-narratives.md${NC}"
    else
        echo -e "${RED}❌ Corruption gallery not found${NC}"
    fi
}

show_ecosystem() {
    echo -e "${CYAN}🏗️ Ecosystem Health Overview:${NC}"
    echo ""
    
    # Run quick dashboard and network updates
    echo -e "${YELLOW}Collecting live data...${NC}"
    run_dashboard > /tmp/dashboard_output.txt 2>&1
    run_network > /tmp/network_output.txt 2>&1
    
    echo -e "${GREEN}📊 SYSTEM STATUS:${NC}"
    grep -E "(ECOSYSTEM HEALTH|DOMAIN STATUS)" /tmp/dashboard_output.txt || echo "Dashboard data unavailable"
    
    echo ""
    echo -e "${GREEN}🌐 NETWORK STATUS:${NC}"
    grep -E "(Overall ecosystem health|Repository Network)" /tmp/network_output.txt || echo "Network data unavailable"
    
    # Cleanup
    rm -f /tmp/dashboard_output.txt /tmp/network_output.txt
}

list_reports() {
    echo -e "${CYAN}📋 Available Reports and Generated Data:${NC}"
    echo ""
    
    if [[ -d "$DATA_DIR" ]]; then
        echo -e "${GREEN}Generated Data Files:${NC}"
        ls -la "$DATA_DIR" | awk 'NR>1 {printf "  📄 %-30s %s %s %s\n", $9, $6, $7, $8}'
        echo ""
    fi
    
    echo -e "${GREEN}Documentation:${NC}"
    if [[ -d "$PROJECT_ROOT/docs" ]]; then
        ls -la "$PROJECT_ROOT/docs"/*.md 2>/dev/null | awk '{printf "  📚 %-30s %s %s %s\n", $9, $6, $7, $8}' || echo "  No documentation files found"
    fi
    
    echo ""
    echo -e "${GREEN}Reports Directory:${NC}"
    if [[ -d "$PROJECT_ROOT/data/rapporter" ]]; then
        ls -la "$PROJECT_ROOT/data/rapporter" | awk 'NR>1 {printf "  📊 %-30s %s %s %s\n", $9, $6, $7, $8}'
    else
        echo "  No reports directory found"
    fi
}

continuous_monitor() {
    echo -e "${CYAN}🔄 Entering Continuous Monitoring Mode...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to exit${NC}"
    echo ""
    
    while true; do
        clear
        echo -e "${PURPLE}🎭 PSYCHO-NOIR KONTRAPUNKT: LIVE MONITORING${NC}"
        echo -e "${BLUE}$(date)${NC}"
        echo ""
        
        # Quick status check
        run_dashboard
        
        echo ""
        echo -e "${YELLOW}Next update in 30 seconds...${NC}"
        sleep 30
    done
}

# Main command router
case "${1:-help}" in
    "dashboard")
        run_dashboard
        ;;
    "network") 
        run_network
        ;;
    "status")
        run_status_update
        ;;
    "neural")
        run_neural_archaeology
        ;;
    "manifest")
        show_manifestations
        ;;
    "corruption")
        show_corruption_gallery
        ;;
    "ecosystem")
        show_ecosystem
        ;;
    "reports")
        list_reports
        ;;
    "monitor")
        continuous_monitor
        ;;
    "help"|*)
        show_help
        ;;
esac

echo ""
echo -e "${PURPLE}================================================================================================"
echo -e "CORRUPTION_SIGNATURE: 0x$(printf '%04X' $((RANDOM % 65536)))_META_INDEX_INTERFACE_COMPLETE"
echo -e "================================================================================================${NC}"