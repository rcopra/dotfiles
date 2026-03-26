# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Gruvbox Material Mix (Hard) colors
export FZF_DEFAULT_OPTS="
  --color=fg:#e2cca9,bg:#1d2021,hl:#e9b143
  --color=fg+:#e2cca9,bg+:#3c3836,hl+:#e9b143
  --color=border:#504945,header:#80aa9e,gutter:#1d2021
  --color=spinner:#f28534,info:#8bba7f
  --color=pointer:#d3869b,marker:#f2594b,prompt:#928374
"

# Use fzf shell integration
command -v fzf > /dev/null && source <(fzf --zsh)
