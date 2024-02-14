-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

local vimrc = vim.api.nvim_create_augroup("vimrc", { clear = true })

--- @sivaplays REMEMBER TO RTFM BEFORE GOING ON A FUCKING SIDE QUEST
---
--
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   group = myGroup,
--   pattern = { "*.templ" },
--   callback = function(args)
--     local filename = vim.api.nvim_buf_get_name(args.buf)
--     vim.system({ "templ", "generate", "-f", filename })
--     vim.notify(([[templ generate -f %s]]):format(filename))
--   end,
-- })

-- vim.api.nvim_clear_autocmds({ group = "autocmd-lua" })

-- vim.api.nvim_create_autocmd("FileType", {
--   group = vimrc,
--   pattern = { "*.templ" },
--   callback = function(args)
--     local bufnr = args.buf
--     -- vim.lsp.buf_attach_client(bufnr, )
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vimrc,
  pattern = "*.hyper",
  callback = function(args)
    vim.api.nvim_set_option_value("filetype", "hyperscript", { buf = args.buf })
    -- vim.cmd("TSBufEnable higlight")
  end,
})
