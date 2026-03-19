return {
  dir = '~/Documents/Github/kiro.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('kiro').setup {
      terminal_cmd = 'kiro-cli',
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          position = 'right',
          width = 0.30,
        },
      },
    }
  end,
  keys = {
    { '<leader>ak', nil, desc = 'Kiro' },
    { '<leader>akk', '<cmd>Kiro<cr>', desc = 'Toggle Kiro (split)' },
    {
      '<leader>akF',
      function()
        require('kiro.terminal').focus_toggle {
          position = 'float',
          width = 0.8,
          height = 0.8,
          border = 'rounded',
        }
      end,
      desc = 'Toggle Kiro (float)',
    },
    { '<leader>akf', '<cmd>KiroFocus<cr>', desc = 'Focus Kiro' },
    { '<leader>akr', '<cmd>KiroResume<cr>', desc = 'Resume Kiro conversation' },
    { '<leader>akR', '<cmd>KiroResumePicker<cr>', desc = 'Pick Kiro conversation' },
  },
}