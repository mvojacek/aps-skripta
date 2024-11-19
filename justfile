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
        mdbook-admonish@1.18.0 \
        mdbook-tabs@0.2.1 \
        mdbook-cmdrun@0.7.1 \
        mdbook-presentation-preprocessor@0.3.1

install-plugins:
    mdbook-admonish install --css-dir theme .
    mdbook-tabs install
    wget -O theme/presentationHider.css "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.css"
    wget -O theme/presentationHider.js "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.js"

build:
    mdbook build

watch:
    mdbook serve -o
