#                 __
#     ____  _____/ /_  __________
#    /_  / / ___/ __ \/ ___/ ___/
#   _ / /_(__  ) / / / /  / /__
#  (_)___/____/_/ /_/_/   \___/

# ---------------------------------------------------------------------------- #
#                                     PATH                                     #
# ---------------------------------------------------------------------------- #

typeset -U PATH path
: "${XDG_DATA_HOME:=$HOME/.local/share}"
path=(
  "$HOME/Code/scripts"
  "$HOME/.local/bin"
  "$XDG_DATA_HOME/npm/bin"
  "$XDG_DATA_HOME/cargo/bin"
  "$XDG_DATA_HOME/go/bin"
  $path
)
export PATH

# ---------------------------------------------------------------------------- #
#                                     ZINIT                                    #
# ---------------------------------------------------------------------------- #

export ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "${ZINIT_HOME%/*}"
[[ ! -d "$ZINIT_HOME/.git" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting \

zinit wait lucid light-mode for \
  Aloxaf/fzf-tab

# Oh-my-zsh functions
zinit wait'1' lucid light-mode for \
  OMZ::plugins/extract/extract.plugin.zsh \
  OMZ::plugins/git-commit/git-commit.plugin.zsh \
  OMZ::plugins/git-extras/git-extras.plugin.zsh \
  OMZ::plugins/sudo/sudo.plugin.zsh

zinit as"completion" wait'1' lucid light-mode blockf for \
  OMZ::plugins/docker/docker.plugin.zsh \
  OMZ::plugins/gh/gh.plugin.zsh

# ---------------------------------------------------------------------------- #
#                                      ZSH                                     #
# ---------------------------------------------------------------------------- #

setopt append_history inc_append_history share_history
setopt hist_ignore_dups hist_ignore_space
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.zsh_history"

autoload -Uz compinit
compinit -C

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

bindkey "^[[H" beginning-of-line # home key
bindkey "^[[F" end-of-line       # end key
bindkey "^[[3~" delete-char      # delete key

# ---------------------------------------------------------------------------- #
#                                      FZF                                     #
# ---------------------------------------------------------------------------- #

export FZF_DEFAULT_OPTS="
  --color=fg:#d8dadd,bg:-1,hl:#B7D4ED
  --color=fg+:#d8dadd,bg+:-1,hl+:#BCC2C6
  --color=info:#B2BCC4,prompt:#758A9B,pointer:#B7D4ED
  --color=marker:#BCC2C6,spinner:#B7D4ED,header:#949EA3
  --layout=reverse"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --group-directories-first $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# ---------------------------------------------------------------------------- #
#                                      GIT                                     #
# ---------------------------------------------------------------------------- #

alias ga="git add"
alias gb="git branch"
alias gc="git commit -m"
alias gd="git diff"
alias gf="git fetch -p"
alias gm="git merge"
alias gp="git push"
alias gs="git status"
alias gu="git uncommit"
alias gsw="git switch"
alias gcl="git clone"

# ---------------------------------------------------------------------------- #
#                                   SHORTCUTS                                  #
# ---------------------------------------------------------------------------- #

alias e="exit"
alias v="source .venv/bin/activate"
alias ff="fastfetch"
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first"
alias lt="eza --tree --level=1 --icons --group-directories-first"
alias lg="lazygit"
alias wifi="nmtui connect"
alias clock="peaclock"
alias reload="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias weather="curl 'wttr.in/{Hsinchu,Taipei}?format=%l:+%c+%C+%t+%28%f%29\n'"
alias log-out="pkill niri"

# ---------------------------------------------------------------------------- #
#                                    PACMAN                                    #
# ---------------------------------------------------------------------------- #

alias inst="paru -S"
alias uninst="paru -Rns"
alias up="paru -Syu"
alias speed="speedtest-cli --bytes"
alias mirrors="rate-mirrors --allow-root --protocol https arch | grep -v '^#' | sudo tee /etc/pacman.d/mirrorlist"

deps() {
  if [[ "$1" == "upward" ]]; then
    aura deps --open "$2"
  elif [[ "$1" == "downward" ]]; then
    aura deps --open --reverse "$2"
  else
    echo "Unknown option: $1"
  fi
}

pkglist() {
  _is_installed() {
    pacman -Qi "$1" &>/dev/null
  }
  local deps=(fzf paru)
  local missing_deps=()
  for dep in "${deps[@]}"; do
    if ! _is_installed "$dep"; then
      missing_deps+=("$dep")
    fi
  done
  if [[ -n $missing_deps ]]; then
    echo "[ERROR] missing dependencies: ${missing_deps[*]}"
    return 1
  fi

  _pkglist() {
    if [[ $# -eq 0 ]]; then
      pacman -Qq | fzf --preview 'paru -Qi {}' --layout=reverse
    elif [[ $1 == '-e' ]]; then
      pacman -Qqe | fzf --preview 'paru -Qi {}' --layout=reverse
    elif [[ $1 == '-h' ]]; then
      echo "pkglist: Browse installed packages via fzf"
      echo ""
      echo "Options:"
      echo " -e Browse explicitly installed packages only"
      echo " -h Show this help message and exit"
      return 0
    else
      echo "[ERROR] Unknown argument: $1"
      return 1
    fi
  }

  _pkglist "$@"
}

pkgcount() {
  _pkgcount() {
    if [[ $# -eq 0 ]]; then
      pacman -Qq | wc -l
    elif [[ $1 == '-e' ]]; then
      pacman -Qqe | wc -l
    elif [[ $1 == '-h' ]]; then
      echo "pkgcount: Count installed packages"
      echo ""
      echo "Options:"
      echo " -e Count explicitly installed packages only"
      echo " -h Show this help message and exit"
      return 0
    else
      echo "[ERROR] Unknown argument: $1"
      return 1
    fi
  }

  _pkgcount "$@"
}

pkgsearch() {
  _is_installed() {
    pacman -Qi "$1" &>/dev/null
  }
  local deps=(fzf paru)
  local missing_deps=()
  for dep in "${deps[@]}"; do
    if ! _is_installed "$dep"; then
      missing_deps+=("$dep")
    fi
  done
  if [[ -n $missing_deps ]]; then
    echo "[ERROR] missing dependencies: ${missing_deps[*]}"
    return 1
  fi

  _pkgsearch() {
    if [[ $# -eq 0 ]]; then
      pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse --bind 'enter:execute(sudo pacman -S {})'
    elif [[ $1 == '-a' ]]; then
      paru -Slqa | fzf --preview 'paru -Si {}' --layout=reverse --bind 'enter:execute(paru -S {})'
    elif [[ $1 == '-h' ]]; then
      echo "pkglist: Browse arch repository via fzf"
      echo ""
      echo "Options:"
      echo " -a Browse arch repository and AUR"
      echo " -h Show this help message and exit"
      return 0
    else
      echo "[ERROR] Unknown argument: $1"
      return 1
    fi
  }

  _pkgsearch "$@"
}

cleanup() {
  _is_installed() {
    pacman -Qi "$1" &>/dev/null
  }
  local deps=(pacman-contrib fd)
  local missing_deps=()
  for dep in "${deps[@]}"; do
    if ! _is_installed "$dep"; then
      missing_deps+=("$dep")
    fi
  done
  if [[ -n $missing_deps ]]; then
    echo "[ERROR] missing dependencies: ${missing_deps[*]}"
    return 1
  fi

  _cleanup() {
    local orphans=$(pacman -Qtdq)
    if [[ -n $orphans ]]; then
      printf "[INFO] Removing orphan packages: \n"
      echo $orphans | xargs printf "   - %s\n"
      printf "[INFO] Proceed? [Y/n]: "
      read choice
      choice=${choice:-Y}
      if [[ $choice =~ ^[Yy]$ ]]; then
        echo "$orphans" | xargs sudo pacman -Rns --noconfirm
        if [[ $? -eq 0 ]]; then
          printf "[INFO] Removal completed\n"
        fi
      fi
    else
      printf "[INFO] No orphan packages\n"
    fi

    local pacman_cache=$(echo $(paccache -d) | grep -oP 'disk space saved: \K[0-9.]+ [A-Za-z]+')
    if [[ -n $pacman_cache ]]; then
      printf "[INFO] Pacman cache found. Save $pacman_cache? [Y/n]: "
      read choice
      choice=${choice:-Y}
      if [[ $choice =~ ^[Yy]$ ]]; then
        sudo paccache -rq
        if [[ $? -eq 0 ]]; then
          printf "[INFO] Pacman cache removed\n"
        fi
      fi
    else
      printf "[INFO] No pacman cache\n"
    fi

    local paru_cache="$HOME/.cache/paru"
    local lookup_result=$(fd --absolute-path --no-ignore '\.tar.gz$|\.deb$' "$paru_cache" | grep -v 'pkg.tar.zst')
    if [[ -n $lookup_result ]]; then
      printf "[INFO] Removing paru cache: \n"
      echo $lookup_result | xargs printf "   - %s\n"
      printf "[INFO] Proceed? [Y/n]: "
      read choice
      choice=${choice:-Y}
      if [[ $choice =~ ^[Yy]$ ]]; then
        rm $(fd --absolute-path --no-ignore '\.tar\.gz$|\.deb$' "$paru_cache" | grep -v 'pkg.tar.zst')
        if [[ $? -eq 0 ]]; then
          printf "[INFO] Removal completed\n"
        fi
      fi
    else
      printf "[INFO] No paru cache\n"
    fi

    printf "[INFO] OK\n"
  }

  _cleanup
}

# ---------------------------------------------------------------------------- #
#                              SHELL INTEGRATIONS                              #
# ---------------------------------------------------------------------------- #

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
else
  printf "[WARNING] fzf is not installed\n"
fi
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
else
  printf "[WARNING] zoxide is not installed\n"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  printf "[WARNING] starship is not installed\n"
fi
