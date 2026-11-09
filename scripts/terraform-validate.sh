#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validation_root="$(mktemp -d)"
trap 'rm -r "$validation_root"' EXIT
cp -R "$repo_root/providers" "$validation_root/"

export TF_IN_AUTOMATION=1
export TF_PLUGIN_CACHE_DIR="$validation_root/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

for config in "$validation_root"/providers/*/bootstrap "$validation_root"/providers/*/module/*; do
  if [[ ! -d "$config" ]] || ! compgen -G "$config/*.tf" >/dev/null; then
    continue
  fi

  echo "Validating ${config#"$validation_root"/}"
  terraform -chdir="$config" init -backend=false -input=false -no-color
  terraform -chdir="$config" validate -no-color
done
