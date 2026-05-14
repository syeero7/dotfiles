vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lsp")

require("plugins.tree-sitter")
require("plugins.blink")
require("plugins.conform")
