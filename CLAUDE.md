# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written in Lua, using lazy.nvim as the plugin manager. The configuration emphasizes LSP integration, debugging capabilities (especially for Java), and efficient navigation/editing workflows.

## Architecture

### Entry Point and Loading
- `init.lua`: Bootstraps lazy.nvim, sets leader key to space, and loads core modules
- Plugins are automatically discovered from `lua/plugins/` directory using `require("lazy").setup("plugins")`
- Core modules (`lua/core/options.lua` and `lua/core/keymaps.lua`) are loaded after lazy.nvim initialization

### Plugin Structure
Each file in `lua/plugins/` returns a lazy.nvim plugin specification table with:
- Plugin URL/name
- Optional `event`, `ft`, or other lazy-loading triggers
- `dependencies` for related plugins
- `config` function for setup code

Example structure:
```lua
return {
  'author/plugin-name',
  event = 'BufReadPre',
  dependencies = { 'other/plugin' },
  config = function()
    -- setup code here
  end
}
```

### Filetype-Specific Configuration
- `ftplugin/java.lua`: Special JDTLS configuration that runs when opening Java files
- `ftplugin/markdown.lua`: Markdown-specific settings
- This follows Neovim's standard ftplugin convention (runs automatically per filetype)

## LSP Configuration

### General LSP Setup (nvim-lspconfig.lua)
- Uses Mason for automatic LSP installation
- Configured LSPs: bashls, cssls, dockerls, html, jsonls, lua_ls, jdtls, lemminx, marksman, quick_lint_js, sqlls, yamlls
- Uses new `vim.lsp.config()` API for Neovim 0.11+ with fallback to legacy `lspconfig[server].setup()`
- All LSP servers are auto-configured from Mason's installed servers list
- Java (jdtls) is explicitly skipped and handled separately in ftplugin/java.lua

### Java LSP (JDTLS)
- Configured in `ftplugin/java.lua` (triggered when opening .java files)
- Creates per-project workspaces in `~/jdtls-workspace/[project-name]`
- Requires Java 21+ for JDTLS itself
- Supports multiple Java runtime versions (configured: Java 17 and 21)
- Project root detection: looks for .git, mvnw, pom.xml, or build.gradle
- Integrates java-debug-adapter and java-test for debugging and unit testing
- **Important paths**: All JDTLS files are in `~/.local/share/nvim/mason/share/jdtls/` and `~/.local/share/nvim/mason/packages/jdtls/`
- Java home is hardcoded to `/usr/lib/jvm/java-21-openjdk-amd64` (update if different)

### Updating Java Paths
When setting up on a new system, check and update these paths in `ftplugin/java.lua`:
- `java.home` setting (line 65)
- Runtime configurations under `java.configuration.runtimes` (lines 73-94)

## Treesitter Configuration

### Version and Compatibility
- Uses nvim-treesitter **v0.9.3** (pinned via `tag = "v0.9.3"`)
- **Important**: Do NOT use `branch = "main"` - the main branch has breaking API changes incompatible with this setup
- Neovim 0.11+ has built-in treesitter, but nvim-treesitter plugin manages parsers and provides additional features

### Parser Management
- Auto-install enabled: parsers install automatically when opening new file types
- Configured parsers: vimdoc, javascript, typescript, c, lua, rust, jsdoc, bash, json, yaml, html, css, scss, toml, jsonc, python, go, java, groovy
- Parsers stored in `~/.local/share/nvim/lazy/nvim-treesitter/parser/`
- Highlight queries in `~/.local/share/nvim/lazy/nvim-treesitter/queries/[language]/`

### Features Enabled
- **Syntax highlighting**: Treesitter-based highlighting for better accuracy
- **Indentation**: Language-aware indentation
- **Folding**: Uses `v:lua.vim.treesitter.foldexpr()` (configured in `lua/core/options.lua`)

