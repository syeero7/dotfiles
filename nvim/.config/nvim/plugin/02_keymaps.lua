-- disable LSP default keymaps
for _, k in ipairs({ "gra", "gri", "grr", "grn", "grt", "grx" }) do
  pcall(vim.keymap.del, { "n", "v" }, k)
end


Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = 'Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = 'Explore' },
  { mode = 'n', keys = '<Leader>f', desc = 'Find' },
  { mode = 'n', keys = '<Leader>c', desc = 'Code' },
  { mode = 'n', keys = '<Leader>q', desc = 'Session' },
}


Config.set_diagnostics_keymaps = function()
  local diagnostics = {
    { name = "Diagnostic", next = "]d", prev = "[d" },
    { severity = "ERROR",  next = "]e", prev = "[e", name = "Error" },
    { severity = "WARN",   next = "]w", prev = "[w", name = "Warning" },
    { severity = "INFO",   next = "]i", prev = "[i", name = "Information" },
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
end

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>ba", ":b#<CR>", { desc = "Alternate" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bo", ":w | %bdelete | edit# | bdelete# <CR>", { desc = "Close other buffers" })
map("n", "<leader>bq", function()
  vim.cmd("bdelete")
  if #vim.fn.bufname("%") == 0 then
    vim.cmd("q")
  end
end, { desc = "Close buffer" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Diagnostic" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
map("n", "<leader>cw", vim.lsp.buf.workspace_diagnostics, { desc = "Workspace Diagnostics" })
map("n", "<S-k>", vim.lsp.buf.hover, { desc = "Hover Documentation" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
map("n", "gx", vim.lsp.codelens.run, { desc = "Run Codelens" })
map("n", "cl", function()
  if vim.fn.exists(":LspOxlintFixAll") > 0 then vim.cmd("LspOxlintFixAll") end
  vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll" }, diagnostics = {} } })
end, { desc = "Fix ALL" })


map("n", "<leader>oc", string.format('<Cmd>edit %s<CR>', vim.fn.stdpath('config')), { desc = "Edit Config" })
map("n", "<leader>oh", "<Cmd>lua MiniNotify.show_history()<CR>", { desc = "Notifications" })
map("n", "<leader>ol", function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
end, { desc = "Location List" })
map("n", "<leader>oq", function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end, { desc = "Quickfix List" })


function exec_cmd(command, project_dir)
  return function()
    local old_lcd = vim.cmd("lcd")
    local new_lcd = vim.fn.getcwd()

    if project_dir then
      local root_markers = { ".git", "build.zig", "package.json", "go.mod" }
      new_lcd = vim.fs.root(0, root_markers) or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
    end

    vim.cmd("lcd " .. new_lcd)
    vim.cmd(command)
    vim.cmd("lcd " .. old_lcd)
  end
end

map("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", { desc = "Explore (root)" })
map("n", "<leader>E", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", { desc = "Explore (file dir)" })

map("n", "<leader>fb", "<cmd>Pick buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fF", exec_cmd("Pick files"), { desc = "Find Files (root)" })
map("n", "<leader>fg", exec_cmd("Pick grep_live"), { desc = "Grep (root)" })
map("n", "<leader>ff", exec_cmd("Pick files", true), { desc = "Find Files (project root)" })
map("n", "<leader><space>", exec_cmd("Pick files", true), { desc = "Find Files (project root)" })
map("n", "<leader>/", exec_cmd("Pick grep_live", true), { desc = "Grep (project root)" })
map("n", "<leader>fh", "<cmd>Pick help<CR>", { desc = "Help" })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit", silent = true })
map("n", "<leader>qr", "<cmd>restart<CR>", { desc = "Restart" })

map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
-- map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move Block Down" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move Block Up" })


local session_new = 'vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)'
map("n", "<leader>qd", "<Cmd>lua MiniSessions.select('delete')<CR>", { desc = "Delete Sessions" })
map("n", "<leader>ql", "<Cmd>lua MiniSessions.select('read')<CR>", { desc = "List Sessions" })
map("n", "<leader>qn", '<cmd>lua ' .. session_new .. '<CR>', { desc = "New Session" })
map("n", "<leader>qr", "<cmd>lua MiniSessions.restart()<CR>", { desc = "Restart" })
map("n", "<leader>qu", "<cmd>lua MiniSessions.write()<CR>", { desc = "Update Session" })

map("n", "<leader>u", function()
  vim.cmd("packadd nvim.undotree")
  require("undotree").open()
end, { desc = "Undo Tree" })

map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wq", "<C-W>c", { desc = "Close Window", remap = true })
map("n", "<leader>wh", "<C-W>s", { desc = "Split Window Horizontal", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Vertical", remap = true })

-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
map("v", "p", '"_dP', { noremap = true, silent = true })

map("n", "<leader>pu", "<cmd>lua vim.pack.update()<cr>", { desc = "Pack Update All" })
