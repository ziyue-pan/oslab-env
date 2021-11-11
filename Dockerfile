FROM ubuntu:20.04

# non-interactive build
ENV DEBIAN_FRONTEND=noninteractive

# version
ARG RV64_VERSION=2021.09.21
ARG QEMU_VERSION=6.1.0

# static link
ARG RV64_REPO_URL=https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download

# apt's mirror domain
ARG APT_MIRROR_DOMAIN=mirrors.zju.edu.cn


RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i s@/archive.ubuntu.com/@/$APT_MIRROR_DOMAIN/@g /etc/apt/sources.list && \
    apt -y update && \
    apt -y upgrade && \
    apt install -y flex bison bc python3 wget make gcc vim git ninja-build libglib2.0-dev libpixman-1-dev pkg-config &&\
    wget $RV64_REPO_URL/$RV64_VERSION/riscv64-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    wget $RV64_REPO_URL/$RV64_VERSION/riscv64-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    tar -zxvf riscv64-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    mv riscv riscv-elf && \
    tar -zxvf riscv64-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    mv riscv riscv-glibc && \
    echo "export PATH=/riscv-glibc/bin:/riscv-elf/bin:$PATH" >> ~/.bashrc && \
    rm -rf riscv64-elf-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz && \
    wget https://download.qemu.org/qemu-$QEMU_VERSION.tar.xz && \
    tar xvJf qemu-$QEMU_VERSION.tar.xz && \
    cd qemu-$QEMU_VERSION && \
    ./configure --target-list=riscv64-softmmu && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf qemu-$QEMU_VERSION qemu-$QEMU_VERSION.tar.xz && \
    rm -rf riscv64-glibc-ubuntu-20.04-nightly-$RV64_VERSION-nightly.tar.gz
