#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
PROXY=socks5h://127.0.0.1:1081
#PROXY=socks5h://192.168.56.100:1082
#PROXY=http://192.168.56.100:1081

find . -type f -name Dockerfile |xargs grep -l PIP_INDEX_URL | xargs sed -i -e "/PIP_INDEX_URL/s##$PIP_INDEX_URL#g"
find . -type f -name Dockerfile |xargs grep -l PROXY | xargs sed -i -e "/PROXY/s##$PROXY#g"

#cd images/base/ && [[ -f source.list.xidian ]] && mv -f source.list.xidian source.list && cd -
