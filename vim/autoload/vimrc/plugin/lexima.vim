function! vimrc#plugin#lexima#init() abort
endfunction

let g:lexima_map_escape = ''

call lexima#set_default_rules()

function! s:disable_inside_string(char) abort
  call lexima#add_rule({
    \ 'char':  a:char,
    \ 'at':    '^\([^"]*"[^"]*"\)*[^"]*"[^"]*\%#',
    \ 'input': a:char,
  \ })
  call lexima#add_rule({
    \ 'char':  a:char,
    \ 'at':    '^\([^'']*''[^'']*''\)*[^'']*''[^'']*\%#',
    \ 'input': a:char,
  \ })
  call lexima#add_rule({
    \ 'char':  a:char,
    \ 'at':    '\%#',
    \ 'input': a:char,
    \ 'syntax': ['String'],
  \ })
endfunction

function! s:disable_inside_regexp(char) abort
  call lexima#add_rule({
    \ 'char':  a:char,
    \ 'at':    '\(...........\)\?/\S.*\%#.*\S/',
    \ 'input': a:char,
  \ })
endfunction


"  Quotes
"-----------------------------------------------
for s:quote in ['"', "'"]
  call lexima#add_rule({
    \ 'char':  s:quote,
    \ 'at':    '\(.......\)\?\%#\w',
    \ 'input': s:quote,
  \ })
  call lexima#add_rule({
    \ 'char':  s:quote,
    \ 'at':    '\(.......\)\?' . s:quote . '\%#',
    \ 'input': s:quote,
  \ })
  call lexima#add_rule({
    \ 'char':  s:quote,
    \ 'at':    '\(...........\)\?\%#' . s:quote,
    \ 'input': '<Right>',
  \ })

  call s:disable_inside_regexp(s:quote)
endfor
unlet s:quote


"  Operators
"-----------------------------------------------
" looping with Smartchr
let s:rules = {
  \ '<':     "smartchr#loop('<', '<<')",
  \ '>':     "smartchr#loop('>', '>>', '>>>')",
  \ '&':     "smartchr#loop('&', '&&')",
  \ '<Bar>': "smartchr#loop('|', '||')",
\ }

for [s:char, s:rule] in items(s:rules)
  let s:uchar = substitute(s:char, '<Bar>', '|', '')

  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '\S\%#',
    \ 'input': ' ' . s:char . ' ',
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '^\s*\%#',
    \ 'input': s:char . ' ',
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '^\s*\%# ',
    \ 'input': s:char,
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '\S \%#',
    \ 'input': s:char . ' ',
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '\S \%# ',
    \ 'input': s:char,
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '\(...\)\?' . s:uchar . ' \%#',
    \ 'input': '<BS><C-r>=' . s:rule . '<CR><Space>',
  \ })
  call lexima#add_rule({
    \ 'char':  s:char,
    \ 'at':    '\(...\)\?' . s:uchar . ' \%# ',
    \ 'input': '<BS><C-r>=' . s:rule . '<CR>',
  \ })

  call s:disable_inside_string(s:char)
  call s:disable_inside_regexp(s:char)
endfor

unlet s:char
unlet s:uchar
unlet s:rule
unlet s:rules

" space around
for s:op in ['+', '-', '/', '*', '=', '%']
  let s:eop = escape(s:op, '*')

  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    '\w\%#',
    \ 'input': ' ' . s:op . ' ',
  \ })
  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    '\(^\|\w\) ' . s:eop . '\%#',
    \ 'input': s:op . ' ',
  \ })
  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    s:eop . ' \%#',
    \ 'input': '<BS>' . s:op . ' ',
  \ })

  call s:disable_inside_string(s:op)
  call s:disable_inside_regexp(s:op)
endfor
unlet s:op
unlet s:eop

" compound assignment operator
call lexima#add_rule({
  \ 'char':  '=',
  \ 'at':    '\s[&|?+-/<>]\%#',
  \ 'input': '= ',
