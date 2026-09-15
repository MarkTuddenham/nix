#!/bin/bash
set -euo pipefail

if [[ "$(id -un)" != mark || "$(uname -sm)" != "Darwin arm64" ]]; then
  echo 'This configuration is for mark on an Apple Silicon Mac.' >&2
  exit 1
fi

config_dir="$(cd "$(dirname "$0")" && pwd)"
load_nix() {
  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}
load_nix
if ! command -v nix >/dev/null 2>&1; then
  installer="$(mktemp -t nix-install)"
  trap 'rm -f "$installer"' EXIT
  curl --fail --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install -o "$installer"
  sh "$installer" --daemon
  load_nix
fi
nix --version

# Lock both inputs, then build and activate that exact Home Manager version.
cd "$config_dir"
nix --extra-experimental-features 'nix-command flakes' flake lock
nix --extra-experimental-features 'nix-command flakes' build \
  --out-link "$config_dir/result" \
  "path:$config_dir#homeConfigurations.macbook.activationPackage"
"$config_dir/result/activate"

"$HOME/.nix-profile/bin/git" --version
"$HOME/.nix-profile/bin/home-manager" --version
test -d "$HOME/Applications/Home Manager Apps/Ghostty.app"
test -d /Applications/1Password.app
echo 'Installed Git, Ghostty, 1Password, and Home Manager. Open a new terminal for the updated PATH.'
open "$HOME/Applications/Home Manager Apps"
