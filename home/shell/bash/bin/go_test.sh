#!/usr/bin/env bash
set -euo pipefail

#
# go_test.sh [ARGS]
#
# This script will run your `go test` test command as usual and pipe its output
# through some sed foo that adds nicer colors

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

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

# main runs the go test command with formatting and optional watch mode
#
# Args:
#   $@: arguments passed to go test
main() {
  # basic dependencies (fswatch is only needed if you want to use -w)
  local -r dependencies=(
    'go'
  )
  common::check_dependencies "${dependencies[@]}"

  # normally you would use while+getopts, but here we want to pass unknown
  # options to go test, so we have to handroll it

  if [[ "${1:-}" == '-h' ]]; then
    usage
    exit 0
  fi

  local watch_dir=""
  if [[ "${1:-}" == '-d' ]]; then
    common::check_dependencies 'fswatch'
    [[ -n "${2:-}" && -a "${2}" && -d "${2}" ]] || { common::err "invalid watch directory: ${2:-}" "$(usage)"; exit 1; }

    watch_dir="${2}"
    shift 2
  fi

  local -a args=( 'test' "$@" )

  # if done without eval:
  # go "${args[@]}" \
  #   | sed \
  #     -e 's/^ok/\x1b[32m\x1b[0m/' \
  #     -e 's/^FAIL\(.*\)/\x1b[31m\1\x1b[0m/' \
  #     -e 's/^?\(.*\)/\x1b[90m\1\x1b[0m/'

  local cmd
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
}

main "$@"

