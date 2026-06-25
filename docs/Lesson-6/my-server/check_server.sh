#!/bin/bash
# Automatically verify local HTTP daemon state and capture HTTP status code
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

echo "Server status code checked: $STATUS"

if [ "$STATUS" -eq 200 ]; then
    echo "Success: Server is active and operational!"
else
    echo "Warning: Critical state or server unreachable."
fi
