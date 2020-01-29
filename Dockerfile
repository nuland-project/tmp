FROM rust:1.40.0-stretch

RUN apt-get update && apt-get -y install ca-certificates cmake musl-tools libssl-dev apache2 apache2-utils software-properties-common && rm -rf /var/lib/apt/lists/*

ENV ROCKSDB_LIB_DIR=/usr/lib/x86_64-linux-gnu
ENV SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libsodium-dev \
        libsnappy-dev \
        librocksdb-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y autoconf automake libtool curl make g++ unzip && \
    mkdir /protoc && \
    cd /protoc && \
    wget https://github.com/google/protobuf/releases/download/v3.4.0/protoc-3.4.0-linux-x86_64.zip && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.zip && \
    unzip protobuf-all-3.6.1.zip && \
    rm -f protobuf-all-3.6.1.zip && \
    cd ./protobuf-3.6.1 && \
    ./configure && \
    make && \
#    make check && \
    make install && \
    ldconfig # refresh shared library cache.

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  C2518248EEA14886

#RUN add-apt-repository ppa:pi-rho/dev
#
#RUN add-apt-repository ppa:exonum/rocksdb

#RUN apt-get install build-essential libsodium-dev libsnappy-dev libssl-dev \
#        librocksdb5.17 pkg-config clang-7 lldb-7 lld-7

#RUN add-apt-repository ppa:maarten-fonville/protobuf
#RUN apt install libprotobuf-dev protobuf-compiler

COPY . .

#RUN cargo install --path /

ENV ROCKSDB_LIB_DIR=/usr/lib/x86_64-linux-gnu
ENV SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/

# External ports
EXPOSE 8088
EXPOSE 80
EXPOSE 8000

RUN echo -lha ls

#CMD ["apache2ctl", "-D", "FOREGROUND"]
#CMD ["/tmp"]
CMD ["/start.sh"]