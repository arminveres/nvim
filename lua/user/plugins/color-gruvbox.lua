return { -- colorschemes TODO: just write my own colorscheme based on gruvbox...
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1001,
    config = true,
    opts = {
      undercurl = true,
      underline = true,
      bold = true,
      -- italic = {}, -- will make italic comments and special strings
      strikethrough = true,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = true,
      dim_inactive = false,
      transparent_mode = false,
      contrast = "hard", -- can be "hard" or "soft"
      -- overriding highlight groups
      palette_overrides = {
        dark0_hard = "#141414"
      },
      overrides = {
        -- ==========================================================================================
        -- LSP and LspSaga colors
        -- ==========================================================================================
        SagaNormal = { link = 'PMenu' },
        -- FloatShadow = { link = 'PMenu' },
        -- FloatShadowThrough = { link = 'PMenu' },
        -- LspInlayHint = { link = 'GruvboxAqua' },
        -- LspInlayHints = { link = 'GruvboxAqua' }
        String = { fg = "#eb9664" }, -- #eb9664, #c89664
        Comment = { fg = "#919191", italic = true, bold = false },
        -- These highlights are special for undefined macros
        ["@lsp.type.comment.c"] = { fg = "#91a573", bg = "#785032" },
        ["@lsp.type.comment.cpp"] = { fg = "#91a573", bg = "#785032" },
        -- Comment = { fg = "#c89664", italic = true, bold = false },
        Define = { link = "GruvboxPurple" },
        Macro = { link = "GruvboxPurple" },

        -- ==========================================================================================
        -- Git Diff
        -- ==========================================================================================
        DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333" },
        DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
        DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
        DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },

        -- ==========================================================================================
        -- Fold
        -- ==========================================================================================
        Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
        FoldColumn = { fg = "#fe8019", bg = "#0E1018" },
        SignColumn = { link = "GruvboxBg0" },

        -- ==========================================================================================
        -- statusline and column
        -- ==========================================================================================
        StatusLine = { bg = "#ffffff", fg = "#0E1018" },
        StatusLineNC = { bg = "#3c3836", fg = "#0E1018" },
        CursorLineNr = { fg = "#fabd2f", bg = "" },
        GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
        GruvboxAquaSign = { fg = "#8EC07C", bg = "" },
        GruvboxGreenSign = { fg = "#b8bb26", bg = "" },
        GruvboxRedSign = { fg = "#fb4934", bg = "" },
        GruvboxBlueSign = { fg = "#83a598", bg = "" },
        WilderMenu = { fg = "#ebdbb2", bg = "" },
        WilderAccent = { fg = "#f4468f", bg = "" },

        -- ==========================================================================================
        -- Markdown highlights
        -- ==========================================================================================
        ["@text.title.1"] = { bg = '#442d30', reverse = false },
        ["@text.title.2"] = { bg = '#442d30', reverse = false },
        ["@text.title.3"] = { bg = '#442d30', reverse = false },
        ["@text.title.4"] = { bg = '#442d30', reverse = false },
        ["@text.title.5"] = { bg = '#442d30', reverse = false },

        -- Tried to clear colors, but remains black
        -- NoiceCmdline = { bg = 'NONE' },
        -- NoiceCmdlinePopup = { link = 'NoiceCmdline' },
        -- NoiceCmdlinePopupBorder = { link = 'NoiceCmdline' }

      }
    }
  }
}
