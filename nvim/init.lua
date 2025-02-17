-- Basic vim stuff
vim.g.mapleader = ' '
vim.g.colorcolumn = 100
vim.g.augment_disable_tab_mapping = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Lazy initialization
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy plugins
require("lazy").setup({
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
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
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  'augmentcode/augment.vim',
  'nvim-treesitter/nvim-treesitter'
})

require('gruvbox').setup({
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
  },
})
vim.cmd([[colorscheme gruvbox]])

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', telescope.find_files)
vim.keymap.set('n', '<leader>/', telescope.live_grep)

require('ibl').setup()

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<Ctrl>-a'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
    end, { 'i', 's' })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' }
  })
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
require('mason-lspconfig').setup()

require('mason-lspconfig').setup_handlers {
  function (server_name) 
    require('lspconfig')[server_name].setup {}
  end,
  ['rust_analyzer'] = function ()
    require('rust-tools').setup {}
  end
}

vim.diagnostic.config({
  update_in_insert = true,
})

local lsp_group = vim.api.nvim_create_augroup("LspDiagnostics", { clear = true })
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
  group = lsp_group,
  callback = function()
    vim.diagnostic.setloclist({ open = false }) 
  end,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)

vim.keymap.set('i', '<C-a>', function()
    vim.fn.call('augment#Accept', {})
end, { noremap = true, silent = true })
vim.g.augment_workspace_folders = {'/Users/tino/Workspace/tcorp'}

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
})
