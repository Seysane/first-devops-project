#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "Usage: ./log_analyzer.sh <log_file> <filter_pattern> [max_results]"
    echo "Example: ./log_analyzer.sh /var/log/auth.log Failed 20"
    exit 0
fi

validate_input() {
    if [ $# -lt 2 ]; then
        echo "Error: Missing required arguments!"
        echo "Usage: $0 <log_file> <filter_pattern> [max_results]"
        exit 1
    fi

    if [ ! -f "$1" ]; then
        echo "Error: File '$1' does not exist or is not a valid file!"
        exit 1
    fi
}

validate_input "$@"

LOG_FILE=$1
PATTERN=$2
MAX_RESULTS=${3:-10}

declare -A IP_COUNTS
TOTAL_MATCHES=0
TEMP_MATCHES_FILE=$(mktemp)

search_logs() {
    echo "Starting analysis of file: $LOG_FILE..."
    
    while read -r line; do
        if [[ "$line" == *"$PATTERN"* ]]; then
            ((TOTAL_MATCHES++))
            
            if [ $TOTAL_MATCHES -le $MAX_RESULTS ]; then
                echo "$line" >> "$TEMP_MATCHES_FILE"
            fi
            
            if [[ "$line" =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then
                IP="${BASH_REMATCH[1]}"
                ((IP_COUNTS[$IP]++))
            fi
        fi
    done < "$LOG_FILE"
}

search_logs

generate_report() {
    REPORT_FILE="report.txt"
    
    {
        echo "=================================================="
        echo "                LOG ANALYSIS REPORT               "
        echo "=================================================="
        echo "Analysis Date:     $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Analyzed File:     $LOG_FILE"
        echo "Search Pattern:    $PATTERN"
        echo "Execution Time:    $SECONDS second(s)"
        echo "--------------------------------------------------"
        echo "General Statistics:"
        echo "Total matching lines found: $TOTAL_MATCHES"
        echo "--------------------------------------------------"
        echo "First $MAX_RESULTS matching lines:"
        if [ -s "$TEMP_MATCHES_FILE" ]; then
            cat "$TEMP_MATCHES_FILE"
        else
            echo "No matching lines to display."
        fi
        echo "--------------------------------------------------"
        
        echo "Top 5 Most Frequent Words in Matches:"
        if [ -s "$TEMP_MATCHES_FILE" ]; then
            cat "$TEMP_MATCHES_FILE" | tr -cs 'a-zA-Z0-9_' '\n' | sort | uniq -c | sort -nr | head -n 5
        else
            echo "No data available."
        fi
        echo "--------------------------------------------------"
        
        echo "IP Address Statistics (Top Hits):"
        if [ ${#IP_COUNTS[@]} -gt 0 ]; then
            for ip in "${!IP_COUNTS[@]}"; do
                echo "${IP_COUNTS[$ip]} $ip"
            done | sort -nr | head -n 5
        else
            echo "No IP addresses found in matching lines."
        fi
        echo "=================================================="
    } > "$REPORT_FILE"
    
    cat "$REPORT_FILE"
    rm -f "$TEMP_MATCHES_FILE"
}

generate_report
