FROM debian:bullseye-slim

RUN  apt-get update && apt-get -y install bash nvme-cli mdadm && apt-get -y clean && apt-get -y autoremove
COPY eks-nvme-ssd-provisioner.sh /usr/local/bin/

ENTRYPOINT ["bash"]

CMD ["-c", "eks-nvme-ssd-provisioner.sh 1> /dev/null"]
