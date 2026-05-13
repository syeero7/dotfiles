local keymaps = {
  { keys = "<leader>ca", func = vim.lsp.buf.code_action,           desc = "Code Actions" },
  { keys = "<leader>cr", func = vim.lsp.buf.rename,                desc = "Code Rename" },
  { keys = "<leader>cw", func = vim.lsp.buf.workspace_diagnostics, desc = "Workspace Diagnostics" },
  {
    keys = "<leader>cl",
    func = function()
      if vim.fn.exists(":LspOxlintFixAll") > 0 then
        vim.cmd("LspOxlintFixAll")
      end
      vim.lsp.buf.code_action(
        { apply = true, context = { only = { "source.fixAll" }, diagnostics = {} } })
    end,
    desc = "LSP Fix All",
  },
  { keys = "<S-k>", func = vim.lsp.buf.hover,           desc = "Hover Documentation",  has = "hoverProvider" },
  { keys = "gd",    func = vim.lsp.buf.definition,      desc = "Goto Definition",      has = "definitionProvider" },
  { keys = "gr",    func = vim.lsp.buf.references,      desc = "Goto References",      has = "referencesProvider" },
  { keys = "gi",    func = vim.lsp.buf.implementation,  desc = "Goto Implementation",  has = "implementationProvider" },
  { keys = "gt",    func = vim.lsp.buf.type_definition, desc = "Goto Type Definition", has = "typeDefinitionProvider" },
  { keys = "gl",    func = vim.lsp.codelens.run,        desc = "Run Codelens",         has = "codeLensProvider" },
}


local completion = vim.g.completion_mode or "blink"
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    local buf = args.buf
    if completion == "native" and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, { bufnr = buf }, {
        style = "virtual",
      })
    end

    for _, km in ipairs(keymaps) do
      if not km.has or client.server_capabilities[km.has] then
        opts = { buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
        vim.keymap.set(km.mode or "n", km.keys, km.func, opts)
      end
    end
  end,
})


vim.lsp.enable({
  -- "vtsls",
  "oxlint", -- Priority linter
  "lua_ls",
  "gopls",
  "zls",
  -- "cssls",
  -- "html",
  -- "helm_ls",
  -- "jsonls",
})
