---@type vim.lsp.Config

return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.api.nvim_get_runtime_file("lua", false)[1],
        --   vim.env.VIMRUNTIME,
        --   "${3rd}/luv/library",
        -- },
        library = vim.api.nvim_get_runtime_file("lua", true),
      },
    },
  },
}
