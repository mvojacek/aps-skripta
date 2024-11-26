_list:
    just -l

install-deps-ubuntu:
    sudo apt-get update && sudo apt install -y patch binutils pkg-config libssl-dev pandoc texlive-xetex texlive-latex-recommended
    bin/cargo-install-mdbook.sh

update-css:
    mdbook-admonish install --css-dir theme .
    mdbook-tabs install
    wget -O theme/presentationHider.css "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.css"
    wget -O theme/presentationHider.js "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.js"

build:
    UID=$(id -u) GID=$(id -g) docker compose run mdbook build

serve:
    UID=$(id -u) GID=$(id -g) docker compose up

DOCKER_IMAGE := "ghcr.io/mvojacek/mdbook"

build-mdbook-docker TAG:
    # build
    docker build -t {{DOCKER_IMAGE}}:{{TAG}} docker
    # push
    docker push {{DOCKER_IMAGE}}:{{TAG}}
    # update latest
    [ "{{TAG}}" = "latest" ] || docker tag {{DOCKER_IMAGE}}:{{TAG}} {{DOCKER_IMAGE}}:latest && docker push {{DOCKER_IMAGE}}:latest
