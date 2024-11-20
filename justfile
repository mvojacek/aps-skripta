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
    mdbook build

watch:
    mdbook serve -o

DOCKER_IMAGE := "ghcr.io/mvojacek/mdbook"

build-mdbook-docker TAG="latest":
    # build
    docker build -t {{DOCKER_IMAGE}}:{{TAG}} bin
    # push
    docker push {{DOCKER_IMAGE}}:{{TAG}}
    # update latest
    [[ "{{TAG}}" == "latest" ]] || docker tag {{DOCKER_IMAGE}}:{{TAG}} {{DOCKER_IMAGE}}:latest && docker push {{DOCKER_IMAGE}}:latest
