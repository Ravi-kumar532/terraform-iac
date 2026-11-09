#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validation_root="$(mktemp -d)"
trap 'rm -r "$validation_root"' EXIT
cp -R "$repo_root/providers" "$validation_root/"

export TF_IN_AUTOMATION=1
export TF_PLUGIN_CACHE_DIR="$validation_root/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

for config in "$validation_root"/providers/* "$validation_root"/providers/*/bootstrap "$validation_root"/providers/*/module/*; do
  if [[ ! -d "$config" ]] || ! compgen -G "$config/*.tf" >/dev/null; then
    continue
  fi

  echo "Validating ${config#"$validation_root"/}"
  terraform -chdir="$config" init -backend=false -input=false -no-color
  terraform -chdir="$config" validate -no-color
done

# Validate the HCL syntax and formatting of checked-in environment examples.
for example in "$repo_root"/providers/*/environment/*.tfvars.example; do
  [[ -f "$example" ]] || continue
  temporary_tfvars="$validation_root/$(basename "${example%.example}")"
  cp "$example" "$temporary_tfvars"
  echo "Formatting ${example#"$repo_root"/}"
  terraform fmt -check "$temporary_tfvars"
done
