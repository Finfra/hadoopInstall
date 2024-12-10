FROM oraclelinux:9
# 공통 설치 스크립트 복사 및 실행
COPY install-common.sh /root/install-common.sh
RUN chmod +x /root/install-common.sh && /root/install-common.sh
