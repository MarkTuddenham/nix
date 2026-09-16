local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader>h", "<cmd>noh<cr>")

-- Paste from clipboard
map({ "n", "v" }, "<leader>p", '"+p<cr>')
map({ "n", "v" }, "<leader>P", '"+P<cr>')

-- Keep flags when reusing substitution
map({ "n", "x" }, "&", ":&&<cr>")

-- Better navigation with next (keeps cursor centered)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- More undo break points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")
map("i", "(", "(<c-g>u")
map("i", ")", ")<c-g>u")

-- Jump list mutations: add to jumplist when moving more than 5 lines
map("n", "k", function()
	return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "k"
end, { expr = true })
map("n", "j", function()
	return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "j"
end, { expr = true })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- Delete line
map("n", "dl", "d0D")

-- Open tmux sessioniser
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessioniser<cr>", { silent = true })

-- Color column highlighting
vim.opt.colorcolumn = "80,120"
vim.cmd("hi ColorColumn ctermbg=lightgrey guibg=#393552")
vim.cmd("highlight OverLength ctermbg=red ctermfg=white guibg=#393552")
vim.cmd("match OverLength /\\%101v.\\+/")
