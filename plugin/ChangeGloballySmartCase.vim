" ChangeGloballySmartCase.vim: Change {motion} text and repeat as SmartCase substitution.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ChangeGlobally.vim plugin
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ChangeGloballySmartCase') || (v:version < 700)
    finish
endif
let g:loaded_ChangeGloballySmartCase = 1
let s:save_cpo = &cpo
set cpo&vim

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
nnoremap <silent> <script> <Plug>(ChangeWholeWordSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWholeWordSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(RegisterWholeWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWordSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWordSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WordSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWordSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWordSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWordSmartCaseOperator)
nnoremap <silent> <script> <Plug>(RegisterWordSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWordSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWholeWORDSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WholeWORDSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWholeWORDSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWholeWORDSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(RegisterWholeWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWholeWORDSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeWORDSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#WORDSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeWORDSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteWORDSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWORDSmartCaseOperator)
nnoremap <silent> <script> <Plug>(RegisterWORDSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeWORDSmartCaseOperator)


nnoremap <silent> <expr> <SID>(ChangeOperatorSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#OperatorSourceOperatorTarget')
nnoremap <silent> <script> <Plug>(ChangeOperatorSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeOperatorSmartCaseOperator)
nnoremap <silent> <script> <Plug>(DeleteOperatorSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeOperatorSmartCaseOperator)
nnoremap <silent> <script> <Plug>(RegisterOperatorSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeOperatorSmartCaseOperator)

nnoremap <silent> <expr> <SID>(ChangeSelectionSmartCaseOperator) ChangeGlobally#OperatorExpression('ChangeGlobally#SelectionSourceSmartCaseOperatorTarget')
vnoremap <silent> <script> <Plug>(ChangeSelectionSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(0, v:count, 0, "\<lt>Plug>(ChangeAreaCannotRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeSelectionSmartCaseOperator)
vnoremap <silent> <script> <Plug>(DeleteSelectionSmartCaseOperator)   :<C-u>call ChangeGlobally#SetParameters(1, v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeSelectionSmartCaseOperator)
vnoremap <silent> <script> <Plug>(RegisterSelectionSmartCaseOperator) :<C-u>call ChangeGlobally#SetSourceRegisterParameters(v:count, 0, "\<lt>Plug>(ChangeAreaRepeat)", "\<lt>Plug>(ChangeAreaVisualRepeat)", function('ChangeGloballySmartCase#Hook'))<CR><SID>(ChangeSelectionSmartCaseOperator)



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
    if ! hasmapto('<Plug>(RegisterWholeWordSmartCaseOperator)', 'n')
	nmap gR* <Plug>(RegisterWholeWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWordSmartCaseOperator)', 'n')
	nmap gCg* <Plug>(ChangeWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWordSmartCaseOperator)', 'n')
	nmap gXg* <Plug>(DeleteWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(RegisterWordSmartCaseOperator)', 'n')
	nmap gRg* <Plug>(RegisterWordSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWholeWORDSmartCaseOperator)', 'n')
	nmap gC<A-8> <Plug>(ChangeWholeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWholeWORDSmartCaseOperator)', 'n')
	nmap gX<A-8> <Plug>(DeleteWholeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(RegisterWholeWORDSmartCaseOperator)', 'n')
	nmap gR<A-8> <Plug>(RegisterWholeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeWORDSmartCaseOperator)', 'n')
	nmap gCg<A-8> <Plug>(ChangeWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteWORDSmartCaseOperator)', 'n')
	nmap gXg<A-8> <Plug>(DeleteWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(RegisterWORDSmartCaseOperator)', 'n')
	nmap gRg<A-8> <Plug>(RegisterWORDSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeOperatorSmartCaseOperator)', 'n')
	nmap <Leader>gC <Plug>(ChangeOperatorSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteOperatorSmartCaseOperator)', 'n')
	nmap <Leader>gX <Plug>(DeleteOperatorSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(RegisterOperatorSmartCaseOperator)', 'n')
	nmap <Leader>gR <Plug>(RegisterOperatorSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(ChangeSelectionSmartCaseOperator)', 'v')
	xmap <Leader>gC <Plug>(ChangeSelectionSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(DeleteSelectionSmartCaseOperator)', 'v')
	xmap <Leader>gX <Plug>(DeleteSelectionSmartCaseOperator)
    endif
    if ! hasmapto('<Plug>(RegisterSelectionSmartCaseOperator)', 'v')
	xmap <Leader>gR <Plug>(RegisterSelectionSmartCaseOperator)
    endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
