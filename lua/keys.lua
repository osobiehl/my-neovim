--[[ keys.lua ]]

-- Functional wrapper for mapping custom keybindings
-- mode (as in Vim modes like Normal/Insert mode)
-- lhs (the custom keybinds you need)
-- rhs (the commands or existing keybinds to customise)
-- opts (additional options like <silent>/<noremap>, see :h map-arguments for more info on it)
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Vimspector
vim.cmd([[
nmap <F9> <cmd>call vimspector#Launch()<cr>
nmap <F5> <cmd>call vimspector#StepOver()<cr>
nmap <F8> <cmd>call vimspector#Reset()<cr>
nmap <F11> <cmd>call vimspector#StepOver()<cr>")
nmap <F12> <cmd>call vimspector#StepOut()<cr>")
nmap <F10> <cmd>call vimspector#StepInto()<cr>")
]])
--setup termina
map('n', "Db", ":call vimspector#ToggleBreakpoint()<cr>")
map('n', "Dw", ":call vimspector#AddWatch()<cr>")
map('n', "De", ":call vimspector#Evaluate()<cr>")
-- set leader key
vim.g.mapleader = ';'
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})

hop.setup()
-- nvim tree mappings
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end


-- pass to setup along with your other options
require("nvim-tree").setup {
  ---:w
  ---
  on_attach = my_on_attach,
  ---
}
map("n", "<leader>nf", ":NvimTreeToggle<CR>")
-- FloaTerm configuration
vim.keymap.set('n', '<leader>nt', ':FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ', {})
vim.keymap.set('n', '<leader>`', ':FloatermToggle myfloat<CR>', {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:q<CR>', {})


map('n', "<leader><Space>", ":lua vim.lsp.buf.code_action()<CR>")
map('n', "<leader>q", "vim.lsp.buf.hover_actions()<CR>")


 vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition)
 vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help)
 vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover)
 vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
 vim.keymap.set('n', '<leader>c', vim.lsp.buf.incoming_calls)
 vim.keymap.set('n', '<leader>d', vim.lsp.buf.type_definition)
 vim.keymap.set('n', '<leader>r', vim.lsp.buf.references)
 vim.keymap.set('n', '<leader>n', vim.lsp.buf.rename)
 vim.keymap.set('n', '<leader>s', vim.lsp.buf.document_symbol)
 vim.keymap.set('n', '<leader>w', vim.lsp.buf.workspace_symbol)
vim.cmd([[set number
]])
vim.cmd([[set smartcase
]])
