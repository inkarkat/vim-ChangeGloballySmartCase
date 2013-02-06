" ChangeGloballySmartCase.vim: Change {motion} text and repeat as SmartCase substitution.
"
" DEPENDENCIES:
"   - ChangeGlobally.vim autoload script
"   - SmartCase plugin (SmartCase() function)
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	26-Sep-2012	Also allow delimiters between CamelCase
"				fragments in a:search.
"	001	25-Sep-2012	file creation from plugin/ChangeGlobally.vim

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ChangeGloballySmartCase') || (v:version < 700)
    finish
endif
let g:loaded_ChangeGloballySmartCase = 1
let s:save_cpo = &cpo
set cpo&vim

"- functions -------------------------------------------------------------------

function! ChangeGloballySmartCase#CountedReplace( count )
    let l:newText = ChangeGlobally#CountedReplace(a:count)
    return (l:newText ==# submatch(0) ? l:newText : SmartCase(l:newText))
endfunction
function! ChangeGloballySmartCase#Hook( search, replace, ... )
    " Use a case-insensitive match (replace \V\C with \V\c, as the hook doesn't
    " allow to append the /i flag to the :substitute command).
    let l:search = a:search[4:]

    " Make all non-alphabetic delimiter characters and whitespace optional, and
    " allow delimiters between CamelCase fragments to catch all variants.
    let l:search = substitute(l:search, '\A', '\\A\\?', 'g')
    let l:search = substitute(l:search, '\(\l\)\(\u\)', '\1\\A\\?\2', 'g')
    return [
    \   '\V\c' . l:search,
    \   substitute(a:replace, 'ChangeGlobally#CountedReplace', 'ChangeGloballySmartCase#CountedReplace', '')
    \]
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
