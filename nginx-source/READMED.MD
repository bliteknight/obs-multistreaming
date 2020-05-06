Nginx 64bit - https://amefs.net/en/archives/1935.html

compile environment:
  MSYS environment (or MSYS2)
  Microsoft Visual Studio, usually requires version 2008 and above, I will use 2017 here.
  Perl environment - Strawberry Perl 32/64 bit.
  Mercurial and Git
  nasm, ASM optimize package
  
download PCRE，zlib and OpenSSL, and uncompress them(following code should be run in MSYS terminal):
  mkdir -p objs/lib
  cd objs/lib
  tar -xzf ../../pcre-8.42.tar.gz
  tar -xzf ../../zlib-1.2.11.tar.gz
  tar -xzf ../../openssl-1.0.2q.tar.gz


Edit configuration for openssl (when you need to compile 64bit executable):
  auto\lib\openssl\makefile.msvc
    
  all:
      cd $(OPENSSL)
    
      perl Configure VC-WIN64A no-shared                  \
          --prefix="%cd%/openssl"                         \
          --openssldir="%cd%/openssl/ssl"                 \
          $(OPENSSL_OPT)
    
      if exist ms\do_win64a.bat (                         \
          ms\do_win64a                                    \
          && $(MAKE) -f ms\nt.mak                         \
          && $(MAKE) -f ms\nt.mak install                 \
      ) else (                                            \
          $(MAKE)                                         \
          && $(MAKE) install_sw                           \
      )

Change warning level:
  nginx\auto\cc\msvc
  
  CFLAGS="$CFLAGS -W3"  

#OPTIONAL:
add msvc linker version:
you will see a warning if you don’t add this parameter auto/cc/msvc: line 117
this will not affect the compile (about line 17)

  NGX_MSVC_VER=19.12 # MSVC 2017 (15.5.7)  cl 19.12 
  
  echo " + cl version: $NGX_MSVC_VER"
  
  
delete edit of manpage:
  the Windows CMD or powershell don’t have a sed command, it may cause a error, nginx\objs\Makefile (about line 1762):
  manpage:    objs/nginx.8
  
  objs/nginx.8:   docs/man/nginx.8 objs/ngx_auto_config.h
    #sed -e "s|%%PREFIX%%||" \
        #-e "s|%%PID_PATH%%|/logs/nginx.pid|" \
        #-e "s|%%CONF_PATH%%|/conf/nginx.conf|" \
        #-e "s|%%ERROR_LOG_PATH%%|/logs/error.log|" \
        #< docs/man/nginx.8 > $@ 
        
## COMPILE        
run config with MSYS, the configuration is the same as Nginx official website:
auto/configure \
--with-cc=cl \
--builddir=build \
--with-debug \
--prefix= \
--conf-path=conf/nginx.conf \
--pid-path=logs/nginx.pid \
--http-log-path=logs/access.log \
--error-log-path=logs/error.log \
--sbin-path=nginx.exe \
--http-client-body-temp-path=temp/client_body_temp \
--http-proxy-temp-path=temp/proxy_temp \
--http-fastcgi-temp-path=temp/fastcgi_temp \
--http-scgi-temp-path=temp/scgi_temp \
--http-uwsgi-temp-path=temp/uwsgi_temp \
--with-cc-opt=-DFD_SETSIZE=1024 \
--with-pcre=objs/lib/pcre-8.44 \
--with-zlib=objs/lib/zlib-1.2.11 \
--with-openssl=objs/lib/openssl-1.1.1g \
--with-select_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_stub_status_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-mail \
--with-stream \
--with-http_ssl_module \
--with-mail_ssl_module \
--with-stream_ssl_module \
--add-module=objs/lib/nginx-rtmp-module
