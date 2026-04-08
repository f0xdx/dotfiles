#!/usr/bin/env bash
#
# validate-hypr-config.sh
#
# Assembles and validates a hybrid Nix/ExtraConfig Hyprland configuration.

set -euo pipefail

# Calculate repo root and source common library
REPO_ROOT=$(git rev-parse --show-toplevel)
# shellcheck source=home/shell/bash/bin/lib/common.sh
source "${REPO_ROOT}/home/shell/bash/bin/lib/common.sh"

usage() {
  cat <<EOF
Usage:
    validate-hypr-config.sh

Assembles the Hyprland configuration from Nix settings and the local .conf file,
then runs a headless Hyprland instance to validate syntax.
EOF
}

main() {
  local -a dependencies=(
    'nix'
    'jq'
    'Hyprland'
    'timeout'
  )
  common::check_dependencies "${dependencies[@]}"

  local hypr_conf="${REPO_ROOT}/home/desktop/hyprland/cfg/hyprland.conf"
  local test_file
  test_file=$(mktemp /tmp/hypr-test.XXXXXX.conf)
  local val_log="/tmp/hypr-val.log"

  echo "--- Assembling Hyprland configuration ---"

  # 1. Detect configuration
  echo "Detecting homeConfiguration..."
  local current_conf
  current_conf="$(whoami)@$(hostname)"
  local config_name
  if nix eval ".#homeConfigurations.\"${current_conf}\"" --apply "x: true" > /dev/null 2>&1; then
    config_name="${current_conf}"
  else
    # Fallback to the first available configuration if current one doesn't exist
    config_name=$(nix eval .#homeConfigurations --apply "builtins.attrNames" --json | jq -r '.[0]')
  fi

  if [[ -z "${config_name}" || "${config_name}" == "null" ]]; then
    common::err "Could not detect any homeConfiguration in flake.nix"
    exit 1
  fi
  echo "Using configuration: ${config_name}"

  # 2. Extract Nix settings
  echo "Evaluating Nix settings..."
  local nix_settings
  nix_settings=$(nix eval ".#homeConfigurations.\"${config_name}\".config.wayland.windowManager.hyprland.settings" --json | jq -r '
    def format_val:
      if type == "array" then (map(format_val) | join(", "))
      elif type == "boolean" then (if . then "true" else "false" end)
      else tostring end;

    def format_block(obj):
      obj | to_entries | map(
        if (.value | type) == "object" then
          "\n  \(.key) {\n    \(format_block(.value) | split("\n") | join("\n    "))\n  }"
        else
          "\n  \(.key) = \( .value | format_val )"
        end
      ) | join("");

    format_block(.)
  ')

  echo "${nix_settings}" > "${test_file}"
  echo "" >> "${test_file}"

  # 3. Append extraConfig
  if [[ -f "${hypr_conf}" ]]; then
    echo "Appending extraConfig from ${hypr_conf}..."
    cat "${hypr_conf}" >> "${test_file}"
  else
    echo "WARNING: ${hypr_conf} not found, skipping extraConfig."
  fi

  # 4. Run Headless Validation
  echo "--- Validating with Headless Hyprland ---"
  # Run for 2 seconds and capture output.
  # We use timeout and redirect to log.
  # HYPRLAND_INSTANCE_SIGNATURE avoids conflicts with running instances.
  timeout 2 WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 HYPRLAND_INSTANCE_SIGNATURE=skill_val Hyprland -c "${test_file}" > "${val_log}" 2>&1 || true

  # 5. Report Results
  if grep -qi "Config error" "${val_log}"; then
    common::err "Configuration error found!" "$(grep -i "Config error" "${val_log}")"
    exit 1
  else
    echo "SUCCESS: Configuration is valid."
    rm "${test_file}"
  fi
}

main "$@"
