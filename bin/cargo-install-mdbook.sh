#!/bin/bash

set -euo pipefail

PACKAGES_LOCKED=(
    mdbook@0.4.42
    mdbook-katex@0.9.1
    mdbook-pandoc@0.7.3
    mdbook-pdf@0.1.10
    mdbook-image-size@0.2.1
    mdbook-toc@0.14.2
    mdbook-admonish@1.18.0
    mdbook-tabs@0.2.1
    mdbook-cmdrun@0.7.1
    mdbook-presentation-preprocessor@0.3.1
    mdbook-quiz@0.3.10
    mdbook-svgbob@0.2.1
    mdbook-open-on-gh@2.4.3
    mdbook-graphviz@0.2.1
    mdbook-kroki-preprocessor@0.2.0
    mdbook-last-changed@0.1.4
    mdbook-emojicodes@0.3.0
    mdbook-embedify@0.2.11
    mdbook-footnote@0.1.1
    mdbook-external-links@0.1.1
)

PACKAGES_NOTLOCKED=(
    mdbook-tera@0.5.1 # lock depends on mdbook 4.15, has rust error
    mdbook-checklist@0.1.1 # dtto
)


for package in "${PACKAGES_LOCKED[@]}"; do
    echo "[#] Installing $package"
    cargo install --locked $package
    echo "[#] Installed $package"
done

for package in "${PACKAGES_NOTLOCKED[@]}"; do
    echo "[#] Installing $package"
    cargo install $package
    echo "[#] Installed $package"
done

