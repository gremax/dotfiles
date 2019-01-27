all:
	ansible-playbook all.yml -i local -vv -K

osx-brew:
	ansible-playbook osx-brew.yml -i local -vvvv -K

tmux:
	ansible-playbook tmux.yml -i local -vv -K

vim:
	ansible-playbook vim.yml -i local -vv -K
