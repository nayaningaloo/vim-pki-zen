" vim-pki-zen autolaod file

" Parse openssl data and return output with printf
function! s:ParseOnLoad(start,end)
"{{{1
  "read cert from buffer
  let l:content = join(getline(a:start, a:end), "\n")
  let l:out = systemlist("openssl x509 -noout -subject -issuer -enddate 2>&1",l:content)

  if v:shell_error != 0 || empty(l:out)
    " Fallback on error
    return = {
        \ 'status': ’[ ?ERR ]',
        \ 'subject': 'Parsing failed (check openssl)',
        \ 'issuer': 'N/A',
        \ 'raw_date': 'N/A',
        \ 'iso_date': 'N/A'
        \ }
  endif

  " Parse data
  let l:sub = substitute(l:out[0], '^subject=\s*', '', '')
  let l:iss = substitute(l:out[1], '^issuer=\s*', '', '')
  let l:raw_date = substitute(l:out[2], '^notAfter=\s*', '', '')

  if empty(l:sub) | let l:sub = "Unknown Subject" | endif
  if empty(l:iss) | let l:iss = "Unknown Issuer" | endif

  " date
  if empty(l:raw_date)
    let l:result = {
        \ 'status': ’[ ?ERR ]',
        \ 'subject': l:sub,
        \ 'issuer': l:iss,
        \ 'raw_date': '????????',
        \ 'iso_date': '????????',
        \ }
  else
    let l:iso_expiry = s:ToISODate(l:raw_date)
    let l:today = strftime('%Y%m%d')
    let l:is_expired = (l:iso_expiry < l:today) ? '[ !EXP ]' : '[  OK  ]'
    let l:result = {
        \ 'status': l:is_expired,
        \ 'subject': l:sub,
        \ 'issuer': l:iss,
        \ 'raw_date': l:raw_date,
        \ 'iso_date': l:iso_expiry
        \ }
  endif

  "return result formattet with printf to reduce fluttering
  return printf("%-8s | S: %-80.80s | I: %-80.80s | Exp: %s",
          \  l:result.status, l:result.subject, l:result.issuer, l:result.iso_date)
endfunction
"}}}

" Convert end_date string to ISO date without date function
" reason: portability
function!  s:ToISODate(openssl_date)
"{{{1
  "Input 'Apr 26 18:00:00 2026 GMT'
  let monthsdic = {}
  let monthsdic["Jan"] = '01'
  let monthsdic["Feb"] = '02'
  let monthsdic["Mar"] = '03'
  let monthsdic["Apr"] = '04'
  let monthsdic["May"] = '05'
  let monthsdic["Jun"] = '06'
  let monthsdic["Jul"] = '07'
  let monthsdic["Aug"] = '08'
  let monthsdic["Sep"] = '09'
  let monthsdic["Oct"] = '10'
  let monthsdic["Nov"] = '11'
  let monthsdic["Dec"] = '12'
  let l:parts = split(a:openssl_date, '\s\+')
  "" parts dictonary  contains
   "l:parts[0] = month
   "l:parts[1] = day
   "l:parts[3] = year
  let l:day = printf('%02d', l:parts[1])
  let l:month = get(monthsdic, l:parts[0], '00')
  return l:parts[3] . l:month . l:day
endfunction
"}}}

" Lazy Caching 
" reason: performance
function! pkizen#SetPEMFoldTextOnLoad()
"{{{1
    if !exists('b:pkizen_on_load_cert_cache')
      let b:pkizen_on_load_cert_cache = {}
    endif

    let l:line_id = v:foldstart
    " check if we already have parsed
    if !has_key(b:pkizen_on_load_cert_cache,l:line_id)
      " 'Lazy Cache' ssl information to buffer
      let b:pkizen_on_load_cert_cache[l:line_id] = s:ParseOnLoad(v:foldstart,v:foldend)
    endif

    " get data from cache
    let l:data = b:pkizen_on_load_cert_cache[l:line_id]
    return l:data

endfunction
"}}}
