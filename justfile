_list:
    just -l

install-deps-ubuntu:
    sudo apt-get update && sudo apt install -y patch binutils pkg-config libssl-dev pandoc texlive-xetex texlive-latex-recommended
    bin/cargo-install-mdbook.sh

update-css:
    mdbook-admonish install --css-dir theme .
    mdbook-tabs install
    wget -O theme/presentationHider.css "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.css"
    wget -O theme/presentationHider.js  "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.js"

raw-serve:
    mdbook serve

build:
    UID=$(id -u) GID=$(id -g) docker compose run mdbook build

serve:
    UID=$(id -u) GID=$(id -g) docker compose up

services:
    UID=$(id -u) GID=$(id -g) docker compose up -d kroki-cache kroki

down:
    UID=$(id -u) GID=$(id -g) docker compose down

DOCKER_IMAGE := "ghcr.io/mvojacek/mdbook"

list-tags:
    skopeo list-tags docker://{{DOCKER_IMAGE}}  | jq -r '.Tags[]'

build-mdbook-docker TAG:
    # build
    docker build -t {{DOCKER_IMAGE}}:{{TAG}} docker
    # push
    docker push {{DOCKER_IMAGE}}:{{TAG}}
    # update latest
    [ "{{TAG}}" = "latest" ] || docker tag {{DOCKER_IMAGE}}:{{TAG}} {{DOCKER_IMAGE}}:latest && docker push {{DOCKER_IMAGE}}:latest
