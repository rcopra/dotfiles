# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Catppuccin Mocha colors
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#2d312c,bg:#232923,spinner:#dc4f62,hl:#dc4f62 \
  --color=fg:#ece1c0,header:#dc4f62,info:#88c1e9,pointer:#81af58 \
  --color=marker:#81af58,fg+:#81af58,prompt:#81af58,hl+:#dc4f62 \
  --color=selected-bg:#363b35 \
  "

# Use fzf shell integration
command -v fzf > /dev/null && source <(fzf --zsh)
