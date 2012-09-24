" ChangeGloballySmartCase.vim: Change {motion} text and repeat the substitution on the entire line.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	25-Sep-2012	Add g:ChangeGlobally_GlobalCountThreshold
"				configuration.
"				Merge ChangeGlobally#SetCount() and
"				ChangeGlobally#SetRegister() into
"				ChangeGlobally#SetParameters() and pass in
"				visual mode flag.
"				Inject the [visual]repeat mappings from the
"				original mappings (via
"				ChangeGlobally#SetParameters()) instead of
"				hard-coding them in the functions, so that
"				the functions can be re-used for similar
"				(SmartCase) substitutions.
"	002	21-Sep-2012	ENH: Use [count] before the operator and in
"				visual mode to specify the number of
"				substitutions that should be made.
"				Call ChangeGlobally#SetCount() to record it.
"	001	28-Aug-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ChangeGloballySmartCase') || (v:version < 700)
    finish
endif
let g:loaded_ChangeGloballySmartCase = 1
let s:save_cpo = &cpo
set cpo&vim

"- functions -------------------------------------------------------------------

function! ChangeGloballySmartCase#SmartCase(arg)
    echomsg '****' string(submatch(0)) string(a:arg)
    return a:arg
endfunction
function! ChangeGloballySmartCase#CountedReplace( count )
    let l:newText = ChangeGlobally#CountedReplace(a:count)
    return (l:newText ==# submatch(0) ? l:newText : ChangeGloballySmartCase#SmartCase(l:newText))
endfunction
function! ChangeGloballySmartCase#Hook( substitution, ... )
    let [l:prefix, l:search, l:postfix, l:count, l:flags] = matchlist(a:substitution, '^\(\\\^\|\\<\)\?\(.\{-}\)\(\\\$\|\\>\)\?/\\=ChangeGlobally#CountedReplace(\(\d\+\))/\([^/]*\)$')[1:5]
    return printf('%s%s%s/\=ChangeGloballySmartCase#CountedReplace(%d)/%si',
    \   l:prefix,
    \   substitute(l:search, '\A', '\\A\\?', 'g'),
    \   l:postfix,
    \   l:count,
    \   l:flags
    \)
endfunction


"- mappings --------------------------------------------------------------------

nnoremap <silent> <expr> <SID>(ChangeGloballySmartCaseOperator) ChangeGlobally#OperatorExpression()
nnoremap <silent> <script> <Plug>(ChangeGloballySmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(v:count, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeGloballySmartCaseOperator)
if ! hasmapto('<Plug>(ChangeGloballySmartCaseOperator)', 'n')
    nmap gC <Plug>(ChangeGloballySmartCaseOperator)
endif
nnoremap <silent> <Plug>(ChangeGloballySmartCaseLine)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(0, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\execute 'normal! V' . v:count1 . "_\<lt>Esc>"<Bar>
\call ChangeGlobally#Operator('V')<CR>
if ! hasmapto('<Plug>(ChangeGloballySmartCaseLine)', 'n')
    nmap gCC <Plug>(ChangeGloballySmartCaseLine)
endif

vnoremap <silent> <Plug>(ChangeGloballySmartCaseVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(v:count, 1, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\call ChangeGlobally#Operator(visualmode())<CR>
if ! hasmapto('<Plug>(ChangeGloballySmartCaseVisual)', 'v')
    xmap gC <Plug>(ChangeGloballySmartCaseVisual)
endif



nnoremap <silent> <Plug>(ChangeGloballySmartCaseRepeat)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#Repeat(0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)")<CR>

vnoremap <silent> <Plug>(ChangeGloballySmartCaseVisualRepeat)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#Repeat(1, "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)")<CR>

" A normal-mode repeat of the visual mapping is triggered by repeat.vim. It
" establishes a new selection at the cursor position, of the same mode and size
" as the last selection.
" Note: The cursor is placed back at the beginning of the selection (via "o"),
" so in case the repeat substitutions fails, the cursor will stay at the current
" position instead of moving to the end of the selection.
" If [count] is given, the size is multiplied accordingly. This has the side
" effect that a repeat with [count] will persist the expanded size, which is
" different from what the normal-mode repeat does (it keeps the scope of the
" original command).
nnoremap <silent> <Plug>(ChangeGloballySmartCaseVisualRepeat)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' v:count1 . 'v' . (visualmode() !=# 'V' && &selection ==# 'exclusive' ? ' ' : ''). "o\<lt>Esc>"<Bar>
\call ChangeGlobally#Repeat(1, "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)")<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
