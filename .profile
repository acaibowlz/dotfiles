#!/bin/sh
# default programs
export EDITOR="nano"
export TERM="alacritty"
export TERMINAL="alacritty"
export BROWSER="firefox"

# ~/.config
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# ~/.cache
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# ~/.local/share
export XDG_DATA_HOME="$HOME/.local/share"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# ~/.local/state
export XDG_STATE_HOME="$HOME/.local/state"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"

# other settings
export PYTHONDONTWRITEBYTECODE=1
