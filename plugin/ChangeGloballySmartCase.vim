" ChangeGloballySmartCase.vim: Change {motion} text and repeat as SmartCase substitution.
"
" DEPENDENCIES:
"   - ChangeGlobally.vim plugin
"   - ingo-library.vim plugin
"   - SmartCase.vim plugin (SmartCase() function)
"
" Copyright: (C) 2012-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.30.007	20-Jun-2014	Factor out SmartCase search pattern conversion
"				to ingo#smartcase#FromPattern().
"   1.30.006	16-Jun-2014	ENH: Implement global delete as a specialization
"				of an empty change.
"				Add a:isDelete flag to
"				ChangeGlobally#SetParameters().
"				Define duplicate delete mappings, with a default
"				mapping to gX instead of gC.
"				FIX: Substitution to make all non-alphabetic
"				delimiter characters and whitespace optional
"				didn't correctly deal with newline \n and the
"				escaped \/ and \\. Tweak the regexp to deal with
"				those.
"				Avoid invoking SmartCase() on empty string. In
"				the debugger, I've seen it turn it into a
"				newline.
"   1.20.005	14-Jun-2013	Minor: Make substitute() robust against
"				'ignorecase'.
"   1.20.004	19-Apr-2013	Adapt to ChangeGlobally.vim version 1.20:
"				Stop duplicating s:count into l:replace and
"				instead access directly from
"				ChangeGlobally#CountedReplace(); i.e. drop the
"				argument of
"				ChangeGloballySmartCase#CountedReplace(), too.
"   1.20.003	18-Apr-2013	Use optional visualrepeat#reapply#VisualMode()
"				for normal mode repeat of a visual mapping.
"				When supplying a [count] on such repeat of a
"				previous linewise selection, now [count] number
"				of lines instead of [count] times the original
"				selection is used.
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

function! s:SmartReplace( newText ) abort
    return (a:newText ==# submatch(0) ?
    \   a:newText :
    \   (empty(a:newText) ?
    \       '' :
    \       SmartCase(a:newText)
    \   )
    \)
