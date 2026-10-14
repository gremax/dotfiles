# Dotfiles

## Preparation

Homebrew should be installed.

Install Ansible:

```
brew install ansible
```

Clone dotfiles:

```
git clone git@github.com:gremax/dotfiles.git ~/.dotfiles
```

## Install

Run to install `tmux`, `vim`, `fzf`, `ripgrep` and create symlinks:

```
cd ~/.dotfiles && make
```

## Initial setup

Only first time run into vim:

```
:PlugInstall
```

## agterm

```
cd ~/.dotfiles && make agterm
```

Installs agterm, lazygit and yazi, and links `files/agterm` into `~/.config/agterm`. On a new machine:
launch agterm, run **Help ▸ Install Agent Status Hooks**, then `make agterm` again. The second run adds the
status hooks to every Claude config dir that exists (`~/.claude`, `~/.claude-personal`, `~/.claude-work`)
and sets restore mode and theme, which need a running agterm.
