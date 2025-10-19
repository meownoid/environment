# Preferences
export LANG="en_US.UTF-8"
export EDITOR="code --wait"
export HOMEBREW_NO_ENV_HINTS="true"
export HOMEBREW_NO_ANALYTICS="true"

# Homebrew
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"
fi

# Local
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# OpenJDK
if [ -d "/opt/homebrew/opt/openjdk" ]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
