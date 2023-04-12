-- TODO use a cleaner setup, similar to
--      https://github.com/LunarVim/Neovim-from-scratch/tree/06-LSP/lua/user/lsp
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gc", vim.lsp.buf.incoming_calls, bufopts)
  vim.keymap.set("n", "gC", vim.lsp.buf.outgoing_calls, bufopts)
  vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>s", vim.lsp.buf.document_symbol, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>xr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>xa", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<space>xf", function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
-- requires the following language servers:
local servers = { "elmls", "gopls", "terraformls", "tsserver", "jsonls", "yamlls", "bashls" }
for _, lsp in pairs(servers) do
  require("lspconfig")[lsp].setup {
    on_attach = on_attach,
  }
end

local util = require("lspconfig/util")

-- setup gopls
require("lspconfig").gopls.setup{
  on_attach = on_attach,
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
      env = {GOFLAGS="-tags=it"},
    },
  },
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  },
  init_options = {
    usePlaceholders = true,
  }
}

