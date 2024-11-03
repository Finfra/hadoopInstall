FROM centos:centos7

# 대체 리포지토리 설정 (Vault 사용)
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo &&     sed -i 's|^#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/7.9.2009|g' /etc/yum.repos.d/CentOS-Base.repo

RUN yum clean all && yum makecache fast &&     yum install -y openssh-clients sshpass nmap-ncat

COPY install-common.sh /root/install-common.sh
RUN chmod +x /root/install-common.sh
RUN /root/install-common.sh

COPY install-i1.sh /root/install-i1.sh
RUN chmod +x /root/install-i1.sh
RUN /root/install-i1.sh

COPY setup-ssh.sh /root/setup-ssh.sh
RUN chmod +x /root/setup-ssh.sh

CMD ["/bin/bash", "-c", "/root/setup-ssh.sh && sleep infinity"]
