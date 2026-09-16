local lsp_opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, lsp_opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, lsp_opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, lsp_opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, lsp_opts)

local M = {}
M.on_attach = function(client, bufnr)
	local opts = vim.tbl_extend("force", lsp_opts, { buffer = bufnr })

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)

	vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
end

local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.codeLens = { dynamicRegistration = false }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local base = { on_attach = M.on_attach, capabilities = capabilities }

-- Protobuf
vim.lsp.config('protols', vim.tbl_extend('force', base, {
	filetypes = { 'proto' },
}))
vim.lsp.enable('protols')

-- Go
vim.lsp.config('gopls', vim.tbl_extend('force', base, {
	cmd = { "gopls", "serve" },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	settings = {
		gopls = {
			analyses = { unusedparams = true },
			staticcheck = true,
		},
	},
}))
vim.lsp.enable('gopls')

-- C/C++
vim.lsp.config('clangd', vim.tbl_extend('force', base, {
	cmd = { "clangd", "--clang-tidy" },
	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}))
vim.lsp.enable('clangd')

-- Python: ruff for linting/formatting, pylsp for code intelligence
vim.lsp.config('ruff', vim.tbl_extend('force', base, {
	filetypes = { 'python' },
	init_options = {
		settings = {
			lineLength = 120,
			organizeImports = true,
			extendSelect = { "ALL" },
		},
	},
}))
vim.lsp.enable('ruff')

vim.lsp.config('pylsp', vim.tbl_extend('force', base, {
	filetypes = { 'python' },
	settings = {
		pylsp = {
			plugins = {
				-- ruff handles all of these
				pyflakes    = { enabled = false },
				pycodestyle = { enabled = false },
				autopep8    = { enabled = false },
				yapf        = { enabled = false },
				mccabe      = { enabled = false },
				-- keep rope for go-to-definition / references
				rope_completion = { enabled = true },
			},
		},
	},
}))
vim.lsp.enable('pylsp')

-- Lua
vim.lsp.config('lua_ls', vim.tbl_extend('force', base, {
	filetypes = { 'lua' },
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}))
vim.lsp.enable('lua_ls')

-- Nix
vim.lsp.config('nixd', vim.tbl_extend('force', base, {
	filetypes = { 'nix' },
}))
vim.lsp.enable('nixd')

return M
