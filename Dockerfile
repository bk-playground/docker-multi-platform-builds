FROM ubuntu:22.04

RUN <<BASH
#!/usr/bin/env bash

set -eufo pipefail

export DEBIAN_FRONTEND=noninteractive

export ARCH=x86_64
if [ "$(dpkg --print-architecture)" = "arm64" ]; then export ARCH=aarch64 ; fi

export DEBIAN_ARCH=$(dpkg --print-architecture)

# Install main packages
apt-get update
apt-get install -y --no-install-recommends \
  apt-transport-https \
  bash \
  ca-certificates \
  curl \
  git \
  git-lfs \
  gnupg-agent \
  jq \
  openssh-client \
  perl \
  python3 \
  python3-pip \
  python3-dev \
  python3-crcmod \
  lsb-release \
  rsync \
  software-properties-common \
  tini \
  sudo \
  bash \
  gnupg \
  zip \
  unzip \
  build-essential

git --version
git-lfs --version

ln -s /usr/bin/tini /usr/sbin/tini

apt clean all

# Clean up apt cache
rm -rf /var/lib/apt/lists/*
BASH
