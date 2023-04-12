local extensions = require('el.extensions')
local subscribe = require('el.subscribe')
local builtin = require('el.builtin')

local generator = function()
    local el_segments = {}

    -- mode
    table.insert(el_segments, extensions.gen_mode({ format_string = " %s "}))
    table.insert(el_segments, "  ")

    -- git branch
    table.insert(el_segments, "שׂ ")
    table.insert(el_segments,
    subscribe.buf_autocmd(
      "el_git_branch",
      "BufEnter",
      function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        if branch then
          return branch
        end
      end
    ))

    -- file name
    table.insert(el_segments, "   ")
    table.insert(el_segments, builtin.file_relative)
    table.insert(el_segments, builtin.modified)
    table.insert(el_segments, " ")
    table.insert(el_segments, builtin.readonly)

    -- git changes
    table.insert(el_segments, "  ")
    table.insert(el_segments,
    subscribe.buf_autocmd(
      "el_git_status",
      "BufWritePost",
      function(window, buffer)
        local changes =  extensions.git_changes(window, buffer)
        if changes then
          return changes
        end
      end
    ))

    -- greedy separator
    table.insert(el_segments, "%=")

    table.insert(el_segments, builtin.quickfix)

    -- file encoding
    table.insert(el_segments, "  ")
    table.insert(el_segments,
    subscribe.buf_autocmd(
      "el_file_encoding",
      "BufRead",
      function(_, buffer)
        return vim.opt.fileencoding:get()
      end
    ))

    -- file type icon
    table.insert(el_segments, "  ")
    table.insert(el_segments,
    subscribe.buf_autocmd(
      "el_file_icon",
      "BufRead",
      function(_, buffer)
        return extensions.file_icon(_, buffer)
      end
    ))
    table.insert(el_segments, " ")
    table.insert(el_segments, builtin.filetype_list)

    -- location
    table.insert(el_segments, "  L:")
    table.insert(el_segments, builtin.line)

    table.insert(el_segments, " C:")
    table.insert(el_segments, builtin.column)

    table.insert(el_segments, string.format(" [%s]", builtin.number_of_lines))

    return el_segments
end

-- TODO add diagnostics: https://github.com/tjdevries/express_line.nvim/blob/master/lua/el/diagnostic.lua#L41-L68

vim.api.nvim_set_hl(0, "ElNormal", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "ElInsert", { link = "PmenuSel" })

-- And then when you're all done, just call
require('el').setup { generator = generator }
