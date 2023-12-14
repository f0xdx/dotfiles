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

-- cmp setup

local ok, cmp = pcall(require, "cmp")
if not ok then
  vim.notify("cmp module not found")
  return
end

cmp.setup({
  completion = {
    keyword_length = 0,   -- min length before showing
    autocomplete = false, -- manual invocation
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          return vim_item
        end
      end
      return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
    end
  },

  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  completion = {
    keyword_length = 0,   -- min length before showing
    autocomplete = false, -- manual invocation
  },

  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


-- luasnip setup

local ok, luasnip = pcall(require, "luasnip")
if ok then
  -- vim.keymap.set({"i", "s"}, "<C-n>", function() luasnip.jump(-1) end, opts)
  -- vim.keymap.set({"i", "s"}, "<C-p>", function() luasnip.jump(1) end, opts)
  vim.keymap.set({"i", "s"}, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump() 
    end
  end, { silent=true })
  vim.keymap.set({"i", "s"}, "<C-j>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1) 
    end
  end, { silent=true })
else
  vim.notify("cmp module not found")
  return
end


-- lsp setup

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.notify("lspconfig module not found")
  return
end

-- language servers (default settings)

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "elmls", "terraformls", "tsserver", "jsonls", "yamlls", "bashls", "hls", "zls" }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

local util = require("lspconfig/util")

-- language servers (specific settings)

lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
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

