#!/usr/bin/env bash
#
# nvim.sh [ARGS]
#
# This script will open any provided file in the last nvim instance you had
# started on your system.

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

set -euo pipefail

export COLOR=on

# usage yields the usage string of this script
usage() {
    cat <<EOF

Usage:
    nvim.sh [ARGS]

Arguments:
    ARGS    your normal nvim args, e.g., a list of files to open

EOF
}

# (0) process pre-conditions

dependencies=(
    'nvim'
)
common::check_dependencies "${dependencies[@]}"

#nvim --server '/tmp/nvim.socket' --remote $(fd -tf -L | fzy)

args=()


if ls -t "${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}"/*/nvim.*.0 &> /dev/null; then
  # guard against empty args when no instance is running: nothing to do here,
  # since the whole purpose of this script is to open a file in a running nvim
  # instance
  [[ $# -eq 0 ]] && exit 0 


  # shellcheck disable=SC2012 # ls supports order by modified timestamp
  nvim_socket="$(ls -t "${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}"/*/nvim.*.0 | head -1)"

  args+=(
    '--server' "${nvim_socket}"
    '--remote'
  )
fi

args+=( 
  "$@"
)

nvim "${args[@]}"
