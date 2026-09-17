-- Runs after ALL plugins load — sobreescribe cualquier colorscheme

-- Cursorline
vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", bold = true })

-- Gruvbox text visibility overrides
vim.api.nvim_set_hl(0, "Normal",     { fg = "#ebdbb2", bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC",   { fg = "#ebdbb2", bg = "NONE" })
vim.api.nvim_set_hl(0, "Comment",    { fg = "#a89984", italic = true })
vim.api.nvim_set_hl(0, "NonText",    { fg = "#928374" })
vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#928374" })
vim.api.nvim_set_hl(0, "Conceal",    { fg = "#a89984" })
