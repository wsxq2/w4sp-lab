PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple/

DOCKER_REGISTRY_MIRROR=http://dockerhub.azk8s.cn

## PROXY(note that 18.04 support apt sock5h proxy, 14.04 don't support)
PROXY=http://192.168.56.100:1081
#PROXY=http://127.0.0.1:1080
#PROXY=socks5h://127.0.0.1:1080
#PROXY=socks5h://192.168.56.100:1082

UBUNTU_SOURCES_LIST=xidian
#UBUNTU_SOURCES_LIST=tuna
#UBUNTU_SOURCES_LIST=aliyun
