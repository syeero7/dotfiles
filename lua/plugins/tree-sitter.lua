vim.pack.add({ {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  version = "main",
  build = ":TSUpdate",
} })


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

local installed_parsers = tree_sitter.get_installed()
local parsers_to_install = {}

for _, parser in ipairs(parsers) do
  if not vim.tbl_contains(installed_parsers, parser) then
    table.insert(parsers_to_install, parser)
  end
end

if #parsers_to_install > 0 then
  tree_sitter.install(parsers_to_install)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("tree_sitter_config", { clear = false }),
  callback = function(args)
    if vim.list_contains(tree_sitter.get_installed(), vim.treesitter.get_parser(args.buf)) then
      vim.treesitter.start(args.buf)
    end
  end
})
