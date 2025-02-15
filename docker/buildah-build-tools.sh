#!/bin/bash

set -euo pipefail
set -x

if ! hash buildah rsync &>/dev/null; then
    echo "Missing required commands"
    exit 1
fi

container=mdbook-tools-builder
cargo_state=cargo
rsync_flags=(-a --delete --exclude git --exclude registry)

# start if necessary
if ! buildah inspect "$container" &>/dev/null; then
    container=$(buildah from --name="$container" docker.io/library/rust:1.82.0-slim-bookworm) || { echo "Failed to start builder!"; exit 1 ; }
fi

function RUN {
    buildah run "$container" /bin/bash -c "$*"
}

mnt=$(buildah mount "$container")

# copy cargo state into container if it exists
if [ -d "$cargo_state" ]; then
    rsync "${rsync_flags[@]}" "$cargo_state/" "$mnt/usr/local/cargo/"
fi

RUN "apt-get update && apt-get install -y patch binutils pkg-config libssl-dev"

buildah add --chmod=755 "$container" cargo-install-mdbook.sh /cargo-install-mdbook.sh

RUN "/cargo-install-mdbook.sh"

RUN "strip /usr/local/cargo/bin/mdbook*"

mkdir -p "$cargo_state"
rsync "${rsync_flags[@]}" "$mnt/usr/local/cargo/" "$cargo_state/"
