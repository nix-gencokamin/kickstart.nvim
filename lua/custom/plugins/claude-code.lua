return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('claudecode').setup {
      terminal_cmd = '~/.local/bin/claude',
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          position = 'right',
          width = 0.30,
          keys = {
            claude_hide = { '<C-x>', function(self) self:hide() end, mode = 't', desc = 'Hide Claude terminal' },
          },
        },
      },
      diff_opts = {
        keep_terminal_focus = false,
        open_in_new_tab = true,
      },
    }
  end,
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude (split)' },
    {
      '<leader>aF',
      function()
        require('claudecode.terminal').focus_toggle {
          snacks_win_opts = {
            position = 'float',
            width = 0.8,
            height = 0.8,
            border = 'rounded',
            keys = {
              claude_hide = { '<C-x>', function(self) self:hide() end, mode = 't', desc = 'Hide Claude terminal' },
            },
          },
        }
      end,
      desc = 'Toggle Claude (float)',
    },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}