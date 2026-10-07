# users generic .zshrc file for zsh(1)

## Shell の基本設定
#
bindkey -e

umask 022

if [ -d ~/dotfiles2 ]; then
  export DOTFILES=~/dotfiles2
else
  export DOTFILES=~/ghq/github.com/yasuc/dotfiles2
fi

## モジュールの読み込み
# options   : setopt / 履歴設定
# env       : 環境変数 / PATH
# functions : シェル関数
# alias     : エイリアス
# bindkey   : キーバインド
# local     : 機体固有設定 (存在しなければ読み飛ばす)
for _module in options env functions alias bindkey local; do
  [ -f $DOTFILES/.zshrc.$_module ] && source $DOTFILES/.zshrc.$_module
done
unset _module

## OS別設定
# getos() が定義する OSTYPE2 で分岐する
case "$OSTYPE2" in
  WSL*|Linux*)
    [ -f $DOTFILES/.zshrc.linux ] && source $DOTFILES/.zshrc.linux
    ;;
  Mac*)
    [ -f $DOTFILES/.zshrc.osx ] && source $DOTFILES/.zshrc.osx
    ;;
esac

## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})

# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0

## Terminal color configuration
#
unset LSCOLORS

case "$TERM" in
  kterm*)
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
  dumb)
    echo "Welcome Emacs Shell"
    ;;
  xterm)
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    zstyle ':completion:*' list-colors \
        'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
  *)
    export LS_COLORS='di=01;32:ln=01;35:so=01;34:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    ;;
esac

## プラグイン
# zsh-completions 等の fpath を compinit に反映させるため compinit の直前に読む
(( $+commands[sheldon] )) && eval "$(sheldon source)"

## Completion の初期化
#
autoload -Uz compinit
compinit -u

if (( $+commands[uv] )); then
  # 出力末尾の compdef で登録されるため compinit より後に評価する
  eval "$(uv generate-shell-completion zsh)"
fi
# source <(jj util completion zsh)

## 外部ツールの初期化
#
[ -f $DOTFILES/.zshrc.tools ] && source $DOTFILES/.zshrc.tools

## local secrets
#
[ -f ~/.secret ] && source ~/.secret

## Prompt
# Keep Starship initialization after other startup files that may set PROMPT.
(( $+commands[starship] )) && eval "$(starship init zsh)"
