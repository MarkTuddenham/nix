require("markt.opts")
-- require("markt.git-worktree")
-- require("markt.dap")
local lsp = require("markt.lsp")
require("markt.notebook")

local map = vim.keymap.set
map("n", "<leader>cn", "<cmd>cnext<cr>", { silent = true })
map("n", "<leader>cp", "<cmd>cprev<cr>", { silent = true })

-- par formatting for paragraphs in code
map("n", "<leader>fcp",  "<cmd>% !par -B+. -w79<cr>",   { silent = true })
map("v", "<leader>fcp",  ":'<,'> !par -B+. -w79<cr>",   { silent = true })
map("n", "<leader>fcjp", "<cmd>% !par -B+. -jw79<cr>",  { silent = true })
map("v", "<leader>fcjp", ":'<,'> !par -B+. -jw79<cr>",  { silent = true })

-- par formatting for paragraphs in markdown
map("n", "<leader>fmp",  "<cmd>% !par -B+. -w119<cr>",  { silent = true })
map("v", "<leader>fmp",  ":'<,'> !par -B+. -w119<cr>",  { silent = true })
map("n", "<leader>fmjp", "<cmd>% !par -B+. -jw119<cr>", { silent = true })
map("v", "<leader>fmjp", ":'<,'> !par -B+. -jw119<cr>", { silent = true })

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { only_current_line = true },
})

vim.g.rustaceanvim = {
	server = {
		on_attach = lsp.on_attach,
		capabilities = (function()
			local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
			return ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
		end)(),
		settings = {
			["rust-analyzer"] = {
				cargo = { features = "all" },
				check = { command = "clippy" },
			},
		},
	},
}

map("n", "<F5>", "<cmd>UndotreeToggle<cr>", {})
