FROM centos

LABEL maintainer="Giuseppe Scrivano <gscrivan@redhat.com>" \
      name="docker-centos" \
      version="0.1" \
      atomic.type="system" \
      architecture="x86_64"

RUN yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    xfsprogs \
    && yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce-18.06.0.ce \
    && mkdir -p /exports/hostfs/etc/docker \
    && yum clean all

ADD init.sh /usr/bin

# system container
COPY service.template tmpfiles.template config.json.template manifest.json /exports/
# Copy /etc/oci-umount.conf over if it exists
RUN (test -e /etc/oci-umount.conf && cp /etc/oci-umount.conf /exports/hostfs/etc) || true
# Copy docker cli to hostfs
RUN mkdir -p /exports/hostfs/usr/local/bin && \
    mv /usr/bin/docker /exports/hostfs/usr/local/bin/docker && \
    chmod +x /exports/hostfs/usr/local/bin/docker

CMD ["/usr/bin/init.sh"]
