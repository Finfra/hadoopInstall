FROM oraclelinux:9

#COPY lotte.net.crt /etc/pki/ca-trust/source/anchors/lotte.net.crt
#RUN update-ca-trust enable
#RUN update-ca-trust extract


# 공통 설치 스크립트 복사 및 실행
COPY install-common.sh /root/install-common.sh
RUN chmod +x /root/install-common.sh && /root/install-common.sh
