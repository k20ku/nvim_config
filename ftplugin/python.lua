-- indent
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

-- "attached" means "preparation completed"
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('PythonLspConfig', { clear = true }),
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    --  if attached lsp is ruff,
    if client and client.name == "ruff" then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          -- format by ruff
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })

          vim.lsp.buf.code_action({
            context = { only = { 'source.organizeImports' } },
            apply = true,
          })
        end,
      })
      print("Ruff format on save: ENABLED")
    end
  end,
})
