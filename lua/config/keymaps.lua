local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local opt = vim.opt

-- Wrap
map({ "n", "v", "s", "o" }, "j", "gj", opts)
map({ "n", "v", "s", "o" }, "k", "gk", opts)

-- Better line start/end (more comfortable than $ and ^)
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })
map("n", "<A-h>", "^", { desc = "Go to start of line", silent = true })
map("n", "<A-l>", "$", { desc = "Go to end of line", silent = true })

map("n", "<leader>o", "m`o<esc>``", { desc = "Insert empty line below", noremap = true })
map("n", "<leader>O", "m`O<esc>``", { desc = "Insert empty line aboce", noremap = true })

-- Open Exploerer
map("n", "<A-e>", ":Ex<CR>", opts)
-- Tab Transition
map("n", "<enter><enter>", "<C-w><C-w>", opts)
-- Copy whole file to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole file to clipboad" })

-- Quick switch to last edited file (super useful!)
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Commenting (add comment above/below current line)
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

map("n", "<leader>n",
  function()
    opt.relativenumber = not opt.relativenumber:get()
  end,
  { desc = "Toggle relative line numbers" }
)
