#!/usr/bin/env zsh
# Script for helping with bumps and upgrades

set -euo pipefail

to_upgrade=$1

EMACS_OVERLAY="https://github.com/nix-community/emacs-overlay"

upgrade_emacs_overlay() {
    rev=$(git ls-remote "$EMACS_OVERLAY" refs/heads/master | awk '{print $1}')
    hash=$(nix-prefetch-url --unpack "$EMACS_OVERLAY/archive/$rev.tar.gz")
    echo "Updating emacs-overlay.nix to $rev and $hash"
    sed -i "s|^  rev = .*|  rev = \"$rev\";  # updated $(date -I)|"           ~/git/graham33/nur-packages/overlays/10-emacs.nix
    sed -i "s|^  sha256 = .*|  sha256 = \"$hash\";|"    ~/git/graham33/nur-packages/overlays/10-emacs.nix
}

upgrade_homeassistant_stubs() {
    homeassistant_version=$(nix eval -I 'nixpkgs=channel:nixos-unstable' "nixpkgs.home-assistant.version" | sed -e 's/"//g')
    echo "Version: $homeassistant_version"
    sha256=$(nix-prefetch-git --quiet https://github.com/KapJI/homeassistant-stubs $homeassistant_version | jq .sha256)
    echo "sha256: $sha256"
    sed -i pkgs/homeassistant-stubs/default.nix -e "s/version = \"[0-9\.]+\"/version = \"$homeassistant_version\"/"
    sed -i pkgs/homeassistant-stubs/default.nix -e "s/sha256 = \"[^\"\"]+\"/sha256 = $sha256/"
}

if [ -z "$to_upgrade" ]; then
    upgrade_emacs_overlay
    upgrade_homeassistant_stubs
else
    upgrade_$to_upgrade
fi
