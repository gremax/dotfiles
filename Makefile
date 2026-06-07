all:
	ansible-playbook -i local -vv all.yml

macos-brew:
	ansible-playbook -i local -vv macos-brew.yml

tmux:
	ansible-playbook -i local -vv tmux.yml

neovim:
	ansible-playbook -i local -vv neovim.yml

neovim-lua:
	ansible-playbook -i local -vv neovim-lua.yml

vim:
	ansible-playbook -i local -vv vim.yml

kitty:
	ansible-playbook -i local -vv kitty.yml

configs:
	ansible-playbook -i local -vv configs.yml
