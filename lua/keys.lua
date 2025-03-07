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
local tel_ext = require('telescope').extensions
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', tel_ext.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 'F', function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 't', function()
	hop.hint_char2({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = 0 })
end, { remap = true })
vim.keymap.set('', 'T', function()
	hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 0 })
end, { remap = true })

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
	vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
	vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end


-- pass to setup along with your other options
require("nvim-tree").setup {
	---:w
	---
	on_attach = my_on_attach,
	---
}
map("n", "<leader>nf", ":NvimTreeToggle<CR>")
-- ToggleTerm configuration
local counter = 0
vim.keymap.set('n', '<leader>nt', function()
	counter         = counter + 1
	local formatted = string.format(":%dToggleTerm size=20 direction=horizontal", counter)
	vim.cmd(formatted)
end, {})
vim.keymap.set('n', '<leader>dt', function()
	if (counter > 0) then
		local formatted = string.format(":%dTermExec cmd='false || exit'", counter)
		counter         = counter - 1
		vim.cmd(formatted)
	end
end, {})

vim.keymap.set('n', '<leader>`', ':ToggleTermToggleAll<CR>', {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})


map('n', "<leader><Space>", ":lua vim.lsp.buf.code_action()<CR>")
map('n', "<leader>q", "vim.lsp.buf.hover_actions()<CR>")


vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition)
vim.keymap.set('n', '<c-k>', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>c', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', '<leader>d', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>n', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>s', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>w', vim.lsp.buf.workspace_symbol)
local harpoon = require('harpoon')
require("telescope").load_extension('harpoon')

vim.keymap.set('n', '<leader>ha', require("harpoon.mark").add_file)
-- vim.keymap.set('n', '<leader>hh', require("harpoon.ui").toggle_quick_menu)

map('n', "<leader>hh", ":Telescope harpoon marks<CR>")
vim.keymap.set('n', '<leader>hb', require("harpoon.ui").nav_prev)
vim.keymap.set('n', '<leader>hn', require("harpoon.ui").nav_next)



map('n', "<leader>gh", ":CodeCompanionChat toggle<CR>")
map('v', "<leader>gi", ":CodeCompanion /buffer ")




-- harpoon keymaps
--
vim.cmd([[set number
]])
vim.cmd([[set smartcase
]])
vim.cmd([[set relativenumber
]])
