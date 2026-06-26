#!/bin/bash

log() {
    echo "$(date "+%Y-%m-%d %H:%M") - $1 $2 "
}

cleanup() {
    rm $PID_FILE
    exit 1
}

PID_FILE="/tmp/myservice.pid"

case $1 in
    start)
        trap cleanup EXIT
        echo "Starting"
        sleep 9999 &
        echo $! > $PID_FILE
        trap - EXIT
        log "INFO" "Service is running"
        ;;
    stop)
    if [ -f $PID_FILE ]; then
        echo "Stopping"
        kill $(cat $PID_FILE) 2>/dev/null
        rm $PID_FILE
        log "INFO" "Service stopped"
    else
        log "INFO" "Service inactive"
    fi
        ;;
    restart)
        $0 stop
        $0 start
    ;;
    status)
        if [ -f $PID_FILE ]; then
            if kill -0 $(cat $PID_FILE) 2>/dev/null; then
                log "INFO" "Service running"
                exit 0
            else
                log "INFO" "Service stopped"
                exit 1
            fi
        else
            log "INFO" "Service stopped"
        fi
    ;;
    *)
        log "ERROR" "Unknow command"
        exit 1
        ;;
esac


