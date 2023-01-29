local hex_ok, hex = pcall(require, 'hex')
if not hex_ok then
  vim.notify('hex not ok')
  return
end

hex.setup({
  -- add config here
})
