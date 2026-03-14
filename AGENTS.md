# AGENTS.md

Guidance for agentic coding assistants working in this chezmoi dotfiles repository.

## Repository Overview
- Purpose: cross-platform developer environment configuration.
- Targets: macOS (Apple Silicon), Debian/Ubuntu, Arch Linux.
- Main file types: shell scripts, chezmoi templates, TOML configs, Lua configs.
- There is no application build pipeline in this repo.

## Primary References
- Start with `CLAUDE.md` for architecture and machine context.
- Follow chezmoi naming semantics and template behavior.
- Preserve platform gates (`.chezmoi.os`) and machine gates (`.machineType`).

## Cursor/Copilot Rules Status
- `.cursorrules`: not found.
- `.cursor/rules/`: not found.
- `.github/copilot-instructions.md`: not found.
- If any are added later, import their instructions here and follow the stricter rule on conflicts.

## Core Commands
```bash
chezmoi cd                 # enter source dir
chezmoi diff               # preview what would change in $HOME
chezmoi apply              # apply managed files
chezmoi update             # pull latest + apply
chezmoi edit ~/.zshrc      # edit a managed target
```

## Build/Lint/Test Guidance
There is no centralized `make test` or CI lint job.
Validation is file-type specific.

### Baseline validation
```bash
chezmoi diff
chezmoi apply
```

### Shell syntax checks
Use for non-template scripts:
```bash
bash -n home/.chezmoiscripts/run_once_install-zinit.sh
```

### Single-test equivalent (important)
When you need to validate one changed file only:

1) Non-template shell script
```bash
bash -n path/to/script.sh
```

2) Template shell script (`*.sh.tmpl`)
```bash
chezmoi execute-template < home/.chezmoiscripts/run_onchange_install-packages.sh.tmpl > /tmp/install-packages.sh
bash -n /tmp/install-packages.sh
```

3) Optional stricter lint (if installed)
```bash
shellcheck /tmp/install-packages.sh
```

### Single template render check
For one changed template (non-shell lint):
```bash
chezmoi execute-template < home/dot_zshrc.tmpl > /tmp/zshrc.rendered
chezmoi execute-template < home/dot_gitconfig.tmpl > /tmp/gitconfig.rendered
```

### Optional tooling
- `shellcheck` and `shfmt` are useful but not configured as required in-repo.
- Do not add mandatory tooling unless the user asks.

## Expected Agent Workflow
1. Inspect nearby files and preserve established style.
2. Make minimal, scoped edits.
3. Run file-scoped validation for touched files.
4. Run `chezmoi diff` to verify resulting home changes.
5. Run `chezmoi apply` when safe in local context.
6. Report what you validated and what you skipped.

### Local drift handling
- If chezmoi reports `<path> has changed since chezmoi last wrote it`, do not overwrite local changes by default.
- When the user wants to keep local machine state, run `chezmoi re-add <path>` to adopt local content into source state.
- Example: `chezmoi re-add ~/.config/opencode/opencode.json`
- After re-adding, run `chezmoi diff` and verify the conflict is resolved.

## Code Style Rules

### General
- Prefer small diffs over broad refactors.
- Keep ASCII unless target file already uses Unicode.
- Do not add comments unless they clarify non-obvious intent.
- Keep secrets and host-specific credentials out of tracked files.

### Naming and file conventions
- `dot_` prefix maps to `.` in home directory.
- `private_` prefix means stricter permissions.
- `run_once_` scripts run once per machine.
- `run_onchange_` scripts rerun when file hash changes.
- `.tmpl` files are Go templates; preserve template delimiters and spacing.
- Use kebab-case action names for scripts.

### Shell style
- Use `#!/bin/bash` for bash scripts unless intentionally zsh-only.
- Prefer `set -euo pipefail` in executable automation scripts.
- Quote variable expansions unless unquoted form is intentional.
- Use `$(...)` instead of backticks.
- Guard optional tools with `command -v tool > /dev/null`.
- Prefer idempotent operations so reruns are safe.
- Use early exits for unsupported platforms/conditions.

### Error handling
- Fail fast for required steps.
- For optional steps, print a clear warning and continue intentionally.
- Do not hide failures silently; if using `|| true`, document why.
- Return non-zero on unrecoverable paths.

### Formatting
- Match existing indentation in each file.
- Keep section separators and grouping style used in current dotfiles.
- Keep lines readable; avoid unnecessary reflow churn.
- Preserve surrounding quote style unless there is a reason to normalize.

### Imports/dependencies/types
- Lua: place `require(...)` calls at top of file.
- Shell: avoid adding new dependencies without clear need.
- If adding a dependency, update package install template for each supported platform.
- This repo has no static type system; enforce "type safety" via explicit runtime checks.

### Config file conventions
- TOML arrays/maps should remain logically grouped.
- Keep comments that explain platform or workflow rationale.
- Do not reorder large sections unless required for correctness.

## Platform and Scope Guardrails
- Keep darwin-specific settings behind darwin checks.
- Keep server machine-type safe (no GUI assumptions).
- Preserve Linux distro branching (`apt` vs `pacman`) behavior.
- Avoid breaking bootstrap on fresh machines.

## External Repos
- Managed via `.chezmoiexternal.toml`.
- Do not vendor external repo contents here.
- If a change depends on external repo behavior, note it explicitly.

## Git and Safety
- Do not revert unrelated user changes.
- Avoid destructive git commands unless explicitly requested.
- Never commit machine-local secrets.
- Keep edits reversible and well-scoped.

## What To Include In Completion Notes
- Files changed.
- Commands run.
- Which checks were file-scoped vs full apply.
- Any skipped checks and the reason.
