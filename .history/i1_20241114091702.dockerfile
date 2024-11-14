FROM centos:centos7


COPY install-common.sh /root/install-common.sh
RUN chmod +x /root/install-common.sh
RUN /root/install-common.sh

COPY install-i1.sh /root/install-i1.sh
RUN chmod +x /root/install-i1.sh
RUN /root/install-i1.sh

COPY setup-ssh.sh /root/setup-ssh.sh
RUN chmod +x /root/setup-ssh.sh

CMD ["/bin/bash", "-c", "/root/setup-ssh.sh && sleep infinity"]
