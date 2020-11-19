FROM ubuntu:latest

WORKDIR /root
# install dependencies
RUN apt update && \
    apt install -y git autoconf automake libtool make gcc rsync libssl-dev
# create directories
RUN mkdir -p src build

WORKDIR src
# copy source tree
COPY . .
# add system user
RUN adduser --system --disabled-password --no-create-home --force-badname \
            --group --home /var/lib/rpki-client \
            --gecos "OpenBSD RPKI validator" _rpki-client
# build sources
RUN ./autogen.sh && \
    ./configure --prefix=/root/build && \
    make
# install
RUN make install
