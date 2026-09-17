-- This file contains custom key mappings for Neovim.

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map Ctrl+b in insert mode to delete to the end of the word without leaving insert mode
vim.keymap.set("i", "<C-b>", "<C-o>de")

-- Map Ctrl+c to escape from other modes
vim.keymap.set({ "i", "n", "v" }, "<C-c>", [[<C-\><C-n>]])



----- VS Code style ──────────────────────────────────────────────────────────
-- Ghostty reenvía Cmd+key como ESC+key (= <M-key> en Neovim).
-- Cmd+C se copia desde Neovim; Cmd+V lo maneja Ghostty con el clipboard nativo.
-- Esperar brevemente para que Neovim reconozca ESC+key como una sola tecla Meta.
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100

-- Shift+flechas: seleccionar carácter a carácter
vim.keymap.set("n", "<S-Right>", "v<Right>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Left>",  "v<Left>",  { noremap = true, silent = true })
vim.keymap.set("n", "<S-Up>",    "v<Up>",    { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>",  "v<Down>",  { noremap = true, silent = true })
vim.keymap.set("v", "<S-Right>", "<Right>",  { noremap = true, silent = true })
vim.keymap.set("v", "<S-Left>",  "<Left>",   { noremap = true, silent = true })
vim.keymap.set("v", "<S-Up>",    "<Up>",     { noremap = true, silent = true })
vim.keymap.set("v", "<S-Down>",  "<Down>",   { noremap = true, silent = true })
vim.keymap.set("i", "<S-Right>", "<Esc>lv<Right>", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Left>",  "<Esc>v<Left>",   { noremap = true, silent = true })
vim.keymap.set("i", "<S-Up>",    "<Esc>lv<Up>",    { noremap = true, silent = true })
vim.keymap.set("i", "<S-Down>",  "<Esc>lv<Down>",  { noremap = true, silent = true })

-- Shift+Option+flechas: seleccionar palabra a palabra
vim.keymap.set("n", "<S-A-Right>", "vw",       { noremap = true, silent = true })
vim.keymap.set("n", "<S-A-Left>",  "vb",       { noremap = true, silent = true })
vim.keymap.set("v", "<S-A-Right>", "w",        { noremap = true, silent = true })
vim.keymap.set("v", "<S-A-Left>",  "b",        { noremap = true, silent = true })
vim.keymap.set("i", "<S-A-Right>", "<Esc>lvw", { noremap = true, silent = true })
vim.keymap.set("i", "<S-A-Left>",  "<Esc>vb",  { noremap = true, silent = true })

-- Option+flechas: mover cursor palabra a palabra (sin selección)
vim.keymap.set({ "n", "v" }, "<A-Right>", "w",        { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<A-Left>",  "b",        { noremap = true, silent = true })
vim.keymap.set("i",           "<A-Right>", "<Esc>lwi", { noremap = true, silent = true })
vim.keymap.set("i",           "<A-Left>",  "<Esc>bi",  { noremap = true, silent = true })

-- Cmd+Left/Right: mover al inicio/final de línea.
vim.keymap.set({ "n", "v" }, "<Home>", "0", { noremap = true, silent = true, desc = "Move to line start" })
vim.keymap.set({ "n", "v" }, "<End>",  "$", { noremap = true, silent = true, desc = "Move to line end" })
vim.keymap.set("i", "<Home>", "<C-o>0", { noremap = true, silent = true, desc = "Move to line start" })
vim.keymap.set("i", "<End>",  "<C-o>$", { noremap = true, silent = true, desc = "Move to line end" })

-- Cmd+Shift+Left/Right: seleccionar hasta el inicio/final de línea.
vim.keymap.set("n", "<S-Home>", "v0", { noremap = true, silent = true, desc = "Select to line start" })
vim.keymap.set("n", "<S-End>",  "v$", { noremap = true, silent = true, desc = "Select to line end" })
vim.keymap.set("v", "<S-Home>", "0", { noremap = true, silent = true, desc = "Select to line start" })
vim.keymap.set("v", "<S-End>",  "$", { noremap = true, silent = true, desc = "Select to line end" })
vim.keymap.set("i", "<S-Home>", "<Esc>v0", { noremap = true, silent = true, desc = "Select to line start" })
vim.keymap.set("i", "<S-End>",  "<Esc>lv$", { noremap = true, silent = true, desc = "Select to line end" })

-- Cmd+C: copiar la línea o selección al clipboard del sistema.
vim.keymap.set("n", "<M-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line" })
vim.keymap.set("v", "<M-c>", '"+y',  { noremap = true, silent = true, desc = "Copy selection" })
vim.keymap.set("i", "<M-c>", '<Esc>"+yygi', { noremap = true, silent = true, desc = "Copy line" })

-- Cmd+Z / Cmd+Shift+Z: undo / redo
vim.keymap.set({ "n", "i", "v" }, "<M-z>", "<cmd>undo<CR>",  { noremap = true, silent = true, desc = "Undo" })
vim.keymap.set({ "n", "i", "v" }, "<M-Z>", "<cmd>redo<CR>",  { noremap = true, silent = true, desc = "Redo" })

-- Cmd+X: cortar línea/selección al clipboard
vim.keymap.set("n", "<M-x>", '"+dd',  { noremap = true, silent = true, desc = "Cut line" })
vim.keymap.set("v", "<M-x>", '"+d',   { noremap = true, silent = true, desc = "Cut selection" })

-- Cmd+A: seleccionar todo
vim.keymap.set({ "n", "i" }, "<M-a>", "<Esc>ggVG", { noremap = true, silent = true, desc = "Select all" })

-- Cmd+/: comentar/descomentar línea
vim.keymap.set({ "n", "v" }, "<M-/>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })

-- Cmd+D: seleccionar siguiente ocurrencia (multicursor via flash/select)
vim.keymap.set("n", "<M-d>", "*Ncgn", { noremap = true, silent = true, desc = "Select next occurrence" })

-- Cmd+B: toggle explorador de archivos con mini.files
-- Ghostty reenvía Cmd+B como ESC+B, que Neovim recibe como <M-b>.
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set("n", "<CR>", function()
      require("mini.files").go_in({ close_on_file = true })
    end, {
      buffer = args.data.buf_id,
      noremap = true,
      silent = true,
      desc = "Open file or enter directory",
    })
  end,
})

vim.keymap.set({ "n", "i", "v" }, "<M-b>", function()
  local ok, mf = pcall(require, "mini.files")
  if not ok then return end

  -- Cerrar si ya está abierto; si no, abrirlo en el archivo/directorio actual.
  if mf.close() ~= nil then return end

  -- Obtener path real del buffer actual (ignorar buffers virtuales/especiales)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path
  if buf_name ~= "" and not buf_name:match("^%w+://") and vim.fn.filereadable(buf_name) == 1 then
    path = buf_name
  else
    path = vim.fn.getcwd()
  end

  mf.open(path, true)
end, { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Cmd+P: buscar archivo
vim.keymap.set({ "n", "i", "v" }, "<M-p>", function() require("snacks").picker.files() end, { noremap = true, silent = true, desc = "Find file" })

-- Cmd+Shift+H: return to the Snacks dashboard without closing buffers.
vim.keymap.set({ "n", "i", "v" }, "<M-H>", function()
  vim.cmd("stopinsert")
  local ok, snacks = pcall(require, "snacks")
  if not ok then return end
  pcall(function() snacks.dashboard() end)
end, { noremap = true, silent = true, desc = "Open dashboard" })


----- OIL -----
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Delete all buffers but the current one
vim.keymap.set(
  "n",
  "<leader>bq",
  '<Esc>:%bdelete|edit #|normal`"<Return>',
  { desc = "Delete other buffers but the current one" }
)

-- Disable key mappings in insert mode
vim.api.nvim_set_keymap("i", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-k>", "<Nop>", { noremap = true, silent = true })

-- Disable key mappings in normal mode
vim.api.nvim_set_keymap("n", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "<Nop>", { noremap = true, silent = true })

-- Disable key mappings in visual block mode
vim.api.nvim_set_keymap("x", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<A-k>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "K", "<Nop>", { noremap = true, silent = true })

-- Redefine Ctrl+s to save with the custom function
vim.api.nvim_set_keymap("n", "<C-s>", ":lua SaveFile()<CR>", { noremap = true, silent = true })

-- Grep keybinding for visual mode - search selected text
vim.keymap.set("v", "<leader>sg", function()
  -- Get the selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")

  -- Escape special characters for grep
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  -- Use the selected text for grep
  if pcall(require, "snacks") then
    require("snacks").picker.grep({ search = selected_text })
  elseif pcall(require, "fzf-lua") then
    require("fzf-lua").live_grep({ search = selected_text })
  else
    vim.notify("No grep picker available", vim.log.levels.ERROR)
  end
end, { desc = "Grep Selected Text" })

-- Grep keybinding for visual mode with G - search selected text at root level
vim.keymap.set("v", "<leader>sG", function()
  -- Get git root or fallback to cwd
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  local root = vim.v.shell_error == 0 and git_root ~= "" and git_root or vim.fn.getcwd()

  -- Get the selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")

  -- Escape special characters for grep
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  -- Use the selected text for grep at root level
  if pcall(require, "snacks") then
    require("snacks").picker.grep({ search = selected_text, cwd = root })
  elseif pcall(require, "fzf-lua") then
    require("fzf-lua").live_grep({ search = selected_text, cwd = root })
  else
    vim.notify("No grep picker available", vim.log.levels.ERROR)
  end
end, { desc = "Grep Selected Text (Root Dir)" })

-- Delete all marks
vim.keymap.set("n", "<leader>md", function()
  vim.cmd("delmarks!")
  vim.cmd("delmarks A-Z0-9")
  vim.notify("All marks deleted")
end, { desc = "Delete all marks" })

-- Custom save function
function SaveFile()
  -- Check if a buffer with a file is open
  if vim.fn.empty(vim.fn.expand("%:t")) == 1 then
    vim.notify("No file to save", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.expand("%:t") -- Get only the filename
  local success, err = pcall(function()
    vim.cmd("silent! write") -- Try to save the file without showing the default message
  end)

  if success then
    vim.notify(filename .. " Saved!") -- Show only the custom message if successful
  else
    vim.notify("Error: " .. err, vim.log.levels.ERROR) -- Show the error message if it fails
  end
end
