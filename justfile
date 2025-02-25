_list:
    just -l

install-deps-ubuntu:
    sudo apt-get update && sudo apt install -y patch binutils pkg-config libssl-dev pandoc texlive-xetex texlive-latex-recommended
    bin/cargo-install-mdbook.sh

mdbook-in-docker *ARGS:
    docker compose run --rm --entrypoint /bin/bash mdbook -c "{{ARGS}}"

update-css:
    @just mdbook-in-docker mdbook-admonish install --css-dir theme .
    @just mdbook-in-docker mdbook-tabs install
    wget -O theme/presentationHider.css "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.css"
    wget -O theme/presentationHider.js  "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.js"

raw-serve:
    mdbook serve

build:
    UID=$(id -u) GID=$(id -g) docker compose run mdbook build

serve:
    UID=$(id -u) GID=$(id -g) docker compose up --no-attach kroki --no-attach kroki-cache

services:
    UID=$(id -u) GID=$(id -g) docker compose up -d kroki-cache kroki

down:
    UID=$(id -u) GID=$(id -g) docker compose down

DOCKER_IMAGE := "ghcr.io/mvojacek/mdbook"

list-tags:
    skopeo list-tags docker://{{DOCKER_IMAGE}}  | jq -r '.Tags[]'

build-docker-full TAG:
    docker build -t {{DOCKER_IMAGE}}:{{TAG}} docker

build-docker-buildah TAG:
    cd docker && buildah unshare ./buildah-build-tools.sh
    cd docker && docker build -t {{DOCKER_IMAGE}}:{{TAG}} -f Dockerfile.buildah .

push-mdbook-docker TAG:
    docker push {{DOCKER_IMAGE}}:{{TAG}}
    [ "{{TAG}}" = "latest" ] || docker tag {{DOCKER_IMAGE}}:{{TAG}} {{DOCKER_IMAGE}}:latest && docker push {{DOCKER_IMAGE}}:latest

pull:
    docker compose pull

test-serve TEST:
    # docker compose run -e "APS_TEST_SEKVENCNI={{TEST}}" -e "APS_TEST_THEME=1" --rm mdbook serve -n 0.0.0.0 -p 3000
    APS_TEST_SEKVENCNI={{TEST}} APS_TEST_THEME=1 MDBOOK_HOST=0.0.0.0 just serve

test-z1: (test-serve "z1")
test-z2: (test-serve "z2")
test-z3: (test-serve "z3")
test-z4: (test-serve "z4")

test-kill:
    docker compose down --remove-orphans -t 0
