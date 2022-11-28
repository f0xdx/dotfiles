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
    config = function() require "user.el" end
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
    
    -- surround / comment / etc.
    use {
      "kylechui/nvim-surround",
      tag = "*", 
      config = function() require("nvim-surround").setup() end
    }
    use {
      "numToStr/Comment.nvim",
      config = function() require("Comment").setup() end
    }
  end

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
