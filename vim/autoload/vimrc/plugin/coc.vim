scriptencoding utf-8

let g:coc_status_error_sign = '✗'
let g:coc_status_warning_sign = '∆'

function! vimrc#plugin#coc#init() abort
  if g:colors_name ==# 'candle'
    autocmd vimrc BufWinEnter,WinEnter *
      \ call candle#highlight('CocErrorSign', 'red', '', '') |
      \ call candle#highlight('CocWarningSign', 'yellow', '', '') |
      \ call candle#highlight('CocInfoSign', 'blue', '', '') |
      \ call candle#highlight('CocHintSign', 'green', '', '') |
      \ call candle#highlight('CocErrorHighlight', 'red', '', 'undercurl') |
      \ call candle#highlight('CocWarningHighlight', 'yellow', '', 'undercurl') |
      \ call candle#highlight('CocInfoHighlight', 'blue', '', 'undercurl') |
      \ call candle#highlight('CocHintHighlight', 'green', '', 'undercurl')
  endif

  " Highlight the symbol and its references when holding the cursor.
  autocmd vimrc CursorHold * silent call CocActionAsync('highlight')

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')
endfunction

"  Custom actions
"-----------------------------------------------
nnoremap <silent> <Plug>(coc-hover) :call CocAction('doHover')<CR>
nnoremap <silent> <Plug>(coc-peek-definition) :call CocAction('jumpDefinition', v:false)<CR>
nnoremap <silent> <Plug>(coc-peek-type-definition) :call CocAction('jumpTypeDefinition', v:false)<CR>

command! -nargs=0 Format :call CocAction('format')

"  Key mappings
"-----------------------------------------------
" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <Tab> <Plug>(coc-range-select)
xmap <silent> <Tab> <Plug>(coc-range-select)

" Refactoring
nmap gr <Plug>(coc-rename)
nmap gq <Plug>(coc-codeaction)

" GoTo code navigation.
nmap gd <Plug>(coc-definition)
nmap gD <Plug>(coc-peek-definition)
nmap gh <Plug>(coc-hover)
nmap gt <Plug>(coc-type-definition)
nmap gT <Plug>(coc-peek-type-definition)
nmap gR <Plug>(coc-references)

"  Config
"-----------------------------------------------
call coc#config('snippets.loadFromExtensions', v:false)

call coc#config('diagnostic.errorSign', '✗')
call coc#config('diagnostic.warningSign', '∆')
call coc#config('diagnostic.infoSign', '▸')
call coc#config('diagnostic.hintSign', '▪︎')
call coc#config('diagnostic.virtualTextPrefix', '←')

"  Servers
"-----------------------------------------------
" Installation:
"   go get -u golang.org/x/tools/gopls
if executable('gopls')
  call coc#config('languageserver', { 'gopls': {
    \ 'command': 'gopls',
    \ 'rootPatterns': ['go.mod'],
    \ 'disableWorkspaceFolders': v:true,
    \ 'filetypes': ['go'],
  \ } })
endif
