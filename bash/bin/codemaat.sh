#!/usr/bin/env bash
#
# codemaat.sh [ARGS]
#
# This script will run the codemaat utility. It is essentially a glorified alias
# for the tool.

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

set -euo pipefail

export COLOR=on

# (0) process pre-conditions

dependencies=(
    'java'
)
common::check_dependencies "${dependencies[@]}"

code_maat_file="${BASH_SOURCE[0]%/*}/lib/code-maat-1.0.4-standalone.jar"

[[ -e "$code_maat_file" ]] || { common::err "${code_maat_file} could not be found, please install it"; exit 1; }

args=( 
  '-jar' "${code_maat_file}"
  "$@"
)

# TODO generate log file for git automatically
git log --all --numstat --date=short --pretty=format:'--%h--%ad--%aN' --no-renames --after=2021-12-01 -- . ":(exclude)*/node_modules" ":(exclude)*/gen" ":(exclude)*/assets" > logfile.log

java "${args[@]}"
