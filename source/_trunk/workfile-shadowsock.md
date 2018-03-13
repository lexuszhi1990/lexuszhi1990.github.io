### First, fetch the GPG public key and then import it to your system with apt-key.
`wget http://shadowsocks.org/debian/1D27208A.gpg`
`sudo apt-key add 1D27208A.gpg`

Now open /etc/apt/sources.list file.

`sudo nano /etc/apt/sources.list`

### Add the following line at the end of the file.

```
#Debian 8

deb http://shadowsocks.org/debian wheezy main

#Ubuntu 14.04
deb http://shadowsocks.org/ubuntu trusty main
```

### Save and close the file. Now update local package index and install shadowsocks-libev.

```
sudo apt-get update;sudo apt-get install shadowsocks-libev
sudo vi /etc/shadowsocks-libev/config.json

{
    "server":"138.68.7.45",
    "server_port":8488,
    "local_port":1080,
    "password":"123454331",
    "timeout":300,
    "method":"aes-256-cfb",
    "workers": 4
}
```

配置如下：

- 服务器：填写你的服务器IP或域名
- 服务器端口号：填写配置文件中的server_port
- 密码：填写配置文件中的password
- 连接超时：填写配置文件中的timeout
- 加密方式：填写配置文件中的method
- 本地端口号：随便填一个大于1024的端口一般都行，如果客户端默认有一个非 0 端口号的话就不需要改变原有设置了


### Save and close the file. Now start the service.

`sudo service shadowsocks-libev start`

sudo cat > /etc/supervisor/conf.d/shadowsocks.conf <<EOF
[program:shadowsocks]
command=service shadowsocks-libev start
autostart=true
autorestart=true
user=nobady
EOF

运行supervisor:
 
```
service supervisor start  
supervisorctl reload  
```


references:
----------
https://www.chedanji.com/ubuntu-shadowsocks/
http://www.jianshu.com/p/65128dd81827