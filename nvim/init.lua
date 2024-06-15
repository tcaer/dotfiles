-- Basic vim stuff
vim.g.mapleader = " "
vim.opt.colorcolumn = '100'
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = false

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
  'williamboman/mason.nvim',
  'folke/twilight.nvim',
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  'f-person/auto-dark-mode.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'lewis6991/gitsigns.nvim',
  'tpope/vim-fugitive',
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  'romainl/vim-cool',
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup({
        keymaps = {
          accept_suggestion = '<C-A>',
        },
      })
    end,
  },
  -- 'github/copilot.vim',
  'joerdav/templ.vim',
})

-- Copilot
vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap('i', '<C-A>', 'copilot#Accept("CR")', { silent = true, expr = true })

-- Ibl
require('ibl').setup()

-- Gitsigns config
require('gitsigns').setup()

-- Gruvbox config
require('gruvbox').setup({
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
  },
})

local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
  update_interval = 1000,
  set_dark_mode = function()
    vim.api.nvim_set_option('background', 'light')
    vim.cmd([[colorscheme gruvbox]])
  end,
  set_light_mode = function()
    vim.api.nvim_set_option('background', 'light')
    vim.cmd([[colorscheme gruvbox]])
  end,
})

-- Twilight config
local twilight = require('twilight')

vim.keymap.set('n', '<leader>vt', twilight.toggle)

-- Telescope config
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', telescope.find_files)
vim.keymap.set('n', '<C-l><C-p>', telescope.live_grep)
vim.keymap.set('n', '<C-l>p', telescope.live_grep)

-- LSP config
vim.keymap.set('n', 'do', vim.diagnostic.open_float)
vim.keymap.set('n', 'd]', vim.diagnostic.goto_next)
vim.keymap.set('n', 'd[', vim.diagnostic.goto_prev)

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)

vim.keymap.set('n', 'vs', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'vt', vim.lsp.buf.hover)

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

require('mason').setup()

local nvim_lsp = require('lspconfig')

nvim_lsp.clangd.setup {
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
  filetypes = { 'c', 'm', 'mm', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
}
nvim_lsp.vtsls.setup({
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
})
nvim_lsp.rust_analyzer.setup{
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
nvim_lsp.gopls.setup{
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
nvim_lsp.denols.setup{
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
  root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
}
nvim_lsp.zls.setup{
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
nvim_lsp.graphql.setup {
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
nvim_lsp.templ.setup {
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
nvim_lsp.svelte.setup {
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
      }
    ),
  },
}
