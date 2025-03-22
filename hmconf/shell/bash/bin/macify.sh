#!/usr/bin/env bash
#
# macify.sh
#
# This script will run required steps after a home manager flake update to
# integrate with the host system on macos. It is only relevant to be run on
# mac.

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

set -euo pipefail

export COLOR=on

# (0) process pre-conditions

dependencies=(
    'osascript'
)
common::check_dependencies "${dependencies[@]}"

# (1) link applications

rm -rf /Applications/Alacritty.app
osascript -e "tell application \"Finder\" to make alias file to posix file \"${HOME}/Applications/Home Manager Apps/Alacritty.app\" at POSIX file \"/Applications\" with properties {name:\"Alacritty.app\"}"
