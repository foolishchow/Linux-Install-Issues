cMake 安装 MYSQL
==================================

目标系统CentOS6.5 64位

源码包位置:`/usr/local/src/mysql-5.6.22.tar.gz`

以下步骤：

```sh 
cd /usr/local/src
tar -zxvf mysql-5.6.22.tar.gz
cd mysql-5.6.22
```
检查是否安装了cmake，未安装则安装
```sh 
yum -y install cmake
```
创建mysql用户、组、数据目录
```sh 
groupadd mysql
useradd -r -g mysql mysql
mkdir -p /usr/local/mysql/data
chown -R mysql:mysql /usr/local/mysql
```
预编译
```sh 
cmake . 
  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql 
  -DMYSQL_DATADIR=/usr/local/mysql/data 
  -DMYSQL_UNIX_ADDR=/tmp/mysql.sock 
  -DWITH_MYISAM_STORAGE_ENGINE=1 
  -DWITH_INNOBASE_STORAGE_ENGINE=1 
  -DWITH_ARCHIVE_STORAGE_ENGINE=1 
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 
  -DENABLED_LOCAL_INFILE=1 
  -DDEFAULT_CHARSET=utf8 
  -DDEFAULT_COLLATION=utf8_general_ci 
  -DEXTRA_CHARSETS=all 
  -DMYSQL_TCP_PORT=3306
```
仔细看预编译的结果提示，如果有错误，查看它给的错误日志文件内容，安装相关的依赖库 重新编译之前，要清除编译缓存，
```sh 
make clean 
rm -f CMakeCache.txt
make & make install
```
初始化数据库
```sh
cd /usr/local/mysql/
vi /etc/my.cnf
```
输入并保存

``` 
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
port            = 3306
socket          = /tmp/mysql.sock
slow_query_log  = 1
\#慢查询时间 超过1秒则为慢查询
long_query_time = 2 
slow_query_log_file = /var/log/mysql/slow.log
user=mysql
```
初始化数据库：
```sh
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data/
```

启动数据库 
```sh 
/usr/local/mysql/bin/mysqld_safe & 大功告成！
```