#!/bin/bash


URL="http://localhost/"
RESULTS_FILE="load_test_results.csv"

echo "Concurrent,Requests,Time,RequestsPerSec,AvgResponseTime" > $RESULTS_FILE
for concurrent in 10 50 100 200 500; do
    result=$(ab -n 500 -c $concurrent "$URL" 2>/dev/null | grep -E "Requests per second|Time per request")
    rps=$(echo "$result" | grep "Requests per second" | awk '{print $4}')
    avg=$(echo "$result" | grep "Time per request" | head -1 | awk '{print $4}')
    echo "$concurrent,500,,$rps,$avg" >> $RESULTS_FILE
done

cat $RESULTS_FILE