# Theme Expansion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Expand themes.toml from 7 to 23 themes, covering all Omarchy official themes plus popular extras.

**Architecture:** Add 16 new theme sections to `.chezmoidata/themes.toml` with consistent semantic color keys. Update CLAUDE.md and the dotfiles-config skill to reflect the new theme list.

**Tech Stack:** Chezmoi data files (TOML), no code changes.

---

### Task 1: Add Omarchy official dark themes (6 themes)

**Files:**
- Modify: `.chezmoidata/themes.toml` (append after dracula section, line 126)

**Step 1: Add ethereal, everforest, miasma, hackerman, osaka-jade, ristretto**

Append to `.chezmoidata/themes.toml`:

```toml
[themes.ethereal]
bg             = "#060B1E"
fg             = "#ffcead"
muted          = "#6d7db6"
accent         = "#7d82d9"
green          = "#92a593"
red            = "#ED5B5A"
yellow         = "#E9BB4F"
orange         = "#F99957"
purple         = "#c89dc1"
teal           = "#a3bfd1"
git_clean      = "#92a593"
git_dirty      = "#F99957"
git_staged     = "#7d82d9"
git_stash      = "#c89dc1"
wezterm_scheme = "Tokyo Night"
delta_theme    = "Monokai Extended"

[themes.everforest]
bg             = "#2D353B"
fg             = "#D3C6AA"
muted          = "#7A8478"
accent         = "#7FBBB3"
green          = "#A7C080"
red            = "#E67E80"
yellow         = "#DBBC7F"
orange         = "#E69875"
purple         = "#D699B6"
teal           = "#83C092"
git_clean      = "#A7C080"
git_dirty      = "#E69875"
git_staged     = "#7FBBB3"
git_stash      = "#D699B6"
wezterm_scheme = "Everforest Dark (Gogh)"
delta_theme    = "Monokai Extended"

[themes.miasma]
bg             = "#222222"
fg             = "#C2C2B0"
muted          = "#666666"
accent         = "#C9A554"
green          = "#5F875F"
red            = "#685742"
yellow         = "#D7C483"
orange         = "#B36D43"
purple         = "#BB7744"
teal           = "#78824B"
git_clean      = "#5F875F"
git_dirty      = "#B36D43"
git_staged     = "#C9A554"
git_stash      = "#BB7744"
wezterm_scheme = "zenburn"
delta_theme    = "zenburn"

[themes.hackerman]
bg             = "#0B0C16"
fg             = "#ddf7ff"
muted          = "#6a6e95"
accent         = "#82FB9C"
green          = "#50f872"
red            = "#85E1FB"
yellow         = "#50f7d4"
orange         = "#7cf8f7"
purple         = "#86a7df"
teal           = "#7cf8f7"
git_clean      = "#50f872"
git_dirty      = "#85E1FB"
git_staged     = "#82FB9C"
git_stash      = "#86a7df"
wezterm_scheme = "Homebrew"
delta_theme    = "Monokai Extended"

[themes.osaka-jade]
bg             = "#111c18"
fg             = "#C1C497"
muted          = "#53685B"
accent         = "#509475"
green          = "#549e6a"
red            = "#FF5345"
yellow         = "#E5C736"
orange         = "#db9f9c"
purple         = "#D2689C"
teal           = "#2DD5B7"
git_clean      = "#549e6a"
git_dirty      = "#db9f9c"
git_staged     = "#509475"
git_stash      = "#D2689C"
wezterm_scheme = "Solarized Dark (Gogh)"
delta_theme    = "Monokai Extended"

[themes.ristretto]
bg             = "#2c2525"
fg             = "#e6d9db"
muted          = "#948a8b"
accent         = "#f38d70"
green          = "#adda78"
red            = "#fd6883"
yellow         = "#f9cc6c"
orange         = "#f38d70"
purple         = "#a8a9eb"
teal           = "#85dacc"
git_clean      = "#adda78"
git_dirty      = "#f38d70"
git_staged     = "#85dacc"
git_stash      = "#a8a9eb"
wezterm_scheme = "Monokai Remastered"
delta_theme    = "Monokai Extended"
```

**Step 2: Verify with chezmoi**

Run: `chezmoi data | grep -A1 ethereal`
Expected: Shows the ethereal theme data.

