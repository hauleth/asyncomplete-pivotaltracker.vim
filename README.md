# asyncomplete-pivotaltracker.vim

[PivotalTracker][pt] stories completion for [asyncomplete.vim][ac].

## Install

Install using your favourite plugin manager and add to your `$MYVIMRC`

```viml
autocmd User asyncomplete_setup call asyncomplete#register_source({
            \ 'name': 'PivotalTracker',
            \ 'whitelist': ['gitcommit'],
            \ 'completor': function('asyncomplete#sources#pivotaltracker#completor'),
            \ })
```
