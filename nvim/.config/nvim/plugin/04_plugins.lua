local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

now(function()
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })

  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)


now(function() require('mini.files').setup() end)
now(function() require('mini.notify').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)
now(function()
  require('mini.sessions').setup({
    autoread = false,
    autowrite = false,
    directory = '~/.vim/sessions',
    file = ''
  })
end)
now(function()
  local starter = require('mini.starter')
  local ascii_art = {
    [[                                                    ]],
    [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
    [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
    [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
    [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
    [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
    [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
    [[                                                    ]],
  }

  starter.setup({
    header = table.concat(ascii_art, "\n"),
    items = {
      starter.sections.sessions(5, true),
      starter.sections.builtin_actions(),
      starter.sections.recent_files(5, nil, false),
      starter.sections.pick(),
    },
  })
end)

now_if_args(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  })
  local on_attach = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end

  Config.new_autocmd('LspAttach', nil, on_attach, "Set 'omnifunc'")

  vim.lsp.config('*', {
    capabilities = vim.tbl_extend("keep",
      MiniCompletion.get_lsp_capabilities(),
      vim.lsp.protocol.make_client_capabilities()
    )
  })
end)

later(function() require('mini.extra').setup() end)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },

    search_method = 'cover',
  })
end)

later(function()
  local miniclue = require('mini.clue')
  -- stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },

    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' }, -- Leader triggers
      { mode = 'n',          keys = '\\' },       -- mini.basics
      { mode = { 'n', 'x' }, keys = '[' },        -- mini.bracketed
      { mode = { 'n', 'x' }, keys = ']' },
      { mode = 'i',          keys = '<C-x>' },    -- Built-in completion
      { mode = { 'n', 'x' }, keys = 'g' },        -- `g` key
      { mode = { 'n', 'x' }, keys = "'" },        -- Marks
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },        -- Registers
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode = 'n',          keys = '<C-w>' },    -- Window commands
      { mode = { 'n', 'x' }, keys = 's' },        -- `s` key (mini.surround, etc.)
      { mode = { 'n', 'x' }, keys = 'z' },        -- `z` key
    },
  })
end)

later(function() require('mini.cmdline').setup() end)
later(function() require('mini.diff').setup() end)
later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function() require('mini.indentscope').setup({ symbol = "│" }) end)
later(function() require('mini.pairs').setup({ modes = { command = true } }) end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function()
  local latex_patterns = { 'latex/**/*.json', '**/latex.json' }
  local lang_patterns = {
    tex = latex_patterns,
    plaintex = latex_patterns,
    markdown_inline = { 'markdown.json' },
  }

  local snippets = require('mini.snippets')
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
  })

  MiniSnippets.start_lsp_server()
end)

now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    {
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
      version = "main",
      build = ":TSUpdate",
    },
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  local parsers = {
    "go",
    "zig",
    "lua",
    "javascript",
    "typescript",
    "json",
    "markdown",
    "bash",
    "html",
    "css",
    "sql"
  }

  local tree_sitter = require("nvim-treesitter")
  tree_sitter.setup({})

  local installed = tree_sitter.get_installed()
  local to_install = {}

  for _, parser in ipairs(parsers) do
    if not vim.tbl_contains(installed, parser) then table.insert(to_install, parser) end
  end

  if #to_install > 0 then tree_sitter.install(to_install) end
  Config.new_autocmd("FileType", nil, function(args)
    if vim.list_contains(tree_sitter.get_installed(), vim.treesitter.get_parser(args.buf)) then
      vim.treesitter.start(args.buf)
    end
  end)
end)

now_if_args(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })

  vim.lsp.enable({
    "vtsls",
    "oxlint",
    "lua_ls",
    "gopls",
    "zls",
    "cssls",
    "html",
    "svelte",
    "jsonls",
    "codebook"
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
  Config.set_diagnostics_keymaps()
end)

later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {
      -- lua = { "stylua" },
      go = { "gofmt" },
      -- python = { "ruff_format", "isort", "black", stop_after_first = true },
      json = { "oxfmt" },
      jsonc = { "oxfmt" },
      javascript = { "oxfmt" },
      typescript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescriptreact = { "oxfmt" },
      svelte = { "oxfmt" },
      css = { "oxfmt" },
      html = { "oxfmt" },
      yaml = { "oxfmt" },
      markdown = { "oxfmt" },
    },

    format_on_save = function(buf)
      local ignore_filetypes = { "sql" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[buf].filetype) then
        return
      end

      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
        return
      end

      if vim.api.nvim_buf_get_name(buf):match("/node_modules/") then
        return
      end

      return { timeout_ms = 500, lsp_format = "fallback" }
    end
  })

  vim.api.nvim_create_user_command("FormatDisable", function(opts)
    if opts.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
    vim.notify("Autoformat disabled" .. (opts.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
  end, { desc = "Disable autoformat-on-save", bang = true })

  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
    vim.notify("Autoformat enabled", vim.log.levels.INFO)
  end, { desc = "Re-enable autoformat-on-save" })

  vim.keymap.set("n", "<leader>of", function()
    if vim.b.disable_autoformat or vim.g.disable_autoformat then
      vim.cmd("FormatEnable")
    else
      vim.cmd("FormatDisable")
    end
  end, { desc = "Toggle Autoformat" })

  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true }, function(err, did_edit)
      if not err and did_edit then
        vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
      end
    end)
  end, { desc = "Format buffer" })
end)
