#!/usr/bin/env bash
#
# common.sh is a set of common utility functions for scripts

export COLOR=on

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

