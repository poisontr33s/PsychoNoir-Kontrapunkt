#!/bin/bash

# Digital Necromancy Failure Analysis Script
# Part of the Psycho-Noir Kontrapunkt Observatory System

set -e

SCRIPT_VERSION="1.0.0"
ANALYSIS_MODE="${1:-standard}"
DATA_DIR="${2:-./observatory-data}"
OUTPUT_DIR="${3:-./failure-analysis}"

echo "🧬 Digital Necromancy Failure Analysis v$SCRIPT_VERSION"
echo "Analysis Mode: $ANALYSIS_MODE"
echo "Data Directory: $DATA_DIR"
echo "Output Directory: $OUTPUT_DIR"
echo ""

# Create output directory structure
mkdir -p "$OUTPUT_DIR"/{categories,patterns,evolution,reports}

# Initialize analysis variables
declare -A error_taxonomy
declare -A temporal_patterns
declare -A correlation_matrix
declare -A failure_signatures

total_runs=0
successful_runs=0
failed_runs=0
unknown_runs=0

# Function to analyze failure patterns
analyze_failure_pattern() {
    local outcome_file="$1"
    local category=$(grep '"category"' "$outcome_file" | cut -d'"' -f4 2>/dev/null || echo "unknown")
    local outcome=$(grep '"outcome"' "$outcome_file" | cut -d'"' -f4 2>/dev/null || echo "unknown")
    local error_type=$(grep '"error_type"' "$outcome_file" | cut -d'"' -f4 2>/dev/null || echo "none")
    local duration=$(grep '"duration_seconds"' "$outcome_file" | cut -d':' -f2 | tr -d ' ,' 2>/dev/null || echo "0")
    local timestamp=$(grep '"timestamp"' "$outcome_file" | cut -d'"' -f4 2>/dev/null || echo "unknown")
    
    total_runs=$((total_runs + 1))
    
    case "$outcome" in
        "SUCCESS") successful_runs=$((successful_runs + 1)) ;;
        "FAILURE") failed_runs=$((failed_runs + 1)) ;;
        *) unknown_runs=$((unknown_runs + 1)) ;;
    esac
    
    # Build error taxonomy
    if [ "$error_type" != "none" ] && [ "$error_type" != "NONE" ]; then
        error_taxonomy["$error_type"]=$((${error_taxonomy["$error_type"]:-0} + 1))
        
        # Create detailed failure signature
        local signature="${category}_${error_type}_$(echo "$duration" | cut -d'.' -f1)"
        failure_signatures["$signature"]=$((${failure_signatures["$signature"]:-0} + 1))
    fi
    
    # Temporal analysis
    if [ "$timestamp" != "unknown" ]; then
        local hour=$(echo "$timestamp" | cut -d'T' -f2 | cut -d':' -f1)
        temporal_patterns["hour_$hour"]=$((${temporal_patterns["hour_$hour"]:-0} + 1))
    fi
    
    # Category correlation
    correlation_matrix["${category}_${outcome}"]=$((${correlation_matrix["${category}_${outcome}"]:-0} + 1))
}

# Function to generate taxonomy report
generate_taxonomy_report() {
    echo "# Failure Taxonomy Analysis" > "$OUTPUT_DIR/reports/taxonomy.md"
    echo "Generated: $(date -u)" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "Analysis Mode: $ANALYSIS_MODE" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "" >> "$OUTPUT_DIR/reports/taxonomy.md"
    
    echo "## Summary Statistics" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "- Total Runs: $total_runs" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "- Successful: $successful_runs" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "- Failed: $failed_runs" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "- Unknown: $unknown_runs" >> "$OUTPUT_DIR/reports/taxonomy.md"
    
    if [ "$total_runs" -gt 0 ]; then
        local success_rate=$((successful_runs * 100 / total_runs))
        local failure_rate=$((failed_runs * 100 / total_runs))
        echo "- Success Rate: ${success_rate}%" >> "$OUTPUT_DIR/reports/taxonomy.md"
        echo "- Failure Rate: ${failure_rate}%" >> "$OUTPUT_DIR/reports/taxonomy.md"
    fi
    
    echo "" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "## Error Type Taxonomy" >> "$OUTPUT_DIR/reports/taxonomy.md"
    for error_type in "${!error_taxonomy[@]}"; do
        echo "- **$error_type**: ${error_taxonomy[$error_type]} occurrences" >> "$OUTPUT_DIR/reports/taxonomy.md"
    done
    
    echo "" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "## Failure Signatures (Category_ErrorType_Duration)" >> "$OUTPUT_DIR/reports/taxonomy.md"
    for signature in "${!failure_signatures[@]}"; do
        echo "- \`$signature\`: ${failure_signatures[$signature]} occurrences" >> "$OUTPUT_DIR/reports/taxonomy.md"
    done
    
    echo "" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "## Temporal Patterns" >> "$OUTPUT_DIR/reports/taxonomy.md"
    for pattern in "${!temporal_patterns[@]}"; do
        echo "- $pattern: ${temporal_patterns[$pattern]} runs" >> "$OUTPUT_DIR/reports/taxonomy.md"
    done
    
    echo "" >> "$OUTPUT_DIR/reports/taxonomy.md"
    echo "## Category Correlation Matrix" >> "$OUTPUT_DIR/reports/taxonomy.md"
    for correlation in "${!correlation_matrix[@]}"; do
        echo "- $correlation: ${correlation_matrix[$correlation]} occurrences" >> "$OUTPUT_DIR/reports/taxonomy.md"
    done
}

