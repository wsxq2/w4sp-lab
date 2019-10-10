# w4sp-lab
该项目是《Wireshark 与 Metasploit 实战指南》（英文名 Wireshark for Security Professionals: Using Wireshark and the Metasploit Framework）一书的实验环境。

该实验环境搭建于 Kali Linux 中的 Docker 之上，提供了一个模拟的网络环境，里面有很多有用的用于学习网络安全基础知识的服务（如 FTP，HTTP，SMB，DNS 等）

## 缘由
[官方 Github 地址](https://github.com/w4sp-book/w4sp-lab)最后一次更新是在 2017-08-23（当前时间为 2019-10-10）。由于 Kali 更新迭代很快以及国内访问国外的官方网站很慢（包括 Ubuntu、Kali、Docker、pypi、elasticsearch等），其介绍的安装方法并不适用我们的国情。

因此，为了更加快速方便地部署该实验环境，我 Fork 了官方版本，作了一些改进。并编写了一个脚本`w4sp_prepare.sh`和配置文件`config.sh`。前者用于做些准备工作，后者用于配置重要软件的下载源（比如使用国内的阿里云下载 Kali 相关软件等）

## 安装方法
### 对于新装的 Kali
1. 使用 root 用户登录后下载该项目：
   ```
   root@kali:/tmp/# git clone https://github.com/wsxq2/w4sp-lab.git
   ```

1. 运行`w4sp_prepare.sh`（使用`create_user`参数）：
   ```
   root@kali:/tmp/w4sp-lab/# bash w4sp_prepare.sh create_user
   ```
   这里会为`w4sp-lab`用户设置初始密码`admIn`

   或者：
   ```
   root@kali:/tmp/w4sp-lab/# python w4sp_webapp.py
   ```
   这时，你需要手动为`w4sp-lab`用户设置密码
   
1. 切换到 w4sp-lab 用户登录
1. 修改配置文件`config.sh`
   1. `PIP_INDEX_URL`(for ubuntu 14.04)：这是为 docker 容器里的操作系统配置的（该实验用的是 ubuntu 14.04）。以提高在安装 Python 相关包时的下载速度。保持默认即可
   1. `DOCKER_REGISTRY_MIRROR`(for kali): 这是为 kali 本身配置的。以提高下载 docker 镜像的速度（如实验用到的 docker 镜像 ubuntu 14.04）。保持默认即可。
      
      如果用不了，可以使用`images/`目录下的脚本`docker_mirror.py`来查找对于你而言最快的镜像

   1. `PROXY`(for ubuntu 14.04)：这是为 kali 本身和 docker 容器里的操作系统配置的。主要针对如下网址：
   ```
   packages.elastic.co
   ppa.launchpad.net
   apt.dockerproject.org
   ```
   以提高使用`apt`时的下载速度。这里必需设置正确的 HTTP 代理，否则后面将无法进行（对于能否设置为空尚未测试）。SOCKS 代理亲测不可行。如果需要的话可使用`prioxy`或`polipo`将 SOCKS 代理转换为 HTTP 代理

   **温馨提示**：如果你的 Kali Linux 在虚拟机中且主机已经实现了科学上网，那么你没必要再折腾，直接使用[通过已经可以科学上网的电脑实现科学上网](https://wsxq2.55555.io/blog/2019/07/07/科学上网#通过已经可以科学上网的电脑实现科学上网)这个方法即可。且宿主机（Windows 或 MacOS）上的本地代理通常是全能代理（既支持 socks 代理又支持 http 代理）
   
   1. `UBUNTU_SOURCES_LIST`(for ubuntu 14.04): 这是为 docker 容器里的操作系统配置的。实质上是覆盖了`ubuntu 14.04`的`/etc/apt/sources.list`文件，以提高 docker 容器中使用 apt 时的下载速度。建议使用`aliyun`

1. 执行脚本`w4sp_prepare.sh`以完成准备工作（使用`new`参数）：
   ```
   w4sp-lab@kali:/tmp/w4sp-lab/$ sudo bash w4sp_prepare.sh new
   ```

1. 执行环境主安装脚本`w4sp_webapp.py`以完成环境安装：
   ```
   w4sp-lab@kali:/tmp/w4sp-lab/$ sudo python w4sp_webapp.py
   ```

### 如果想要不影响系统文件
上述方法会影响 Kali 的`/etc/apt/sources.list`文件，它会从<https://raw.githubusercontent.com/wsxq2/MyProfile/master/Linux/Kali/etc/apt/sources.list>下载并覆盖`/etc/apt/sources.list，并自动添加 docker 源（<apt.dockerproject.org>）。而且会同步时间、安装一些我喜欢的工具（`tree`，`curl`，`info`，`ncat`，`nload`）

如果你不喜欢这样，可以使用`w4sp_prepare.sh`脚本的`config`参数（而非`new`）。但是请确保安装了`curl`，因为`check_config`会用到它

假如你当前使用的用户名为`bob`，属于`sudo`组，且主机名为`kali`。则：
1. 下载该项目：
   ```
   bob@kali:/tmp/$ git clone https://github.com/wsxq2/w4sp-lab.git
   ```
1. 创建用户`w4sp-lab`：
   ```
   bob@kali:/tmp/w4sp-lab/$ sudo bash w4sp_prepare.sh create_user
   ```
   这里会为`w4sp-lab`用户设置初始密码`admIn`

   或者：
   ```
   bob@kali:/tmp/w4sp-lab/$ sudo python w4sp_webapp.py
   ```
   这时，你需要手动为`w4sp-lab`用户设置密码

1. 切换用户为 w4sp-lab 登录
1. 执行如下命令：
   ```
   w4sp-lab@kali:/tmp/w4sp-lab/$ sudo w4sp_prepare.sh config
   ......
   w4sp-lab@kali:/tmp/w4sp-lab/$ sudo python w4sp_webapp.py
   ```


