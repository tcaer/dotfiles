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
	'neovim/nvim-lspconfig',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
	'hrsh7th/vim-vsnip',
	
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	
	'lewis6991/gitsigns.nvim',
	'tpope/vim-fugitive',
	
	{ 'ellisonleao/gruvbox.nvim', priority = 1000 },

	'romainl/vim-cool',
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
vim.cmd([[colorscheme gruvbox]])

-- Telescope config
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.find_files)
vim.keymap.set('n', '<C-l><C-p>', telescope.live_grep)
vim.keymap.set('n', '<C-l>p', telescope.live_grep)
--
-- LSP config
vim.keymap.set('n', 'do', vim.diagnostic.open_float)
vim.keymap.set('n', 'd]', vim.diagnostic.goto_next)
vim.keymap.set('n', 'd[', vim.diagnostic.goto_prev)

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)

local cmp = require('cmp')

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
		['<C-e>'] = cmp.mapping.abort(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' }
	}),
})
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
	}, {
		{ name = 'buffer' },
	}),
})
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

local status, nvim_lsp = pcall(require, "lspconfig")

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
	handlers = {
		['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				update_in_insert = true,
			}
		),
	},
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}
