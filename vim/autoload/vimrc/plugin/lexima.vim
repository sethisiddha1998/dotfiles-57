function! vimrc#plugin#lexima#init() abort
endfunction

let g:lexima_map_escape = ''

"  Comma
"-----------------------------------------------
call lexima#add_rule({ 'char': ',', 'input': "<C-r>=smartchr#loop(', ', ',')<CR>" })

"  Angle brackets
"-----------------------------------------------
call lexima#add_rule({ 'char': '<', 'input_after': '>', 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'] })
call lexima#add_rule({ 'char': '<', 'at': '\\\%#' })
call lexima#add_rule({ 'char': '>', 'at': '<%#>', 'leave': 1 })
call lexima#add_rule({ 'char': '<BS>', 'at': '<%#>', 'delete': 1 })
call lexima#add_rule({ 'char': '>', 'at': '< \%#', 'input': '<BS>', 'input_after': '>' })

" sql not <>
" call lexima#add_rule({
"   \ 'char':     '>',
"   \ 'at':       '< \%#',
"   \ 'input':    '<BS>><Space>',
"   \ 'filetype': ['sql'],
"   \ 'priority': 1,
" \ })

"  Arrows
"-----------------------------------------------
" indent on return
call lexima#add_rule({
  \ 'char':  '<CR>',
  \ 'at':    '\(<[-=]\|[-=]>\)\%#',
  \ 'input': '<CR><Tab>',
\ })
call lexima#add_rule({
  \ 'char':  '<CR>',
  \ 'at':    '\(<[-=]\|[-=]>\) \%#',
  \ 'input': '<BS><CR><Tab>',
\ })

"  C-l
"-----------------------------------------------
call lexima#add_rule({ 'char': '<C-l>', 'input': '' })

" transpose charactors before/after cursor
call lexima#add_rule({
  \ 'char':     '<C-l>',
  \ 'at':       '\w\%#\w',
  \ 'input':    '<Esc>"0ylxa<C-r>0<Left>',
  \ 'priority': 10,
\ })

" delete spaces around
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '\S [+\-\*/%?&|<>=]\+ \%#',
  \ 'input': '<Esc>bh"_xf<Space>"_cl',
\ })
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '\S [+\-\*/%?&|<>=]\+\%#',
  \ 'input': '<Space><Esc>bh"_xf<Space>"_cl',
\ })
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '\S[+\-\*/%?&|<>=]\+ \%#',
  \ 'input': '<BS>',
\ })

" nesting
for s:pa in ['()', '[]', '{}']
  call lexima#add_rule({
    \ 'char':     '<C-l>',
    \ 'at':       escape(s:pa[1], '[]') . '\%#',
    \ 'input':    '<Esc>%i' . s:pa[0] . '<Esc><Right>%a' . s:pa[1],
    \ 'priority': 10,
  \ })
  call lexima#add_rule({
    \ 'char':     '<C-l>',
    \ 'at':       '\%#' . escape(s:pa[1], '[]'),
    \ 'input':    '<Esc><Right>%i' . s:pa[0] . '<Esc><Right>%i' . s:pa[1],
    \ 'priority': 10,
  \ })
endfor
unlet s:pa

" tag close
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '<[a-zA-Z0-9_-]\+[^>]*>\%#',
  \ 'input': '<Esc>F<<Right>"xyiwf>a</><Esc><Left>"xpF<i',
\ })

" go channel
call lexima#add_rule({
  \ 'char':     '<C-l>',
  \ 'at':       '\(chan\|<-chan\|chan<-\)\%#',
  \ 'input':    "<C-r>=smartchr#loop('chan', '<-chan', 'chan<-')<CR>",
  \ 'filetype': ['go'],
\ })

"  Ruby
"-----------------------------------------------
" lambda
call lexima#add_rule({
  \ 'char':        '(',
  \ 'at':          '?->\%#',
  \ 'input':       '(',
  \ 'input_after': ')',
  \ 'filetype':    ['ruby', 'ruby.rspec'],
\ })
call lexima#add_rule({
  \ 'char':        '(',
  \ 'at':          '?-> \%#',
  \ 'input':       '<BS>(',
  \ 'input_after': ')',
  \ 'filetype':    ['ruby', 'ruby.rspec'],
\ })

"  Html
"-----------------------------------------------
" attributes
call lexima#add_rule({
  \ 'char':        '=',
  \ 'at':          '\w\+\%#',
  \ 'input':       '="',
  \ 'input_after': '"',
  \ 'syntax':      ['htmlArg'],
\ })

" entity
call lexima#add_rule({
  \ 'char':        '&',
  \ 'at':          '\%#',
  \ 'input':       '&',
  \ 'input_after': ';',
  \ 'filetype':    ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" comment
call lexima#add_rule({
  \ 'char':        '-',
  \ 'at':          '<\%#>',
  \ 'input':       '!-- ',
  \ 'input_after': ' --',
  \ 'filetype':    ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" server script
call lexima#add_rule({
  \ 'char':        '%',
  \ 'at':          '<\%#>',
  \ 'input':       '% ',
  \ 'input_after': ' %',
  \ 'filetype':    ['html', 'ejs', 'eruby'],
\ })
call lexima#add_rule({
  \ 'char':     '%',
  \ 'at':       '<%[=-]\? \%# %>',
  \ 'input':    "<C-r>=smartchr#loop('% ', '%= ', '%- ')<CR>",
  \ 'filetype': ['html', 'ejs', 'eruby'],
\ })

" program block
call lexima#add_rule({
  \ 'char':     '=',
  \ 'at':       '^\s*\([.#%]\(\w\|-\)\+\)*\%#',
  \ 'input':    '= ',
  \ 'filetype': ['haml', 'slim'],
\ })

"  Command mode
"-----------------------------------------------
" write a file as sudo :w!!
call lexima#add_rule({
  \ 'char':  '!',
  \ 'at':    '^w!\%#',
  \ 'input': "\<C-u>w !sudo tee % > /dev/null",
  \ 'mode':  ':',
\ })

" edit relative :ee
call lexima#add_rule({
  \ 'char':  'e',
  \ 'at':    '^e\%#',
  \ 'input': " \<C-r>=expand('%:p:h') . '/' \<CR>",
  \ 'mode':  ':',
\ })

" edit file :ef
call lexima#add_rule({
  \ 'char':  'f',
  \ 'at':    '^e\%#',
  \ 'input': " \<C-r>=expand('%:p')\<CR>",
  \ 'mode':  ':',
\ })

" directory shortcuts
let s:directories = {
  \ 'h': '~/',
  \ 'g': '~/go/src/github.com/',
\ }
for [s:shortcut, s:directory] in items(s:directories)
  call lexima#add_rule({
    \ 'char':  s:shortcut,
    \ 'at':    '^e\%#',
    \ 'input': ' ' . s:directory,
    \ 'mode':  ':',
  \ })
endfor
unlet s:directories
unlet s:shortcut
unlet s:directory

" edit buffer :eb
call lexima#add_rule({
  \ 'char':  'b',
  \ 'at':    '^e\%#',
  \ 'input': ' #',
  \ 'mode':  ':',
\ })

" rename :er
call lexima#add_rule({
  \ 'char':  'r',
  \ 'at':    '^e\%#',
  \ 'input': "\<C-u>Rename \<C-r>=expand('%:p') \<CR>",
  \ 'mode':  ':',
\ })

" font
call lexima#add_rule({
  \ 'char':  '<Space>',
  \ 'at':    '^font\%#',
  \ 'input': "\<C-u>Font ",
  \ 'mode':  ':',
\ })
