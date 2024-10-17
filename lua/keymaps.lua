local opts = { noremap = true, silent = false }
local keymap = vim.api.nvim_set_keymap

keymap("n", ";", ":", opts)
keymap("n", "<Esc><Esc>", ":noh<CR>", opts)
keymap("i", "jj", "<Esc>", opts)

