_list:
    just -l

install-deps-ubuntu:
    # hash pandoc 2>/dev/null || sudo apt install -y pandoc
    # hash latex xetex 2>/dev/null || sudo apt install -y texlive-xetex texlive-latex-recommended
    cargo install --locked \
        mdbook@0.4.42 \
        mdbook-katex@0.9.1 \
        mdbook-pandoc@0.7.3 \
        mdbook-pdf@0.1.10 \
        mdbook-image-size@0.2.1 \
        mdbook-toc@0.14.2 \
        mdbook-admonish@1.18.0

build:
    mdbook build

watch:
    mdbook watch -o
