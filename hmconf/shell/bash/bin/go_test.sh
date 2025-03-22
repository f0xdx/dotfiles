#!/usr/bin/env bash
#
# go_test.sh [ARGS]
#
# This script will run your `go test` test command as usual and pipe its output
# through some sed foo that adds nicer colors

set -euo pipefail

export COLOR=on

# usage yields the usage string of this script
usage() {
    cat <<EOF

Usage:
    go_test.sh [-w DIRECTORY ] [TEST ARGS]

Options:
    -h            print usage information
    -w DIRECTORY  watch the given directory for changes; this requires 'fswatch'
                  on your system

Arguments:
    TEST ARGS     your normal test arguments for 'go test', e.g., instead of
                  'go test -tags foo ./...', you would simply use
                  'go_test.sh -tags foo ./...'

                  please run 'go help test' for more information on arguments

EOF
}

# err prints the provided message to stderr. Use as
#
#   err error_message [ details ]

# Args
#   error_message   the main error message
#   context
common::err() {
    if [[ -n "${COLOR:-}" ]]; then
        >&2 printf "\u001b[31;1mERROR\u001b[31;0m: \u001b[31m%s\u001b[0m\n" "$1"
    else
        >&2 printf "ERROR: %s\n" "$1"
    fi

    shift
    >&2 echo "$@"
}

# check_dependencies checks whether the required external dependencies are
# installed on your system
#
#   check_dependencies dependency1 [ ... ]
#
# Args
#   dependency  list of dependencies to check
common::check_dependencies() {
    for command_name in "$@"; do
      [[ -z "$(command -v "${command_name}")" ]] && { common::err "${command_name} could not be found, please install it" "$(usage)"; exit 1; }
    done

    true # set -e hack
}


# (0) process pre-conditions

# basic dependencies (fswatch is only needed if you want to use -w)
dependencies=(
    'go'
)
common::check_dependencies "${dependencies[@]}"

# normally you would use while+getopts, but here we want to pass unknown
# options to go test, so we have to handroll it

[[ "${1:-}" == '-h' ]] && { usage; exit 0; }

if [[ "${1:-}" == '-d' ]]; then
  common::check_dependencies 'fswatch'
  [[ -n "${2:-}" && -a "$2" && -d "$2" ]] || { common::err "invalid watch directory: ${2}" "$(usage)"; exit 1; }

  watch_dir="$2"
  shift 2
fi

args=( 'test' "$@" )

# if done without eval:
# go "${args[@]}" \
#   | sed \
#     -e 's/^ok/\x1b[32m\x1b[0m/' \
#     -e 's/^FAIL\(.*\)/\x1b[31m\1\x1b[0m/' \
#     -e 's/^?\(.*\)/\x1b[90m\1\x1b[0m/'

cmd="go ${args[*]} \
  | sed \
    -e 's/^ok/\x1b[32m\x1b[0m/' \
    -e 's/^FAIL\(.*\)/\x1b[31m\1\x1b[0m/' \
    -e 's/^?\(.*\)/\x1b[90m\1\x1b[0m/'"

if [[ -n "${watch_dir:-}" ]]; then
  clear
  set +e; eval "$cmd"; set -e
  fswatch -0 -o -e '.*' -i '.*/*\.go$' "${watch_dir}" \
    | xargs -0 -n1 -I{} bash -c "clear; ${cmd}"

else
  eval "$cmd"
fi
