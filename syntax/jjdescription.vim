if exists("b:current_syntax")
  finish
endif

scriptencoding utf-8

syn include @Diff syntax/diff.vim

syn case match
syn sync minlines=50
syn sync linebreaks=1

if has("spell")
  syn spell toplevel
endif

if get(g:, 'jjdescription_summary_length') < 0
  syn match   jjdescriptionSummary	"^.*$" contained containedin=jjdescriptionFirstLine nextgroup=jjdescriptionOverflow contains=@Spell
elseif get(g:, 'jjdescription_summary_length', 1) > 0
  exe 'syn match   jjdescriptionSummary	"^.*\%<' . (get(g:, 'jjdescription_summary_length', 50) + 1) . 'v." contained containedin=jjdescriptionFirstLine nextgroup=jjdescriptionOverflow contains=@Spell'
endif
syn match   jjdescriptionOverflow	".*" contained contains=@Spell
syn match   jjdescriptionBlank	"^.\+" contained contains=@Spell
syn match   jjdescriptionFirstLine	"\%^.*" nextgroup=jjdescriptionBlank,jjdescriptionComment,jjdescriptionRest skipnl

" The diff syntax is used when configuring JJ to output diff.stat() and diff.git()
" in a description template, as in the following example:
"
"   [templates]
"   draft_commit_description = '''
"   concat(
"     coalesce(description, default_commit_description, "\n"),
"     "\nJJ: ignore-rest\n",
"     diff.stat(72),
"     "\n",
"     diff.git(),
"   )
"   '''
"
syn region jjdescriptionDiff start=/\%(^diff --\%(git\|cc\|combined\) \)\@=/ end=/^\%(diff --\|$\|@@\@!\|[^[:alnum:]\ +-]\S\@!\)\@=/ fold contains=@Diff

syn match   jjdescriptionComment "^JJ:.*"

" Highlight the diff.stat() output
syn match   jjdescriptionDiffStatAdd   "\v\++" contained
syn match   jjdescriptionDiffStatDel   "\v-+" contained
syn region  jjdescriptionDiffStatLine  start=/\v^\s*[^|]+ \|\s+\d+\s+\zs/ end=/$/ transparent contains=jjdescriptionDiffStatAdd,jjdescriptionDiffStatDel
syn match   jjdescriptionDiffStatSummary "^\s*\d+ files\? changed, .*$"

syn region  jjdescriptionRest start=/^JJ: ignore-rest$\n\zs/ end=/\%$/ contains=jjdescriptionComment,jjdescriptionDiffStatLine,jjdescriptionDiffStatSummary,jjdescriptionDiff

" Headers are comments which end with a colon, followed by a non-empty line.
syn match   jjdescriptionHeader	"\%(^JJ:\s*\)\@<=\S.*:\%(\n^$\)\@!$" contained containedin=jjdescriptionComment

" Sigils extracted from https://github.com/martinvonz/jj/blob/95283dd04f7047c48356de1addd3d59d35ec5bce/cli/src/diff_util.rs#L1542.
syn match   jjdescriptionType		"\%(^JJ:\s*\)\@<=[CRMAD]\ze " contained containedin=jjdescriptionComment nextgroup=jjdescriptionFile skipwhite
syn match   jjdescriptionFile		".*" contained

hi def link jjdescriptionSummary		Keyword
hi def link jjdescriptionComment		Comment
hi def link jjdescriptionType		Type
hi def link jjdescriptionHeader		PreProc
hi def link jjdescriptionFile		Constant
hi def link jjdescriptionBlank		Error

" New highlighting for diff.stat()
hi def link jjdescriptionDiffStatAdd      DiffAdd
hi def link jjdescriptionDiffStatDel      DiffDelete
hi def link jjdescriptionDiffStatSummary  Comment

let b:current_syntax = "jjdescription"