endfunction
function! ChangeGloballySmartCase#CountedReplace() abort
    return s:SmartReplace(ChangeGlobally#CountedReplace())
endfunction
function! ChangeGloballySmartCase#AreaReplaceSecondPass() abort
    return s:SmartReplace(ChangeGlobally#AreaReplaceSecondPass())
endfunction
function! ChangeGloballySmartCase#Hook( search, replace, ... ) abort
    " Use a case-insensitive match (prepend \c, as the hook doesn't allow to
    " append the /i flag to the :substitute command).
    let l:search = '\c' . substitute(a:search, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\c', '', 'g')

    let l:replace = a:replace
    " Change moved-over text / selection globally.
    let l:replace = substitute(l:replace, '\CChangeGlobally#CountedReplace', 'ChangeGloballySmartCase#CountedReplace', '')
    " Change current word / WORD / selection / moved-over text over the moved-over area.
    let l:replace = substitute(l:replace, '\CChangeGlobally#AreaReplaceSecondPass', 'ChangeGloballySmartCase#AreaReplaceSecondPass', '')

    " The substitution separator is /; therefore, the escaped form (\/) must be
    " converted, too.
    return ['\V' . ingo#smartcase#FromPattern(l:search, '/'), l:replace]
endfunction



"- Change moved-over text / selection globally mappings ------------------------

nnoremap <silent> <expr> <SID>(ChangeGloballySmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#SourceOperator')
nnoremap <silent> <script> <Plug>(ChangeGloballySmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeGloballySmartCaseOperator)
nnoremap <silent> <Plug>(ChangeGloballySmartCaseLine)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(0, 0, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\execute 'normal! V' . v:count1 . "_\<lt>Esc>"<Bar>
\call ChangeGlobally#Operator('V')<CR>

vnoremap <silent> <Plug>(ChangeGloballySmartCaseVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(0, v:count, 1, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\call ChangeGlobally#Operator(visualmode())<CR>



nnoremap <silent> <script> <Plug>(DeleteGloballySmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeGloballySmartCaseOperator)
nnoremap <silent> <Plug>(DeleteGloballySmartCaseLine)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(1, 0, 0, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\execute 'normal! V' . v:count1 . "_\<lt>Esc>"<Bar>
\call ChangeGlobally#Operator('V')<CR>

vnoremap <silent> <Plug>(DeleteGloballySmartCaseVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call ChangeGlobally#SetParameters(1, v:count, 1, "\<lt>Plug>(ChangeGloballySmartCaseRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<Bar>
\call ChangeGlobally#Operator(visualmode())<CR>



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
"   If [count] is given, that number of lines is used / the original size is
"   multiplied accordingly. This has the side effect that a repeat with [count]
"   will persist the expanded size, which is different from what the normal-mode
"   repeat does (it keeps the scope of the original command).
nnoremap <silent> <Plug>(ChangeGloballySmartCaseVisualRepeat)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' ChangeGlobally#VisualMode()<Bar>
\call ChangeGlobally#Repeat(1, "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)", "\<lt>Plug>(ChangeGloballySmartCaseVisualRepeat)")<CR>



"- Change cword / cWORD / selection / moved-over text over the moved-over area -

nnoremap <silent> <expr> <SID>(ChangeWholeWordSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WholeWordSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWholeWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWholeWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWordSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWordSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WordSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWordSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWholeWORDSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WholeWORDSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWholeWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWholeWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWORDSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWORDSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WORDSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWORDSmartCaseOperator)


nnoremap <silent> <expr> <SID>(ChangeOperatorSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#OperatorSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeOperatorSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeOperatorSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteOperatorSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeOperatorSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeSelectionSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#SelectionSourceSmartCaseOperatorTarget')
vnoremap <silent> <script> <Plug>(ChangeSelectionSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeSelectionSmartCaseOperator)
vnoremap <silent> <script> <Plug>(DeleteSelectionSmartCaseOperator) :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeSelectionSmartCaseOperator)



"- default mappings ------------------------------------------------------------

if ! exists('g:ChangeGloballySmartCase_no_mappings')
    if ! hasmapto('<Plug>(ChangeGloballySmartCaseOperator)', 'n')
	nmap gC <Plug>(ChangeGloballySmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeGloballySmartCaseLine)', 'n')
	nmap gCC <Plug>(ChangeGloballySmartCaseLine)
    endif
    if ! hasmapto('<Plug>(ChangeGloballySmartCaseVisual)', 'x')
	xmap gC <Plug>(ChangeGloballySmartCaseVisual)
    endif
    if ! hasmapto('<Plug>(DeleteGloballySmartCaseOperator)', 'n')
	nmap gX <Plug>(DeleteGloballySmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteGloballySmartCaseLine)', 'n')
	nmap gXX <Plug>(DeleteGloballySmartCaseLine)
    endif
    if ! hasmapto('<Plug>(DeleteGloballySmartCaseVisual)', 'x')
	xmap gX <Plug>(DeleteGloballySmartCaseVisual)
    endif
    if ! hasmapto('<Plug>(ChangeWholeWordSmartCaseOperator)', 'n')
	nmap gC* <Plug>(ChangeWholeWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWholeWordSmartCaseOperator)', 'n')
	nmap gX* <Plug>(DeleteWholeWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWordSmartCaseOperator)', 'n')
	nmap gCg* <Plug>(ChangeWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWordSmartCaseOperator)', 'n')
	nmap gXg* <Plug>(DeleteWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWholeWORDSmartCaseOperator)', 'n')
	nmap gC<A-8> <Plug>(ChangeWholeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWholeWORDSmartCaseOperator)', 'n')
	nmap gX<A-8> <Plug>(DeleteWholeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWORDSmartCaseOperator)', 'n')
	nmap gCg<A-8> <Plug>(ChangeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWORDSmartCaseOperator)', 'n')
	nmap gXg<A-8> <Plug>(DeleteWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeOperatorSmartCaseOperator)', 'n')
	nmap <Leader>gC <Plug>(ChangeOperatorSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteOperatorSmartCaseOperator)', 'n')
	nmap <Leader>gX <Plug>(DeleteOperatorSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeSelectionSmartCaseOperator)', 'v')
	xmap <Leader>gC <Plug>(ChangeSelectionSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteSelectionSmartCaseOperator)', 'v')
	xmap <Leader>gX <Plug>(DeleteSelectionSmartCaseOperator)
    endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
