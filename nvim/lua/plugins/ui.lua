local function alternate_buffer()
  local name = vim.fn.bufname("#")
  if name == "" then
    return nil
  end

  return vim.fn.fnamemodify(name, ":t")
end

local function current_branch()
  local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })
  if vim.v.shell_error ~= 0 or branch[1] == nil or branch[1] == "" then
    return nil
  end

  return branch[1]
end

local gruvbox = {
  red = "#fb4934",
  orange = "#fe8019",
  yellow = "#fabd2f",
  green = "#b8bb26",
  aqua = "#8ec07c",
  blue = "#83a598",
  purple = "#d3869b",
  indent = "#504945",
  indent_scope = "#665c54",
  background = "#282828",
  foreground = "#ebdbb2",
}

local branch = {
  current_branch,
  icon = { "", color = { fg = gruvbox.orange, bg = "NONE" } },
  color = { fg = gruvbox.blue, bg = "NONE", gui = "bold" },
  padding = { left = 0, right = 1 },
}

local filename = {
  "filename",
  icon = "󰈔",
  color = { fg = gruvbox.orange, bg = "NONE" },
  padding = { left = 0, right = 1 },
}

local alternate = {
  alternate_buffer,
  cond = function()
    return alternate_buffer() ~= nil
  end,
  icon = "↶",
  color = { fg = gruvbox.purple, bg = "NONE" },
  padding = { left = 0, right = 1 },
}

-- Use Normal-linked colors for empty sections so lualine keeps the editor background.
local transparent_theme = {
  normal = {
    a = { fg = gruvbox.foreground, bg = "NONE" },
    b = { fg = gruvbox.foreground, bg = "NONE" },
    c = { fg = gruvbox.foreground, bg = "NONE" },
  },
  inactive = {
    a = { fg = gruvbox.foreground, bg = "NONE" },
    b = { fg = gruvbox.foreground, bg = "NONE" },
    c = { fg = gruvbox.foreground, bg = "NONE" },
  },
}

local function build_statusline_sections()
  return {
    lualine_a = { branch },
    lualine_b = { filename, alternate },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
end

local statusline_sections = build_statusline_sections()
local inactive_statusline_sections = build_statusline_sections()

-- This file contains the configuration for various UI-related plugins in Neovim.
return {
  -- Plugin: folke/todo-comments.nvim
  -- URL: https://github.com/folke/todo-comments.nvim
  -- Description: Plugin to highlight and search for TODO, FIX, HACK, etc. comments in your code.
  -- IMPORTANT: using version "*" to fix a bug
  { "folke/todo-comments.nvim", version = "*" },

  -- Plugin: folke/which-key.nvim
  -- URL: https://github.com/folke/which-key.nvim
  -- Description: Plugin to show a popup with available keybindings.
  -- IMPORTANT: using event "VeryLazy" to optimize loading time
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = { border = "single" },
    },
  },

  -- Plugin: nvim-docs-view
  -- URL: https://github.com/amrbashir/nvim-docs-view
  -- Description: A Neovim plugin for viewing documentation.
  {
    "amrbashir/nvim-docs-view",
    lazy = true, -- Load this plugin lazily
    cmd = "DocsViewToggle", -- Command to toggle the documentation view
    opts = {
      position = "right", -- Position the documentation view on the right
      width = 60, -- Set the width of the documentation view
    },
  },

  -- Plugin: lualine.nvim
  -- URL: https://github.com/nvim-lualine/lualine.nvim
  -- Description: A blazing fast and easy to configure Neovim statusline plugin.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event
    requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- Optional dependency for icons
    opts = {
      options = {
        theme = transparent_theme,
        icons_enabled = true,
        section_separators = "",
        component_separators = "",
      },
      sections = statusline_sections,
      inactive_sections = inactive_statusline_sections,
      extensions = {
        "quickfix",
        {
          filetypes = { "oil" },
          sections = statusline_sections,
          inactive_sections = inactive_statusline_sections,
        },
      },
    },
  },


  -- Plugin: zen-mode.nvim
  -- URL: https://github.com/folke/zen-mode.nvim
  -- Description: A Neovim plugin for distraction-free coding.
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode", -- Command to toggle Zen Mode
    opts = {
      plugins = {
        gitsigns = true, -- Enable gitsigns integration
        tmux = true, -- Enable tmux integration
        kitty = { enabled = false, font = "+2" }, -- Disable kitty integration and set font size
        twilight = { enabled = true }, -- Enable twilight integration
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } }, -- Keybinding to toggle Zen Mode
  },

  -- Plugin: snacks.nvim
  -- URL: https://github.com/folke/snacks.nvim/tree/main
  -- Description: A Neovim plugin for creating a customizable dashboard.
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find Buffers",
      },
    },
    opts = {
      indent = {
        enabled = true,
        indent = {
          hl = "SnacksIndent",
        },
        scope = {
          hl = "SnacksIndentScope",
        },
      },
      notifier = {},
      image = {},
      picker = {
        exclude = {
          ".git",
          "node_modules",
        },
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = true,
          filename_bonus = true,
        },
        sources = {
          -- explorer = {
          --   matcher = {
          --     fuzzy = true, -- Enables fuzzy matching, so you can be a bit imprecise with your search terms
          --     smartcase = true, -- If your search term has uppercase letters, the search becomes case-sensitive
          --     ignorecase = true, -- Ignores case when searching, unless smartcase is triggered
          --     filename_bonus = true, -- Gives a higher priority to matches in filenames
          --     sort_empty = false, -- If no matches are found, it won't sort the results
          --   },
          -- },
        },
      },
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", limit = 3, indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
        preset = {
          header = (function()
            local file = io.open(vim.fn.expand("~/.config/nvim/dashboard-header.txt"), "r")
            if not file then return "" end
            local content = file:read("*all")
            file:close()
            return content:gsub("\n$", "")
          end)(),
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "ff", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
    config = function(_, opts)
      local Snacks = require("snacks")
      Snacks.setup(opts)
      require("snacks.indent")
      Snacks.util.set_hl({
        SnacksIndent = { fg = gruvbox.indent },
        SnacksIndentScope = { fg = gruvbox.indent_scope },
      })
    end,
  },
}
