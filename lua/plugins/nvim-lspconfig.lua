-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'BufReadPre', -- Load on very lazy event
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { 'williamboman/mason-lspconfig.nvim' },

    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function ()
    require('mason').setup()
    require('mason-lspconfig').setup({
      -- Install these LSPs automatically
      ensure_installed = {
        'bashls', -- requires npm to be installed
        'cssls', -- requires npm to be installed
        'dockerls',
        'html', -- requires npm to be installed
        'jsonls',
        'lua_ls',
        'jdtls', -- requires java 21 to be installed
        'jsonls', -- requires npm to be installed
        'lemminx',
        'marksman',
        'quick_lint_js',
        'sqlls',
        -- 'tsserver', -- requires npm to be installed
        'yamlls', -- requires npm to be installed
      },
    })

    -- Mason can't install these at the moment
    -- require('mason-tool-installer').setup({
    --   -- Install these linters, formatters, debuggers automatically
    --   ensure_installed = {
    --     'java-debug-adapter',
    --     'java-test',
    --   },
    -- })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lsp_attach = function(client, bufnr)
      -- Create your keybindings here...
    end

    -- Setup all installed servers automatically using the new vim.lsp.config API
    local mason_lspconfig = require('mason-lspconfig')
    local installed_servers = mason_lspconfig.get_installed_servers()
    
    for _, server_name in ipairs(installed_servers) do
      -- Skip jdtls as it's handled separately in ftplugin/java.lua
      if server_name ~= 'jdtls' then
        local opts = {
          capabilities = lsp_capabilities,
        }
        
        -- Add special settings for lua_ls
        if server_name == 'lua_ls' then
          opts.settings = {
            Lua = {
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
              },
            },
          }
        end
        
        -- Use the new vim.lsp.config API for Neovim 0.11+
        if vim.lsp.config then
          vim.lsp.config(server_name, opts)
          vim.lsp.enable(server_name)
        else
          -- Fallback to old API for older Neovim versions
          require('lspconfig')[server_name].setup(opts)
        end
      end
    end
    
    -- Setup on_attach callback for all LSP servers
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          lsp_attach(client, args.buf)
        end
      end,
    })

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end

  end
}

