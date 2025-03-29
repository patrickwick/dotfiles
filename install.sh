#!/bin/sh

cp ./tmux.conf ~/.tmux.conf
cp ./gdbinit ~/.gdbinit
# cat ./gterminal | dconf load /org/gnome/terminal/legacy/profiles:/

mkdir -p ~/.config
cp -r ./config/nvim ~/.config/
cp -r ./config/fish ~/.config/
