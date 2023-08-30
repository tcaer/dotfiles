-- Basic vim stuff
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Lazy initialization
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy plugins
require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'pmizio/typescript-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
	},
	'lewis6991/gitsigns.nvim',
	'tpope/vim-fugitive',
	{ 'ellisonleao/gruvbox.nvim', priority = 1000 },
})

-- Gitsigns config
require('gitsigns').setup()

-- Gruvbox config
vim.o.background = 'dark'

require('gruvbox').setup({
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
	},
})
vim.cmd('colorscheme gruvbox')

-- LSP config
vim.keymap.set('n', 'do', vim.diagnostic.open_float)
vim.keymap.set('n', 'd]', vim.diagnostic.goto_next)
vim.keymap.set('n', 'd[', vim.diagnostic.goto_prev)

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)

-- Telescope config
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.find_files)
vim.keymap.set('n', '<C-l><C-p>', telescope.live_grep)
vim.keymap.set('n', '<C-l>p', telescope.live_grep)

-- Typescript
require('typescript-tools').setup {
}