# Function to generate evolution patterns
generate_evolution_patterns() {
    echo "# Evolution Pattern Analysis" > "$OUTPUT_DIR/reports/evolution.md"
    echo "Generated: $(date -u)" >> "$OUTPUT_DIR/reports/evolution.md"
    echo "" >> "$OUTPUT_DIR/reports/evolution.md"
    
    echo "## Failure Evolution Indicators" >> "$OUTPUT_DIR/reports/evolution.md"
    
    # Analyze failure density
    if [ "$failed_runs" -gt "$successful_runs" ]; then
        echo "- **System State**: High Entropy (More failures than successes)" >> "$OUTPUT_DIR/reports/evolution.md"
        echo "- **Recommendation**: Immediate intervention required" >> "$OUTPUT_DIR/reports/evolution.md"
    elif [ "$failed_runs" -gt 0 ]; then
        echo "- **System State**: Moderate Entropy (Some failures present)" >> "$OUTPUT_DIR/reports/evolution.md"
        echo "- **Recommendation**: Monitor patterns and preventive measures" >> "$OUTPUT_DIR/reports/evolution.md"
    else
        echo "- **System State**: Low Entropy (Stable operation)" >> "$OUTPUT_DIR/reports/evolution.md"
        echo "- **Recommendation**: Maintain current practices" >> "$OUTPUT_DIR/reports/evolution.md"
    fi
    
    # Dominant failure patterns
    echo "" >> "$OUTPUT_DIR/reports/evolution.md"
    echo "## Dominant Failure Patterns" >> "$OUTPUT_DIR/reports/evolution.md"
    local max_error_count=0
    local dominant_error="none"
    
    for error_type in "${!error_taxonomy[@]}"; do
        if [ "${error_taxonomy[$error_type]}" -gt "$max_error_count" ]; then
            max_error_count=${error_taxonomy[$error_type]}
            dominant_error="$error_type"
        fi
    done
    
    if [ "$dominant_error" != "none" ]; then
        echo "- **Primary Failure Mode**: $dominant_error ($max_error_count occurrences)" >> "$OUTPUT_DIR/reports/evolution.md"
        if [ "$failed_runs" -gt 0 ]; then
            local percentage=$((max_error_count * 100 / failed_runs))
            echo "- **Pattern Significance**: ${percentage}% of all failures" >> "$OUTPUT_DIR/reports/evolution.md"
        fi
    fi
}

# Function to create machine-readable data files
generate_machine_data() {
    # Create JSON summary for machine processing
    cat > "$OUTPUT_DIR/analysis-summary.json" << EOF
{
  "analysis_version": "$SCRIPT_VERSION",
  "analysis_mode": "$ANALYSIS_MODE",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": {
    "total_runs": $total_runs,
    "successful_runs": $successful_runs,
    "failed_runs": $failed_runs,
    "unknown_runs": $unknown_runs,
    "success_rate": $(if [ "$total_runs" -gt 0 ]; then python3 -c "print(f'{$successful_runs * 100 / $total_runs:.1f}')"; else echo "0"; fi),
    "failure_rate": $(if [ "$total_runs" -gt 0 ]; then python3 -c "print(f'{$failed_runs * 100 / $total_runs:.1f}')"; else echo "0"; fi)
  },
  "error_taxonomy": {
EOF

    # Add error taxonomy to JSON
    local first=true
    for error_type in "${!error_taxonomy[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_DIR/analysis-summary.json"
        fi
        echo -n "    \"$error_type\": ${error_taxonomy[$error_type]}" >> "$OUTPUT_DIR/analysis-summary.json"
    done
    
    cat >> "$OUTPUT_DIR/analysis-summary.json" << EOF

  },
  "temporal_patterns": {
EOF

    # Add temporal patterns to JSON
    first=true
    for pattern in "${!temporal_patterns[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_DIR/analysis-summary.json"
        fi
        echo -n "    \"$pattern\": ${temporal_patterns[$pattern]}" >> "$OUTPUT_DIR/analysis-summary.json"
    done
    
    echo -e "\n  }\n}" >> "$OUTPUT_DIR/analysis-summary.json"
}

# Main analysis execution
echo "📊 Scanning for outcome data files..."

if [ ! -d "$DATA_DIR" ]; then
    echo "❌ Data directory not found: $DATA_DIR"
    echo "🔧 Creating minimal analysis with zero data points..."
    # Continue with empty analysis instead of exiting
fi

outcome_files=$(find "$DATA_DIR" -name "outcome.json" -type f 2>/dev/null || echo "")

if [ -z "$outcome_files" ]; then
    echo "⚠️  No outcome.json files found in $DATA_DIR"
    echo "Creating empty analysis with zero data points..."
else
    echo "🔍 Found $(echo "$outcome_files" | wc -l) outcome files to analyze"
    
    for outcome_file in $outcome_files; do
        echo "  Analyzing: $outcome_file"
        analyze_failure_pattern "$outcome_file"
    done
fi

echo ""
echo "📈 Generating analysis reports..."

generate_taxonomy_report
generate_evolution_patterns
generate_machine_data

echo ""
echo "✅ Analysis complete!"
echo "📁 Reports generated in: $OUTPUT_DIR/reports/"
echo "📄 Machine data: $OUTPUT_DIR/analysis-summary.json"
echo ""
echo "🎭 Digital Necromancy Analysis Summary:"
echo "   Total Runs: $total_runs"
if [ "$total_runs" -gt 0 ]; then
    echo "   Success Rate: $((successful_runs * 100 / total_runs))%"
    echo "   Failure Rate: $((failed_runs * 100 / total_runs))%"
else
    echo "   Success Rate: N/A"
    echo "   Failure Rate: N/A"
fi
echo "   Dominant Failures: $(echo "${!error_taxonomy[@]}" | tr ' ' '\n' | head -3 | tr '\n' ' ')"