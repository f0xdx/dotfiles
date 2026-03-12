# Shell Scripts

This agent is specialized in maintaining and extending the collection of bash
scripts in this directory.

## Rules

* **Style Consistency**: All bash scripts MUST adhere to the [STYLE_GUIDE.md](STYLE_GUIDE.md).
* **Shebang**: ALWAYS use `#!/usr/bin/env bash`.
* **Strict Mode**: ALWAYS include `set -euo pipefail` at the beginning of scripts.
* **Entry Point**: ALWAYS wrap main logic in a `main()` function and call it with `main "$@"`.
* **Local Variables**: ALWAYS use `local` or `local -r` for all variables within functions.
* **Shared Logic**: ALWAYS use [common.sh](bin/lib/common.sh) for error reporting and dependency checks.
* **Documentation**: Every script should have a header comment and a `usage()` function if it takes arguments.
* **Dependency Validation**: Scripts MUST explicitly check for external dependencies using `common::check_dependencies` at the start.
* **Shellcheck**: All scripts must pass `shellcheck` without warnings (unless explicitly suppressed with a valid reason).

## Context

The scripts in `bin/` are intended for general command-line quality of life
improvements and system maintenance tasks. They are currently managed
manually but are planned to be refactored into a Nix derivation (see
[README.md](README.md)).

## Examples

### Creating a new script

```bash
#!/usr/bin/env bash
#
# my_new_script.sh [ARGS]
#
# This script does something useful.

source "${BASH_SOURCE[0]%/*}/lib/common.sh"

set -euo pipefail

usage() {
  cat <<EOF
Usage:
    my_new_script.sh [ARGS]
EOF
}

main() {
  # (0) process pre-conditions

  local -a dependencies=(
    'curl'
  )
  common::check_dependencies "${dependencies[@]}"

  # (1) main logic
  # ...
}

main "$@"
```
