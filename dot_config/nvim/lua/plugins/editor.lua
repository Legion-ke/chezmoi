return {
  -- =========================================================================
  -- 1. OIL.NVIM (File Management)
  -- =========================================================================
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        columns = { "icon", "size", "mtime" },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _) return name == '..' or name == '.git' end,
        },
        keymaps = {
          ["g?"]    = "actions.show_help",
          ["<CR>"]  = "actions.select",
          ["l"]     = "actions.select",
          ["h"]     = "actions.parent",
          ["<BS>"]  = "actions.parent",
          ["-"]     = "actions.parent",
          ["q"]     = "actions.close",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["_"]     = "actions.open_cwd",
          ["`"]     = "actions.cd",
          ["~"]     = "actions.tcd",
          ["gs"]    = "actions.change_sort",
          ["gx"]    = "actions.open_external",
          ["g."]    = "actions.toggle_hidden",
        },
      })
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- =========================================================================
  -- 2. FZF-LUA (Blazing Fast Fuzzy Finding)
  -- =========================================================================
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        "fzf-native",
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = { layout = "vertical", vertical = "up:45%" },
        },
      })
      vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "Project Files" })
      vim.keymap.set("n", "<leader>ps", fzf.live_grep, { desc = "Project Search" })
      vim.keymap.set("n", "<leader><space>", fzf.buffers, { desc = "Switch Buffers" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
      vim.keymap.set("n", "<leader>?", fzf.help_tags, { desc = "Help Tags" })
    end,
  },

  -- =========================================================================
  -- 3. ZEN MODE & TWILIGHT (Focus Tools)
  -- =========================================================================
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode", -- Loads only when you run the command
    opts = {
      window = { backdrop = 0.95, width = 120 },
      plugins = {
        options = { enabled = true, ruler = false, showcmd = false },
        twilight = { enabled = true }, -- auto enable twilight when zen
      },
    },
  },
  {
    "folke/twilight.nvim", -- Dims inactive code
    opts = { context = 10, dimming = { alpha = 0.4 } },
  },

  -- =========================================================================
  -- 4. BETTER ESCAPE (Fast Mode Switching)
  -- =========================================================================
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      default_mappings = false,
      mappings = {
        i = {
          j = { k = "<Esc>", j = "<Esc>" },
        },
      },
    },
  },

  -- =========================================================================
  -- 5. AUTO SAVE
  -- =========================================================================
  {
    "Pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = { message = function() return "" end },
      trigger_events = { "InsertLeave", "TextChanged" },
    },
  },

  -- =========================================================================
  -- 6. UNDOTREE
  -- =========================================================================
  {
    "mbbill/undotree",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
    },
  },
  -- =========================================================================
  -- 7. MULTI-CURSOR (VS Code Style)
  -- =========================================================================
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      -- Optimize for speed
      vim.g.vm_theme = "ocean"
      vim.g.vm_maps = {
        ["Find Under"] = "<C-n>", -- Select current word (like VS Code Ctrl+d)
        ["Find Subword Under"] = "<C-n>",
      }
    end,
  },
  -- =========================================================================
  -- 7. TROUBLE (The "Problems" Tab)
  -- =========================================================================
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,  -- Jump to the window when opened
    },
    cmd = "Trouble", -- Lazy load until command is used
  },
}
