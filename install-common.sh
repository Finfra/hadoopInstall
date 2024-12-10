#!/bin/bash

# EPEL 리포지토리 활성화
dnf install -y oracle-epel-release-el9

# 유틸리티 패키지 설치
dnf install -y tree which git unzip tar wget net-tools nmap-ncat sshpass hostname


# Python3.12 설치
dnf install python3.12-requests
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip