FROM rust:1.82.0-slim-bookworm AS builder

RUN apt-get update && apt-get install -y patch binutils pkg-config libssl-dev

ADD --chmod=755 cargo-install-mdbook.sh /cargo-install-mdbook.sh

RUN /cargo-install-mdbook.sh

RUN strip /usr/local/cargo/bin/mdbook*

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y pandoc texlive-xetex texlive-latex-recommended libssl3

COPY --from=builder --chmod=755 /usr/local/cargo/bin/mdbook* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/mdbook"]
