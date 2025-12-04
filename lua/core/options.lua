local opt = vim.opt

-- Session Management
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = false
opt.number = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.bo.softtabstop = 2

-- Line Wrapping
opt.wrap = true

-- Search Settings
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Cursor Line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8 -- min number of lines after cursor
opt.showmode = false
vim.diagnostic.config {
  float = { border = "rounded" }, -- add border to diagnostic popups
}
vim.g.have_nerd_fonts = 1

-- highlight yanking in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Use groovy formatting for Jenkinsfiles
vim.filetype.add({ pattern = {['Jenkinsfile'] = 'groovy'} })

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Enable mouse support
opt.mouse = "a"
-- opt.mouse = "" -- to disable

-- swap writing delay
opt.updatetime = 250

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Utilize Treesitter folds (Neovim 0.11+)

-- Whitespace chars
opt.list = true
opt.listchars:append({ tab = '» ', trail = '·', nbsp = '␣' })

