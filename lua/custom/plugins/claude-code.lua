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
    { '<leader>ac', nil, desc = 'Claude Code' },
    { '<leader>acc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude (split)' },
    {
      '<leader>acF',
      function()
        require('claudecode.terminal').focus_toggle {
          snacks_win_opts = {
            position = 'float',
            width = 0.8,
            height = 0.8,
            border = 'rounded',
          },
        }
      end,
      desc = 'Toggle Claude (float)',
    },
    { '<leader>acf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>acr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>acC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>acm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>acb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>acs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>acs',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>acd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}