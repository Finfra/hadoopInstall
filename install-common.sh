#!/bin/bash

echo "📌 /etc/bashrc 설정 추가 중..."
cat << 'EOF' >> /etc/bashrc 
export LC_ALL=C.UTF-8
EOF

echo "📌 /root/.bashrc에 /etc/bashrc 로드 설정 추가..."
echo '[ -f /etc/bashrc ] && . /etc/bashrc' >> /root/.bashrc

echo "📌 DNF 업데이트 및 EPEL 리포지토리 설치..."
dnf update -y
dnf install -y oracle-epel-release-el9

echo "📌 기본 유틸리티 패키지 설치..."
dnf install -y tree which git unzip tar wget net-tools nmap-ncat sshpass hostname tmux

echo "📌 Python 3.12 및 관련 패키지 설치..."
dnf install -y python3.12-requests
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip

echo "📌 dnf-utils 설치 및 리포지토리 활성화..."
dnf install -y dnf-utils
dnf config-manager --set-enabled ol9_baseos_latest ol9_appstream

echo "📌 OpenSSH 서버 및 클라이언트 설치..."
dnf install -y openssh-server openssh-clients

echo "📌 SSH 설정 및 root 비밀번호 설정..."
mkdir -p /var/run/sshd
echo 'root:password' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "📌 SSH 호스트 키 생성..."
ssh-keygen -A

echo "📌 개인용 SSH 키 생성 (존재하지 않을 경우)..."
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
fi

echo "📌 SSH 폴더 권한 설정..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo "📌 OpenJDK 1.8 설치 및 JAVA_HOME 설정..."
dnf install -y java-1.8.0-openjdk-devel 
JAVA_EXEC=$(readlink -f $(which java))
JAVA_HOME=$(dirname $(dirname $JAVA_EXEC))
echo "export JAVA_HOME=$JAVA_HOME" >> /etc/bashrc 

echo "📌 /etc/bashrc 적용 중..."
source /etc/bashrc

# 필요 시 /bin/sh를 bash로 변경
# echo "📌 /bin/sh를 /bin/bash로 심볼릭 링크 변경..."
# ln -sf /bin/bash /bin/sh

echo "✅ 모든 작업 완료!"