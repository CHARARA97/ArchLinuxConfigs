local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
  -- 启用 LSP 相关功能时附加的配置
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- 设置快捷键（参考你的 keymaps.lua 风格）
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- 跳转到定义
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)      -- 查找引用
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)  -- 跳转到实现
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)            -- 悬停显示文档
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)  -- 重命名
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- 代码操作
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)    -- 上一个诊断
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)    -- 下一个诊断
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- 显示诊断悬浮窗

  -- 如果服务器支持，启用格式化
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end
end

-- 通过 mason-lspconfig 自动安装并配置服务器
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',          -- Lua
    'pyright',         -- Python
    'rust_analyzer',   -- Rust
    'clangd',          -- C/C++
    -- 按需添加更多
  },
  automatic_installation = true,
})

-- 为每个服务器设置具体的配置（如果默认配置不够）
require('mason-lspconfig').setup({ handlers = {
  -- 默认处理器：所有服务器都使用通用配置
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      -- 可根据需要覆盖特定服务器的配置
    })
  end,

  -- 针对特定服务器的自定义配置
  ['lua_ls'] = function()
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
  end,

  -- 其他服务器可以类似覆盖
}})
