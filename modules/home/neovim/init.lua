-- Line numbers
    vim.opt.number = true
    vim.opt.relativenumber = true
        
-- Tabs and indentation
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.smartindent = true
       
-- Appearance
    vim.opt.wrap = false
    vim.opt.cursorline = true
    vim.opt.scrolloff =     
    vim.cmd.colorscheme('moonfly')

-- Tree-sitter: enable for all filetypes that have a parser
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })