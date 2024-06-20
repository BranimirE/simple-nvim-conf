vim.opt.makeprg='g++ -Wall -W -O3 -std=c++0x %'
vim.cmd [[
  autocmd! QuickFixCmdPost [^l]* nested cwindow
  autocmd! QuickFixCmdPost    l* nested lwindow
]]
