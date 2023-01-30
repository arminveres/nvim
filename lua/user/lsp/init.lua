local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  return
end

-- add border to lsp info windows
require('lspconfig.ui.windows').default_options.border = 'rounded'

require('user.lsp.lsp-installer')
require('user.lsp.handlers').setup()
require('user.lsp.null-ls')
