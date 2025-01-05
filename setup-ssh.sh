#!/bin/bash

# 필요한 패키지 설치
dnf install -y openssh-clients sshpass

# SSH 키 생성 및 배포
if [ ! -f /root/.ssh/id_rsa ]; then
  # SSH 키 생성
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""
  echo "SSH 키를 생성했습니다."
else
  echo "SSH 키가 이미 존재합니다. 새로운 키를 생성하지 않습니다."
fi

# 기존 known_hosts 제거
rm -f ~/.ssh/known_hosts

# 대상 호스트 확인 및 SSH 연결 테스트
for host in s1 s2 s3; do
  echo "Waiting for SSH on $host..."
  while ! nc -z $host 22; do
    sleep 1
  done
done



# SSH 키 복사
for host in s1 s2 s3; do
  sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@${host}
done
# ssh s1 -C 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""'
ssh s1 -C 'sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@s1'
ssh s1 -C 'sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@s2'
ssh s1 -C 'sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@s3'


# i1에서 i1 접근 허용[kafka 설치용]
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
# sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@i1
# ssh -o StrictHostKeyChecking=no i1 hostname
echo '
Host i1
    StrictHostKeyChecking no
' >> /root/.ssh/config

echo "-----------------------------"
touch /tmp/setup-ssh
