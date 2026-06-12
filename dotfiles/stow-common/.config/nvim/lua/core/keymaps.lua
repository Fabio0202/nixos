local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { silent = true })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { silent = true })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { silent = true })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { silent = true })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Stay in visual after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { silent = true })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { silent = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { silent = true })

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- Save / quit
map({ "n", "i" }, "<C-s>", "<cmd>w<cr>",  { desc = "Save" })
map("n", "<leader>q",       "<cmd>q<cr>",  { desc = "Quit" })
map("n", "<leader>Q",       "<cmd>qa<cr>", { desc = "Quit all" })

-- File explorer
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "File explorer" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })

-- LSP (buffer-local ones are set in lsp.lua on_attach, these are global fallbacks)
map("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })

