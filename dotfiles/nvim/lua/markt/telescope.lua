local opts = { noremap = true, silent = true }

-- Image preview via image.nvim (Kitty graphics protocol, no external tools needed)
local _preview_img = nil
local _img_exts = { png = true, jpg = true, jpeg = true, gif = true, webp = true, bmp = true, tiff = true }

local function is_image(path)
  return path and _img_exts[(path:match("%.([^%.]+)$") or ""):lower()] or false
end

local image_previewer = require("telescope.previewers").new_buffer_previewer({
  title = "Image Preview",
  define_preview = function(self, entry)
    if _preview_img then
      pcall(function() _preview_img:clear() end)
      _preview_img = nil
    end
    local path = require("telescope.from_entry").path(entry)
    if not is_image(path) then return end
    local ok, image = pcall(require, "image")
    if not ok then return end
    _preview_img = image.from_file(path, {
      window = self.state.winid,
      buffer = self.state.bufnr,
      with_virtual_padding = true,
    })
    if _preview_img then _preview_img:render() end
  end,
})

require("telescope").setup({
	defaults = {
		color_devicons = true,
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},
		},
		sorting_strategy = "ascending",
		file_ignore_patterns = {
			-- we have set hidden files to shown, but we don't want git dotfiles
			".git/.*",
			".sqlx/.*",
			".bare/.*",
			".*venv/.*",
			".*target/.*",
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = false, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- 'smart_case' or 'ignore_case' or 'respect_case'
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

vim.keymap.set("n", "<leader>ff", '<cmd>lua require("telescope.builtin").find_files({hidden=true})<cr>', opts)
vim.keymap.set("n", "<leader>fi", function()
  require("telescope.builtin").find_files({ hidden = true, previewer = image_previewer, prompt_title = "Find Images" })
end, vim.tbl_extend("force", opts, { desc = "Find images (with preview)" }))
vim.keymap.set("n", "<leader>fo", '<cmd>lua require("telescope.builtin").file_browser({hidden=true})<cr>', opts)

vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
vim.keymap.set("n", "<leader>f[", "<cmd>Telescope diagnostics<cr>", opts)


-- require('telescope').load_extension('gh')
-- vim.keymap.set("n", "<leader>gi", "<cmd>Telescope gh issues<cr>", opts)
-- vim.keymap.set("n", "<leader>gp", "<cmd>Telescope gh pull_request<cr>", opts)
-- vim.keymap.set("n", "<leader>gr", "<cmd>Telescope gh run<cr>", opts)

-- require("telescope").load_extension("dap")
-- vim.keymap.set("n", "<leader>fdc", "<cmd>Telescope commands<cr>", opts)
-- vim.keymap.set("n", "<leader>fdv", "<cmd>Telescope variables<cr>", opts)
-- vim.keymap.set("n", "<leader>fdf", "<cmd>Telescope frames<cr>", opts)
-- vim.keymap.set("n", "<leader>fdb", "<cmd>Telescope list_breakpoints<cr>", opts)

-- require("telescope").load_extension("git_worktree")
-- vim.keymap.set("n", "<leader>gw", '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>', opts)
-- vim.keymap.set("n", "<leader>gc", '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>', opts)


