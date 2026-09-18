return {
	"nvim-lua/plenary.nvim",

	-- Load colorscheme first, eagerly
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- main | moon | dawn
				dark_variant = "moon",
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},
				palette = {
					moon = { base = "#191720" }, -- less blue than default #232136
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- Display
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup({
				signs = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged_enable = true,
				signcolumn = true,
				numhl = false,
				linehl = false,
				word_diff = false,
				watch_gitdir = { interval = 1000, follow_files = true },
				auto_attach = true,
				attach_to_untracked = true,
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil,
				max_file_length = 40000,
				diff_opts = { internal = true },
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 750,
					ignore_whitespace = true,
				},
				current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
				preview_config = {
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					map('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, { expr = true })
					map('n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, { expr = true })
					map('n', '<leader>hs', gs.stage_hunk)
					map('n', '<leader>hr', gs.reset_hunk)
					map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
					map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
					map('n', '<leader>hS', gs.stage_buffer)
					map('n', '<leader>hu', gs.undo_stage_hunk)
					map('n', '<leader>hR', gs.reset_buffer)
					map('n', '<leader>hp', gs.preview_hunk)
					map('n', '<leader>hb', function() gs.blame_line { full = true } end)
					map('n', '<leader>tb', gs.toggle_current_line_blame)
					map('n', '<leader>hd', gs.diffthis)
					map('n', '<leader>hD', function() gs.diffthis('~') end)
					map('n', '<leader>td', gs.toggle_deleted)
					map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				end,
			})
		end,
	},

	"tpope/vim-fugitive",
	"tpope/vim-eunuch",
	"mbbill/undotree",

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = 'rose-pine',
					icons_enabled = true,
					section_separators = '',
					component_separators = '',
					disabled_filetypes = { statusline = {}, winbar = {} },
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
				},
				sections = {
					lualine_a = { "hostname", "mode", "paste" },
					lualine_b = {
						{ "filename", file_status = true, new_file_status = true, path = 2 },
						{
							"diagnostics",
							sources = { 'nvim_lsp', "nvim_diagnostic", 'nvim_workspace_diagnostic' },
							symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						},
					},
					lualine_c = { "branch", "diff" },
					lualine_x = { "searchcount", "selectioncount" },
					lualine_y = { "filetype", 'encoding', 'fileformat' },
					lualine_z = { "progress", "location" },
				},
				extensions = { "fugitive", "fzf" },
			})
		end,
	},

	-- Motion
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				global_settings = { save_on_toggle = false, save_on_change = true },
			})
			local mark = require("harpoon.mark")
			local ui   = require("harpoon.ui")
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>tt", mark.add_file, opts)
			vim.keymap.set("n", "<leader>tl", ui.toggle_quick_menu, opts)
			vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, opts)
			vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, opts)
			vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, opts)
			vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, opts)
			vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, opts)
		end,
	},
	"bkad/CamelCaseMotion",
	{
		"folke/flash.nvim",
		config = function()
			require("flash").setup()
			local map = vim.keymap.set
			map({ "n", "x", "o" }, "s",     function() require("flash").jump() end,              { desc = "Flash jump" })
			map({ "n", "x", "o" }, "S",     function() require("flash").treesitter() end,        { desc = "Flash treesitter" })
			map("o",               "r",     function() require("flash").remote() end,             { desc = "Flash remote" })
			map({ "o", "x" },      "R",     function() require("flash").treesitter_search() end,  { desc = "Flash treesitter search" })
			map("c",               "<c-s>", function() require("flash").toggle() end,             { desc = "Toggle flash search" })
		end,
	},

	-- Tree Sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- New nvim-treesitter API: configs module removed, install() replaces ensure_installed
			require("nvim-treesitter").install({
				"rust", "go", "c", "cpp", "python", "proto",
				"lua", "toml", "yaml", "json", "nix",
				"markdown", "markdown_inline", "bash",
				"vim", "vimdoc",
			})
			-- Highlighting via Neovim's built-in treesitter (replaces highlight.enable)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
	-- LSP
	"neovim/nvim-lspconfig",

	-- Completion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp",
	"petertriho/cmp-git",
	"kdheepak/cmp-latex-symbols",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind.nvim",
	"L3MON4D3/LuaSnip",

	-- Diagnostics panel
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup()
			local map = vim.keymap.set
			map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                { desc = "All diagnostics" })
			map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",   { desc = "Buffer diagnostics" })
			map("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                    { desc = "Symbols" })
			map("n", "<leader>xl", "<cmd>Trouble lsp toggle<cr>",                        { desc = "LSP references/defs" })
			map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                     { desc = "Quickfix" })
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua    = { "stylua" },
					python = { "ruff_format", "ruff_organize_imports" },
					nix    = { "nixfmt" },
					toml   = { "taplo" },
					go     = { "gofmt" },
					rust   = { "rustfmt", lsp_format = "fallback" },
				},
				format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			})
			-- Override the LSP format binding with conform
			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end, { desc = "Format" })
		end,
	},

	-- Git diff / history viewer
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup()
			local map = vim.keymap.set
			map("n", "<leader>dv", "<cmd>DiffviewOpen<cr>",              { desc = "Diff working tree" })
			map("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>",     { desc = "File history" })
			map("n", "<leader>dc", "<cmd>DiffviewClose<cr>",             { desc = "Close diffview" })
		end,
	},

	-- File navigation
	{
		"stevearc/oil.nvim",
		config = function() require('oil').setup() end,
	},
	{
		"mikavilpas/yazi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("yazi").setup({ open_for_directories = false })
			local map = vim.keymap.set
			map("n", "<leader>yz", "<cmd>Yazi<cr>",     { desc = "Yazi (current file)" })
			map("n", "<leader>yc", "<cmd>Yazi cwd<cr>", { desc = "Yazi (cwd)" })
		end,
	},

	-- MDX
	"davidmh/mdx.nvim",

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("markt.telescope")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Jupyter notebooks
	"3rd/image.nvim",
	{
		"benlubas/molten-nvim",
		build = ":UpdateRemotePlugins",
	},

	-- Rust
	"mrcjkb/rustaceanvim",
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function() require('crates').setup() end,
	},
}
