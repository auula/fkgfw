#!bin/bash

#域名变量
domain_str=$1
#密码变量
password=$2

# 判断 domain_str 是否未设置
if [ -z "${domain_str}" ]; then
    echo "domain_str 变量为空或未设置 $1"
fi

# 判断 password 是否未设置
if [ -z "${password}" ]; then
    echo "password 变量为空或未设置 $2"
fi

# 提权
su -

# 开启 BBR
echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf

# 运行 sysctl -p 命令
sysctl -p

# 检查返回结果是否包含 BBR 配置项
if sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"; then
    echo "BBR 已启用"
else
    echo "BBR 未启用"
fi

# 更新升级系统软件包
sudo apt-get upgrade -y

# 获取 wget 获取
sudo apt-get install wget

# 下载软件包
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
# 解压软件
unzip trojan-go-linux-amd64.zip -d /root/tarjan-server
# 复制配置文件
mkdir -p /usr/share/trojan-go
# 复制文件
cd /root/tarjan-server
cp geoip.dat /usr/share/trojan-go
cp geosite.dat /usr/share/trojan-go

# 安装教程
sudo apt-get install -y nginx
# 设置开启启动
systemctl enable nginx
# 清理默认的文件
rm -rf /var/www/html
# 重启服务器
systemctl restart nginx

# 获取 curl 软件包
sudo apt-get install -y curl

# 需要邮箱地址
curl https://get.acme.sh | sh -s email=coding1618@gmail.com
# 起一个别名方便使用
alias acme.sh=~/.acme.sh/acme.sh
# 设置别名
ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
# 更换签发机构
acme.sh --set-default-ca --server letsencrypt
# 申请 ssl 证书
acme.sh --issue -d ${domain_str} -w /var/www/html

# 获取脚本
wget git.io/warp.sh
# 添加执行权限
chmod +x warp.sh
