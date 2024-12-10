#!/bin/bash

# 리포지토리 업데이트 및 기본 설정
dnf install -y dnf-utils
dnf config-manager --set-enabled ol9_baseos_latest ol9_appstream

# OpenSSH 설치 및 설정
dnf install -y openssh-server openssh-clients

# SSH 설정 및 root 비밀번호 설정
mkdir -p /var/run/sshd
echo 'root:password' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# SSH 호스트 키 생성
ssh-keygen -A

# 개인 SSH 키 생성
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
fi

# 권한 설정
mkdir -p /root/.ssh
chmod 700 /root/.ssh


# OpenJDK Development Kit 설치 (javac, jps 포함)
dnf install -y java-1.8.0-openjdk-devel 
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk 
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> /etc/profile 
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile 
source /etc/profile
