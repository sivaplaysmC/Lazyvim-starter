-- local cmd = vim.cmd
-- local api = vim.api
-- local fn = vim.fn
--
-- local function createQf()
--     cmd('enew')
--     local bufnr = api.nvim_get_current_buf()
--     local lines = {}
--     for i = 1, 3 do
--         table.insert(lines, ('%d | %s'):format(i, fn.strftime('%F')))
--     end
--     api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
--     fn.setqflist({
--         {bufnr = bufnr, lnum = 1, col = 5}, {bufnr = bufnr, lnum = 2, col = 10},
--         {bufnr = bufnr, lnum = 3, col = 13}
--     })
-- end
--
-- function _G.bqfPattern()
--     createQf()
--     fn.setqflist({}, 'r', {context = {bqf = {pattern_hl = [[\d\+]]}}, title = 'patternHl'})
--     cmd('cw')
-- end
--
-- function _G.bqfLspRanges()
--     createQf()
--     local lspRanges = {}
--     table.insert(lspRanges,
--         {start = {line = 0, character = 4}, ['end'] = {line = 0, character = 8}})
--     table.insert(lspRanges,
--         {start = {line = 1, character = 9}, ['end'] = {line = 1, character = 11}})
--     table.insert(lspRanges,
--         {start = {line = 2, character = 12}, ['end'] = {line = 2, character = 14}})
--     fn.setqflist({}, 'r', {context = {bqf = {lsp_ranges_hl = lspRanges}}, title = 'lspRangesHl'})
--     cmd('cw')
-- end
--
-- function _G.qfRanges()
--     createQf()
--     local items = fn.getqflist()
--     local it1, it2, it3 = items[1], items[2], items[3]
--     it1.end_lnum, it1.end_col = it1.lnum, it1.col + 4
--     it2.end_lnum, it2.end_col = it2.lnum, it2.col + 2
--     it3.end_lnum, it3.end_col = it3.lnum, it3.col + 2
--     fn.setqflist({}, 'r', {items = items, title = 'qfRangesHl'})
--     cmd('cw')
-- end
--
-- -- Save and source me(`so %`). Run `:lua bqfPattern()`, `:lua bqfLspRanges()` and `:lua qfRanges()`

-- Define custom highlight groups for quickfix entries
-- vim.cmd("highlight link QuickFixError ErrorMsg")
-- vim.cmd("highlight link QuickFixWarning WarningMsg")
-- vim.cmd("highlight link QuickFixInfo SpecialComment")
--
-- -- Add custom entries to the quickfix list with different highlight groups
--
-- local qflist = {}
-- local function add_to_quickfix(message, type)
-- 	-- Create a new item for the quickfix list
-- 	local new_item = {
-- 		text = message,
-- 		type = type,
-- 		lnum = 1,
-- 		col = 1,
-- 	}
--
-- 	-- Append the new item to the existing quickfix list
-- 	table.insert(qflist, new_item)
--
-- 	-- Set the modified quickfix list
-- 	vim.fn.setqflist(qflist)
--
-- 	-- Open the quickfix window
-- end
--
-- -- Example usage:
-- add_to_quickfix("Error message", "QuickFixError")
-- add_to_quickfix("Warning message", "QuickFixWarning")
-- add_to_quickfix("Info message", "QuickFixInfo")
--
-- vim.cmd("copen")

vim = vim

-- Function to create a new floating window for your custom quickfix list
local function create_custom_quickfix_list(items)
	-- Calculate the size and position of the floating window
	-- Calculate the position of the status bar
	local status_line_height = vim.o.cmdheight
	local status_line_row = vim.o.lines - status_line_height + 1

	-- Calculate the size of the floating window
	local height = 12
	local row = status_line_row - height - 2

	-- Define options for the floating window
	local opts = {
		relative = "editor",
		row = row,
		col = 0,
		width = vim.o.columns,
		height = height,
		style = "minimal",
		border = { "", "", "", "", "", "", "", "" },
	}

	-- Create a new buffer for the floating window
	local buf = vim.api.nvim_create_buf(false, true)

	vim.keymap.set("n", "<CR>", function()
		vim.notify("Hi There")
	end, { noremap = true, silent = true, buffer = buf })

	-- Open a new floating window with the specified options
	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { noremap = true, silent = true, buffer = buf })

	-- Get quickfix list
	local qf_list = vim.fn.getqflist()

	-- Populate buffer with quickfix list entries
	local lines = {}
	for _, item in ipairs(qf_list) do
		table.insert(lines, string.format("%s:%d:%s", item.filename, item.lnum, item.text))
	end

	-- Set the content of the buffer with the provided items
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)

	return win
end

-- Example usage:
local my_items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
local my_quickfix_list = create_custom_quickfix_list(my_items)

-- vim.defer_fn(function()
-- 	vim.api.nvim_win_close(my_quickfix_list, true)
-- end, 3000)
