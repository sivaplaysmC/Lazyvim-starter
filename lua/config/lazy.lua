local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  dev = {
    path = "/home/sivaplays/repos/nvim-stuff",
    -- patterns = { "trouble" }, -- For example {}
  },
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, frequency = 604800 }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- local colors = require("tokyonight.colors").setup()
-- local utils = require("tokyonight.util")
--
-- local TelescopePrompt = {
--   TelescopePromptNormal = {
--     bg = utils.lighten(colors.bg_popup, 0.9),
--   },
--   TelescopePromptBorder = {
--     bg = utils.lighten(colors.bg_popup, 0.9),
--   },
--   TelescopePromptTitle = {
--     bg = utils.lighten(colors.bg_popup, 0.9),
--     fg = utils.lighten(colors.bg_popup, 0.9),
--   },
--
--   TelescopePreviewNormal = {
--     bg = colors.bg_dark,
--   },
--   TelescopePreviewBorder = {
--     bg = colors.bg_dark,
--   },
--   TelescopePreviewTitle = {
--     bg = colors.bg_dark,
--     fg = colors.bg_dark,
--   },
--
--   TelescopeResultsTitle = {
--     bg = colors.bg_dark,
--   },
--   TelescopeResultsNormal = {
--     bg = colors.bg_dark,
--   },
--   TelescopeResultsBorder = {
--     bg = colors.bg_dark,
--     fg = colors.bg_dark,
--   },
-- }
-- for hl, col in pairs(TelescopePrompt) do
--   vim.api.nvim_set_hl(0, hl, col)
-- end
