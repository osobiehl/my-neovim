--- Setup filetree parsing
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Mason Setup
require("mason").setup({
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	}
})

require("mason-lspconfig").setup()
-- IMPORTS
require('vars') -- Variables
require('opts') -- Options
require('keys') -- Keymaps
require('plug') -- Plugins
local lsp_config = require("lspconfig")
lsp_config.clangd.setup({})
lsp_config.pyright.setup({})
lsp_config.lua_ls.setup({})
vim.g.rustaceanvim = {
	-- Plugin configuration
	--  tools = {
	--  },
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			-- you can also put keymaps in here
		end,
		default_settings = {
			-- rust-analyzer language server configuration
			['rust-analyzer'] = {
				check = {
					command = "clippy",
				}
			},
		},
	},
	-- DAP configuration
	dap = {
	},
}



require('sonarlint').setup({
	server = {
		cmd = {
			vim.fn.expand('$MASON/bin/sonarlint-language-server'),
			-- Ensure that sonarlint-language-server uses stdio channel
			'-stdio',
			'-analyzers',
			-- paths to the analyzers you need, using those for python and java in this example
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
		},
		settings = {
			sonarlint = {
				pathToCompileCommands = vim.fn.expand("$PWD/build/sonarlint_compile_commands.json"),

				connectedMode = {
					project = {
						connectionId = "https-sonarqube-draeger-net-",
						projectKey = "txng"
					}

				},
				disableTelemetry = true,
				focusOnNewCode = true
			},
			files = {
				exclude = {
					["**/.git"] = true
				}
			}
		}

	},
	filetypes = {
		-- Tested and workindefault		'cpp',
		'java',
	}
})
--vim.lsp.set_log_lev:Cel('debug')
require("codecompanion").setup({
	--	opts = {
	--		log_level = "DEBUG", -- or "TRACE"
	--	},
	strategies = {
		chat = {
			adapter = "copilot",
			slash_commands = {
				["file"] = {
					-- Location to the slash command in CodeCompanion
					callback = "strategies.chat.slash_commands.file",
					description = "Select a file using Telescope",
					opts = {
						provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
						contains_code = true,
					}
				}
			}
		},
		inline = {
			adapter = "copilot",
		},
	},
	display = {
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ", -- Prompt used for interactive LLM calls
			provider = "mini_pick", -- default|telescope|mini_pick
			opts = {
				show_default_actions = true, -- Show the default actions in the action palette?
				show_default_prompt_library = true, -- Show the default prompt library in the action palette?
			},
		},
	},
})

-- LSP Diagnostics Options Setup
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end
sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

require('toggleterm').setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
-- Completion Plugin Setup
local cmp = require 'cmp'
cmp.setup({
	-- Enable LSP snippets
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		-- Add tab support
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		})
	},
	-- Installed sources:
	sources = {
		{ name = 'path' },                         -- file paths
		--{ name = 'copilot',                group_index = 2 }, -- github copilot
		{ name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
		{ name = 'nvim_lsp_signature_help' },      -- display function signatures with current parameter emphasized
		{ name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
		{ name = 'buffer',                 keyword_length = 2 }, -- source current buffer
		{ name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
		{ name = 'calc' },                         -- source for math calculation
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { 'menu', 'abbr', 'kind' },
		format = function(entry, item)
			local menu_icon = {
				Copilot = '',
				nvim_lsp = 'λ',
				vsnip = '⋗',
				buffer = 'Ω',
				path = '🖫',
			}
			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
})
require('nvim-treesitter.configs').setup {
	ensure_installed = { "lua", "rust", "toml" },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	ident = { enable = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	}
}

require('treesitter-context').setup()

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
local telescope_actions = require("telescope.actions.set")

local fixfolds = {
	hidden = true,
	attach_mappings = function(_)
		telescope_actions.select:enhance({
			post = function()
				vim.cmd(":normal! zx")
			end,
		})
		return true
	end,
}
require('telescope').setup {
	defaults = {
		file_ignore_patterns = {
			".git/",
			"^./target/",
			"LICENSE*"
		}
	},
	pickers = {
		buffers = fixfolds,
		file_browser = fixfolds,
		find_files = fixfolds,
		git_files = fixfolds,
		grep_string = fixfolds,
		live_grep = fixfolds,
		oldfiles = fixfolds,
		-- I probably missed some
	},
}
require("trouble").setup()
require("harpoon").setup()
require("autoclose").setup()

-- lua line setup
require('lualine').setup({
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { { 'filename', path = 1 }, 'location' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = {}
	},
})

require('gitsigns').setup()


vim.cmd("colorscheme tokyonight")
vim.cmd("set ignorecase")

vim.cmd("cabbr <expr> %% expand('%')")
vim.cmd("cabbr <expr> %H expand('%:h')")

-- Toggle Inlay Hints
vim.lsp.inlay_hint.enable(true)
