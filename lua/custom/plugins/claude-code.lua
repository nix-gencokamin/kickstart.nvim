-- "Parking float" to prevent PTY resize (SIGWINCH) when toggling the terminal.
-- Before destroying the split window, we create a hidden floating window with the
-- same dimensions holding the terminal buffer. The PTY never sees a dimension change
-- because the buffer is always displayed in a window of the correct size.
-- See: https://github.com/coder/claudecode.nvim/issues/183
local parking_win = nil

local function park_terminal(bufnr, win)
  if parking_win and vim.api.nvim_win_is_valid(parking_win) then return end
  if not win or not vim.api.nvim_win_is_valid(win) then return end
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  parking_win = vim.api.nvim_open_win(bufnr, false, {
    relative = 'editor',
    row = 0,
    col = 0,
    width = width,
    height = height,
    hide = true,
    style = 'minimal',
    noautocmd = true,
  })
end

local function unpark_terminal()
  if parking_win and vim.api.nvim_win_is_valid(parking_win) then pcall(vim.api.nvim_win_close, parking_win, true) end
  parking_win = nil
end

local function smart_toggle(t)
  if t:is_open() then
    if vim.api.nvim_get_current_win() == t.window then
      t:close()
    else
      t:focus()
    end
  else
    t:open()
  end
end

local function setup_toggleterm_provider()
  local claude_terminal = {}

  local toggleterm_provider = {
    setup = function(config)
      local Terminal = require('toggleterm.terminal').Terminal
      claude_terminal = Terminal:new {
        id = 99,
        direction = 'vertical',
        size = 80,
        on_open = function(t)
          vim.api.nvim_win_set_width(t.window, math.floor(vim.o.columns * 0.30))
          vim.keymap.set(
            { 'n', 't' },
            '<C-x>',
            '<C-\\><C-n><C-w>p',
            { noremap = true, silent = true, buffer = t.bufnr, desc = 'Switch focus to previous window' }
          )
          -- Scroll the diff window without leaving the terminal
          vim.keymap.set('t', '<C-f>', '<C-\\><C-n><C-w>p<C-f><C-w>p i', { noremap = true, silent = true, buffer = t.bufnr, desc = 'Scroll diff down' })
          vim.keymap.set('t', '<C-b>', '<C-\\><C-n><C-w>p<C-b><C-w>p i', { noremap = true, silent = true, buffer = t.bufnr, desc = 'Scroll diff up' })
        end,
      }
    end,

    open = function(cmd_string, env_table, effective_config, focus)
      claude_terminal.cmd = cmd_string
      claude_terminal.env = env_table
      if claude_terminal:is_open() then
        claude_terminal:focus()
      else
        smart_toggle(claude_terminal)
      end
      vim.schedule(unpark_terminal)
    end,

    close = function()
      if claude_terminal:is_open() and claude_terminal.bufnr and claude_terminal.window then park_terminal(claude_terminal.bufnr, claude_terminal.window) end
      claude_terminal:close()
      vim.schedule(unpark_terminal)
    end,

    simple_toggle = function(cmd_string, env_table, effective_config)
      claude_terminal.cmd = cmd_string
      claude_terminal.env = env_table
      if claude_terminal:is_open() and claude_terminal.bufnr and claude_terminal.window then park_terminal(claude_terminal.bufnr, claude_terminal.window) end
      claude_terminal:toggle()
      vim.schedule(unpark_terminal)
    end,

    focus_toggle = function(cmd_string, env_table, effective_config)
      claude_terminal.cmd = cmd_string
      claude_terminal.env = env_table
      if claude_terminal:is_open() and claude_terminal.bufnr and claude_terminal.window then park_terminal(claude_terminal.bufnr, claude_terminal.window) end
      smart_toggle(claude_terminal)
      vim.schedule(unpark_terminal)
    end,

    ensure_visible = function()
      if not claude_terminal:is_open() then smart_toggle(claude_terminal) end
      vim.schedule(unpark_terminal)
    end,

    get_active_bufnr = function()
      if claude_terminal.bufnr then return claude_terminal.bufnr end
      return nil
    end,

    is_available = function()
      local ok, _ = pcall(require, 'toggleterm')
      return ok
    end,
  }

  return toggleterm_provider
end

return {
  'coder/claudecode.nvim',
  dependencies = { 'akinsho/toggleterm.nvim' },
  config = function()
    require('claudecode').setup {
      terminal_cmd = '~/.local/bin/claude',
      terminal = {
        provider = setup_toggleterm_provider(),
      },
      diff_opts = {
        keep_terminal_focus = false,
        open_in_new_tab = true,
      },
    }
  end,
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
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
