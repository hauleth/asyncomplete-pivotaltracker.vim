func! asyncomplete#sources#pivotaltracker#completor(opt, ctx) abort
    let l:col = a:ctx['col']
    let l:typed = a:ctx['typed']

    let l:kw = matchstr(l:typed, '\v#\zs\d*$')
    let l:kwlen = len(l:kw)

    let l:startcol = l:col - l:kwlen

    func! Complete(items) closure abort
        call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, a:items)
    endfunc

    call asyncomplete#sources#pivotaltracker#fetch(funcref('Complete'))
endfunc

func! asyncomplete#sources#pivotaltracker#fetch(cb) abort
    if $PT_TOKEN is# '' || $PT_ID is# ''
        echom 'No Pivotal Tracker config'
        return call(a:cb, [[]])
    endif

    let l:raw = ''
    func! Append(id, data, type) closure abort
        let l:raw .= join(a:data)
    endfunc
    let l:cmd = ['curl',
                \  '-X', 'GET',
                \  '-H', 'X-TrackerToken:'.$PT_TOKEN,
                \  'https://www.pivotaltracker.com/services/v5/projects/'.$PT_ID.'/stories?fields=name&with_state=started']

    call jobstart(l:cmd,
                \ {
                \   'on_stdout': funcref('Append'),
                \   'on_exit': {-> call(a:cb, [s:parse(l:raw)])}
                \ })
endfunc

func! s:parse(raw) abort
    return map(json_decode(a:raw), function('s:build_result'))
endfunc

func! s:build_result(id, val) abort
    return {'word': a:val.id, 'abbr': '#'.a:val.id, 'menu': a:val.name}
endfunc
