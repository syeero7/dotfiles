vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.files").setup()
require("mini.diff").setup()
require("mini.pick").setup()
require("mini.icons").setup()
require("mini.sessions").setup()
require("mini.starter").setup()
require("mini.indentscope").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
local mini_hipatterns = require('mini.hipatterns')
local mini_clue = require("mini.clue")

mini_clue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'i',          keys = '<C-x>' },
    { mode = 'n',          keys = '<C-w>' },
    { mode = 'n',          keys = '[' },
    { mode = 'n',          keys = ']' },
  },
  clues = {
    { mode = 'n', keys = '<Leader>b', desc = 'Buffer' },
    { mode = 'n', keys = '<Leader>e', desc = 'Explore' },
    { mode = 'n', keys = '<Leader>f', desc = 'Find' },
    { mode = 'n', keys = '<Leader>q', desc = 'Session' },
    { mode = 'n', keys = '<Leader>c', desc = "LSP" },

    mini_clue.gen_clues.square_brackets(),
    mini_clue.gen_clues.builtin_completion(),
    mini_clue.gen_clues.marks(),
    mini_clue.gen_clues.registers(),
    mini_clue.gen_clues.windows(),
    mini_clue.gen_clues.g(),
    mini_clue.gen_clues.z(),
  },
})

local map = vim.keymap.set
map("n", "<leader>qn", "<cmd>mksession<CR>", { desc = "New Session" })
map("n", "<leader>qr", "<cmd>restart<CR>", { desc = "Restart" })
map("n", "<leader>qc", "<cmd>mksession!<CR>", { desc = "Clear Session" })


function exec_within_project_dir(command)
  return function()
    local old_lcd = vim.cmd("lcd")
    local new_lcd = vim.fs.root(0, ".git") or vim.api.nvim_buf_get_name(0)
    vim.cmd("lcd " .. new_lcd)
    vim.cmd(command)
    vim.cmd("lcd " .. old_lcd)
  end
end

map("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", { desc = "Explore (root)" })
map("n", "<leader>E", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", { desc = "Explore (file dir)" })

map("n", "<leader>fb", "<cmd>Pick buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fF", "<cmd>Pick files<CR>", { desc = "Find Files (root)" })
map("n", "<leader>fg", "<cmd>Pick grep_live<CR>", { desc = "Grep (root)" })
map("n", "<leader>ff", exec_within_project_dir("Pick files"), { desc = "Find Files (project root)" })
map("n", "<leader><space>", exec_within_project_dir("Pick files"), { desc = "Find Files (project root)" })
map("n", "<leader>/", exec_within_project_dir("Pick grep_live"), { desc = "Grep (proje:ct root)" })
map("n", "<leader>fh", "<cmd>Pick help<CR>", { desc = "Help" })

mini_hipatterns.setup({
  highlighters = {
    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = mini_hipatterns.gen_highlighter.hex_color(),
  },
})
