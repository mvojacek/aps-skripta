#!/bin/bash

set -euo pipefail

PACKAGES_LOCKED=(
    # mdbook@0.4.43
    "https://github.com/mvojacek/mdBook?tag=v0.4.43-1&bin=mdbook"
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
    mdbook-pagetoc@0.2.0
    https://github.com/mvojacek/mdbook-minijinja?tag=v0.2.0-7
)

PACKAGES_NOTLOCKED=(
    mdbook-checklist@0.1.1 # needs deps update
)

function cargo_install() {
    local package="$1" package_full="$1"
    shift 1

    # check if package is a git url
    if [[ $package =~ ^https?://|^git@ ]]; then
        # get tag or branch or commit from url
        # git@github.com/username/repo?tag=version
        # git@github.com/username/repo?branch=branch
        # git@github.com/username/repo#commit
        # for repos with multiple binaries, append &bin=bin
        local commit='' tag='' branch='' bin='' url=''
        if [[ $package =~ \&bin= ]]; then
            bin="${package##*bin=}"
            bin="${bin%%\&*}"
            package="${package%%\&bin=*}"
        fi
        if [[ $package =~ \# ]]; then
            commit="${package##*#}"
            package="${package%%#*}"
        fi
        if [[ $package =~ \?tag= ]]; then
            tag="${package##*tag=}"
            tag="${tag%%\&*}"
        fi
        if [[ $package =~ \?branch= ]]; then
            branch="${package##*branch=}"
            branch="${branch%%\&*}"
        fi
        local url="${package%%\?*}"

        local cargo_install=()
        local installed_pattern=

        if [[ -n $commit ]]; then
            cargo_install+=(--rev "$commit")
            installed_pattern="\\(${url}.*#${commit}\\)"
        elif [[ -n $tag ]]; then
            cargo_install+=(--tag "$tag")
            installed_pattern="\\(${url}\?.*tag=${tag}.*\\)"
        elif [[ -n $branch ]]; then
            cargo_install+=(--branch "$branch")
            installed_pattern="\\(${url}\?.*branch=${branch}.*\\)"
        fi

        # check if installed
        if cargo install --list | grep -qP "$installed_pattern"; then
            echo "[#] Package $package_full already installed"
            return
        fi

        local bins=()
        if [[ -n $bin ]]; then
            bins+=("$bin")
        fi

        # install
        echo "[#] Installing $package"
        cargo install "${cargo_install[@]}" "$@" --git "$url" "${bins[@]}"
        echo "[#] Installed $package"
    else
        # split version from package
        local package_version="${package##*@}"
        local package_name="${package%@*}"

        local installed_pattern=
        if [[ -n $package_version ]]; then
            installed_pattern="^${package_name} v${package_version}"
        else
            installed_pattern="^${package_name} "
        fi

        # check if installed
        if cargo install --list | grep -qP "$installed_pattern"; then
            echo "[#] Package $package_full already installed"
            return
        fi

        # install
        echo "[#] Installing $package"
        cargo install "$@" "$package"
        echo "[#] Installed $package"
    fi
}


for package in "${PACKAGES_LOCKED[@]}"; do
    cargo_install "$package" --locked
done

for package in "${PACKAGES_NOTLOCKED[@]}"; do
    cargo_install "$package"
done

echo "[#] All packages installed"
