#!/usr/bin/env bash
set -eux -o pipefail

if [ "$(uname)" == "Darwin" ]; then
  OS="macOS"
elif [ "$(uname -s)" == "Linux" ]; then
  OS="Linux"
else
  echo "Your platform ($(uname -a)) is not suppported."
  exit 1
fi

if [ $OS == "Linux" ]; then
  sudo apt-mark hold grub-efi-amd64-signed
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt full-upgrade -y

  sudo apt install -y autoconf automake bison build-essential zip cmake curl \
    gettext git libbz2-dev libclang-dev libcurl4-gnutls-dev libevent-dev libexpat1-dev \
    libffi-dev libfreetype6-dev libfontconfig1-dev libghc-zlib-dev liblzma-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev \
    libxcb-xfixes0-dev llvm make pkg-config python3-openssl python3 \
    software-properties-common tk-dev wget xz-utils zlib1g-dev

#  sudo apt autoremove -y
elif [ $OS == "macOS" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "eval $(/opt/homebrew/bin/brew shellenv)" >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source "$HOME/.cargo/env"

cargo install cargo-make

# Load cargo setting again
source "$HOME/.cargo/env"
