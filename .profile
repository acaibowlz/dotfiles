#!/bin/sh
# default programs
export EDITOR="nano"
export TERM="alacritty"
export TERMINAL="alacritty"
export BROWSER="firefox"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# program settings
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/cpython/"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc":"$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

