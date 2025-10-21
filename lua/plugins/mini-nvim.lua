return {
  'nvim-mini/mini.nvim',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Setup mini.indentscope
    require('mini.indentscope').setup({
      symbol = "│",
      -- symbol = "╎",
      options = { try_as_border = true },
    })
    
    -- Customize the color of the indent scope line
    -- You can change the color by modifying the 'fg' value (hex color code)
    -- Some examples:
    -- vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#E06C75' })  -- Red
    -- vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#61AFEF' })  -- Blue
    -- vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#98C379' })  -- Green
    -- vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#E5C07B' })  -- Yellow
    vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#61AFEF' })  -- Blue (default example)
    
    -- Disable in certain filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}