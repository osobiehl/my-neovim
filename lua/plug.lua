return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig'
	use 'simrat39/rust-tools.nvim'
	use 'hrsh7th/nvim-cmp'

	-- LSP completion source:
	use 'hrsh7th/cmp-nvim-lsp'



	-- Useful completion sources:
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/vim-vsnip'
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-treesitter/nvim-treesitter-context'

	use 'puremourning/vimspector'
	use 'tpope/vim-fugitive'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons' }
	}

	use { "lewis6991/gitsigns.nvim" }

	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end }
	-- Used to hop around:
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' }, { "nvim-telescope/telescope-live-grep-args.nvim" }, }, config = function()
		require("telescope").load_extension("live_grep_args")
	end
	}

	use {
		'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	}

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		},
	}

	use {
		'folke/trouble.nvim',
		requires = { 'nvim-tree/nvim-web-devicons' }, -- optional
	}

	use 'simrat39/symbols-outline.nvim' -- enable symbols tab
	use 'folke/tokyonight.nvim'
	-- Harpoon
	use 'm4xshen/autoclose.nvim'
	use {
		'ThePrimeagen/harpoon',
		requires = { 'nvim-lua/plenary.nvim' }, -- optional
	}
	use {
		"zbirenbaum/copilot.lua",
	}
	use {
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup({
				event = { "InsertEnter", "LspAttach" },
				fix_pairs = true,
			})
		end
	}
	use { 'vim-scripts/DoxygenToolkit.vim' }

	use { 'https://gitlab.com/schrieveslaach/sonarlint.nvim', as = 'sonarlint.nvim' }
end)
