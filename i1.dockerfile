FROM centos:centos7

# 대체 리포지토리 설정 (Vault 사용)
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo &&     sed -i 's|^#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/7.9.2009|g' /etc/yum.repos.d/CentOS-Base.repo
## ok!!
RUN /usr/bin/echo '[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
#baseurl=http://vault.centos.org/7.9.2009/updates/x86_64/epel/
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch/debug
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
baseurl=http://download.fedoraproject.org/pub/epel/7/SRPMS
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1'> /etc/yum.repos.d/epel.repo



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
