return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { { "prettierd", "prettier" } },
      typescript = { "eslint_d" },
      -- Added Go and Rust here:
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      -- Fallback for others
      ["_"] = { "trim_whitespace" },
    },
  },
}
