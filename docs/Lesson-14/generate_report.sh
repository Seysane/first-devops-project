#!/bin/bash

RESULTS_FILE="load_test_results.csv"
OUTPUT_FILE="report.txt"

{
echo "# Load Test Report"
echo "Test Date: $(date)"
echo ""
echo "## Results Summary"
echo "| Concurrency | RPS | Avg Response Time |"
echo "|-------------|-----|-------------------|"
awk -F',' 'NR > 1 { printf "| %-11s | %-8s | %-17s |\n", $1, $4, $5 }' "$RESULTS_FILE"

} > "$OUTPUT_FILE"

echo "Test report has been generated and saved as: $OUTPUT_FILE"