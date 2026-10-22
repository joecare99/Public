#!/bin/sh
# Holt einen Backtrace fuer ein abstuerzendes Programm.
#   FPC/tools/trace.sh <Programm> [Argumente ...]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 1
PROG=$1
shift
gdb -q -batch \
    -ex "set pagination off" \
    -ex "run $*" \
    -ex "bt 20" \
    --args "./bin/x86_64-linux/$PROG" "$@" 2>&1 | tail -30
