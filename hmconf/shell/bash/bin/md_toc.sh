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


# basic dependencies 
dependencies=(
    'sed'
    'rg'
)
common::check_dependencies "${dependencies[@]}"

[[ "$(uname -a)" == Darwin* ]] && common::check_dependencies 'gsed' # required for mac

# normally you would use while+getopts, but here we want to pass unknown
# options to go test, so we have to handroll it

[[ "${1:-}" == '-h' ]] && { usage; exit 0; }

# inspired by https://ahwhattheheck.wordpress.com/2019/02/08/how-to-create-a-table-of-contents-in-a-github-markdown-formatted-file-with-sed/
sed_expr=(
  'h;'
  's/[()/:!]//g;'
  's/^#\+\s\+\(.*$\)/(#\L\1)/;'
  's/\s/-/g;'
  's/\.//g;'
  'G;'
  's/\(([^)]\+)\)\n\(\#\+\)\s\+\(.*$\)/\2 [\3]\1/;'
  's/# /asdyxc /;'
  's/(#/(qweasd/;'
  's/#/   /g;'
  's/asdyxc/1\./;'
  's/qweasd/#/;'
  's/^   //'
)

if [[ "$(uname -a)" == Darwin* ]]; then
  rg -N '##' "$@" \
    | gsed "${sed_expr[*]}"
else
  rg -N '##' "$@" \
    | sed "${sed_expr[*]}"
fi
