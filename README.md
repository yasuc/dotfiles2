# dotfiles

yasuc 用の dotfiles 詰め合わせ。zsh の設定をモジュール分割し、Linux / macOS / WSL で共通利用する。

## 構成

### `$HOME` にシンボリックリンク（setup.sh）

`.dir_colors` `.gdbinit` `.gitconfig` `.gitignore` `.inputrc` `.zsh` `.zshrc` `.secret`

### `$HOME/.config` にシンボリックリンク（setup.sh）

- `sheldon`（zsh プラグインマネージャの設定）

### zsh 設定モジュール（リポジトリから直接 source）

| ファイル | 内容 |
| --- | --- |
| `.zshrc` | エントリポイント。各モジュールと OS 別設定を読み込む |
| `.zshrc.options` | setopt / 履歴設定 |
| `.zshrc.env` | 環境変数 / locale / PATH |
| `.zshrc.functions` | シェル関数 |
| `.zshrc.alias` | エイリアス |
| `.zshrc.bindkey` | キーバインド |
| `.zshrc.tools` | 開発ツールの PATH と初期化（compinit より後に読む） |
| `.zshrc.linux` | Linux / WSL 固有設定 |
| `.zshrc.osx` | macOS 固有設定 |
| `.zshrc.local` | 機体固有設定（未作成なら読み飛ばす） |

### 読み込み順序

1. `.zshrc.options` → `.zshrc.env` → `.zshrc.functions` → `.zshrc.alias` → `.zshrc.bindkey` → `.zshrc.local`
2. OS 別設定（`getos()` が定義する `OSTYPE2` で分岐）
3. 補完（fpath, zstyle）と `sheldon source` → `compinit` → `uv` の補完
4. `.zshrc.tools`（rbenv / pyenv / nvm / opam などの初期化）
5. `~/.secret`
6. starship（PROMPT を上書きされないよう最後に初期化）

## セットアップ

```sh
git clone https://github.com/yasuc/dotfiles2.git ~/dotfiles2
cd ~/dotfiles2
./setup.sh
```

`setup.sh` が `$HOME` と `$HOME/.config` にシンボリックリンクを作成する。

## 補足

- nvim の設定は別リポジトリへ移動済み。tmux の設定も管理対象から外した
- zsh のプラグインマネージャは zinit から sheldon に変更
