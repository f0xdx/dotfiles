-- TODO find a better, asynchronous way to identify git branch / ref for
-- headless branches
--  lean on
--
--  - https://github.com/nvim-lualine/lualine.nvim or
--  - https://github.com/feline-nvim/feline.nvimhttps://github.com/feline-nvim/feline.nvim
--  - https://github.com/beauwilliams/statusline.lua
--

local function GitBranch()
  return vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\\n'")
end

local modes = {
  ['n']      = 'NORMAL',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI']    = 'NORMAL',
  ['niR']    = 'NORMAL',
  ['niV']    = 'NORMAL',
  ['nt']     = 'NORMAL',
  ['ntT']    = 'NORMAL',
  ['v']      = 'VISUAL',
  ['vs']     = 'VISUAL',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']   = 'V-BLOCK',
  ['\22s']  = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']   = 'S-BLOCK',
  ['i']      = 'INSERT',
  ['ic']     = 'INSERT',
  ['ix']     = 'INSERT',
  ['R']      = 'REPLACE',
  ['Rc']     = 'REPLACE',
  ['Rx']     = 'REPLACE',
  ['Rv']     = 'V-REPLACE',
  ['Rvc']    = 'V-REPLACE',
  ['Rvx']    = 'V-REPLACE',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPLACE',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERMINAL',
}

local function CurrentMode()
  local mode = vim.api.nvim_get_mode().mode
  if modes[mode] == nil then
    return mode
  end
  return modes[mode]
end

function StatusLine()
  local parts = {
    "%#PmenuSel#",
    " ", CurrentMode(), " ",
    "%#StatusLine#  ",
--    "שׂ ", GitBranch(), "  ", -- git branch
    " %f%M %r",             -- current file
    "%=",                    -- center greedy separator
    "%q ",                   -- quickfix / location list marker
    vim.opt.fileencoding:get(), "  ",
    "%Y  ",                   -- file type
    "L%l/%L C%c ",                   -- line : column [number of lines]
  }
  --return "%f %= %l,%c %p%%"
  return table.concat(parts, "")
end


vim.o.statusline = "%!luaeval('StatusLine()')"

