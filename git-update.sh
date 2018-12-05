#!/bin/bash

yum install -y gcc gcc-c++ tk zlib-devel openssl-devel perl cpio expat-devel gettext-devel asciidoc xmlto
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel -y
yum install gcc perl-ExtUtils-MakeMaker -y

yum remove git -y
wget --no-check-certificate https://www.kernel.org/pub/software/scm/git/git-2.12.2.tar.gz
tar -zxf git-2.12.2.tar.gz
cd git-2.12.2
./configure --prefix=/usr/local/git && make install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
source /etc/profile
git --version
