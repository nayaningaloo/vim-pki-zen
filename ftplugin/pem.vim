" vim-pki-zen
" pem filetype specific settings
"
setlocal foldmethod=marker
setlocal foldmarker=-----BEGIN\ CERTIFICATE-----,-----END\ CERTIFICATE-----
setlocal foldcolumn=2
setlocal fillchars=fold:.
setlocal foldtext=pkizen#SetPEMFoldTextOnLoad()

" Reset highlights for Folded
highlight clear Folded
highlight link Folded Normal
highlight clear FoldColumn
highlight link FoldColumn Normal

