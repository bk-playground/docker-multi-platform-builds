#!/bin/bash

printf "Checking latest Go version...\n";
LATEST_GO_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
LATEST_GO_DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz"

printf "cd to home (%s) directory \n" $USER
cd $HOME || exit

printf "Downloading %s\n\n" ${LATEST_GO_DOWNLOAD_URL};
curl -OJ -L --progress-bar $LATEST_GO_DOWNLOAD_URL

printf "Extracting file...\n"
tar -xf "${LATEST_GO_VERSION}.linux-amd64.tar.gz"

printf "You are ready to Go!";
$HOME/go/bin/go version