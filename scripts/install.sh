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
install_dependencies() {
    pushd ${DEPLOY_HOME}/dependencies
    # install setuptools
    unzip setuptools-41.0.1.zip
    pushd setuptools-41.0.1
    python3 setup.py install --user
    popd
    # install and activate virtualenv
    tar -zxvf virtualenv-16.5.0.tar.gz
    pushd virtualenv-16.5.0
    python3 setup.py install --user
    pushd ../../
    ${HOME}/.local/bin/virtualenv --python=/usr/bin/python3 venv
    source ./venv/bin/activate
    popd
    popd
    # install requests
    tar -zxvf chardet-3.0.4.tar.gz
    pushd chardet-3.0.4
    python setup.py install
    popd
    tar -zxvf idna-2.8.tar.gz
    pushd idna-2.8
    python setup.py install 
    popd
    tar -zxvf urllib3-1.24.3.tar.gz
    pushd urllib3-1.24.3
    python setup.py install 
    popd
    tar -zxvf certifi-2019.3.9.tar.gz
    pushd certifi-2019.3.9
    python setup.py install 
    popd
    tar -zxvf requests-2.21.0.tar.gz
    pushd requests-2.21.0
    python setup.py install 
    popd
    deactivate
    popd
}

main(){
    install_dependencies
}

main
