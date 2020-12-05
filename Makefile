all:
	ansible-playbook -i local -vv all.yml

osx-brew:
	ansible-playbook -i local -vv osx-brew.yml

tmux:
	ansible-playbook -i local -vv tmux.yml

neovim:
	ansible-playbook -i local -vv neovim.yml

vim:
	ansible-playbook -i local -vv vim.yml

configs:
	ansible-playbook -i local -vv configs.yml
