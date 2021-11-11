
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{219} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit load zdharma-continuum/history-search-multi-word
zinit load zsh-users/zsh-completions

zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zaw

zinit for \
    zdharma-continuum/history-search-multi-word \
    zsh-users/zsh-completions \
    light-mode pick"async.zsh" src"pure.zsh" \
    sindresorhus/pure

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# zsh setting
## History
HISTFILE=~/.zsh_history
HISTSIZE=10000               # history size in memory
SAVEHIST=100000              # history size in file
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録

## beep音を鳴らさない
setopt no_beep
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

autoload -U compinit
compinit
### End of Zplugin's installer chunk

bindkey '^r' zaw-history
bindkey '^zd' zaw-cdr
bindkey '^zb' zaw-git-branches

# zstyle
zstyle ':zaw:history' default zaw-callback-replace-buffer
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
zstyle ':filter-select' case-insensitive yes

# environment variables
## for nodebrew
export PATH=$HOME/.nodebrew/current/bin:$HOME/.nodebrew/current/lib/node_modules/npm/bin:./node_modules/.bin:$PATH

## for flutter
export PATH=$PATH:$HOME/flutter/bin

## for go
export GOPATH=$HOME/.go
export PATH=$HOME/.go/bin:$PATH
export GHQ_ROOT=$HOME/ghq

## for ruby
[[ -d ~/.rbenv  ]] && export PATH=${HOME}/.rbenv/bin:${PATH} && eval "$(rbenv init -)"

## for homebrew
export PATH="/usr/local/sbin:$PATH"

## for dart tools
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Aliases
alias ls='ls -G'
alias rm='rm -i'
alias gitback='git checkout `git reflog | grep "moving from" | cut -d " " -f6 | head -n 1`'
alias bundler='bundle install --path=vendor/bundle --binstubs=vendor/bin'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border"

## ghq cd
function gcd() {
  local distination=$(ghq list | fzf +m --query "$LBUFFER" --prompt="Select Repository > ")
  if [ "$distination" = "" ]; then
    zle redisplay
    return 1
  fi
  cd $GHQ_ROOT/$distination
}
zle -N gcd
bindkey '^j' gcd

function fssh() {
  local sshLoginHost
  sshLoginHost=`cat ~/.ssh/config | grep -i ^host | awk '{print $2}' | fzf`

  if [ "$sshLoginHost" = "" ]; then
    return 1
  fi

  ssh ${sshLoginHost}
}

