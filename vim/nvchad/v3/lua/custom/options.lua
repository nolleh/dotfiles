local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.mouse = "a"
o.autoindent = true

o.ts = 2
o.shiftwidth = 2
o.expandtab = true
o.relativenumber = true
o.termguicolors = true
o.clipboard = "unnamed,unnamedplus"
o.langmap =
  "ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz"

local set = vim.opt
set.listchars = { space = "·", tab = ">-", eol = "↵" }
set.list = true

-- set.spell = true
--set.foldmethod = syntax
