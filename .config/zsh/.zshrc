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
  zdharma-continuum/fast-syntax-highlighting

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

_is_installed() {
  pacman -Qi "$1" &>/dev/null
}

pkglist() {
  local deps=(fzf paru)
  local missing=()

  for dep in "${deps[@]}"; do
    _is_installed "$dep" || missing+=("$dep")
  done

  if [[ -n ${missing[*]} ]]; then
    echo "[ERROR] missing dependencies: ${missing[*]}"
    return 1
  fi

  case "$1" in
    "")
      pacman -Qq | fzf --preview 'paru -Qi {}' --layout=reverse
      ;;
    -e)
      pacman -Qqe | fzf --preview 'paru -Qi {}' --layout=reverse
      ;;
    -h)
      echo "pkglist: Browse installed packages via fzf"
      echo " -e   Explicitly installed only"
      echo " -h   Show help"
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      return 1
      ;;
  esac
}

pkgcount() {
  case "$1" in
    "")
      pacman -Qq | wc -l
      ;;
    -e)
      pacman -Qqe | wc -l
      ;;
    -h)
      echo "pkgcount: count installed packages"
      echo " -e   Count explicit only"
      echo " -h   Show help"
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      return 1
      ;;
  esac
}

pkgsearch() {
  local deps=(fzf paru)
  local missing=()

  for dep in "${deps[@]}"; do
    _is_installed "$dep" || missing+=("$dep")
  done

  if [[ -n ${missing[*]} ]]; then
    echo "[ERROR] missing dependencies: ${missing[*]}"
    return 1
  fi

  case "$1" in
    "")
      pacman -Slq |
        fzf --preview 'pacman -Si {}' \
          --layout=reverse \
          --bind 'enter:execute(sudo pacman -S {})'
      ;;
    -a)
      paru -Slqa |
        fzf --preview 'paru -Si {}' \
          --layout=reverse \
          --bind 'enter:execute(paru -S {})'
      ;;
    -h)
      echo "pkgsearch: search repos (or AUR with -a) via fzf"
      echo " -a   Include AUR"
      echo " -h   Show help"
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      return 1
      ;;
  esac
}

cleanup() {
  local deps=(pacman-contrib fd)
  local missing=()

  for dep in "${deps[@]}"; do
    _is_installed "$dep" || missing+=("$dep")
  done

  if [[ -n ${missing[*]} ]]; then
    echo "[ERROR] missing dependencies: ${missing[*]}"
    return 1
  fi

  # Orphan packages
  local orphans=$(pacman -Qtdq)
  if [[ -n $orphans ]]; then
    printf "[INFO] Removing orphan packages:\n"
    printf "   - %s\n" $orphans
    printf "[INFO] Proceed? [Y/n]: "
    read choice
    choice=${choice:-Y}

    if [[ $choice =~ ^[Yy]$ ]]; then
      echo "$orphans" | xargs sudo pacman -Rns --noconfirm
      [[ $? -eq 0 ]] && printf "[INFO] Orphan removal completed\n"
    fi
  else
    printf "[INFO] No orphan packages\n"
  fi

  # Pacman cache
  local saved=$(paccache -d | grep -oP 'disk space saved: \K[0-9.]+ [A-Za-z]+')

  if [[ -n $saved ]]; then
    printf "[INFO] Pacman cache found. Save %s? [Y/n] " "$saved"
    read choice
    choice=${choice:-Y}

    [[ $choice =~ ^[Yy]$ ]] && sudo paccache -rq && printf "[INFO] Pacman cache removed\n"
  else
    printf "[INFO] No pacman cache\n"
  fi

  # Paru cache
  local paru_cache="$HOME/.cache/paru"
  local -a lookup=()

  # Read each path as a separate array element (preserves spaces, newlines)
  while IFS= read -r line; do
    [[ -n $line ]] && lookup+=("$line")
  done < <(fd --absolute-path --no-ignore '\.tar\.gz$|\.deb$' "$paru_cache" | grep -v 'pkg.tar.zst')

  if ((${#lookup[@]})); then
    printf "[INFO] Removing paru cache:\n"
    printf "   - %s\n" "${lookup[@]}"
    printf "[INFO] Proceed? [Y/n]: "
    read choice
    choice=${choice:-Y}

    if [[ $choice =~ ^[Yy]$ ]]; then
      rm -- "${lookup[@]}"
      if [[ $? -eq 0 ]]; then
        printf "[INFO] Removal completed\n"
      fi
    fi
  else
    printf "[INFO] No paru cache\n"
  fi

  printf "[INFO] OK\n"
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
