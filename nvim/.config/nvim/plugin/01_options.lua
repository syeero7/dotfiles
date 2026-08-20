vim.g.mapleader = " "
vim.g.maplocalleader = " "

Config.now(function()
  vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
  vim.cmd.colorscheme("tokyonight-moon")
end)

local opt                        = vim.opt

opt.number                       = true                             -- Line numbers
opt.relativenumber               = true                             -- Relative line numbers
opt.cursorline                   = true                             -- Highlight current line
opt.wrap                         = false                            -- Don't wrap lines
opt.scrolloff                    = 10                               -- Keep 10 lines above/below cursor
opt.sidescrolloff                = 10                               -- Keep 10 columns left/right of cursor
opt.tabstop                      = 2                                -- Tab width
opt.shiftwidth                   = 2                                -- Indent width
opt.softtabstop                  = 2                                -- Soft tab stop
opt.expandtab                    = true                             -- Use spaces instead of tabs

opt.smartindent                  = true                             -- Smart auto-indenting
opt.autoindent                   = true                             -- Copy indent from current line

opt.ignorecase                   = true                             -- Case insensitive search
opt.smartcase                    = true                             -- Case sensitive if uppercase in search
opt.hlsearch                     = true                             -- Highlight search results
opt.incsearch                    = true                             -- Show matches as you type

opt.termguicolors                = true                             -- Enable 24-bit colors
opt.signcolumn                   = "yes"                            -- Always show sign column
opt.showmatch                    = true                             -- Highlight matching brackets
opt.matchtime                    = 2                                -- How long to show matching bracket
opt.cmdheight                    = 1                                -- Command line height
opt.showmode                     = false                            -- Don't show mode in command line
opt.pumheight                    = 10                               -- Popup menu height
opt.pumblend                     = 10                               -- Popup menu transparency
opt.pummaxwidth                  = 60                               -- cap completion popup width
opt.winblend                     = 0                                -- Floating window transparency
opt.complete                     = '.,w,b,kspell'                   -- Use less sources
opt.completeopt                  = 'menuone,noselect,fuzzy,nosort'  -- Use custom behavior
opt.completetimeout              = 100                              -- Limit sources delay
-- opt.completeopt = "menu,menuone,noselect,popup" -- popup shows completionItem/resolve preview
opt.conceallevel                 = 2                                -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm                      = true                             -- Confirm to save changes before exiting modified buffer
opt.concealcursor                = ""                               -- Don't hide cursor line markup
opt.synmaxcol                    = 300                              -- Syntax highlighting limit
opt.ruler                        = false                            -- Disable the default ruler
opt.winminwidth                  = 5                                -- Minimum window width
opt.inccommand                   = "split"
opt.shada                        = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

opt.backup                       = false                            -- Don't create backup files
opt.writebackup                  = false                            -- Don't create backup before writing
opt.swapfile                     = false                            -- Don't create swap files
opt.undofile                     = true                             -- Persistent undo
opt.undolevels                   = 10000
opt.updatetime                   = 250
opt.timeoutlen                   = 1000               -- Which-key delay
opt.ttimeoutlen                  = 0                  -- Key code timeout
opt.autoread                     = true               -- Auto reload files changed outside vim
opt.autowrite                    = false              -- Don't auto save
opt.hidden                       = true               -- Allow hidden buffers
opt.errorbells                   = false              -- No error bells
opt.backspace                    = "indent,eol,start" -- Better backspace behavior
opt.autochdir                    = false              -- Don't auto change directory
opt.selection                    = "exclusive"        -- Selection behavior
opt.mouse                        = "a"                -- Enable mouse support
opt.modifiable                   = true               -- Allow buffer modifications
opt.encoding                     = "UTF-8"            -- Set encoding
opt.virtualedit                  = "block"            -- Allow cursor to move where there is no text in visual block mode
opt.smoothscroll                 = false
vim.wo.foldmethod                = "manual"
opt.foldlevel                    = 99         -- Start with all folds open
opt.formatoptions                = "jcroqlnt" -- tcqj
opt.nrformats                    = "unsigned"
opt.grepformat                   = "%f:%l:%c:%m"
opt.grepprg                      = "rg --vimgrep --no-heading --smart-case"
opt.splitbelow                   = true -- Horizontal splits go below
opt.splitright                   = true -- Vertical splits go right
opt.splitkeep                    = "screen"
opt.wildmenu                     = true
opt.wildmode                     = "longest:full,full"
opt.redrawtime                   = 10000
opt.maxmempattern                = 20000
vim.g.autoformat                 = true
vim.g.trouble_lualine            = true
opt.winborder                    = "rounded"
opt.pumborder                    = "rounded"
opt.messagesopt                  = "hit-enter,history:500,progress:c"
opt.jumpoptions                  = "view"
opt.laststatus                   = 3    -- global statusline
opt.linebreak                    = true -- Wrap lines at convenient points
vim.opt.list                     = true
vim.opt.listchars                = { tab = "» ", trail = "·", nbsp = "␣", }
opt.shiftround                   = true                                 -- Round indent
opt.shiftwidth                   = 2                                    -- Size of an indent
vim.g.markdown_recommended_style = 0
local undodir                    = vim.fn.stdpath("data") .. "/undodir" -- Undo directory
opt.undodir                      = undodir
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

opt.shortmess:append({ W = true, I = true, c = true, C = true })

local nowrap_cmnt = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
Config.new_autocmd('FileType', nil, nowrap_cmnt, "Proper 'formatoptions'")

vim.schedule(function() opt.clipboard = 'unnamedplus' end)
opt.path:append("**") -- include subdirectories in search
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.diffopt:append("linematch:60,indent-heuristic,inline:char")

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end


vim.filetype.add({
  extension = {
    env = "dotenv",
    txt = "markdown",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
