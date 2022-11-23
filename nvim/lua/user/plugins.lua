local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- autocommand that reloads neovim whenever you save the plugins.lua file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "plugins.lua" },
  group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
  command = "source <afile> | PackerSync",
})

-- packer setup
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- install plugins
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  use "RRethy/nvim-base16" -- treesitter/lsp compatible base16 themes

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
