#!/bin/bash
################ 一键安装人人影视 ##################"
#防火墙放行端口
#安装人人影视函数
function install_rr(){
	while :; do
		echo -e "请输入人人影视端口 ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(默认端口: 3001):")" port
		[[ -z "$port" ]] && port="3001"
		case $port in
			[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
		echo
		echo -e "设定端口 = $port"
		echo "----------------------------------------------------------------"
			break
			;;
			*)
			error
			;;
		esac
	done
cd /home/
wget http://113.132.128.134:3054/rrshareweb_centos7.tar.gz
#解压
tar -zxvf rrshareweb_centos7.tar.gz
rm -rf rrshareweb_centos7.tar.gz
#修改默认端口
cat > /home/rrshareweb/conf/rrshare.json <<EOF
      {
      "port" : $port,
      "logpath" : "",
      "logqueit" : false,
      "loglevel" : 1,
      "logpersistday" : 2,
      "defaultsavepath" : "/home"
      }
EOF
#设定后台运行及开机自启
if [[ -f /home/rrshareweb/rrshareweb ]]; then
cat >/etc/systemd/system/rr.service <<-EOF
[Unit]
Description=rr

[Service]
WorkingDirectory=/home/rrshareweb/
ExecStart=/home/rrshareweb/rrshareweb
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl enable rr
systemctl start rr

else
echo -e "\n$red 安装出错啦...$none\n" && exit 1
fi

#获取IP
osip=$(curl https://api.ip.sb/ip)
echo "------------------------------------------------------"
echo
echo "恭喜，安装完成。请访问：http://${osip}:$port$none"
echo
echo "点击设置，修改下载目录，登陆账号开始当矿工吧"
echo
echo "阿里云请开启入站相应端口"
echo "------------------------------------------------------"
}
echo "##########欢迎使用人人影视web一键安装脚本##########"
echo "1.安装人人影视linux"
echo "2.卸载人人影视linux"
echo "3.退出"
declare -i stype
read -p "请输入选项:（1.2.3）:" stype
if [ "$stype" == 1 ]
then
#检查目录是否存在
if [ -e "/home/rrshareweb" ]
then
echo "目录存在，请检查是否已经安装。"
exit
else
#执行安装函数
install_rr
fi
	elif [ "$stype" == 2 ]
		then
			systemctl disable rr
		systemctl stop rr
			rm -rf /home/rrshareweb
			rm -rf /etc/systemd/system/rr.service 
			echo '卸载完成.'
			exit
	elif [ "$stype" == 3 ]
		then
			exit
	else
		echo "参数错误！"
	fi	
