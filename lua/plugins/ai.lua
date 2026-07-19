return {
  {
    "georgeguimaraes/review.nvim",
    version = "v*",
    dependencies = {
      "esmuellert/codediff.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Review" },
    opts = {},
    config = function(_, opts)
      require("review").setup(opts)
      require("review.export").to_sidekick = function()
        require("herdr").send_review()
      end
    end,
  }
}
