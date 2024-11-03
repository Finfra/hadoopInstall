#!/bin/bash
if [ ! -f /root/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""
  echo "SSH 키를 생성했습니다."
  rm -f ~/.ssh/known_hosts
  for host in s1 s2 s3; do
    echo "Waiting for SSH on $host..."
    while ! nc -z $host 22; do
      sleep 1
    done
  done
  for host in s1 s2 s3; do
    sshpass -p "password" ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@${host}
  done
else
  echo "SSH 키가 이미 존재합니다. 새로운 키를 생성하지 않습니다."
fi



#sleep infinity
