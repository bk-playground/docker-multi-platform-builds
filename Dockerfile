FROM ubuntu:22.04 as base

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

# install bazelisk
curl -fLo /tmp/bazelisk.deb https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-${DEBIAN_ARCH}.deb
dpkg -i /tmp/bazelisk.deb
rm -f /tmp/bazelisk.deb

# install buildkite-cli
curl -fLo /tmp/bk.deb https://github.com/buildkite/cli/releases/download/v${BK_CLI_VERSION}/bk_${BK_CLI_VERSION}_linux_${DEBIAN_ARCH}.deb
dpkg -i /tmp/bk.deb
rm -f /tmp/bk.deb

# install aws-cli
curl https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /opt
/opt/aws/install --update -i /usr/local/aws-cli -b /usr/local/bin
rm -rf /tmp/awscliv2.zip /opt/aws
aws --version

# install GCP CLI
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update && apt-get install -y google-cloud-cli
gcloud --version

# install nodejs
git clone https://github.com/tj/n /usr/src/n
pushd /usr/src/n
make install
popd
n lts
rm -rf /usr/src/n /tmp/*
node --version

ln -s /usr/bin/tini /usr/sbin/tini

apt clean all

# Clean up apt cache
rm -rf /var/lib/apt/lists/*
BASH

FROM base