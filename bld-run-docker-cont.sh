#!/bin/bash

export LATEST_BUILDX=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep 'tag_name' | cut -d\" -f4)
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    DOWNLOAD_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    DOWNLOAD_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

