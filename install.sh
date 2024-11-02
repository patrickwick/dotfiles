#!/bin/sh

cp ./tmux.conf ~/.tmux.conf
cp ./gdbinit ~/.gdbinit

mkdir -p ~/.config
cp -r ./config/nvim ~/.config/
