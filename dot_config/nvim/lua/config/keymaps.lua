-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Apply this file to your config

local map = vim.keymap.set

-- =============================================================================
-- 1. GENERAL EDITING (The "Make it feel nice" stuff)
-- =============================================================================

-- REDO: Make 'U' behave like 'Redo' (Standard Vim is Ctrl-r)
map("n", "U", "<C-r>", { desc = "Redo" })

-- QUICK SAVE: Ctrl+s to save (Works in Insert, Visual, and Normal modes)
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- BETTER INDENTING: Stay in Visual Mode when pressing < or >
map("v", "<", "<gv", { desc = "Indent Left" })
map("v", ">", ">gv", { desc = "Indent Right" })

-- MOVE LINES: Alt + j/k to move text up and down (Like VS Code)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })


-- =============================================================================
-- 2. HARPOON (Speed Navigation)
-- =============================================================================

-- Add current file to Harpoon list
map("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon Add File" })

-- Toggle the quick menu (Visual list of files)
map("n", "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
  { desc = "Harpoon Menu" })

-- JUMP immediately to files 1-4 (The fastest way to switch buffers)
map("n", "<C-j>", function() require("harpoon"):list():select(1) end, { desc = "Harpoon File 1" })
map("n", "<C-k>", function() require("harpoon"):list():select(2) end, { desc = "Harpoon File 2" })
map("n", "<C-l>", function() require("harpoon"):list():select(3) end, { desc = "Harpoon File 3" })
map("n", "<C-;>", function() require("harpoon"):list():select(4) end, { desc = "Harpoon File 4" })


-- =============================================================================
-- 3. TMUX INTEGRATION (Run Code in Tmux Panes)
-- =============================================================================

-- HELPER FUNCTION: Sends a command to a new Tmux split
local function run_in_tmux(cmd_str)
  -- 1. Save the file first
  vim.cmd("w")

  -- 2. Construct the tmux command
  -- split-window -h : split horizontally (side by side)
  -- -c '#{pane_current_path}' : use current directory
  -- -l 35% : take up 35% of the screen
  -- "..." : the command to run, followed by a pause so it doesn't close immediately
  local tmux_cmd = string.format(
    "tmux split-window -h -l 35%% -c '%s' '%s; echo \"\\n[Press Enter to close]\"; read'",
    vim.fn.getcwd(), -- Current Working Directory
    cmd_str
  )

  -- 3. Execute it
  os.execute(tmux_cmd)
end

-- KEYMAP: <leader>r to Run Project in Tmux
map("n", "<leader>.", function()
  local ft = vim.bo.filetype
  if ft == "go" then
    run_in_tmux("go run .")
  elseif ft == "rust" then
    run_in_tmux("cargo run")
  elseif ft == "typescript" or ft == "javascript" then
    run_in_tmux("bun run index.ts") -- Adjust for your project entry point
  elseif ft == "python" then
    run_in_tmux("python3 " .. vim.fn.expand("%"))
  else
    vim.notify("No run command for " .. ft)
  end
end, { desc = "Run in Tmux" })


-- KEYMAP: <leader>tt for a Quick Terminal Split
-- Opens a blank terminal next to your code
map("n", "<leader>tt", function()
  -- split-window -h (horizontal) or -v (vertical)
  os.execute("tmux split-window -h -l 35% -c '" .. vim.fn.getcwd() .. "'")
end, { desc = "Tmux Terminal Split" })

-- KEYMAP: <leader>tf for a Floating Terminal (Tmux Popup)
-- Requires Tmux 3.2+
map("n", "<leader>tf", function()
  os.execute("tmux display-popup -E -w 80% -h 80% -d '" .. vim.fn.getcwd() .. "'")
end, { desc = "Tmux Float Terminal" })
-- =============================================================================
-- 4. VIEW TOGGLES
-- =============================================================================

-- Zen Mode Toggle
map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })

-- UndoTree Toggle
map("n", "<leader>U", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })

-- Clean View (Toggle line numbers and sign column for reading)
map("n", "<leader>uc", function()
  vim.opt.number = not vim.opt.number:get()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
  vim.opt.signcolumn = vim.opt.signcolumn:get() == "yes" and "no" or "yes"
end, { desc = "Toggle Clean View" })



-- =============================================================================
-- 5. FASTER NAVIGATION (Flash & Buffers)
-- =============================================================================

-- FLASH JUMP (The fastest way to move on screen)
-- Press 's', type 2 characters, then jump to any highlighted spot.
-- (LazyVim uses 's' by default, but we force it here to be sure)
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })

-- BUFFER CYCLING (Shift + H/L)
-- Move between open files without opening a menu
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- DIAGNOSTICS (Jumping between errors)
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Next Error" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Prev Error" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" }) -- Show error message in float


-- =============================================================================
-- 6. BETTER EDITING (Surround & Text Objects)
-- =============================================================================

-- SURROUND SHORTCUTS (Leveraging mini.surround)
-- LazyVim defaults are 'gsa' (add), 'gsd' (delete), 'gsr' (replace).
-- Let's make them memorable.

-- Visual Mode: Wrap selection with " or ( or {
-- Usage: Highlight text, press S, then type " or )
map("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Surround Selection" })

-- DELETE/CHANGE SURROUND (Normal Mode)
-- Usage: 'sd"' (delete surrounding quotes) | 'sr"'' (replace " with ')
map("n", "sd", [[:<C-u>lua MiniSurround.delete()<CR>]], { desc = "Delete Surround" })
map("n", "sr", [[:<C-u>lua MiniSurround.replace()<CR>]], { desc = "Replace Surround" })

-- QUICK REPLACE WORD
-- Highlight a word, press <leader>rw to replace all occurrences in the file
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace Word Under Cursor" })

-- =============================================================================
-- 7. TROUBLE DIAGNOSTICS
-- =============================================================================

-- Project-wide Errors (Like VS Code "Problems" tab)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Project Diagnostics" })

-- Current File Errors
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

-- Symbols Outline (Variables, Functions in current file)
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols Outline" })



-- =============================================================================
-- 8. VS CODE STYLE EDITING (Undo/Redo/Actions)
-- =============================================================================

-- UNDO (Ctrl+z)
-- Maps Ctrl+z to Undo in both Normal and Insert modes
map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })

-- REDO (Ctrl+y)
-- Maps Ctrl+y to Redo (Standard for Windows/Linux editors)
map("n", "<C-y>", "<cmd>redo<cr>", { desc = "Redo" })
map("i", "<C-y>", "<cmd>stopinsert | redo<cr>", { desc = "Redo" })

-- CODE ACTIONS (Ctrl+.)
-- The standard "Quick Fix" menu.
-- "Ctrl+r" is usually reserved for Redo in Vim, so we use "Ctrl+." (VS Code style)
map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action" })

-- RENAME VARIABLE (F2)
-- Standard rename key
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
