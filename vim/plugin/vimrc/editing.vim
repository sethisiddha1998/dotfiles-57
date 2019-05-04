if exists('g:loaded_vimrc_editing') || v:version < 702
  finish
endif
let g:loaded_vimrc_editing = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

augroup vimrc_editing
  autocmd!
augroup END

" indent
set noautoindent
set smartindent
set cindent
set smarttab
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=0
set shiftround

" virtualedit with freedom
set virtualedit& virtualedit+=block

" don't insert the current comment leader on leading lines
set formatoptions-=ro

" remove a comment leader when joining lines
set formatoptions+=j

" shortcut
nmap <C-s> <C-w>

" edit configurations
command! Vimrc edit $MYVIMRC
command! Dotfiles exec 'lcd' vimrc#env.path.dotfiles
command! MacVim exec 'lcd' vimrc#env.path.runtime

" pay respect to vim
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

" move cursor visually with long lines
nmap j gj
vmap j gj
nmap k gk
vmap k gk

" paste
inoremap <C-v> <C-r><C-p>*
cnoremap <C-v> <C-r>*

inoremap <C-\> <C-v>
cnoremap <C-\> <C-v>

" do not store to register with x, c
nnoremap x "_x
nnoremap X "_X
nnoremap c "_c
nnoremap C "_C
vnoremap c "_c
vnoremap x "_x

" undo
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" why are you left out??
nnoremap Y y$

" keep the cursor in place while joining lines
nnoremap J mZJ`ZmZ

" split lines: inverse of J
nnoremap <silent> K ylpr<Enter>

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" indent/outdent
inoremap <C-s><C-h> <C-d>
inoremap <C-s><C-l> <C-t>
inoremap <C-s>h <C-d>
inoremap <C-s>l <C-t>

" easy key
nnoremap <Space>h g^
nnoremap <Space>l g$
nnoremap <Space>m %
vnoremap <Space>h g^
vnoremap <Space>l g$
vnoremap <Space>m %

" insert blank lines without going into insert mode
nnoremap <Space>o mZo<Esc>`ZmZ
nnoremap <Space>O mZO<Esc>`ZmZ

" reselect pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" select all
map <Space>a ggVG

" avoid suicide
nnoremap ZQ <Nop>

" useless and annoying
vnoremap K <Nop>

" sort lines inside block
nnoremap <leader>sor ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

" tags
nnoremap tn :tn<CR>
nnoremap tp :tp<CR>
nnoremap tl :tags<CR>

nnoremap <C-]> g<C-]>

" tab pages / buffers
nmap <C-w><C-t> <C-w>t
nnoremap <C-w>t :tabnew<CR>

nmap <C-w><C-v> <C-w>v
nnoremap <C-w>v :vnew<CR>

nmap <C-w><C-s> <C-w>s
nnoremap <C-w>s :split +enew<CR>

nmap <C-w><C-c> <Nop>
nnoremap <C-w>c <Nop>

nmap <C-w><C-d> <C-w>d
nnoremap <C-w>d :quit<CR>

nnoremap <C-w><C-n> gt
nnoremap <C-w><C-b> gT

" dim match highlight
autocmd vimrc_editing User ClearSearchHighlight :
nnoremap <silent> <Space><Space> :nohlsearch<CR>:doautocmd User ClearSearchHighlight<CR>
autocmd vimrc_editing BufReadPost * nohlsearch | doautocmd User ClearSearchHighlight

" search selection
vnoremap <Space>/ "xy/<C-r>=escape(@x, '\\/.*$^~')<CR>

" replace selection
vnoremap <Space>r "xy:%s/<C-r>=escape(@x, '\\/.*$^~')<CR>/

" replace word under cursor
nnoremap <Space>* "xyiw:%s/\<<C-r>=escape(@x, '\\/.*$^~')<CR>\>/

" auto escaping
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" change soft-indent size
command! -nargs=1 SoftTab :setl expandtab tabstop=<args> shiftwidth=<args>

" remove trailing spaces before saving
autocmd vimrc_editing BufWritePre *
  \ if &ft != 'markdown' |
    \ :%s/\s\+$//ge |
  \ endif

" convert tabs to soft tabs if expandtab is set
autocmd vimrc_editing BufWritePre *
  \ if &et |
    \ exec "%s/\t/" . repeat(' ', &tabstop) . "/ge" |
  \ endif

" back to the last line I edited
autocmd vimrc_editing BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
  \ endif

" numbering selection in visual-block mode
nnoremap <silent> sc :ContinuousNumber <C-a><CR>
vnoremap <silent> sc :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber
  \ let c = col('.') |
  \ for n in range(1, <count>?<count>-line('.'):1) |
    \ exec 'normal! j' . n . <q-args> |
    \ call cursor('.', c) |
  \ endfor

" use I, A for all visual modes
vnoremap <expr> I <SID>force_blockwise_visual('I')
vnoremap <expr> A <SID>force_blockwise_visual('A')

let s:blockwise_visual_paste = 0

function! s:force_blockwise_visual(next_key) abort
  let l:m = mode()

  let s:blockwise_visual_paste = 1
  set paste

  if l:m ==# 'v'
    return "\<C-v>" . a:next_key
  elseif l:m ==# 'V'
    return "\<C-v>0o$" . a:next_key
  else
    return a:next_key
  endif
endfunction

autocmd vimrc_editing InsertLeave *
  \ if s:blockwise_visual_paste == 1 |
    \ let s:blockwise_visual_paste = 0 |
    \ set nopaste |
  \ endif

" next/last text-object
onoremap <silent> an :<C-u>call vimrc#text_object#next('a', '/')<CR>
xnoremap <silent> an :<C-u>call vimrc#text_object#next('a', '/')<CR>
onoremap <silent> in :<C-u>call vimrc#text_object#next('i', '/')<CR>
xnoremap <silent> in :<C-u>call vimrc#text_object#next('i', '/')<CR>
onoremap <silent> al :<C-u>call vimrc#text_object#next('a', '?')<CR>
xnoremap <silent> al :<C-u>call vimrc#text_object#next('a', '?')<CR>
onoremap <silent> il :<C-u>call vimrc#text_object#next('i', '?')<CR>
xnoremap <silent> il :<C-u>call vimrc#text_object#next('i', '?')<CR>

" number text-object
onoremap <silent> m  :<C-u>call vimrc#text_object#number(0)<CR>
xnoremap <silent> m  :<C-u>call vimrc#text_object#number(0)<CR>
onoremap <silent> am :<C-u>call vimrc#text_object#number(1)<CR>
xnoremap <silent> am :<C-u>call vimrc#text_object#number(1)<CR>
onoremap <silent> im :<C-u>call vimrc#text_object#number(1)<CR>
xnoremap <silent> im :<C-u>call vimrc#text_object#number(1)<CR>

let &cpoptions = s:save_cpo
unlet s:save_cpo