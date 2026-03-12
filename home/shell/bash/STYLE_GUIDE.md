# Bash Scripting Style Guide

This guide defines the conventions and standards for bash scripts in this
repository. It is heavily influenced by the [Google Shell Style
Guide](https://google.github.io/styleguide/shellguide.html) and streamlined for
automated editing.

## Core Principles

* **Safety First**: Always use strict mode to prevent silent failures.
* **Consistency**: Follow established patterns for error reporting and
  dependency management.
* **Portability**: Use `#!/usr/bin/env bash` for the shebang.
* **Local Scope**: Always use `local` or `local -r` for variables inside
  functions.
* **Main Entry Point**: Wrap the primary logic in a `main()` function and call
  it with `main "$@"`.

## General Conventions

### Shebang and Strict Mode
Every script must start with the following lines:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

### Script Header
Include a brief header describing the script's purpose and usage.
```bash
#
# script_name.sh [ARGS]
#
# A brief description of what this script does.
```

### Shared Utilities
Use the common library for error reporting and dependency checks.
```bash
source "${BASH_SOURCE[0]%/*}/lib/common.sh"
```

## Functions and Variables

### Naming

* **Functions and Local Variables**: Use `lowercase_with_underscores`.
* **Constants and Environment Variables**: Use `UPPERCASE_WITH_UNDERSCORES`.
* **Namespacing**: Functions in library files should be prefixed with the
  filename (e.g., `common::err`).

### Function Definitions

* Use `my_func() { ... }` (avoid the `function` keyword).
* Braces must start on the same line as the function name.
* Every function should have a brief comment describing its purpose and
  arguments.

### Error Handling

* Use `common::err` for printing error messages to stderr (`>&2`).
* Always provide a `usage()` function for scripts that take arguments.
* Check return values explicitly: `if ! command; then ...`.

### Dependencies

* Explicitly check for external dependencies at the start of the script.

```bash
dependencies=(
    'go'
    'rg'
)
common::check_dependencies "${dependencies[@]}"
```

## Shell Scripting Best Practices (Agentic Summary)

| **Feature** | **Do** | **Don't** |
| :--- | :--- | :--- |
| **Command Substitution** | `$(command)` | `` `command` `` |
| **Tests** | `[[ ... ]]` | `[ ... ]` or `test` |
| **Variable Scope** | `local var` (in functions) | Global variables |
| **Lists / Flags** | `("${arr[@]}")` | Space-separated strings |
| **Arithmetic** | `(( i++ ))` | `let` or `expr` |
| **Indentation** | 2 spaces | Tabs |
| **Quoting** | `"${var}"` | `$var` (unquoted) |
| **Wildcards** | `./*` (to avoid `-` issues) | `*` |

* **Arrays**: Use arrays for building command arguments to handle spaces and
  special characters correctly.
* **Variable Expansion**: Use `${VAR:-}` to handle potentially unset variables
  when `set -u` is active.
* **Path Resolution**: Use `${BASH_SOURCE[0]%/*}` to refer to the script's
  directory.
* **Shellcheck**: Address all warnings from `shellcheck`. Use directives like `#
  shellcheck disable=SCxxxx` only when absolutely necessary.