\ })
call lexima#add_rule({
  \ 'char':  '=',
  \ 'at':    '[&|?+-/<>] \%#',
  \ 'input': '<BS>= ',
\ })

" slash as non arithmetic operators
call lexima#add_rule({
  \ 'char':  '/',
  \ 'at':    '\S/\S[^/]*\%#',
  \ 'input': '/',
\ })
call lexima#add_rule({
  \ 'char':  '/',
  \ 'at':    '^\s*\%#',
  \ 'input': '/',
\ })
call lexima#add_rule({
  \ 'char':  '/',
  \ 'at':    '^\s*/.*\%#',
  \ 'input': '/',
\ })
call s:disable_inside_regexp('/')

" decrement/increment operators
for s:op in ['+', '-']
  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    ' ' . s:op . ' \%#',
    \ 'input': '<BS><BS><BS>' . s:op . s:op,
  \ })
  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    "^\(\t\|  \)\+" . s:op . ' \%#',
    \ 'input': s:op,
  \ })
  call lexima#add_rule({
    \ 'char':  s:op,
    \ 'at':    '\w' . s:op . s:op . '\%#',
    \ 'input': '<BS><BS><Space>' . s:op . s:op . '<Space>',
  \ })
endfor
unlet s:op

" dash in html/css
call lexima#add_rule({
  \ 'char':     '-',
  \ 'at':       '\(........\)\?\%#',
  \ 'input':    '-',
  \ 'filetype': ['html', 'eruby', 'slim', 'xml', 'css', 'scss'],
\ })
call lexima#add_rule({
  \ 'char':     '-',
  \ 'at':       '^[ \t]*[\.#]\w\+\%#',
  \ 'input':    '-',
  \ 'filetype': ['haml', 'slim'],
\ })
call lexima#add_rule({
  \ 'char':     '-',
  \ 'at':       '}*[\.#]\w\+\%#',
  \ 'input':    '-',
  \ 'filetype': ['haml', 'slim'],
\ })

" hyphenated words
call lexima#add_rule({
  \ 'char':  '-',
  \ 'at':    '\(........\)\?\w\+-\w\+\%#',
  \ 'input': '-',
\ })


"  C-l
"-----------------------------------------------
" nop
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '\%#',
  \ 'input': '',
\ })

" transpose charactors before/after cursor
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '\(...........\)\?\w\%#\w',
  \ 'input': '<Esc>"0ylxa<C-r>0<Left>',
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

" indent
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '^\s*\%#',
  \ 'input': '<Esc>ddO',
\ })

" nesting
for s:pa in ['()', '[]', '{}']
  call lexima#add_rule({
    \ 'char':  '<C-l>',
    \ 'at':    '\(...........\)\?' . escape(s:pa[1], '[]') . '\%#',
    \ 'input': '<Esc>%i' . s:pa[0] . '<Esc><Right>%a' . s:pa[1],
  \ })
  call lexima#add_rule({
    \ 'char':  '<C-l>',
    \ 'at':    '\(...........\)\?\%#' . escape(s:pa[1], '[]'),
    \ 'input': '<Esc><Right>%i' . s:pa[0] . '<Esc><Right>%i' . s:pa[1],
  \ })
endfor
unlet s:pa

" tag close
call lexima#add_rule({
  \ 'char':  '<C-l>',
  \ 'at':    '<[a-zA-Z0-9_-]\+[^>]*>\%#',
  \ 'input': '<Esc>F<<Right>"xyiwf>a</><Esc><Left>"xpF<i',
\ })


"  Backspace
"-----------------------------------------------
" delete whole pair
for s:pa in ['()', '[]', '{}', '<>']
  let s:epa = escape(s:pa, '[]')

  call lexima#add_rule({
    \ 'char':  '<BS>',
    \ 'at':    s:epa[0] . '\s\+' . s:epa[1] . '\%#',
    \ 'input': '<C-o>di' . s:pa[0],
  \ })

  call lexima#add_rule({
    \ 'char':  '<BS>',
    \ 'at':    s:epa . '\%#',
    \ 'input': '<BS><BS>',
  \ })
