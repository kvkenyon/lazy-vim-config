-- lua/plugins/neogen.lua

return {
  "danymat/neogen",
  opts = {
    snippet_engine = "luasnip",
  },
  config = function(_, opts)
    require("neogen").setup(opts)

    -- Set reStructuredText as default
    vim.g.neogen_default_annotations = "reST"
  end,
  keys = {
    {
      "<leader>cc",
      function()
        require("neogen").generate()
      end,
      desc = "Generate docstring",
    },
  },
}
