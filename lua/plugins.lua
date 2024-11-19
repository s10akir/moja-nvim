vim.cmd [[packadd packer.nvim]]

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/vim-vsnip"
  use "folke/lazydev.nvim"
  use "nvimtools/none-ls.nvim"
  use "nvim-lua/plenary.nvim"
  use "jay-babu/mason-null-ls.nvim"

  -- Diagnostics
  use "github/copilot.vim"

  -- Syntax highlighting
  -- use "nvim-treesitter/nvim-treesitter"

  -- UI
  use "rebelot/kanagawa.nvim"
  use "nvim-lualine/lualine.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "rcarriga/nvim-notify"
  use "MunifTanjim/nui.nvim"
  -- use "folke/noice.nvim"

  -- Navigation
  use "kylechui/nvim-surround"
end)

require("nvim-surround").setup()
-- require("noice").setup({
--   cmdline = {
--     -- view = "cmdline",
--   },
--   messages = {
--     view = "mini",
--   },
--   lsp = {
--   },
--   presets = {
--     lsp_doc_border = true,
--   },
-- })

require("mason").setup()
require("mason-lspconfig").setup_handlers({ function(server)
  local opt = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  }

  require("lspconfig")[server].setup(opt)
end })

require("mason-null-ls").setup({
  handlers = {},
})

vim.api.nvim_set_option("showmode", false)
require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "ayu_mirage",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
}


vim.diagnostic.config {
  float = {
    border = "rounded",
  },
  serverity_sort = true,
  virtual_text = false,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
    virtual_text = false,
  }
)

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     border = "rounded",
--   }
-- )
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
--   vim.lsp.handlers.signature_help, {
--     border = "rounded",
--   }
-- )

vim.keymap.set("n", "<C-f>", "<cmd>lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

local signs = { Error = "❌", Warn = "⚠︎", Hint = "💡", Info = "ℹ️" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local cmp = require("cmp")
cmp.setup({
  window = {
    completion = {
      border = "rounded",
      -- NOTE: 透過させると下の字がハイライトされてむしろ使いにくいかもしれない
      -- winblend = 10,
      scrolloff = 0,
      col_offset = 4,
      side_padding = 1,
      scrollbar = true,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    -- { name = "buffer" },
    -- { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-l>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Esc>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})

local function open_diagnostics_on_hover()
  vim.diagnostic.open_float(0, {
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end

vim.api.nvim_set_option('updatetime', 500)
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = open_diagnostics_on_hover,
  group = "lsp_diagnostics_hold",
})
