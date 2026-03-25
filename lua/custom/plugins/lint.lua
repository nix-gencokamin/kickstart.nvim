-- Extend nvim-lint with eslint_d for JS/TS projects
-- (kickstart.plugins.lint handles the plugin setup + markdownlint)
return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft['javascript'] = { 'eslint_d' }
    lint.linters_by_ft['javascriptreact'] = { 'eslint_d' }
    lint.linters_by_ft['typescript'] = { 'eslint_d' }
    lint.linters_by_ft['typescriptreact'] = { 'eslint_d' }
  end,
}
