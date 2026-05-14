vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/nvim-lualine/lualine.nvim",

  "https://github.com/folke/which-key.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/folke/todo-comments.nvim",
})

require("lualine").setup({
  options = {
    section_separators = { left = "", right = "", },
    component_separators = { left = "", right = "", },
  },
})
require("which-key").setup({
  preset = "helix",
  spec = {
    { "<leader>s", group = "[S]earch", icon = { icon = "", color = "green", }, },
  }
})
require("nvim-autopairs").setup()
require("todo-comments").setup()
