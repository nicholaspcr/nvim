let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_mod_fmt_autosave = 0
let g:go_imports_mode = 'gofumpt'
let g:go_fmt_autosave = 0
let g:go_fmt_command = 'gofumpt'
let g:go_fmt_fail_silently = 1

set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr