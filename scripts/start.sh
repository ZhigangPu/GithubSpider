#! /bin/bash

SCRIPT_HOME=$(readlink -f $(dirname "$0"))

pm2 start ${SCRIPT_HOME}/run.sh --name FpToHkViid
