[![macos](https://github.com/saku/dotfiles/actions/workflows/macos.yml/badge.svg)](https://github.com/saku/dotfiles/actions/workflows/macos.yml)
[![linux](https://github.com/saku/dotfiles/actions/workflows/linux.yml/badge.svg)](https://github.com/saku/dotfiles/actions/workflows/linux.yml)
[![lint](https://github.com/saku/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/saku/dotfiles/actions/workflows/lint.yml)

# dotfiles

このリポジトリは saku が愛用している設定の dotfiles です。  
この dotfiles は数多くの優秀な同僚やエンジニアの知恵（via Google）を借りてできています。

そのためお好きに fork したり、一部を持っていったりしてもらってかまいません。  
ですが LICENSE にある通り、もしよろしければあなたの dotfiles も公開してくれると嬉しいです。  
みなさんの dotfiles により育てられ、また誰かの dotfiles が育つキッカケとなれば幸いです。

## CI Ready dotfiles

この CI 設定は lint および ubuntu/mac 環境でのセットアップ確認が CI により自動で行われております。  
ですが自身のデバッグ中でも Github actions では通るのに仮想マシン内ではうまく動作しない、ということもあったのであくまで目安とお考えください。

## How to install

### Linux(Ubuntu)

作者自身の環境が Mac のため、Docker コンテナでのみ検証している状態です。  
そのため、Mac 環境のみ実行コマンドを記載させていただきます。

### MacOS

前提として Xcode tools をインストール済であるインストール直後の状態を想定したものとなります。

```shell
* $ git clone https://github.com/saku/dotfiles.git $HOME/dotfiles
* $ cd $HOME/dotfiles
~/dotfiles $ ./script/install.sh

（cargo makeコマンドが実行できることを確認してください）
（できない場合はターミナルを再起動してください）

~/dotfiles $ cargo make --makefile script/task.toml setup \
        -e GIT_NAME="saku" \
        -e GIT_EMAIL="example@example.com" \
        -e PYTHON_VERSION="3.11.1" \
        -e GO_VERSION="1.19.4" \
        -e NODE_VERSION="18.12.1"
（言語のバージョンは好きに指定してください）

上記のコマンドがうまく実行できない場合には環境変数を事前にexportして実行してみてください。

~/dotfiles $ export GIT_NAME="saku"
~/dotfiles $ export GIT_EMAIL="example@example.com"
~/dotfiles $ export PYTHON_VERSION="3.11.1"
~/dotfiles $ export GO_VERSION="1.19.4"
~/dotfiles $ export NODE_VERSION="18.12.1"
~/dotfiles $ cargo make --makefile script/task.toml setup
```

## Tools

下記のツールが設定込でインストールされます

- shell
  - zsh
  - tmux
  - starship
- languages version manager
  - asdf
- programming languages
  - python (via asdf)
  - go (via asdf)
  - node (via asdf)
  - deno
  - rust
- editor
  - vim
  - emacs (Only setting files, not install app)
- development tools
  - docker
  - tig
- CLI
  - bat (When install succeeded, alias for `cat`)
  - dapr
  - direnv (via asdf)
  - exa (Only MacOS. [See issue](https://github.com/ogham/exa/issues/1068) When install succeeded, alias for `ls`.)
  - fd (When install succeeded, alias for `find`)
  - fzf
  - ghq
  - git-delta
  - jq
  - ripgrep
  - zoxide
  - cargo-watch
  - cargo-update
- GUI (MacOS only)
  - AppCleaner
  - Better touch tools
  - Clipy
  - Contexts
  - Discord
  - Dropbox
  - Google Chrome
  - Skitch
  - Slack
  - TablePlus
  - Zoom
