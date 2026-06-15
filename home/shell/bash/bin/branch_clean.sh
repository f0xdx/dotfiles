#!/usr/bin/env bash
#
# branch_clean.sh
#
# This script will clean the branches in the current git repository, i.e.,
# attempt to delete all local branches that do not have a remote counterpart.

set -euo pipefail

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

# usage prints script usage information
usage() {
  cat <<EOF
Usage: ${0##*/}

Clean local git branches that no longer exist on the remote repository.
EOF
}

# main cleans the local branches in the current git repository
main() {
  local -r dependencies=(
    'git'
    'cut'
    'grep'
  )
  common::check_dependencies "${dependencies[@]}"

  if [[ ! -d ".git" ]]; then
    common::err "Not in a git repository root directory"
    exit 1
  fi

  local branch
  local -A remotes

  # Read remote branches and store them in an associative array.
  while read -r branch; do
    if [[ -n "${branch}" ]]; then
      remotes["${branch}"]=1
    fi
  done < <( \
    git branch -r \
      | cut -d '/' -f2- \
      | grep -v '^HEAD' \
  )

  # Delete local branches that do not have a remote counterpart.
  while read -r branch; do
    if [[ -n "${branch}" ]] && [[ ! -v "remotes[${branch}]" ]]; then
      git branch -d "${branch}"
    fi
  done < <(git for-each-ref --format='%(refname:short)' refs/heads/)
}

main "$@"
