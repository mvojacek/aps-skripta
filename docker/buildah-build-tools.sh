#!/bin/bash

set -euo pipefail
set -x

container=mdbook-tools-builder

# start if necessary
if ! buildah inspect "$container" &>/dev/null; then
    container=$(buildah from --name="$container" docker.io/library/rust:1.82.0-slim-bookworm) || { echo "Failed to start builder!"; exit 1 ; }
fi

function RUN {
    buildah run "$container" /bin/bash -c "$*"
}

RUN "apt-get update && apt-get install -y patch binutils pkg-config libssl-dev"

buildah add --chmod=755 "$container" cargo-install-mdbook.sh /cargo-install-mdbook.sh

RUN /cargo-install-mdbook.sh