endfor

unlet s:pa
unlet s:epa


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


"  Fix pair completion
"-----------------------------------------------
for s:pair in ['()', '[]', '{}']
  call lexima#add_rule({
    \ 'char':  s:pair[0],
    \ 'at':    '\(........\)\?\%#[^\s' . escape(s:pair[1], ']') . ']',
    \ 'input': s:pair[0],
  \ })
endfor
unlet s:pair


"  Comma
"-----------------------------------------------
call lexima#add_rule({
  \ 'char':     ',',
  \ 'at':       '\%#',
  \ 'input':    "<C-r>=smartchr#loop(', ', ',')<CR>",
\ })


"  Vim
"-----------------------------------------------
" end wise
for s:at in ['fu', 'fun', 'func', 'funct', 'functi', 'functio', 'function', 'if', 'wh', 'whi', 'whil', 'while', 'for', 'try']
  call lexima#add_rule({
    \ 'char':     '<CR>',
    \ 'at':       '^\s*' . s:at . '\>.*\%#',
    \ 'input':    '<CR>end' . s:at . '<Esc>O',
    \ 'filetype': ['vim'],
  \ })
endfor
unlet s:at


"  Ruby
"-----------------------------------------------
" end wise
for s:at in [
    \ '\%([=,*/%+-]\|<<\|>>\|:\s\|^\)\s*\%(module\|def\|class\|if\|unless\|for\|while\|until\|case\)\>\%(.*[^.:@$]\<end\>\)\@!.*\%#',
    \ '^\s*\(public\|protected\|private\)\s\+def\>\%(.*[^.:@$]\<end\>\)\@!.*\%#',
    \ '^\s*\%(begin\)\s*\%#',
    \ '\%(^\s*#.*\)\@<!do\%(\s*|\k\+|\)\?\s*\%#',
  \ ]

  call lexima#add_rule({
    \ 'char':     '<CR>',
    \ 'at':       s:at,
    \ 'input':    '<CR>end<Esc>O',
    \ 'filetype': ['ruby', 'ruby.rspec'],
  \ })
endfor
unlet s:at

call lexima#add_rule({
  \ 'char':     '<CR>',
  \ 'at':       '\<\%(if\|unless\)\>.*\%#',
  \ 'input':    '<CR>end<Esc>O',
  \ 'filetype': ['ruby', 'ruby.rspec'],
  \ 'syntax':   ['rubyConditionalExpression']
\ })

" block
call lexima#add_rule({
  \ 'char':     '<Bar>',
  \ 'at':       '\({\|do\)\s*\%#',
  \ 'input':    '<Bar><Bar><Left>',
  \ 'filetype': ['ruby', 'ruby.rspec'],
\ })
call lexima#add_rule({
  \ 'char':     '<Bar>',
  \ 'at':       '\({\|do\)\s*|[^|]*\%#|',
  \ 'input':    '<Right>',
  \ 'filetype': ['ruby', 'ruby.rspec'],
\ })

" lambda
call lexima#add_rule({
  \ 'char':     '(',
  \ 'at':       '\(........\)\?-> \%#',
  \ 'input':    '<BS>()<Left>',
  \ 'filetype': ['ruby', 'ruby.rspec'],
\ })


"  Shell
"-----------------------------------------------
" do-end pair
let s:rules = {
  \ '^\s*if\>.*\%#':             'fi',
  \ '^\s*case\>.*\%#':           'esac',
  \ '\%(^\s*#.*\)\@<!do\>.*\%#': 'done',
\ }

for [s:at, s:end_word] in items(s:rules)
  call lexima#add_rule({
    \ 'char':     '<CR>',
    \ 'at':       s:at,
    \ 'input':    '<CR>' . s:end_word . '<Esc>O',
    \ 'filetype': ['sh', 'zsh'],
  \ })
endfor

unlet s:at
unlet s:end_word
unlet s:rules


