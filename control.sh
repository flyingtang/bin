#!/bin/bash

WORKSPACE=$(cd $(dirname $0)/; pwd)
cd $WORKSPACE

app=monitor
conf=config
pidfile=/var/run/monitor.pid
logfile=/dev/null

function check_pid() {
    if [ -f $pidfile ];then
        pid=`cat $pidfile`
        if [ -n $pid ]; then
            running=`ps -p $pid|grep -v "PID TTY" |wc -l`
            return $running
        fi
    fi
    return 0
}

function start() {
    check_pid
    running=$?
    if [ $running -gt 0 ];then
        echo -n "$app now is running already, pid="
        cat $pidfile
        return 1
    fi

    nohup ./$app 2>&1 &
    echo $! > $pidfile
    echo "$app started..., pid=$!"
}

function stop() {
    pid=`cat $pidfile`
    kill $pid
    echo "$app stoped..."
}

function restart() {
    stop
    sleep 1
    start
}

function status() {
    check_pid
    running=$?
    if [ $running -gt 0 ];then
        echo started
    else
        echo stoped
    fi
}

function help() {
    echo "$0 start|stop|restart|status"
}

case "$1" in 
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "restart")
        restart
        ;;
    "status")
        status
        ;;
    *)
        help
        ;;
esac