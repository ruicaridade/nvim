return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local fzf_opts = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }

      local telescope = require "telescope"
      telescope.setup {
        pickers = {
          lsp_dynamic_workspace_symbols = {
            sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts),
          },
        },
        extensions = {
          fzf = fzf_opts,
        },
      }
      telescope.load_extension "fzf"
    end,
  },
}
