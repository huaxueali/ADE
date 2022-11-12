#!/bin/bash
#-------------------------------------
# 1.先查看自己当前内核版本
# 2.导入elrepo公钥
# 3.安装ELRepo到CentOS
# 4.查看可用内核安装包
# 5.安装长期支持稳定版本
# lt = long time     长期支持内核
# ml=mainline        稳定主线内核
# 查看系统全部内核
# 设置开机从新内核启动
# 重启并检查内核
# 移除旧内核 yum -y remove 3..... 
#-------------------------------------

uname -r

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

rpm -Uvh http://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

if grep -q initrd16 /boot/grub2/grub.cfg;
then yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
fi

yum --enablerepo=elrepo-kernel install -y kernel-lt

rpm -qa |grep kernel

echo " Finally, set grub2: \" grub2-set-default 'CentOS Linux () 7 (Core)' \" "
