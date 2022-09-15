FROM ubuntu:22.04

# non-interactive build
ENV DEBIAN_FRONTEND=noninteractive

# riscv isa bit width
ARG BITS=64

# version
ARG QEMU_VERSION=7.1.0

# apt's mirror domain
ARG APT_MIRROR_DOMAIN=mirrors.tuna.tsinghua.edu.cn


RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i s@/archive.ubuntu.com/@/$APT_MIRROR_DOMAIN/@g /etc/apt/sources.list && \
    apt -y update && \
    apt -y upgrade && \
    apt install -y autoconf automake autotools-dev libmpc-dev libmpfr-dev libgmp-dev gawk build-essential texinfo patchutils zlib1g-dev libexpat-dev && \
    apt install -y flex bison bc python3 curl wget make gcc vim git ninja-build libglib2.0-dev libpixman-1-dev pkg-config gperf libtool && \
    git clone https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain && \
    ./configure --prefix=/riscv && make -j$(nproc) && make linux -j$(nproc) && \
    echo "export PATH=/riscv/bin:$PATH" >> ~/.bashrc && \
    cd .. && rm -rf riscv-gnu-toolchain && \
    wget https://download.qemu.org/qemu-$QEMU_VERSION.tar.xz && \
    tar xJf qemu-$QEMU_VERSION.tar.xz && \
    cd qemu-$QEMU_VERSION && \
    ./configure --target-list=riscv$BITS-softmmu && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf qemu-$QEMU_VERSION qemu-$QEMU_VERSION.tar.xz
