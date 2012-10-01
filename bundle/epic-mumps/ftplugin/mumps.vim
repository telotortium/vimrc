"allow gf/goto file on routine names
let &l:isfname = 'A-Z,a-z,48-57,/,_,%,~,-,.'
let &l:includeexpr = 'substitute(v:fname,"%","_","")'
"comment & dot level formatting
let &l:commentstring = ';%s'
let &l:comments = 'n:;,n:.'
"autoformatting
let &l:formatoptions = 'rol'
"change word characters (default is '@,48-57,_,192-255')
"we want to add '%' and remove '_'
let &l:iskeyword = '@,%,48-57,A-Z,a-z,192-255'
