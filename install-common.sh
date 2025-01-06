#!/bin/bash
cat << 'EOF' >> /etc/bashrc 
export LC_ALL=C.UTF-8
EOF

# EPEL 리포지토리 활성화
dnf install -y oracle-epel-release-el9

# 유틸리티 패키지 설치
dnf install -y tree which git unzip tar wget net-tools nmap-ncat sshpass hostname tmux


# Python3.12 설치
dnf install python3.12-requests
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip


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

dnf install -y java-17-openjdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.13.0.11-4.0.1.el9.x86_64
echo 'export JAVA_HOME=export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.13.0.11-4.0.1.el9.aarch64' >> /etc/bashrc 
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/bashrc
source /etc/bashrc



# ln -sf /bin/bash /bin/sh
