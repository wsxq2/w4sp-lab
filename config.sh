#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


PROXY=socks5h://127.0.0.1:1081
#PROXY=socks5h://192.168.56.100:1082
#PROXY=http://192.168.56.100:1081
grep -rlI --exclude config.sh 'http://192.168.56.100:1081' . | xargs sed -i -e "/http:\/\/192.168.56.100:1081/s##$PROXY#g"

#cd images/base/ && [[ -f source.list.xidian ]] && mv -f source.list.xidian source.list && cd -
