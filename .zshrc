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
#proxy

## Backspace key
#
bindkey "^?" backward-delete-char

#
# Color
#
DEFAULT=$'%{\e[1;0m%}'
RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
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
HISTSIZE=100000
SAVEHIST=100000

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
export EDITOR=nvim
export PATH=/usr/bin:/bin:/sbin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:$HOME/local/bin:$HOME/bin
export PATH="/snap/bin:$PATH"
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
    #alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code'
    alias code='/mnt/c/Users/yasuc/Appdata/Local/Programs/Microsoft\ VS\ Code/bin/code'
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
eval "$(fzf --zsh)"

## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})


export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -n "$NVIM" ] || [ -n "$NVIM_LOG_FILE" ] || [ -n "$VSCODE_INJECTION" ]; then
   eval "$(starship init zsh)"
    alias c=clear
else
   eval "$(starship init zsh)"
fi

eval "$(sheldon source)"

autoload -U compinit
compinit -u

eval "$(sheldon source)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export FZF_CTRL_T_OPTS="+s -e"
export FZF_CTRL_R_OPTS="+s -e"
export FZF_ALT_C_OPTS="+s -e"

export HOMEBREW_NO_AUTO_UPDATE=1

source ~/fzf-git.sh/fzf-git.sh
eval "$(zoxide init zsh)"

# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)


# alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
# alias nvim-kick="NVIM_APPNAME=kickstart nvim"
# alias nvim-chad="NVIM_APPNAME=NvChad nvim"
# alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"
#
# export NVIM_APPNAME=LazyVim
# export NVM_DIR="$HOME/.nvm"

# function nvims() {
#   items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
#   config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config >> " --height=~50% --layout=reverse --border --exit-0)
#   if [[ -z $config ]]; then
#     echo "Nothing selected"
#     return 0
#   elif [[ $config == "default" ]]; then
#     config=""
#   fi
#   NVIM_APPNAME=$config nvim $@
# }
#

# pnpm
export PNPM_HOME="/Users/yasuc/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Windsurf
export PATH="/Users/yasuc/.codeium/windsurf/bin:$PATH"

# Added by Windsurf
export PATH="/Users/yasuc/.codeium/windsurf/bin:$PATH"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

if [ -n "$NVIM" ]; then
   eval "$(starship init zsh)"
else
   eval "$(starship init zsh)"
fi

less_with_unbuffer () {
    unbuffer "$@" |& less -SR
}
alias ul=less_with_unbuffer

export XDG_RUNTIME_DIR=/home/yasuc/.tmp

export https_proxy=""
export HTTPS_PROXY=""
unset https_proxy
unset HTTPS_PROXY

# BEGIN opam configuration
[[ ! -r '/Users/yasuc/.opam/opam-init/init.zsh' ]] || source '/Users/yasuc/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
[[ ! -r /home/yasuc/.opam/opam-init/init.zsh ]] || source /home/yasuc/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# Add .NET Core SDK tools
export PATH="/home/yasuc/anaconda3/bin:$PATH:/home/yasuc/.dotnet/tools"

# bindkey
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

# autoload smart-insert-last-word
# zle -N insert-last-word smart-insert-last-word
# bindkey '^[.' insert-last-word


# Added by Antigravity
export PATH="/Users/yasuc/.antigravity/antigravity/bin:$PATH"

eval "$(uv generate-shell-completion zsh)"
source <(jj util completion zsh)

source ~/.secret
