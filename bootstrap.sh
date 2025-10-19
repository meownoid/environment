#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it from https://brew.sh first." >&2
  exit 1
fi

brew update

brew bundle --file=- <<'BREWFILE'
brew "cmake"
brew "codex"
brew "colima"
brew "docker"
brew "ffmpeg"
brew "git-lfs"
brew "gnupg"
brew "imagemagick"
brew "pandoc"
brew "qemu"
brew "rsync"
brew "sox"
brew "stow"
brew "tree"
brew "uv"
brew "wget"
brew "yt-dlp"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
BREWFILE
