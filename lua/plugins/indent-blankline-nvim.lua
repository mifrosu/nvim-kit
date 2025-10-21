-- Indentation guides
return {
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  "lukas-reineke/indent-blankline.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = '│', -- Use a better looking character
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
    },
  },
}
