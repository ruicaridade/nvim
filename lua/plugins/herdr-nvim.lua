return {
  {
    "ChmaraX/herdr-nvim",
    lazy = false,
    opts = {},
    config = function(_, opts)
      local herdr = require("herdr-nvim")
      herdr.setup(opts)

      local function comment()
        local bufnr = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == "" or vim.bo[bufnr].buftype ~= "" or vim.fn.filereadable(name) ~= 1 then
          vim.notify("Comment on the working-tree file pane", vim.log.levels.WARN, {
            title = "herdr-nvim",
          })
          return
        end

        if vim.fn.mode():match("[vV\22]") then
          herdr.comment_selection()
        else
          herdr.comment_line()
        end
      end

      vim.keymap.set({ "n", "x" }, "<leader>ac", comment, {
        desc = "Comment for Herdr agent",
      })

      -- <leader>as already sends the current file/selection to a Herdr agent.
      vim.keymap.set("n", "<leader>ax", "<cmd>Herdr send<cr>", {
        desc = "Send Herdr annotations",
      })
    end,
  },
}
