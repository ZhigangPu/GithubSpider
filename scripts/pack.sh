#!/bin/bash
set -o errexit

PROJECT=FpToHKViid
GIT_HASH=$(git log -n 1 --pretty=format:"%H")
GIT_BRANCH=$(git symbolic-ref -q HEAD)
GIT_BRANCH=${GIT_BRANCH##refs/heads/}
SCRIPT_HOME=$(readlink -f $(dirname "$0"))
PROJECT_HOME=${SCRIPT_HOME}/..
OUT_HOME=${PROJECT_HOME}/out/${GIT_BRANCH}/${PROJECT}

pushd() {
  command pushd "$@" &>/dev/null
}

popd() {
  command popd "$@" &>/dev/null
}

# 创建输出目录
init_output() {
  rm -rf ${OUT_HOME}
  mkdir -p ${OUT_HOME}
  pushd ${OUT_HOME}
  mkdir config scripts lib dependencies
  popd
}

download_dependencies() {
    pushd ${OUT_HOME}/dependencies
    # get pypi package
    # setupytools
    wget https://files.pythonhosted.org/packages/1d/64/a18a487b4391a05b9c7f938b94a16d80305bf0369c6b0b9509e86165e1d3/setuptools-41.0.1.zip
    # requests
    wget https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz
    # chardet
    wget https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz
    # idna
    wget https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz
    # urllib3
    wget https://files.pythonhosted.org/packages/8a/3c/1bb7ef6c435dea026f06ed9f3ba16aa93f9f4f5d3857a51a35dfa00882f1/urllib3-1.24.3.tar.gz
    # certifi
    wget https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz

    # virtualenv
    wget https://files.pythonhosted.org/packages/6a/56/74dce1fdeeabbcc0a3fcf299115f6814bd9c39fc4161658b513240a75ea7/virtualenv-16.5.0.tar.gz
    popd
}

copy_file() {
  cp ${PROJECT_HOME}/push_pics.py ${OUT_HOME}/
  cp ${PROJECT_HOME}/bsd_web_api.py ${OUT_HOME}/
  cp ${SCRIPT_HOME}/* ${OUT_HOME}/scripts
  cp ${PROJECT_HOME}/config.json ${OUT_HOME}/
  }

publish() {
  pushd ${OUT_HOME}
  cat >version <<VERSION_END
NAME=${PROJECT}
VERSION=$1
OS_ARCH=x86_64
OS_NAME=Linux
BRANCH=${GIT_BRANCH}
SOURCE=${GIT_HASH}
DATE=$(date +'%Y-%m-%d %H:%M:%S.%3N')
VERSION_END
pushd ..
echo "updating ${PROJECT}.tar.gz"
tar czf ${PROJECT}.tar.gz ${PROJECT}
md5sum ${PROJECT}.tar.gz | cut -d ' ' -f 1 >${PROJECT}.tar.gz.md5
popd
popd
}

main() {
    init_output
    download_dependencies
    copy_file
    publish $1 
}

main $1
