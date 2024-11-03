FROM centos:centos7

# 대체 리포지토리 설정 (Vault 사용)
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=http://vault.centos.org/7.9.2009|g' /etc/yum.repos.d/CentOS-Base.repo

# OpenSSH 설치
RUN yum clean all && yum makecache fast && yum install -y openssh-server && \
    mkdir -p /var/run/sshd && echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# SSH 호스트 키 수동 생성
RUN ssh-keygen -A

COPY install-common.sh /root/install-common.sh
RUN chmod +x /root/install-common.sh
RUN /root/install-common.sh

# 포트 22 노출
EXPOSE 22

# SSHD 실행 전 호스트 키 확인 및 SSHD 실행
CMD ssh-keygen -A && [ -f /etc/ssh/ssh_host_rsa_key ] && [ -f /etc/ssh/ssh_host_ecdsa_key ] && [ -f /etc/ssh/ssh_host_ed25519_key ] && /usr/sbin/sshd -D || (echo "Host keys not found!" && exit 1)
