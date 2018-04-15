#!/bin/bash

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    echo running command "$@"
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
else
    exec nctelegram
fi
