-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Remove solid background from cursorline so it respects terminal transparency
-- defer_fn ensures this runs AFTER the colorscheme finishes loading
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", bold = true })
    end, 100)
  end,
})
