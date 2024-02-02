-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end
--
-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

function extractSignature(inputString)
  local startIndex = inputString:find("%(.*%)")
  if startIndex then
    local extractedString = inputString:sub(startIndex)
    return extractedString
  else return "" end
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
      -- disable a keymap
      keys[#keys + 1] = { "K", false }
      -- add a keymap
      keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    opts = {
      timer_interval = 100,
      floating_window = false,
    },
  },

  { -- folke/tokyonight

    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
      end,
    },
  },
  {
    "rafamadriz/neon",
  },
  {
    "AlexvZyl/nordic.nvim",
  },

  -- Configure LazyVim to load nord
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-storm",
      lsp = {},
    },
  },
  -- change trouble config
  {
    "sivaplaysmC/trouble.nvim",
    dev = false,
    enabled = true,
    -- opts will be merged with the parent spec
    opts = {
      use_diagnostic_signs = true,
      group = true,
      auto_fold = true,
      action_keys = {
        jump = { "l" },
        open_split = { "<C-s>" },
      },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dev = false,
    keys = {
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cpp",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local get_text = function()
        local res = require("lsp_signature").status_line(100000)
        local modifiedLabel = res.label:sub(1, res.range.start - 1)
          .. "%#LspSignatureActiveParameter#"
          .. res.hint
          .. "%#StatusLine#"
          .. res.label:sub(res.range["end"] + 1)
        return extractSignature(modifiedLabel)
      end
      table.insert(opts.sections.lualine_c, {
        get_text,
      })
    end,
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  {
    "folke/noice.nvim",
    cond = false,
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "junegunn/fzf.vim" },
    event = "UiEnter",
    opts = {
      preview = {
        auto_preview = true,
        show_title = false,
        winblend = 0,
        win_height = 999,
        border = "none",
      },
      fzf = {
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
      },
    },
    init = function() end,
  },
  { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
  {
    "folke/edgy.nvim",
    -- enabled = false,
    opts = function(_, opts)
      table.insert(opts.bottom, { ft = "qf", title = "QuickFix", size = { height = 18 } })
      -- opts.animate.enabled = false
      return opts
    end,
  },
  {
    "joerdav/templ.vim",
  },

  {
    "duane9/nvim-rg",
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = {
        "gr",
        function()
          vim.lsp.buf.references()
        end,
        desc = "lsp_references",
      }
      -- change a keymap
    end,
  },
}
