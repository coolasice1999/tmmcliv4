FROM frolvlad/alpine-glibc:latest
# Define software versions.
ARG TMM_VERSION=4.3.8.1

# Define software download URLs.
ARG TMM_URL=https://release.tinymediamanager.org/v4/dist/tmm_${TMM_VERSION}_linux-amd64.tar.gz
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jre/bin

# Define working directory.
WORKDIR /tmp

#set timezone 
RUN apk add --no-cache tzdata
ENV TZ America/New_York

#add helper packages
COPY helpers/* /usr/local/bin/
COPY ./entrypoint.sh /mnt/entrypoint.sh

RUN chmod +x /usr/local/bin/add-pkg && chmod +x /usr/local/bin/del-pkg && chmod +x /mnt/entrypoint.sh

# Download TinyMediaManager
RUN \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.gz

# Install dependencies.
RUN \
    add-pkg \
        openjdk8-jre \
        libmediainfo \
        bash \
        tar \
        ttf-dejavu \
        zenity \
        zstd \
        gettext

# Fix Java Segmentation Fault
RUN wget "https://www.archlinux.org/packages/core/x86_64/zlib/download" -O /tmp/libz.tar.zst \
    && mkdir -pv /tmp/libz \
    && tar --use-compress-program=unzstd -xfvC /tmp/libz.tar.zst /tmp/libz \
    && cp -v /tmp/libz/usr/lib/libz.so.1.2.13 /usr/glibc-compat/lib \
    && /usr/glibc-compat/sbin/ldconfig \
    && rm -rfv /tmp/libz /tmp/libz.tar.zst

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
