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
