---@brief
---
--- https://github.com/luals/lua-language-server
---
--- Lua language server.
---
--- `lua-language-server` can be installed by following the instructions [here](https://luals.github.io/#neovim-install).
---
--- The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.
---
--- If you primarily use `lua-language-server` for Neovim, and want to provide completions,
--- analysis, and location handling for plugins on runtime path, you can use the following
--- settings.
---
--- ```lua
--- vim.lsp.config('lua_ls', {
---   on_init = function(client)
---     if client.workspace_folders then
---       local path = client.workspace_folders[1].name
---       if
---         path ~= vim.fn.stdpath('config')
---         and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
---       then
---         return
---       end
---     end
---
---     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
---       runtime = {
---         -- Tell the language server which version of Lua you're using (most
---         -- likely LuaJIT in the case of Neovim)
---         version = 'LuaJIT',
---         -- Tell the language server how to find Lua modules same way as Neovim
---         -- (see `:h lua-module-load`)
---         path = {
---           'lua/?.lua',
---           'lua/?/init.lua',
---         },
---       },
---       -- Make the server aware of Neovim runtime files
---       workspace = {
---         checkThirdParty = false,
---         library = {
---           vim.env.VIMRUNTIME,
---           -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
---           vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
---         },
---         -- Or pull in all of 'runtimepath'.
---         -- NOTE: this is a lot slower and will cause issues when working on
---         -- your own configuration.
---         -- See https://github.com/neovim/nvim-lspconfig/issues/3189
---         -- library = vim.api.nvim_get_runtime_file('', true),
---       },
---     })
---   end,
---   settings = {
---     Lua = {},
---   },
--- })
--- ```
---
--- See `lua-language-server`'s [documentation](https://luals.github.io/wiki/settings/) for an explanation of the above fields:
--- * [Lua.runtime.path](https://luals.github.io/wiki/settings/#runtimepath)
--- * [Lua.workspace.library](https://luals.github.io/wiki/settings/#workspacelibrary)
---

---@param names string[]
---@return string[]
local function get_plugin_paths(names)
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    vim.notify("lazy.core.config cannot be loaded")
    return {}
  end

  local plugins = lazy_config.plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
    return paths
  end
end

---@param plugins string[]
---@return string[]
local function library(plugins)
  local paths = get_plugin_paths(plugins)
  -- "/lua" is added since runtime.pathStrict is true
  -- to prevent fazzy search.
  -- path-to user-setting file
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  return paths
end

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json", ".luarc.jsonc", ".luacheckrc",
    ".stylua.toml", "stylua.toml", "selene.toml",
    "selene.yml", ".git"
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      }, -- Neovim uses LuaJIT
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" }
      }, -- Recognize 'vim' global
      workspace = {
        checkThirdParty = false,
        library = library({
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        })
      },
      completion = {
        callSnippet = "Replace",
        keywordSnippet = "Replace",
        displayContext = 6,
      },
      hint = {
        enable = false,
        arrayIndex = "Auto",
        paramName = "All",
        paramType = true,
        setType = true,
      },
      format = {
        enable = true, -- stylua を使うなら false
      },
      telemetry = { enable = false },
    },
  },
}
