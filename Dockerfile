FROM ubuntu:20.04

# non-interactive build
ENV DEBIAN_FRONTEND=noninteractive

# riscv isa bit width
ARG BITS=64

# version
ARG RV64_VERSION=2021.12.22
ARG QEMU_VERSION=6.2.0

# static link
ARG RV64_REPO_URL=https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download

# apt's mirror domain
ARG APT_MIRROR_DOMAIN=mirrors.tuna.tsinghua.edu.cn


RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i s@/archive.ubuntu.com/@/$APT_MIRROR_DOMAIN/@g /etc/apt/sources.list && \
    apt -y update && \
    apt -y upgrade && \
    apt install -y flex bison bc python3 wget make gcc vim git ninja-build libglib2.0-dev libpixman-1-dev pkg-config &&\
    wget $RV64_REPO_URL/$RV64_VERSION/riscv$BITS-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    wget $RV64_REPO_URL/$RV64_VERSION/riscv$BITS-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    tar -zxvf riscv$BITS-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    mv riscv riscv-elf && \
    tar -zxvf riscv$BITS-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    mv riscv riscv-glibc && \
    echo "export PATH=/riscv-glibc/bin:/riscv-elf/bin:$PATH" >> ~/.bashrc && \
    rm -rf riscv$BITS-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    rm -rf riscv$BITS-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    wget https://download.qemu.org/qemu-$QEMU_VERSION.tar.xz && \
    tar xvJf qemu-$QEMU_VERSION.tar.xz && \
    cd qemu-$QEMU_VERSION && \
    ./configure --target-list=riscv$BITS-softmmu && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf qemu-$QEMU_VERSION qemu-$QEMU_VERSION.tar.xz
