return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  lazy = false,
  build = ":UpdateRemotePlugins",
  dependencies = {
    "3rd/image.nvim",
    {
      "quarto-dev/quarto-nvim",
      dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("quarto").setup({
          codeRunner = {
            enabled = true,
            default_method = "molten", -- "molten", "slime", "iron" or <function>
            ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
            -- Takes precedence over `default_method`
            never_run = { "yaml" }, -- filetypes which are never sent to a code runner
          },
        })
      end,
    },
    {
      "GCBallesteros/jupytext.nvim",
      config = function()
        require("jupytext").setup({
          style = "markdown",
          output_extension = "md",
          force_ft = "markdown",
        })
      end,
    },
  },
  init = function()
    local map = vim.keymap.set

    -- {{ Molten START
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true

    map("n", "<leader>op", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
    map("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "open output window", silent = true })
    map("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
    map("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection", silent = true })
    map("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
    map("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
    map("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })

    -- automatically import output chunks from a jupyter notebook
    -- tries to find a kernel that matches the kernel in the jupyter notebook
    -- falls back to a kernel that matches the name of the active venv (if any)
    local imb = function(e) -- init molten buffer
      vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        local try_kernel_name = function()
          local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
          return metadata.kernelspec.name
        end
        local ok, kernel_name = pcall(try_kernel_name)
        if not ok or not vim.tbl_contains(kernels, kernel_name) then
          kernel_name = nil
          local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          if venv ~= nil then
            kernel_name = string.match(venv, "/.+/(.+)")
          end
        end
        if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
          vim.cmd(("MoltenInit %s"):format(kernel_name))
        end
        -- vim.cmd("MoltenImportOutput")
      end)
    end

    -- automatically import output chunks from a jupyter notebook
    vim.api.nvim_create_autocmd("BufAdd", {
      pattern = { "*.ipynb" },
      callback = imb,
    })

    -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.ipynb" },
      callback = function(e)
        if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
          imb(e)
        end
      end,
    })

    -- Provide a command to create a blank new Python notebook
    -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
    -- if you use another language than Python, you should change it in the template.
    local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

    local function new_notebook(filename)
      local path = filename .. ".ipynb"
      local file = io.open(path, "w")
      if file then
        file:write(default_notebook)
        file:close()
        vim.cmd("edit " .. path)
      else
        print("Error: Could not open new notebook file for writing.")
      end
    end

    vim.api.nvim_create_user_command("NewNotebook", function(opts)
      new_notebook(opts.args)
    end, {
      nargs = 1,
      complete = "file",
    })
    -- Molten END }}

    -- {{ Quarto START
    local runner = require("quarto.runner")
    map("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
    map("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
    map("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
    map("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
    map("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
    map("n", "<localleader>RA", function()
      runner.run_all(true)
    end, { desc = "run all cells of all languages", silent = true })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        require("quarto").activate()
      end,
    })
    -- Quarto END }}
  end,
}
