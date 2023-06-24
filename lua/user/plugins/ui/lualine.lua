-- @brief Returns the current window number
local function current_window()
  return vim.api.nvim_win_get_number(0)
end

local function lspsaga_winbar()
  return require('lspsaga.symbolwinbar'):get_winbar()
end

return {
  {
    "nvim-lualine/lualine.nvim", -- Fancier statusline
    config = function()
      local my_theme = require("lualine.themes.powerline")
      local gruvbox = require("gruvbox.palette").colors
      local my_colors = {
        gray1  = '#262626',
        gray2  = '#303030',
        gray4  = '#585858',
        gray5  = '#606060',
        gray7  = '#9e9e9e',
        gray8  = '#aaaaaa',
        gray10 = '#f0f0f0',
      }

      my_theme.normal = {
        a = { fg = gruvbox.dark0, bg = gruvbox.bright_orange, gui = 'bold' },
        b = { fg = my_colors.gray10, bg = gruvbox.dark1 },
        c = { fg = my_colors.gray8, bg = gruvbox.dark0 },
      }
      my_theme.visual = {
        a = { fg = gruvbox.light0, bg = gruvbox.neutral_blue, gui = 'bold' }
      }
      my_theme.insert = {
        a = { fg = gruvbox.dark0, bg = gruvbox.neutral_green, gui = 'bold' }
      }
      my_theme.terminal = {
        a = { fg = gruvbox.dark0, bg = gruvbox.bright_aqua, gui = 'bold' }
      }
      my_theme.inactive.a.fg = gruvbox.light0_hard
      my_theme.inactive.b.fg = gruvbox.light0_hard
      my_theme.inactive.c.fg = gruvbox.light0_hard

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = my_theme, -- "powerline", --"adwaita", "auto"
          -- component_separators = { left = '|', right = '|' },
          -- section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = {
            { "mode" },
          },
          lualine_b = {
            {
              "branch",
              icon = { "", color = { fg = "#f34f29" } },
            },
            {
              "diff",
            },
            {
              "diagnostics",
            },
          },
          lualine_c = {
            {
              "%=",
              separator = "",
            },
            {
              function()
                return vim.fn.fnamemodify(require("project_nvim.project").find_pattern_root(), ":t")
              end,
              cond = function()
                local capture =
                    vim.fn.fnamemodify(require("project_nvim.project").find_pattern_root(), ":t")
                return capture ~= "null" and capture ~= "v:null"
              end,
            },
            {
              "filename",
              path = 0,             -- 0: Just the filename, 1: Relative path, 2: Absolute path
              file_status = true,   -- Displays file status (readonly status, modified status)
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window for other components.
            },
          },
          lualine_x = {
            {
              function()
                local msg = "No Active Lsp"
                local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return msg
                end
                local lsps = ""
                for k, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    lsps = lsps .. client.name .. " "
                  end
                end

                if lsps == "" then
                  return msg
                else
                  return lsps
                end
              end,
              icon = "  LSP:",
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = { current_window },
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },

        -- TODO: (aver) add outline to lualine and then make status global again, as currently lualine hijackts outline
        -- in wibar
        -- winbar = {
        --   lualine_a = {
        --     lspsaga_winbar,
        --   },
        -- },
        -- inactive_winbar = {
        --   lualine_a = { current_window },
        -- },

        extensions = {},
      })
    end,
  },
}
