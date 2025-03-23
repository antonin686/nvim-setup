-- Safe require function to prevent errors from breaking Neovim startup
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Error loading module: " .. module, vim.log.levels.ERROR)
  end
  return result
end

safe_require('core.options')  -- Load general options
safe_require('core.keymaps')  -- Load general keymaps
safe_require('core.snippets') -- Custom code snippets

-- Install Lazy.nvim package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Function to load all plugin configurations from lua/plugins/*.lua
local function get_plugin_files()
  local plugins = {}
  local files = vim.fn.globpath(vim.fn.stdpath('config') .. '/lua/plugins', '*.lua', false, true)
  
  for _, file in ipairs(files) do
    local module_name = file:match(".+/lua/(.-)%.lua$"):gsub("[/\\]", ".") -- Handle cross-platform paths
    local ok, plugin = pcall(require, module_name)
    if ok then
      table.insert(plugins, plugin)
    else
      vim.notify("Error loading plugin: " .. module_name, vim.log.levels.ERROR)
    end
  end

  return plugins
end

-- Ensure `vim.g.have_nerd_font` is set before using it
vim.g.have_nerd_font = vim.g.have_nerd_font or false

-- Setup Lazy.nvim with UI configuration
require('lazy').setup(get_plugin_files(), {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

