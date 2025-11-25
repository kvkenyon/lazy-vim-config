# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **LazyVim starter template** — a Neovim configuration distribution built on LazyVim. It demonstrates how to extend the LazyVim framework with custom plugins, keybindings, autocmds, and language-specific tools. The configuration is written entirely in Lua and is designed to be forked, modified, and maintained as a personal development environment.

**Key Links:**
- [LazyVim Documentation](https://lazyvim.github.io/)
- [LazyVim GitHub](https://github.com/LazyVim/LazyVim)
- [Neovim Documentation](https://neovim.io/doc/user/)

## Common Development Commands

### Starting Neovim
```bash
# Start with this configuration
nvim

# Start with minimal configuration (no plugins)
nvim --noplugin

# Start in headless mode for testing
nvim -es
```

### Managing Plugins
```bash
# Open the lazy.nvim UI within Neovim
:Lazy

# Install/sync all plugins
:Lazy sync

# Update all plugins to latest versions
:Lazy update

# Check for plugin updates
:Lazy check

# View plugin status
:Lazy status
```

### Formatting and Validation
```bash
# Format a Lua file with stylua (must have stylua installed)
stylua lua/plugins/myfile.lua

# Format all Lua files
stylua lua/

# Format current file in Neovim
# (Depends on conform.nvim and available formatters)
:w

# Reload current configuration without restarting
:source %
```

### Language Server Protocol
```bash
# Check LSP status
:LspInfo

# Start a specific language server
:LspStart python

# Stop a language server
:LspStop python

# Check overall health
:checkhealth
```

### Git Operations
```bash
# View git changes in signs
# (Integrated via gitsigns.nvim)

# Stage hunks
# (Use default LazyVim keymaps via which-key)

# View all git changes
:LazyGitFilter
```

## Architecture and Code Organization

### Directory Structure
```
lua/
├── config/
│   ├── lazy.lua        # Plugin manager bootstrap and configuration
│   ├── options.lua     # Neovim editor options
│   ├── keymaps.lua     # Custom keybindings
│   └── autocmds.lua    # Autocommand definitions
└── plugins/
    ├── example.lua     # Reference examples (disabled by default)
    └── ruff.lua        # Custom Python formatter configuration

lazy-lock.json         # Reproducible plugin version lockfile
lazyvim.json          # LazyVim metadata (enabled extras, version)
stylua.toml           # Lua code formatter configuration
.neoconf.json         # LSP configuration
init.lua              # Single-line entry point
```

### Bootstrap Flow

1. **init.lua**: Entry point that delegates to `config.lazy`
2. **config/lazy.lua**:
   - Bootstraps lazy.nvim plugin manager
   - Imports LazyVim core: `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`
   - Imports custom plugins: `{ import = "plugins" }`
   - Configures defaults: `lazy = false` (custom plugins eager-load), `version = false` (always latest)
   - Disables performance-impacting built-in plugins
3. **config/options.lua**: Editor settings (extends LazyVim defaults)
4. **config/keymaps.lua**: Custom keybindings (loaded on `VeryLazy` event)
5. **config/autocmds.lua**: Custom autocommands (loaded on `VeryLazy` event)
6. **plugins/\*.lua**: Auto-loaded plugin specifications (all `.lua` files)

### Plugin Specification Pattern

All plugin specifications follow the lazy.nvim format. Example structure:

```lua
return {
  {
    "author/plugin-name",
    dependencies = { "another/plugin" },
    event = "VeryLazy",           -- Lazy load on event
    cmd = "PluginCommand",        -- Lazy load on command
    keys = {
      { "<leader>xx", "<cmd>Cmd<cr>", desc = "Description" },
    },
    opts = {
      option_key = value,
    },
    enabled = true,
  },
}
```

### Extending the Configuration

**Override LazyVim defaults:**
```lua
-- lua/plugins/custom-config.lua
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "my-colorscheme",
    },
  },
}
```

**Modify existing plugin options:**
```lua
return {
  {
    "plugin-name",
    -- Replace completely
    opts = { new_option = value },
    -- OR merge with defaults
    opts = function(_, opts)
      opts.array = opts.array or {}
      table.insert(opts.array, new_item)
      return opts
    end,
  },
}
```

**Add new plugins:**
1. Create `lua/plugins/newplugin.lua`
2. Define plugin spec and return it
3. Restart Neovim or run `:Lazy sync`

## Key Files and Patterns

### lua/config/lazy.lua
**Purpose**: Plugin manager bootstrap and default configuration

**Critical Sections**:
- Lazy.nvim auto-bootstrap from GitHub if missing
- LazyVim core import: `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`
- Custom plugins import: `{ import = "plugins" }`
- Performance: Disables gzip, tarPlugin, tohtml, tutor, zipPlugin
- Colorscheme fallback: tokyonight, then habamax
- Update checker enabled with notifications disabled

**Modification Pattern**: Add plugins to the spec table, adjust `lazy`, `version`, or `checker` settings

### lua/config/options.lua
**Purpose**: Neovim editor options and settings

**Note**: Minimal by default, extends LazyVim's defaults. Modify here for custom:
- Line number display, indentation, tabs
- Search behavior, completion settings
- Visual elements (colors, borders, etc.)

**Reference**: [LazyVim default options](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua)

### lua/config/keymaps.lua
**Purpose**: Custom key mappings

**Current bindings**:
- `<leader>bn` — Next buffer
- `<leader>bp` — Previous buffer
- `<leader>bx` — Close buffer

**Pattern**: Use `vim.keymap.set(mode, keys, action, { desc = "..." })` or define in plugin specs via `keys` table

**Reference**: [LazyVim default keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)

### lua/config/autocmds.lua
**Purpose**: Autocommand definitions triggered on editor events

**Currently empty** — add custom autocommands here with `vim.api.nvim_create_autocmd`

**Delete LazyVim autocommands**: `vim.api.nvim_del_augroup_by_name("lazyvim_groupname")`

**Reference**: [LazyVim default autocmds](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua)

### lua/plugins/example.lua
**Purpose**: Reference file with common plugin configuration patterns

**Status**: Disabled by default (`if true then return {} end`)

**Examples Contained**:
- Adding standalone plugins (gruvbox colorscheme)
- Overriding LazyVim plugins (colorscheme, trouble.nvim)
- Disabling plugins
- Extending dependencies (cmp-emoji)
- Modifying keymaps (telescope)
- LSP configuration (pyright, tsserver)
- Treesitter parser management
- Mason tool installation
- Static vs function-based option merging

### lua/plugins/ruff.lua
**Purpose**: Custom Python formatter configuration

**Implementation**: Extends `conform.nvim` with Ruff:
- `ruff_format` for formatting
- `ruff_fix` for auto-fixes
- 3000ms timeout, synchronous execution
- LSP fallback enabled

**Modification Pattern**: Update `opts.formatters_by_ft.python` array or timeout values

### lazy-lock.json
**Purpose**: Reproducible plugin version lockfile

**Function**: Records exact Git commit hashes for all plugins

**Management**:
- Auto-generated by lazy.nvim (never manually edit)
- Updated with `:Lazy update`
- Must be committed to git for reproducibility
- View changes: `git diff lazy-lock.json`

### lazyvim.json
**Purpose**: LazyVim metadata and configuration

**Fields**:
- `extras`: Array of enabled LazyVim language/feature extras
- `version`: Current LazyVim configuration version (for migrations)
- `install_version`: Version at setup time
- `news`: Changelog position tracking

**Enabled Extras** (in this configuration):
- `lazyvim.plugins.extras.lang.docker`
- `lazyvim.plugins.extras.lang.markdown`
- `lazyvim.plugins.extras.lang.python`

**To add more extras**: Import in `lazy.lua` or update this file

### stylua.toml
**Purpose**: Lua code formatter configuration

**Current Settings**:
```toml
indent_type = "Spaces"
indent_width = 2
column_width = 120
```

**Usage**: Ensures consistent Lua code formatting. Run `stylua lua/` before committing

## Plugin Ecosystem

### Current Plugin Groups

**LazyVim Core** (auto-loaded):
- Plugin manager (lazy.nvim)
- LSP configuration (nvim-lspconfig, mason)
- Completion (blink.cmp)
- Formatting (conform.nvim)
- Linting (nvim-lint)

**Language Support** (extras):
- Python, Docker, Markdown (enabled in lazyvim.json)
- Treesitter parsers for 14+ languages

**UI Enhancements**:
- bufferline.nvim (buffer tabs)
- lualine.nvim (status line)
- which-key.nvim (keymap hints)
- snacks.nvim (utilities: picker, explorer, etc.)
- trouble.nvim (diagnostics window)
- noice.nvim (message UI)

**Navigation and Editing**:
- telescope.nvim (fuzzy finder)
- flash.nvim (enhanced motions)
- gitsigns.nvim (git integration)

**Productivity**:
- persistence.nvim (session management)
- todo-comments.nvim (TODO highlighting)
- Color schemes: catppuccin, tokyonight

### Adding Language Support

LazyVim provides language extras. To add TypeScript support:

```lua
-- In lua/config/lazy.lua
{ import = "lazyvim.plugins.extras.lang.typescript" }
```

Available languages: typescript, python, docker, json, markdown, rust, go, lua, etc.

## Common Customization Tasks

### Add a New Plugin
```lua
-- lua/plugins/mynewplugin.lua
return {
  {
    "author/plugin-name",
    keys = {
      { "<leader>xx", "<cmd>PluginCommand<cr>", desc = "My command" },
    },
    opts = { option = value },
  },
}
```

### Add a Custom Keymap
**Option 1** — Add to keymaps.lua:
```lua
vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "..." })
```

**Option 2** — Add to plugin spec:
```lua
keys = { { "<leader>xx", "<cmd>Cmd<cr>", desc = "..." } }
```

### Override a LazyVim Plugin
```lua
return {
  {
    "plugin-author/plugin-name",
    opts = { custom_option = new_value },
  },
}
```

### Configure LSP for a Language
```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylance = {
          settings = { python = { analysis = { ... } } },
        },
      },
    },
  },
}
```

### Ensure Tools/Parsers are Installed
```lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "stylua", "black", "flake8" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python", "rust" })
    end,
  },
}
```

## Important Notes for Development

### Git Workflow
- Always commit `lazy-lock.json` changes when updating plugins
- Review git diff before committing configuration changes
- Use `:Lazy update` to safely update plugins and lock file

### Configuration Reloading
- Simple edits: `:source %` to reload current file
- Complex changes: Restart Neovim (`:qa!` then `nvim`)
- Plugin changes: Run `:Lazy sync` then restart

### Debugging
- Use `:Lazy` to inspect plugin status and errors
- Use `:checkhealth` to diagnose configuration issues
- View LSP logs: `:LspInfo` then follow server info
- Enable debug mode: `vim.lsp.set_log_level("debug")`

### Performance Considerations
- Prefer `event = "VeryLazy"` for non-critical plugins
- Use `cmd` for command-only plugins
- Use `keys` for keymap-triggered plugins
- Avoid eager loading (`lazy = false`) for heavy plugins
- Monitor startup time: `nvim --startuptime /tmp/startup.log`

### Style and Conventions
- **Formatting**: Run `stylua lua/` before committing
- **Indentation**: 2 spaces (see stylua.toml)
- **Line Width**: 120 characters max
- **Comments**: Use `--` for single-line, Lua doesn't have multiline comments by default
- **Plugin Specs**: Always include `desc` in keymaps for which-key documentation

## Testing and Validation

### Before Committing
1. Test startup: `:Lazy status` should show no errors
2. Run formatter: `stylua lua/`
3. Check health: `:checkhealth` for warnings
4. Review git diff: `git diff` to catch unintended changes
5. Test functionality: Verify custom keymaps and plugin behavior work

### Troubleshooting
- **Slow startup**: Check `:Lazy` for heavy plugins, consider lazy loading
- **LSP not starting**: `:LspInfo` and verify mason tools are installed
- **Formatting not working**: Ensure formatter is installed via Mason (`:Mason`)
- **Plugin errors**: Check `:messages` after startup or `:Lazy log`
- **Corrupted lock file**: Remove `lazy-lock.json` and run `:Lazy sync` to regenerate

## References

- LazyVim official docs: https://lazyvim.github.io/
- Neovim Lua guide: https://neovim.io/doc/user/lua.html
- Lazy.nvim spec format: https://github.com/folke/lazy.nvim#-plugin-spec
- LSP configuration: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
- Treesitter parsers: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
