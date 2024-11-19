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
        mdbook-presentation-preprocessor@0.3.1 \
        mdbook-quiz@0.3.10 \
        mdbook-svgbob@0.2.1 \
        mdbook-open-on-gh@2.4.3 \
        mdbook-graphviz@0.2.1 \
        mdbook-kroki-preprocessor@0.2.0 \
        mdbook-tera@0.5.1 \
        mdbook-last-changed@0.1.4 \
        mdbook-emojicodes@0.3.0 \
        mdbook-embedify@0.2.11 \
        mdbook-footnote@0.1.1 \
        mdbook-external-links@0.1.1 \
        mdbook-checklist@0.1.1

install-plugins:
    mdbook-admonish install --css-dir theme .
    mdbook-tabs install
    wget -O theme/presentationHider.css "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.css"
    wget -O theme/presentationHider.js "https://raw.githubusercontent.com/FreeMasen/mdbook-presentation-preprocessor/refs/heads/main/src/presentationHider.js"

build:
    mdbook build

watch:
    mdbook serve -o
