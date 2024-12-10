FROM nowage/i1s3:oraclelinux9


# 추가 설치 스크립트 복사 및 실행
COPY install-i1.sh /root/install-i1.sh
RUN chmod +x /root/install-i1.sh && /root/install-i1.sh

# SSH 설정 스크립트 복사
COPY setup-ssh.sh /root/setup-ssh.sh
RUN chmod +x /root/setup-ssh.sh

# SSH 설정 및 실행
CMD ["/bin/bash", "-c", "/root/setup-ssh.sh && sleep infinity"]