**Step 3: Commit**

```bash
git add .chezmoidata/themes.toml
git commit -m "add omarchy official dark themes: ethereal, everforest, miasma, hackerman, osaka-jade, ristretto"
```

---

### Task 2: Add monochrome/minimal themes (2 themes)

**Files:**
- Modify: `.chezmoidata/themes.toml` (append)

**Step 1: Add matte-black, vantablack**

Append to `.chezmoidata/themes.toml`:

```toml
[themes.matte-black]
bg             = "#121212"
fg             = "#bebebe"
muted          = "#8a8a8d"
accent         = "#e68e0d"
green          = "#FFC107"
red            = "#D35F5F"
yellow         = "#e68e0d"
orange         = "#e68e0d"
purple         = "#D35F5F"
teal           = "#bebebe"
git_clean      = "#FFC107"
git_dirty      = "#D35F5F"
git_staged     = "#e68e0d"
git_stash      = "#8a8a8d"
wezterm_scheme = "Builtin Tango Dark"
delta_theme    = "Monokai Extended"

[themes.vantablack]
bg             = "#0d0d0d"
fg             = "#ffffff"
muted          = "#8d8d8d"
accent         = "#cecece"
green          = "#b6b6b6"
red            = "#a4a4a4"
yellow         = "#cecece"
orange         = "#9b9b9b"
purple         = "#9b9b9b"
teal           = "#b0b0b0"
git_clean      = "#b6b6b6"
git_dirty      = "#a4a4a4"
git_staged     = "#cecece"
git_stash      = "#9b9b9b"
wezterm_scheme = "Grayscale (dark) (terminal.sexy)"
delta_theme    = "Monokai Extended"
```

**Step 2: Commit**

```bash
git add .chezmoidata/themes.toml
git commit -m "add monochrome themes: matte-black, vantablack"
```

---

### Task 3: Add light themes (3 themes)

**Files:**
- Modify: `.chezmoidata/themes.toml` (append)

**Step 1: Add flexoki-light, catppuccin-latte, white**

Append to `.chezmoidata/themes.toml`:

```toml
[themes.flexoki-light]
bg             = "#FFFCF0"
fg             = "#100F0F"
muted          = "#878580"
accent         = "#205EA6"
green          = "#879A39"
red            = "#D14D41"
yellow         = "#D0A215"
orange         = "#DA702C"
purple         = "#8B7EC8"
teal           = "#3AA99F"
git_clean      = "#879A39"
git_dirty      = "#DA702C"
git_staged     = "#205EA6"
git_stash      = "#8B7EC8"
wezterm_scheme = "flexoki-light"
delta_theme    = "GitHub"

[themes.catppuccin-latte]
bg             = "#EFF1F5"
fg             = "#4C4F69"
muted          = "#9CA0B0"
accent         = "#1E66F5"
green          = "#40A02B"
red            = "#D20F39"
yellow         = "#DF8E1D"
orange         = "#FE640B"
purple         = "#8839EF"
teal           = "#179299"
git_clean      = "#40A02B"
git_dirty      = "#FE640B"
git_staged     = "#1E66F5"
git_stash      = "#8839EF"
wezterm_scheme = "Catppuccin Latte"
delta_theme    = "Catppuccin Latte"

[themes.white]
bg             = "#ffffff"
fg             = "#000000"
muted          = "#6e6e6e"
accent         = "#1a1a1a"
green          = "#3a3a3a"
red            = "#2a2a2a"
yellow         = "#4a4a4a"
orange         = "#2e2e2e"
purple         = "#2e2e2e"
teal           = "#3e3e3e"
git_clean      = "#3a3a3a"
git_dirty      = "#2a2a2a"
git_staged     = "#1a1a1a"
git_stash      = "#4a4a4a"
wezterm_scheme = "Grayscale (light) (terminal.sexy)"
delta_theme    = "GitHub"
```

**Step 2: Commit**

```bash
git add .chezmoidata/themes.toml
git commit -m "add light themes: flexoki-light, catppuccin-latte, white"
```

---

### Task 4: Add extras themes (5 themes)

**Files:**
- Modify: `.chezmoidata/themes.toml` (append)

**Step 1: Add flexoki-dark, solarized-dark, one-dark-pro, monokai, eldritch**

