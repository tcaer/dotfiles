-- Editor settings
vim.wo.number = true
vim.opt.wrap = false

-- Syntax settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "no"

-- Packages
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'nvim-treesitter/nvim-treesitter'
  use 'rust-lang/rust.vim'
  use 'DingDean/wgsl.vim'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      -- Snippet Collection (Optional)
      {'rafamadriz/friendly-snippets'},
    }
  }
end)

-- Theme settings
vim.o.background = "dark"
vim.cmd [[colorscheme gruvbox]]

-- Mappings
local opts = { noremap=true, silent=true }
vim.g.mapleader = ' '
---- fzf
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Files<cr>', opts)
vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>GFiles<cr>', opts)

-- LSP
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'sumneko_lua',
  'rust_analyzer'
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  if client.name == "eslint" then
    vim.cmd.LspStop('eslint')
    return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "df", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