"  Html
"-----------------------------------------------
" tag
call lexima#add_rule({
  \ 'char':  '>',
  \ 'at':    '\(.....\)\?<\%#',
  \ 'input': '>',
\ })
call lexima#add_rule({
  \ 'char':  '>',
  \ 'at':    '\(........\)\?< \%#',
  \ 'input': '<BS>><Left>',
\ })
call lexima#add_rule({
  \ 'char':  '>',
  \ 'at':    '\(........\)\?<\%#>',
  \ 'input': '<Right>',
\ })
call lexima#add_rule({
  \ 'char':     '<',
  \ 'at':       '\(........\)\?\%#',
  \ 'input':    '<><Left>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })
call lexima#add_rule({
  \ 'char':     '>',
  \ 'at':       '\(........\)\?\%#',
  \ 'input':    '>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })
call lexima#add_rule({
  \ 'char':     '>',
  \ 'at':       '\(........\)\?\%#>',
  \ 'input':    '<Right>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" attributes
call lexima#add_rule({
  \ 'char':     '=',
  \ 'at':       '\(........\)\?<.\+\%#',
  \ 'input':    '=""<Left>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" entity
call lexima#add_rule({
  \ 'char':     '&',
  \ 'at':       '\(........\)\?\%#',
  \ 'input':    '&;<Left>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" comment
call lexima#add_rule({
  \ 'char':     '-',
  \ 'at':       '\(........\)\?<\%#>',
  \ 'input':    '!--  --<Left><Left><Left>',
  \ 'filetype': ['html', 'eruby', 'slim', 'php', 'xml'],
\ })

" server script
call lexima#add_rule({
  \ 'char':     '%',
  \ 'at':       '\(........\)\?<\%#',
  \ 'input':    '%  %<Left><Left>',
  \ 'filetype': ['html', 'ejs', 'eruby'],
\ })
call lexima#add_rule({
  \ 'char':     '%',
  \ 'at':       '\(........\)\?<%[=-]\? \%#',
  \ 'input':    "<C-r>=smartchr#loop('% ', '%= ', '%- ')<CR>",
  \ 'filetype': ['html', 'ejs', 'eruby'],
\ })
call lexima#add_rule({
  \ 'char':     '%',
  \ 'at':       '\(........\)\?<%[=-]\?\%#',
  \ 'input':    "<C-r>=smartchr#loop('%', '%=', '%-)<CR>",
  \ 'filetype': ['html', 'ejs', 'eruby'],
\ })


"  Haml / Slim
"-----------------------------------------------
" equal sign
call lexima#add_rule({
  \ 'char':     '=',
  \ 'at':       '^\s*\([.#%]\(\w\|-\)\+\)*\%#',
  \ 'input':    '= ',
  \ 'filetype': ['haml', 'slim'],
\ })


"  PHP
"-----------------------------------------------
" <?php
call lexima#add_rule({
  \ 'char':     '?',
  \ 'at':       '\(........\)\?<\%#>',
  \ 'input':    '?php  ?<Left><Left>',
  \ 'filetype': ['php'],
\ })


"  SQL
"-----------------------------------------------
" not <>
call lexima#add_rule({
  \ 'char':     '>',
  \ 'at':       '\(.....\)\?< \%#',
  \ 'input':    '<BS>><Space>',
  \ 'filetype': ['sql'],
\ })


"  Go
"-----------------------------------------------
" chan
call lexima#add_rule({
  \ 'char':     '<C-l>',
  \ 'at':       '\(chan\|<-chan\|chan<-\)\%#',
  \ 'input':    "<C-r>=smartchr#loop('chan', '<-chan', 'chan<-')<CR>",
  \ 'filetype': ['go'],
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

if has('gui_running')
  " Font
  call lexima#add_rule({
    \ 'char':  '<Space>',
    \ 'at':    '^font\%#',
    \ 'input': "\<C-u>Font ",
    \ 'mode':  ':',
  \ })
endif
