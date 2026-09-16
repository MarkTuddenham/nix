-- image.nvim: inline image rendering via the kitty graphics protocol
-- tmux passes the protocol through via `allow-passthrough on` in tmux.conf

local image_ok, image = pcall(require, "image")
if not image_ok then return end
local setup_ok, err = pcall(image.setup, {
	backend = "kitty",
	max_width = 100,
	max_height = 15,
	-- Allow images to exceed window height so they don't get clipped
	max_height_window_percentage = math.huge,
	max_width_window_percentage = math.huge,
	-- Clear images obscured by floating windows (e.g. cmp)
	window_overlap_clear_enabled = true,
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})
if not setup_ok then
	vim.notify("image.nvim: " .. err, vim.log.levels.WARN)
	return
end

-- molten-nvim: run code against a Jupyter kernel and show output inline
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
-- Don't open output automatically on evaluate — use <localleader>os to inspect
vim.g.molten_auto_open_output = false
vim.g.molten_wrap_output = true
vim.g.molten_virt_lines_off_by_1 = true
-- Show a brief virtual text summary of the output on the cell line
vim.g.molten_virt_text_output = true

local map = vim.keymap.set

-- Kernel lifecycle
map("n", "<localleader>mi", "<cmd>MoltenInit<cr>",        { desc = "Init kernel" })
map("n", "<localleader>mr", "<cmd>MoltenRestart!<cr>",    { desc = "Restart kernel" })
map("n", "<localleader>mq", "<cmd>MoltenInterrupt<cr>",   { desc = "Interrupt kernel" })

-- Cell evaluation
map("n", "<localleader>e",  "<cmd>MoltenEvaluateOperator<cr>", { desc = "Evaluate (operator)" })
map("n", "<localleader>ll", "<cmd>MoltenEvaluateLine<cr>",     { desc = "Evaluate line" })
map("n", "<localleader>rr", "<cmd>MoltenReevaluateCell<cr>",   { desc = "Re-evaluate cell" })
map("v", "<localleader>e",  "<cmd>MoltenEvaluateVisual<cr>",   { desc = "Evaluate selection" })

-- Output window
map("n", "<localleader>oh", "<cmd>MoltenHideOutput<cr>",   { desc = "Hide output" })
map("n", "<localleader>os", "<cmd>MoltenEnterOutput<cr>",  { desc = "Enter output window" })
map("n", "<localleader>od", "<cmd>MoltenDelete<cr>",       { desc = "Delete cell output" })

-- .ipynb import/export (round-trip outputs with the notebook file)
map("n", "<localleader>nb", function()
	vim.cmd("MoltenImportOutput " .. vim.fn.expand("%:p"))
end, { desc = "Import notebook outputs" })
map("n", "<localleader>nx", function()
	vim.cmd("MoltenExportOutput! " .. vim.fn.expand("%:p"))
end, { desc = "Export notebook outputs" })
