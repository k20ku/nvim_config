
-- Python用のインデント設定
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

-- LSPがアタッチ（準備完了）した時に実行する
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('PythonLspConfig', { clear = true }),
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- アタッチされたのが Ruff なら保存時の設定を登録
    if client and client.name == "ruff" then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          -- 確実に Ruff を指定してフォーマット
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          
          -- インポート整理（不要ならコメントアウトしてください）
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

print("Python config loaded successfully!")
