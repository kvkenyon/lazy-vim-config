-- lua/plugins/ruff.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_format", "ruff_fix" }, -- Use ruff_format for formatting and ruff_fix for auto-fixable issues
      -- Add other filetypes as needed
    },
    -- Optional: Configure default formatting options
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
  },
}
