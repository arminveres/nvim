-- TODO(aver): find a way to move these also to /plugin rtp
-- Re-sourcing your config is not supported message
require("core.mappings")
require("core.lazy")

-- move here, for some reason "SIXEL IMAGE 1x1" gets logged if called too early...
vim.cmd.colorscheme("gruvbox")
