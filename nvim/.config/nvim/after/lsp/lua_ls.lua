---@type vim.lsp.Config

return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.env.VIMRUNTIME,
        --   vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        -- },
        library = vim.api.nvim_get_runtime_file("lua", true),
      },
    },
  },
}
