#!/bin/sh
#
# Install dependencies. Requires apt and snap.

apt install git build-essential curl htop clang

# lua package manager
apt install luarocks

# grep for nvim telescope
apt install ripgrep

snap install nvim
snap install ghostty --classic

# fish as default shell
apt install fish
chsh -s $(which fish)

# zigup (not tested)
# mkdir -p ~/zigup
# curl -L https://github.com/marler8997/zigup/releases/latest/download/zigup-x86_64-linux.tar.gz | tar -xz ~/zigup/zigup
