#!/bin/bash

DOT_FILES=(.byobu .dir_colors .gdbinit .gitconfig .gitignore .inputrc .p10k.zsh .screenrc .tmux.conf .zsh .zshrc)

for file in ${DOT_FILES[@]}; do
	rm $HOME/$file
	ln -s $PWD/$file $HOME/$file
done

CONFIG_DIRS=(nvim tmux sheldon)

for dir in ${CONFIG_DIRS[@]}; do
	rm -rf $HOME/.config/$dir
	ln -s $PWD/$dir $HOME/.config/$dir
done
