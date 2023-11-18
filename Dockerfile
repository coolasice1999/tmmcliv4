FROM debian:stable-slim
# Define software versions.
ARG TMM_VERSION=4.3.14
# Define software download URLs.
ARG TMM_URL=https://release.tinymediamanager.org/v4/dist/tmm_${TMM_VERSION}_linux-amd64.tar.gz
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jre/bin:$PATH

# Define working directory.
WORKDIR /tmp

#set timezone 
# RUN apt-install -y nocache tzdata
ENV TZ America/New_York

#add helper packages
COPY helpers/* /usr/local/bin/
COPY ./entrypoint.sh /mnt/entrypoint.sh

RUN chmod +x /usr/local/bin/add-pkg && chmod +x /usr/local/bin/del-pkg && chmod +x /mnt/entrypoint.sh

# Download TinyMediaManager
RUN \
    apt update && \
    apt-get install -y wget && \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.gz

# Install dependencies.
RUN \
    apt-get update \
    && apt install -y \
        libmediainfo0v5 \
        bash \
        tar \
        zenity \
        zstd \
        gettext \
        cron && \
    rm -rf /var/lib/apt/lists/*

# Fix Java Segmentation Fault
# RUN mkdir -p /tmp/libz \
  #  && wget "https://www.archlinux.org/packages/core/x86_64/zlib/download" -O /tmp/libz/libz.tar.zst \
   # && unzstd -v /tmp/libz/libz.tar.zst \
    #&& tar -xvf /tmp/libz/libz.tar -C /tmp/libz \
    #&& cp -v /tmp/libz/usr/lib/libz.so.1.3 /usr/glibc-compat/lib \
    #&& /usr/glibc-compat/sbin/ldconfig \
    #&& rm -rfv /tmp/libz
# Add files.
COPY rootfs/ /

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]


ENTRYPOINT ["/mnt/entrypoint.sh"]
CMD ["/usr/sbin/crond", "-f", "-d", "0"] 

# Metadata.
LABEL \
      org.label-schema.name="tinymediamanagerCMD" \
      org.label-schema.description="Docker container for TinyMediaManager Command line cron scheduled" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/coolasice1999/tmmcliv4" \
      org.label-schema.schema-version="1.0"
