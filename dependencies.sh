#!/bin/sh
#
# Install dependencies. Requires apt and snap.
# NOTE: did not bother to list all basic dependencies

# lua package manager
apt install luarocks

# grep for nvim telescope
apt install ripgrep

snap install neovim
