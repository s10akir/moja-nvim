require('keymaps')
require('plugins')

local opt = vim.opt

opt.clipboard:append{'unnamedplus'}
opt.termguicolors = true
-- NOTE: 透過させると下の字がハイライトされてむしろ使いにくいかもしれない
-- opt.pumblend = 10
-- opt.winblend = 10
opt.number = true
opt.expandtab = true
opt.smartindent = true

-- default tab settings
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.fixeol = true
opt.ttimeoutlen = 10

opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.incsearch = true
opt.hlsearch = true

-- vim.cmd[[colorscheme kanagawa]]
vim.cmd.colorscheme "catppuccin-frappe"

opt.errorbells = false

opt.synmaxcol = 200
