local opt = vim.opt

-- Leader (set early so plugins pick it up)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Global statusline (one bar across all windows, not one per window)
opt.laststatus = 3

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"
opt.showmode = false
opt.cmdheight = 0

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Clipboard (system)
opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"
