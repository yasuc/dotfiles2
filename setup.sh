#!/bin/bash

DOT_FILES=(.dir_colors .gdbinit .gitconfig .gitignore .inputrc .zsh .zshrc)

for file in ${DOT_FILES[@]}; do
	rm $HOME/$file
	ln -s $PWD/$file $HOME/$file
done

CONFIG_DIRS=(nvim tmux sheldon)

for dir in ${CONFIG_DIRS[@]}; do
	rm -rf $HOME/.config/$dir
	ln -s $PWD/$dir $HOME/.config/$dir
done
