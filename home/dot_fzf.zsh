# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#49473e,bg:#1f1f28,spinner:#957fb8,hl:#e46a78 \
  --color=fg:#ddd8bb,header:#7eb3c9,info:#7eb3c9,pointer:#957fb8 \
  --color=marker:#e5c283,fg+:#e6e0c2,prompt:#98bc6d,hl+:#ec818c \
  --color=selected-bg:#49495e \
  "

# Use fzf shell integration
command -v fzf > /dev/null && source <(fzf --zsh)
