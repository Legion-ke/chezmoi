return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ng", function() require("neogit").open() end, desc = "Neogit Status" },
  },
  opts = {
    kind = "floating",
  },
  config = true,
}
