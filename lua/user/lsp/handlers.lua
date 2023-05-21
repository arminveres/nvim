local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.setup = function()
  local signs = {
    { name = 'DiagnosticSignError', text = '' }, -- ""
    { name = 'DiagnosticSignWarn',  text = '' },
    { name = 'DiagnosticSignHint',  text = '' },
    { name = 'DiagnosticSignInfo',  text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  -- NOTE: not really neede anymore, because replacement with lspsaga.
  -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = 'rounded',
  -- })
  -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = 'rounded',
  -- })
end

local function lsp_highlight_document(client)
  -- if client.server_capabilities.document_highlight then
  local status_ok, illuminate = pcall(require, 'illuminate')
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
  -- end
end

M.on_attach = function(client, bufnr)
  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if not status_ok then
    print("cmp failed!!!")
    return
  end

  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
  M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

  lsp_highlight_document(client)
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>bf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

return M
