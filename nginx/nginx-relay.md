Linux redhat安装Nginx
==============================================

### ![nginxPic][nginxPic]

- Nginx是一款非常优秀的Web服务器，它是由俄罗斯人Igor Sysoev（伊戈尔-塞索耶夫）写的，虽然它的应用还没有老牌Web服务器Apache广泛，但相比Apache，它有着自己的一些优势，比如很好的高并发访问支持内存却占用少，配置简单，稳定性高，支持热部署等等。
Nginx 已经在俄罗斯的最大的门户网站Rambler Media上运行了好几年的时间，在国内也有很多一些知名网站也采用Nginx作为Web服务器或反向代理服务器，比如新浪、网易、空中网等等。
在这里，我记录一下安装Nginx的过程，因为Nginx需要其他第三方库的支持，比如rewrite模块需要pcre库，ssl需要openssl库，所以也一并介绍了一下其他库，主要是pcre和openssl库的安装说明。
 
[nginxPic]: http://nginx.org/nginx.png "nginxPIc"

##1. 安装PCRE
>  [PCRE官网][pcrehome] 
   [下载页面][pcredownload] 
   [测试版本][pcrehere] 
>
   * 解压： `tar –zxvf pcre-8.10.tar.gz` (解压目录为：pcre-8.10)
   * 进入到解压目录 `cd pcre-8.10` 
   * 配置 `./configure` 或 `./config`
   * 编译 `make`
   * 安装 `make install`

[pcrehome]: http://www.pcre.org/ "PCRE官网"
[pcredownload]: ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/ "下载页面"
[pcrehere]: ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.10.tar.gz "选择最新版本下载"


##2. 安装OpenSSL ![OpenSSl][openssl-ico] 
>  OpenSSl上网[官网][OpenSSlhome] 找到[下载页面][OpenSslDown] 选择最新版本 [下载][downNewest]
>
   * 解压： `tar –zxvf openssl-1.0.0.tar.gz` (解压目录为：openssl-1.0.0)
   * 进入到解压目录 `cd openssl-1.0.0` 
   * 配置 `./configure` 或 `./config`
   * 编译 `make`
   * 安装 `make install`

[openssl-ico]: http://www.openssl.org/favicon.ico "openssl-ico"
[OpenSSlhome]: http://www.openssl.org "官网"
[OpenSslDown]: http://www.openssl.org/source/ "下载地址"
[downNewest]: http://www.openssl.org/source/openssl-1.0.0a.tar.gz "最新版本"


##3. nginx安装
> 官网[地址][nginxcom] 我们的下载[地址][nginxdown] 下载版本[0.8.53][nginx-v]
>
   * 解压： `tar –zxvf nginx-0.8.53.tar.gz` ( 解压目录为：nginx-0.8.53 )
   * 进入到解压目录 `cd nginx-0.8.53` 
   * 配置 `./configure` 或 `./config`
   * 编译 `make`
   * 安装 `make install` 

  
按照一般的说明，也就是通过./config或./configure直接进行配置了，但配置后，在编译make的时候很可能会报：`*** No rule to make target 'clean'.  Stop. `等这样的错误，

所以仅仅通过`./configure`来进行配置是不够的，至少在配置的时候需要指定openssl的安装目录，

比如我的openssl安装目录是：`openssl-1.0.0`，则在配置的时候应该为`./configure –with-http_stub_status_module –with-http_ssl_module –with-openssl=/usr/local/openssl-1.0.0 –with-http_gzip_static_module`
   
这样在编译的时候才会成功，接下来就是安装：`make install`安装成功后，会生成一个nginx的目录。 

```sh
   ./configure 
   --prefix=/data/services/nginx 
   --with-http_realip_module 
   --with-http_sub_module 
   --with-http_flv_module 
   --with-http_dav_module 
   --with-http_gzip_static_module 
   --with-http_stub_status_module 
   --with-http_addition_module 
   --with-pcre=/data/services/pcre-8.10 
   --with-openssl=/data/services/openssl-1.0.0a 
   --with-http_ssl_module 
   --with-zlib=/data/services/zlib-1.2.5  
```

[nginxcom]: http://nginx.org "官网"
[nginxdown]: http://nginx.org/en/download.html "下载地址"
[nginx-v]: http://nginx.org/download/nginx-0.8.53.tar.gz "0.8.53"


#安装方法二:下载后在安装

一般编译nginx时，都要先安装pcre、zlib等外部支持程序，然后编译安装nginx时指定这些外部支持程序的位置，这样nginx在每次启动的时候，就会去动态加载这些东西了。

下面介绍的是另一种方式，即将这些程序编译到nginx里面去，这样nginx启动时就不会采用动态加载的方式去load。从古谱中可获知，这种方式会比动态加载有更高的效率。

需要下载的东西：
```
   1. wget http://www.openssl.org/source/openssl-0.9.8l.tar.gz
   2. wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.00.tar.bz2
   3. wget http://www.zlib.net/zlib-1.2.3.tar.bz2
   4. wget http://nginx.org/download/nginx-0.8.30.tar.gz
```
把这些玩意都解压缩后，就会有：
```
   1. openssl-1.0.0a
   2. pcre-8.20
   3. zlib-1.2.5
   4. nginx-0.8.30
```
这几个目录，我把它们都放在/data/download/里，按原先的方式，需要进openssl、pcre、zlib目录里去编译安装它们，现在不用了，直接进nginx目录。
```
   cd nginx-0.8.20
   ./configure 
         --prefix=/data/nginx 
         --with-http_realip_module 
         --with-http_sub_module 
         --with-http_flv_module 
         --with-http_dav_module 
         --with-http_gzip_static_module 
         --with-http_stub_status_module 
         --with-http_addition_module 
         --with-pcre=/data/download/pcre-8.2。0 
         --with-openssl=/data/download/openssl-1.0.0a 
         --with-http_ssl_module 
         --with-zlib=/data/download/zlib-1.2.5
   make
   make install
```


