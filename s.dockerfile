FROM nowage/i1s3:oraclelinux9

# 추가 설치 스크립트 복사 및 실행
COPY install-s.sh /root/install-s.sh
RUN chmod +x /root/install-s.sh && /root/install-s.sh

# 포트 22 노출
EXPOSE 22

# SSHD 실행
CMD ["/usr/sbin/sshd", "-D"]

# # SSHD 실행
# CMD ssh-keygen -A && [ -f /etc/ssh/ssh_host_rsa_key ] && [ -f /etc/ssh/ssh_host_ecdsa_key ] && [ -f /etc/ssh/ssh_host_ed25519_key ] && /usr/sbin/sshd -D || (echo "Host keys not found!" && exit 1)
