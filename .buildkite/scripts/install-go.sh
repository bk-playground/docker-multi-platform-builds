#!/bin/bash

printf "Checking latest Go version...\n";
LATEST_GO_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
LATEST_GO_DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz"

cd /usr/local || exit

printf "Downloading %s\n\n" ${LATEST_GO_DOWNLOAD_URL};
curl -OJ -L --progress-bar $LATEST_GO_DOWNLOAD_URL

printf "Extracting file...\n"
tar -xf "${LATEST_GO_VERSION}.linux-amd64.tar.gz"

printf "Setting up environment variables...\n"
export PATH="/usr/local/go/bin:$PATH"

printf "You are ready to Go!";
go version
go env