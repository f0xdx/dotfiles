-- automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


-- autocommand for syncing packer on any changes to the plugins file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "plugins.lua" },
  group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
  command = "source <afile> | PackerSync",
})


-- check minimal required / not required
local minimal =  os.getenv("MINIMAL") ~= nil and os.getenv("MINIMAL") ~= ""


-- install plugins
return require("packer").startup(function(use)
  use "wbthomason/packer.nvim" -- manages itself
  use "RRethy/nvim-base16"     -- treesitter/lsp compatible base16 themes
 
  use  'nvim-tree/nvim-web-devicons'
  use {
    'tjdevries/express_line.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim', opt=false },
      { 'nvim-tree/nvim-web-devicons', opt=true },
    },
    config = function() require "user.el" end,
  }

  if not minimal then
    -- fzf
    use {
      "junegunn/fzf",
      run = function() vim.fn['fzf#install'](0) end,
    }
    use {
      "junegunn/fzf.vim",
      requires = { "junegunn/fzf" },
      config = function() require "user.fzf" end,
    }

    -- lsp
    use {
      "neovim/nvim-lspconfig",
      config = function() require "user.lsp" end,
    }

    -- treesitter
    use "nvim-treesitter/playground"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        { "nvim-treesitter/playground", opt=true },
        { "nvim-treesitter/nvim-treesitter-textobjects", opt=true },
      },
      run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
      config = function() require "user.treesitter" end,
    }
    
    -- surround / comment / etc.
    use {
      "kylechui/nvim-surround",
      tag = "*", 
      config = function() require("nvim-surround").setup() end,
    }
    use {
      "numToStr/Comment.nvim",
      config = function() require("Comment").setup() end,
    }
  end

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

