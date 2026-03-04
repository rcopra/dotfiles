# Theme Expansion Design

## Goal

Expand themes.toml from 7 themes to 23 themes, matching all Omarchy official themes plus popular extras.

## Theme List

### Existing (7) — no changes
kanagawa, catppuccin-mocha, tokyo-night, gruvbox-dark, rose-pine, nord, dracula

### New from Omarchy official (11)

| Theme | bg | fg | muted | accent | wezterm_scheme |
|-------|----|----|-------|--------|----------------|
| ethereal | #060B1E | #ffcead | #6d7db6 | #7d82d9 | Tokyo Night (fallback) |
| everforest | #2D353B | #D3C6AA | #7A8478 | #7FBBB3 | Everforest Dark (Gogh) |
| miasma | #222222 | #C2C2B0 | #666666 | #C9A554 | zenburn (fallback) |
| hackerman | #0B0C16 | #ddf7ff | #6a6e95 | #82FB9C | Homebrew (fallback) |
| osaka-jade | #111c18 | #C1C497 | #53685B | #509475 | Solarized Dark (Gogh) (fallback) |
| matte-black | #121212 | #bebebe | #8a8a8d | #e68e0d | Builtin Tango Dark (fallback) |
| vantablack | #0d0d0d | #ffffff | #8d8d8d | #8d8d8d | Grayscale Dark (Gogh) (fallback) |
| ristretto | #2c2525 | #e6d9db | #948a8b | #f38d70 | Monokai Remastered (fallback) |
| flexoki-light | #FFFCF0 | #100F0F | #878580 | #205EA6 | flexoki-light |
| catppuccin-latte | #EFF1F5 | #4C4F69 | #9CA0B0 | #1E66F5 | Catppuccin Latte |
| white | #ffffff | #000000 | #6e6e6e | #6e6e6e | Grayscale Light (Gogh) (fallback) |

### New from extras (5)

| Theme | bg | fg | muted | accent | wezterm_scheme |
|-------|----|----|-------|--------|----------------|
| flexoki-dark | #100F0F | #CECDC3 | #6F6E69 | #4385BE | flexoki-dark |
| solarized-dark | #002B36 | #839496 | #586E75 | #268BD2 | Solarized (dark) (terminal.sexy) |
| one-dark-pro | #282C34 | #ABB2BF | #5C6370 | #61AFEF | One Dark (Gogh) |
| monokai | #2D2A2E | #FCFCFA | #727072 | #78DCE8 | Monokai Pro (Gogh) |
| eldritch | #212337 | #EBFAFA | #7081D0 | #04D1F9 | Eldritch |

## Design Decisions

- **WezTerm fallbacks**: Themes without built-in WezTerm schemes use best-match fallback. User can define custom schemes later.
- **Monochrome themes** (vantablack, white): All colors are grayscale. Git status colors use different gray shades for contrast.
- **Unconventional palettes** (hackerman, miasma): Map to closest available colors in the palette.
- **Light themes** (flexoki-light, catppuccin-latte, white): Use standard semantic keys; may need tmux/FZF contrast tweaks after testing.
- **git_* convention**: git_clean=green, git_dirty=orange, git_staged=accent, git_stash=purple (matching existing patterns).
- **delta_theme**: Use "Monokai Extended" as fallback for themes without a delta equivalent.

## Files Changed

1. `.chezmoidata/themes.toml` — add 16 new theme sections
2. `CLAUDE.md` — update theme list in docs
3. `.claude/skills/dotfiles-config/skill.md` — update available themes list

## Palette Sources

- Omarchy official: github.com/basecamp/omarchy/tree/master/themes
- Catppuccin Latte: github.com/catppuccin/palette
- Everforest: github.com/sainnhe/everforest/blob/master/palette.md
- Flexoki: github.com/kepano/flexoki
- Eldritch: github.com/eldritch-theme/eldritch SPEC.md
- Miasma: github.com/xero/miasma.nvim
- Solarized: ethanschoonover.com/solarized
- One Dark: github.com/Binaryify/OneDark-Pro
- Monokai Pro: monokai.pro
