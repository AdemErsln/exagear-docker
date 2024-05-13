#!/bin/bash

run()
{
    "$@" &
    pid="$!"
    trap "kill -SIGINT $pid" SIGINT SIGTERM
    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
}

run /entrypoint.sh $@