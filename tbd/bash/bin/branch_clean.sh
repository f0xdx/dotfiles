#!/usr/bin/env bash
#
# branch_clean.sh
#
# This script will clean the branches in the current git repository, i.e.,
# attempt to delete all local branches that do not have a remote counter part

set -euo pipefail


[ ! -d ".git" ] && { echo "ERR: not in a git repository" >&2; exit 1; }


# remotes

declare -A remotes
while read -r branch; do
  remotes[$branch]=1
done < <( \
  git branch -r \
    | cut -d '/' -f2- \
    | grep -v '^HEAD' \
)

# clean branches

for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
  [[ ! -v "remotes[$branch]" ]] && { git branch -d $branch; }
done

