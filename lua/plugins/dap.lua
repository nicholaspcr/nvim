local function dap()
    local dap = require('dap')
    local dapui = require('dapui')
    local go = require('dap-go')

    -- Setup nvim-dap-go
    go.setup({
        dap_configurations = {
            {
              type = "go",
              name = "Debug", -- Overrides the default "Debug" launch configuration
              request = "launch",
              program = "${fileDirname}",
              buildFlags = "-tags=tti", -- Add your build tags here
            },
            {
              type = "go",
              name = "Test", -- Overrides the default "Test" launch configuration
              request = "launch",
              mode = "test",
              program = "${fileDirname}",
              buildFlags = "-tags=tti", -- Also apply tags to tests
            }
        }
    })


    -- Setup nvim-dap-ui
    dapui.setup()

    local map = require('core.keymap').map
    
    map('n', '<F5>', function() dap.continue() end)
    map('n', '<F10>', function() dap.step_over() end)
    map('n', '<F11>', function() dap.step_into() end)
    map('n', '<F12>', function() dap.step_out() end)
    map('n', '<Leader>tb', function() dap.toggle_breakpoint() end)
    map('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
    map('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    map('n', '<Leader>dr', function() dap.repl.open() end)
    map('n', '<Leader>dl', function() dap.run_last() end)

    -- Open and close DAP UI with the debugger
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
end

return {
   'mfussenegger/nvim-dap',
   dependencies = {
     { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
     { 'leoluz/nvim-dap-go', dependencies = {'mfussenegger/nvim-dap'} },    -- Go support for nvim-dap
   },
   config = dap
 }
