#!/usr/bin/env bash
#
# update.sh
#
# This script will update the current system setup (tooling, dotfiles, plugins
# etc.).

set -euo pipefail

function nvm::update() {
  local -r current_version=$(nvm current)
  local -r next_version=$(nvm version-remote --lts)
  if [ "$current_version" != "$next_version" ]; then
    local -r previous_version=$current_version
    nvm install --lts
    nvm reinstall-packages "$previous_version"
    nvm uninstall "$previous_version"
    nvm cache clear
  fi
}

echo "hello world"
exit 0