Append to `.chezmoidata/themes.toml`:

```toml
[themes.flexoki-dark]
bg             = "#100F0F"
fg             = "#CECDC3"
muted          = "#6F6E69"
accent         = "#4385BE"
green          = "#879A39"
red            = "#D14D41"
yellow         = "#D0A215"
orange         = "#DA702C"
purple         = "#8B7EC8"
teal           = "#3AA99F"
git_clean      = "#879A39"
git_dirty      = "#DA702C"
git_staged     = "#4385BE"
git_stash      = "#8B7EC8"
wezterm_scheme = "flexoki-dark"
delta_theme    = "Monokai Extended"

[themes.solarized-dark]
bg             = "#002B36"
fg             = "#839496"
muted          = "#586E75"
accent         = "#268BD2"
green          = "#859900"
red            = "#DC322F"
yellow         = "#B58900"
orange         = "#CB4B16"
purple         = "#6C71C4"
teal           = "#2AA198"
git_clean      = "#859900"
git_dirty      = "#CB4B16"
git_staged     = "#268BD2"
git_stash      = "#6C71C4"
wezterm_scheme = "Solarized (dark) (terminal.sexy)"
delta_theme    = "Solarized (dark)"

[themes.one-dark-pro]
bg             = "#282C34"
fg             = "#ABB2BF"
muted          = "#5C6370"
accent         = "#61AFEF"
green          = "#98C379"
red            = "#E06C75"
yellow         = "#E5C07B"
orange         = "#D19A66"
purple         = "#C678DD"
teal           = "#56B6C2"
git_clean      = "#98C379"
git_dirty      = "#D19A66"
git_staged     = "#61AFEF"
git_stash      = "#C678DD"
wezterm_scheme = "One Dark (Gogh)"
delta_theme    = "OneHalfDark"

[themes.monokai]
bg             = "#2D2A2E"
fg             = "#FCFCFA"
muted          = "#727072"
accent         = "#78DCE8"
green          = "#A9DC76"
red            = "#FF6188"
yellow         = "#FFD866"
orange         = "#FC9867"
purple         = "#AB9DF2"
teal           = "#78DCE8"
git_clean      = "#A9DC76"
git_dirty      = "#FC9867"
git_staged     = "#78DCE8"
git_stash      = "#AB9DF2"
wezterm_scheme = "Monokai Pro (Gogh)"
delta_theme    = "Monokai Extended"

[themes.eldritch]
bg             = "#212337"
fg             = "#EBFAFA"
muted          = "#7081D0"
accent         = "#04D1F9"
green          = "#37F499"
red            = "#F16C75"
yellow         = "#F1FC79"
orange         = "#F7C67F"
purple         = "#A48CF2"
teal           = "#04D1F9"
git_clean      = "#37F499"
git_dirty      = "#F7C67F"
git_staged     = "#04D1F9"
git_stash      = "#A48CF2"
wezterm_scheme = "Eldritch"
delta_theme    = "Monokai Extended"
```

**Step 2: Verify all 23 themes load**

Run: `chezmoi data | grep 'themes\.' | wc -l`
Expected: Should show entries for all 23 themes.

**Step 3: Commit**

```bash
git add .chezmoidata/themes.toml
git commit -m "add extras themes: flexoki-dark, solarized-dark, one-dark-pro, monokai, eldritch"
```

---

### Task 5: Update documentation and skill

**Files:**
- Modify: `/Users/rickcopra/.local/share/chezmoi/CLAUDE.md` — update `.theme` variable docs
- Modify: `/Users/rickcopra/.claude/skills/dotfiles-config/skill.md` — update available themes list

**Step 1: Update CLAUDE.md**

Find the `.theme` line and update with full theme list.

**Step 2: Update dotfiles-config skill**

Find the "Available themes" line and update with full theme list.

**Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update theme list to 23 themes"
```

---

### Task 6: Smoke test a theme switch

**Step 1: Switch to a new theme to verify**

Pick one new theme (e.g., everforest) and run through the dotfiles-config skill's theme switch workflow:
- Edit chezmoi.toml to set theme
- Run chezmoi apply
- Verify templated configs render with correct colors
- Check oh-my-posh gets the right palette from the official theme

**Step 2: Switch back to dracula**

Restore the user's current theme.
