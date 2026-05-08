# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using GNU Stow for symlink management. Each top-level directory represents a stow package that can be independently deployed.

## Stow Package Structure

Each package follows the pattern `<package>/.config/<app>/` which stows to `~/.config/<app>/`:

- **aerospace/** - AeroSpace window manager config
- **claude/** - Claude Code CLI configuration
- **cmux/** - cmux terminal multiplexer config
- **ghostty/** - Ghostty terminal emulator config
- **hammerspoon/** - macOS automation scripts (Lua)
- **karabiner/** - Keyboard customization (JSON)
- **nvim/** - AstroNvim v4+ configuration (Lua)
- **stow/** - GNU Stow default target configuration
- **yazi/** - Yazi file manager config
- **zsh/** - Zsh shell config with Oh My Zsh

## Quick Start: Automated Installation

For new machines, use the automated installer:

```bash
# Clone repository
git clone https://github.com/obiyoag/my_dotfiles.git ~/my_dotfiles
cd ~/my_dotfiles

# Run installer (one command to configure everything)
./install.sh
```

The script will:
- Verify prerequisites (GNU Stow required)
- Deploy all configs via stow
- Configure Hammerspoon config path
- Verify all symlinks

**Requirements**: git, stow (others can be installed after)

## Manual Deployment (Advanced)

```bash
# Deploy a single package (from repo root)
stow <package>

# Deploy all packages
stow */

# Remove a package's symlinks
stow -D <package>
```

## Key Configuration Details

**Zsh**: Uses Oh My Zsh as plugin manager. Main entry is `~/.zshrc` → `~/.config/zsh/zshrc`. Machine-specific config (paths, tokens, conda env) goes in `~/.config/zsh/env.local.zsh` (not tracked in repo; see `env.local.zsh.example`).

**Neovim**: AstroNvim v4+ based. Plugin configs in `lua/plugins/`. Uses Lazy.nvim for plugin management. Theme is catppuccin-mocha.

**Hammerspoon**: Config loaded from `~/.config/hammerspoon/` (set via `defaults write` in install.sh, not the default `~/.hammerspoon/`).
