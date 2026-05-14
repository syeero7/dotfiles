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

    for _, k in ipairs(keymaps) do
      if not k.has or client.server_capabilities[k.has] then
        local options = { buffer = buf, desc = "LSP: " .. k.desc, nowait = k.nowait }
        vim.keymap.set(k.mode or "n", k.keys, k.func, options)
      end
    end
  end,
})


vim.lsp.enable({
  -- "vtsls",
  "oxlint",
  "lua_ls",
  "gopls",
  "zls",
  -- "cssls",
  -- "html",
  -- "helm_ls",
  -- "jsonls",
})

vim.diagnostic.config({

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Diagnostic" })

local diagnostics = {
  { name = "Diagnostic", next = "]d", prev = "[d" },
  { severity = "ERROR", next = "]e", prev = "[e", name = "Error" },
  { severity = "WARN", next = "]w", prev = "[w", name = "Warning" },
}

for _, k in ipairs(diagnostics) do
  local severity = k.severity and vim.diagnostic.severity[k.severity] or nil

  local toNext = function()
    vim.diagnostic.jump({ count = 1, float = true, severity = severity })
  end

  local toPrev = function()
    vim.diagnostic.jump({ count = -1, float = true, severity = severity })
  end

  vim.keymap.set("n", k.next, toNext, { desc = "Next " .. k.name })
  vim.keymap.set("n", k.prev, toPrev, { desc = "Previous " .. k.name })
end
