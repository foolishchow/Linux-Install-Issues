CENTOS6 下编译安装 MYSQL 5.6.26
==================================

CentOS6下通过yum安装的MySQL是5.1版的，比较老，所以就想通过源代码安装高版本的5.6.26

[原文地址][yuanwen]
[参考文档][cankao]

[yuanwen]: http://www.cnblogs.com/xiongpq/p/3384681.html "原文"
[cankao]: http://www.cnblogs.com/xiongpq/p/3384681.html "参考"

> 一：卸载旧版本

使用下面的命令检查是否安装有MySQL Server
```sh
rpm -qa | grep mysql
```
有的话通过下面的命令来卸载掉

```sh 
rpm -e mysql 
// 普通删除模式
rpm -e --nodeps mysql 
// 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除
```

>二、安装编译MySQL需要的工具

安装g++和gdb
```sh 
yum install gcc-c++
yum install gdb
```
安装cmake
```sh 
yum install cmake
```
安装ncurses
```sh 
yum install ncurses-devel
```
安装bison
```sh
yum install bison bison-devel
```
( 编译依赖的工具说明请参考  http://dev.mysql.com/doc/refman/5.6/en/source-installation.html )

> 三、安装MySQL

1）参考以下两个链接下载MySQL 5.6.26
``` 
http://dev.mysql.com/doc/refman/5.6/en/getting-mysql.html
http://dev.mysql.com/downloads/mirrors.html
```
下载完成后解压
``` 
tar xvf mysql-5.6.26.tar.gz
cd mysql-5.6.26
```
2）编译安装
```sh 
cmake 
  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql 
  -DMYSQL_DATADIR=/usr/local/mysql/data 
  -DSYSCONFDIR=/etc 
  -DWITH_INNOBASE_STORAGE_ENGINE=1 
  -DWITH_PARTITION_STORAGE_ENGINE=1 
  -DMYSQL_UNIX_ADDR=/tmp/mysql.sock 
  -DMYSQL_TCP_PORT=3306 
  -DDEFAULT_CHARSET=utf8 
  -DDEFAULT_COLLATION=utf8_general_ci
make
make install
```
编译的参数请参考 http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html

编译过程需要30分钟左右，编译并安装完成后可以看一下结果
```sh 
ll /usr/local/mysql
```

>四、配置MySQL

1. 配置用户

使用下面的命令查看是否有mysql用户及用户组
```sh 
cat /etc/passwd //查看用户列表
cat /etc/group  //查看用户组列表
```
如果没有就创建
```sh 
groupadd mysql
useradd -r -g mysql mysql
```
确认一下创建结果
```sh 
id mysql
```
修改/usr/local/mysql目录权限
```sh 
chown -R mysql:mysql /usr/local/mysql
```
2. 初始化配置
安装运行MySQL测试脚本需要的perl
```sh 
yum install perl
```
进入安装路径
```sh 
cd /usr/local/mysql
```
执行初始化配置脚本，创建系统自带的数据库和表
```sh 
./scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql
```
（ps：在启动MySQL服务时，会按照一定次序搜索my.cnf，先在/etc目录下找，找不到则会搜索"$basedir/my.cnf"，在本例中就是 /usr/local/mysql/my.cnf，这是新版MySQL的配置文件的默认位置！)

######注意：

在`CentOS 6.4`版操作系统的最小安装完成后，在`/etc`目录下会存在一个`my.cnf`，需要将此文件更名为其他的名字，如：`/etc/my.cnf.bak`，否则，该文件会干扰源码安装的MySQL的正确配置，造成无法启动。

在使用`yum update`更新系统后，需要检查下`/etc`目录下是否会多出一个`my.cnf`，如果多出，将它重命名成别的。否则，MySQL将使用这个配置文件启动，可能造成无法正常启动等问题。

3. 启动MySQL

添加服务，拷贝服务脚本到init.d目录，并设置开机启动
```sh 
cp support-files/mysql.server /etc/init.d/mysql
chkconfig mysql on
service mysql start  --启动MySQL
```

4. 配置MySQL账号密码
MySQL启动成功后，root默认没有密码，我们需要设置root密码。

设置之前，我们需要先设置PATH，要不不能直接调用mysql

修改/etc/profile文件，在文件末尾添加
```sh 
PATH=/usr/local/mysql/bin:$PATH
export PATH
```
关闭文件，运行下面的命令，让配置立即生效
```sh 
source /etc/profile
```
现在，我们可以在终端内直接输入mysql进入，mysql的环境了

执行下面的命令修改root密码
```sh 
mysql -uroot  
mysql> SET PASSWORD = PASSWORD('123456');
```
若要设置root用户可以远程访问，执行
```sh 
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```
远程访问时的密码可以和本地不同。
5. 配置防火墙
防火墙的3306端口默认没有开启，若要远程访问，需要开启这个端口

打开/etc/sysconfig/iptables

在“-A INPUT –m state --state NEW –m tcp –p –dport 22 –j ACCEPT”，下添加：
```sh 
-A INPUT -m state --state NEW -m tcp -p -dport 3306 -j ACCEPT
```
然后保存，并关闭该文件，在终端内运行下面的命令，刷新防火墙配置：
```sh 
service iptables restart
```
一切配置完毕，你就可以访问MySQL了。





















