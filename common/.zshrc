### History ###

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# Record timestamp of command
setopt extended_history

# Delete duplicates first when history file size exceeds maximum size
setopt hist_expire_dups_first

# Ignore duplicated commands
setopt hist_ignore_dups

# Ignore commands that start with space
setopt hist_ignore_space

# Show command with history expansion before running it
setopt hist_verify

### Key bindings ###

autoload zsh/terminfo

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# [Space] - don't do history expansion
bindkey ' ' magic-space

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

#### Prompt ###

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%F{cyan}[%b]%f%u%c "
zstyle ':vcs_info:git*' actionformats "%F{cyan}[%b](%a)%f%u%c "
precmd() {
    vcs_info

    if [[ -n ${vcs_info_msg_0_} ]]; then
      STATUS=$(git status --porcelain --untracked-files=no 2> /dev/null | tail -n 1)
      if [[ -n $STATUS ]]; then
        vcs_info_msg_0_="${vcs_info_msg_0_}%F{red}⏺%f "
      else
        vcs_info_msg_0_="${vcs_info_msg_0_}%F{8}⏺%f "
      fi
    fi
}

autoload -Uz promptinit && promptinit
setopt prompt_subst
PROMPT='%B%F{yellow}%c%b%f ${vcs_info_msg_0_}%(?:%F{green}:%F{red})⏵%f '

### Command options ###

autoload -U colors && colors

export CLICOLOR=true
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export GREP_OPTIONS='--color=auto'

### Completion ###

autoload -Uz compinit && compinit

# Menu style completion
zstyle ':completion:*:*:*:*:*' menu select

# Case insensitive, partial-word and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# Disable named directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Load bash completion functions
autoload -U +X bashcompinit && bashcompinit

### Plugins ###

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

### Source additional files ###
if [ -d ~/.zshrc.d ]; then
  for file in ~/.zshrc.d/*; do
    [ -r "$file" ] && source "$file"
  done
fi

### Named directories ###

hash -d icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

if [ -d "$HOME/Library/Mobile Documents/iCloud~md~obsidian/" ]; then
  hash -d obsidian="$HOME/Library/Mobile Documents/iCloud~md~obsidian/"
fi

### Aliases ###

alias ll="ls -1"
alias la="ls -1A"
alias sg="conda run --no-capture-output -n sage sage"

if [[ $(command -v yt-dlp) != "" ]]; then
  alias ytdv="yt-dlp -f \"bestvideo[ext=mp4]+bestaudio[acodec=aac]/bestvideo+bestaudio/best\" --merge-output-format mp4,mkv --embed-metadata --embed-thumbnail --embed-chapters --no-warnings"
  alias ytda="yt-dlp --embed-metadata --embed-thumbnail -x --audio-format mp3"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
