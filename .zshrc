# users generic .zshrc file for zsh(1)
## Environment variable configuration
#
export LANGUAGE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

bindkey -e

umask 022

if [ -d ~/dotfiles2 ]; then
  export DOTFILES=~/dotfiles2
else
  export DOTFILES=~/ghq/github.com/yasuc/dotfiles2
fi

## setopt設定
#
[ -f $DOTFILES/.zshrc.options ] && source $DOTFILES/.zshrc.options

## functions設定
#
[ -f $DOTFILES/.zshrc.functions ] && source $DOTFILES/.zshrc.functions

## alias設定
#
[ -f $DOTFILES/.zshrc.alias ] && source $DOTFILES/.zshrc.alias

## local固有設定
#
[ -f $DOTFILES/.zshrc.local ] && source $DOTFILES/.zshrc.local

#proxyの設定
proxy

## Backspace key
#
bindkey "^?" backward-delete-char

#
# Color
#
DEFAULT=$'%{\e[1;0m%}'
RESET="%{${reset_color}%}"
#GREEN=$'%{\e[1;32m%}'
GREEN="%{${fg[green]}%}"
#BLUE=$'%{\e[1;35m%}'
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
WHITE="%{${fg[white]}%}"

# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
#bindkey "^p" history-beginning-search-backward-end
#bindkey "^n" history-beginning-search-forward-end
bindkey "^p" up-line-or-history
bindkey "^n" down-line-or-history
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# glob(*)によるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ctrl-w, ctrl-bキーで単語移動
bindkey "^W" forward-word
bindkey "^@" backward-word

# back-wordでの単語境界の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# URLをコピペしたときに自動でエスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# エラーメッセージ本文出力に色付け
e_normal=`echo -e "¥033[0;30m"`
e_RED=`echo -e "¥033[1;31m"`
e_BLUE=`echo -e "¥033[1;36m"`

## zsh editor
#
autoload zed

## Prediction configuration
#
autoload predict-on
#predict-off

## Command Line Stack [Esc]-[q]
bindkey -a 'q' push-line


## Alias configuration
#
# expand aliases before completing
#

alias where="command -v"

export TERM=xterm-256color
#export DISPLAY=localhost:0.0
#export DISPLAY=:0.0

## terminal configuration
# http://journal.mycom.co.jp/column/zsh/009/index.html
unset LSCOLORS

case "${TERM}" in
xterm-256color)
    export TERM=xterm-256color
    export LS_COLORS='di=01;32:ln=01;35:so=01;34:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

    ;;
xterm)
    export TERM=xterm-256color
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

    ;;
kterm)
    export TERM=kterm-color
    # set BackSpace control character

    stty erase
    ;;

cons25)
    unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad

    export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
    zstyle ':completion:*' list-colors \
        'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;

kterm*|xterm*)
   # Terminal.app
#    precmd() {
#        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#    }
    # export LSCOLORS=exfxcxdxbxegedabagacad
    # export LSCOLORS=gxfxcxdxbxegedabagacad
    # export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad

    zstyle ':completion:*' list-colors \
        'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;

dumb)
    echo "Welcome Emacs Shell"
    ;;
esac
export EDITOR=vi
export PATH=/usr/bin:/bin:/sbin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:$HOME/local/bin:$HOME/bin
export MANPATH=$MANPATH:/opt/local/man:/usr/local/share/man

expand-to-home-or-insert () {
        if [ "$LBUFFER" = "" -o "$LBUFFER[-1]" = " " ]; then
                LBUFFER+="~/"
        else
                zle self-insert
        fi
}

#        Linux*Microsoft*)     machine=WSL;;
#        Linux*)     machine=Linux;;
#        Darwin*)    machine=Mac;;
#        CYGWIN*)    machine=Cygwin;;
#        MINGW*)     machine=MinGw;;
#        *)          machine="UNKNOWN:${unameOut}"
case "${OSTYPE2}" in
msys*)
    [ -f $DOTFILES/.zshrc.msys2 ] && source $DOTFILES/.zshrc.msys2
		;;
WSL*)
    IP=`ip route | grep 'default via' | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
    alias start='/mnt/c/Windows/explorer.exe'
    alias explorer='/mnt/c/Windows/explorer.exe'
    alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code'
#     export DISPLAY=${IP}:0.0
    [ -f $DOTFILES/.zshrc.linux ] && source $DOTFILES/.zshrc.linux
    ;;
Linux*)
    [ -f $DOTFILES/.zshrc.linux ] && source $DOTFILES/.zshrc.linux
    ;;
Cygwin*)
    [ -f $DOTFILES/.zshrc.cygwin ] && source $DOTFILES/.zshrc.cygwin
    ;;
Mac*)
    zle -N expand-to-home-or-insert
#    bindkey "@"  expand-to-home-or-insert
    [ -f $DOTFILES/.zshrc.osx ] && source $DOTFILES/.zshrc.osx
    ;;
freebsd*)
    zle -N expand-to-home-or-insert
#    bindkey "@"  expand-to-home-or-insert
    case ${UID} in
    0)
        updateports()
        {
            if [ -f /usr/ports/.portsnap.INDEX ]
            then
                portsnap fetch update
            else
                portsnap fetch extract update
            fi
            (cd /usr/ports/; make index)

            portversion -v -l \<
        }
        alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
        ;;
    esac
    ;;
esac

case "${OSTYPE}" in
# Mac(Unix)
darwin*)
    # ここに設定
    ;;
# Linux
linux*)
    # ここに設定
    ;;
cygwin*)
    # ここに設定
    ;;
esac

autoload -Uz zmv

#export GOROOT=c:\\tools\\go
#export GOARCH=386
#export GOOS=linux
export GOBIN=~/go/bin
export PATH=$PATH:$GOBIN
export PATH="$HOME/.rbenv/bin:$PATH"
[[ -f $HOME/.rbenv/bin/rbenv ]] && eval "$(rbenv init -)"

export LESS="--RAW-CONTROL-CHARS"

export LIBGL_ALWAYS_INDIRECT=1

[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP
export THEOS=~/theos

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})


export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export HOMEBREW_GITHUB_API_TOKEN=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

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/night-owl.omp.json)"


autoload -U compinit
compinit -u

eval "$(sheldon source)"
