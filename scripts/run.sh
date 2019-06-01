#!/bin/bash
set -o errexit

SCRIPT_HOME=$(readlink -f $(dirname "$0"))
DEPLOY_HOME=${SCRIPT_HOME}/..


pushd() {
  command pushd "$@" &>/dev/null
}

popd() {
  command popd "$@" &>/dev/null
}

source ${DEPLOY_HOME}/venv/bin/activate
pushd ${DEPLOY_HOME}
python push_pics.py
popd