### Troubleshooting
If syntax highlighting stops working:
1. Check parser is installed: `:TSInstallInfo [language]`
2. Manually enable highlighting: `:TSBufEnable highlight`
3. Verify treesitter is active: `:lua print(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)`
4. Check under cursor: `:Inspect` (shows treesitter highlight groups)
5. Reinstall parser if needed: `:TSUninstall [language]` then `:TSInstall [language]`

If you encounter "Parser could not be created" errors, the nvim-treesitter version may be incompatible - ensure `tag = "v0.9.3"` is set in `lua/plugins/treesitter.lua`.

## Key Bindings

Leader key is `<space>`. Major prefixes:
- `<leader>f*`: Telescope fuzzy finding (files, grep, buffers, LSP symbols)
- `<leader>g*`: LSP functions (definition, references, hover, format, diagnostics)
- `<leader>e*`: File explorer (nvim-tree)
- `<leader>h*`: Harpoon quick navigation
- `<leader>s*`: Split window management
- `<leader>t*`: Tab management and testing (Java)
- `<leader>b*` / `<leader>d*`: Debugging (DAP breakpoints, stepping, UI)
- `<leader>q*`: Quickfix list navigation
- `<leader>c*`: Diff/merge operations
- `<leader>w*`: Save/quit shortcuts

All keybindings include descriptions for which-key display.

## Testing and Debugging

### Java Testing
- `<leader>tc`: Test entire class (JDTLS)
- `<leader>tm`: Test nearest method (JDTLS)
- `<leader>go`: Organize imports
- `<leader>gu`: Update project configuration

### Debug Adapter Protocol (DAP)
- Configured in `lua/plugins/nvim-dap-ui.lua` and `lua/plugins/nvim-dap-virtual-text.lua`
- Java debugging bundles loaded from `~/.local/share/nvim/mason/share/java-debug-adapter/` and `~/.local/share/nvim/mason/share/java-test/`
- Breakpoint commands: `<leader>bb` (toggle), `<leader>bc` (conditional), `<leader>bl` (log point)
- Stepping: `<leader>dc` (continue), `<leader>dj` (over), `<leader>dk` (into), `<leader>do` (out)
- UI: `<leader>di` (hover), `<leader>d?` (scopes), `<leader>df` (frames)

## Common Workflows

### Adding a New Plugin
1. Create a new file in `lua/plugins/[plugin-name].lua`
2. Return a lazy.nvim spec table (see Plugin Structure above)
3. Restart Neovim or run `:Lazy sync`

### Modifying LSP Servers
- Add/remove from `ensure_installed` table in `lua/plugins/nvim-lspconfig.lua`
- Run `:Mason` to manually manage installations
- Server-specific settings go in the opts table before `vim.lsp.config()` call

### Editing Keybindings
- Global keymaps: `lua/core/keymaps.lua`
- Plugin-specific keymaps: usually in the plugin's config file under `lua/plugins/`

## Important Notes

- Netrw (built-in file explorer) is disabled; nvim-tree is used instead
- Treesitter folding is enabled (`foldmethod=expr`)
- Clipboard is synced with system clipboard (`clipboard=unnamedplus`)
- Custom filetype: Jenkinsfiles are treated as groovy
- Big file handling is optimized via bigfile-nvim plugin
- Tmux navigation integration available via vim-tmux-navigator
- Git blame integration available via git-blame-nvim (toggle with `<leader>gb`)

## Diagnostics and Troubleshooting

### LSP Issues
- Check Mason installations: `:Mason`
- Check LSP status: `:LspInfo`
- Check attached clients: `:lua print(vim.inspect(vim.lsp.get_clients()))`

### Java/JDTLS Issues
- Workspace location: `~/jdtls-workspace/[project-name]/`
- Delete workspace directory to force clean rebuild
- Check Java version: `java -version` (needs 21+)
- JDTLS logs are in the workspace directory

### Plugin Issues
- Check lazy.nvim status: `:Lazy`
- Update all plugins: `:Lazy sync`
- Check for errors: `:checkhealth`
