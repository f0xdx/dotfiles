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

# shellcheck disable=SC2012 # ls supports order by modified timestamp
nvim_socket="$(ls -t "${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}"/*/nvim.*.0 | head -1)"

# TODO handle the case where there is no running nvim instance
args=( 
  '--server' "${nvim_socket}"
  '--remote'
  "$@"
)

nvim "${args[@]}"
