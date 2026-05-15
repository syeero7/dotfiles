vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
})

local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = group,
  once = true,
  callback = function()
    require("blink.cmp").setup({
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          -- treesitter_highlighting = true
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      keymap = {
        preset = "super-tab",

        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<Esc>'] = { 'cancel', 'fallback' },
      }
    })
  end,
})
