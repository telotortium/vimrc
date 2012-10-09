" Mumps syntax file
" Language:	MUMPS
" Original Author: Jim Self, jaself@ucdavis.edu (28 April 2001)
" Other Modifications:
"  2012-05-09 - *ARB- add spell checking, lots of misc. changes I don't remember
"  2012-10-02 - *RMI- fix regex typos, document case sensitivity vs.
"                     insensitivity, add modern test for loaded syntax file,
"                     add mNumber to mExpr to match numeric literals,
"                     add zw to mZCommand as well as mIntrFunc (the syntax
"                     file can tell the difference)
"
" TODO:
" - doArg,gotoArg highlighting
" - bad operator catches (&&, ||)
" - flag implementation specific intrinsics
" - highlight do/goto labels

" Quit when a syntax file already has been loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" By default, M is case insensitive
syn case ignore

"errors
syn match   mError	contained /[^ \t;].\+/
syn match   mBadString	/".*/
" Catch mismatched parentheses
syn match   mParenError	/).*/
syn match   mBadParen	/(.*/

" Line Structure
syn region  mComment	contained start=/;/ end=/$/ contains=mTodo,@Spell
syn keyword mTodo	contained todo xxx hack
" Labels are case-sensitive
syn case match
syn region   mLabel	contained start=/[%[:alpha:]]/ end=/[^[:alnum:]]/me=e-1 contains=mName nextgroup=mFormalArgs
syn case ignore
"
syn region  mFormalArgs	contained oneline start=/(/ end=/)/ contains=mLocalName,",","."
syn match   mDotLevel	contained /\.[. \t]*/
syn region  mCmd	contained oneline start=/[[:alpha:]]/ end=/[\ \t]/ end=/$/ contains=mDoCommand nextgroup=mDoArgsSeg
syn region  mCmd	contained oneline start=/[[:alpha:]]/ end=/[\ \t]/ end=/$/ contains=mGotoCommand nextgroup=mGotoArgsSeg
syn region  mCmd	contained oneline start=/[[:alpha:]]/ end=/[ \t]/ end=/$/ contains=mCommand,mZCommand,mPostCond,mError nextgroup=mArgsSeg
syn region  mPostCond	contained oneline start=/:/hs=s+1 end=/[ \t]/re=e-1,he=e-1,me=e-1 end=/$/ contains=@mExpr
syn region  mArgsSeg	contained oneline start=/[ \t]/lc=1 end=/[ \t]\+/ end=/$/ contains=@mExpr,",",mPostCond
syn region  mDoArgsSeg	contained oneline start=/[ \t]/lc=1 end=/[ \t]\+/ end=/$/ contains=@mSubRef,",",mPostCond
syn region  mGotoArgsSeg	contained oneline start=/[ \t]/lc=1 end=/[ \t]\+/ end=/$/ contains=@mTagRef,",",mPostCond
syn match   mLineStart	contained /^[ \t][. \t]*/
syn match   mLineStart	contained /^[%[:alpha:]][^ \t;]*[. \t]*/ contains=mLabel,mDotLevel
syn region  mLine	start=/^/ keepend end=/$/ contains=mCmd,mLineStart,mComment
syn cluster mExpr	contains=mVar,mIntr,mExtr,mString,mNumber,mParen,mIndirExpr,mOperator,mBadString,mBadNum,mVRecord
syn region  mIndirExpr	start=/@/ end=/@/ oneline contains=@mExpr nextgroup=mSubs
syn match   mIndirExpr	contained /@/ nextgroup=@mExpr
" Variables and labels are case-sensitive, but not intrinsic functions or
" commands
syn case match
syn match   mName	contained /[%[:alpha:]]/ nextgroup=mNameBody transparent
syn match   mNameBody	contained /[[:alnum:]]/ nextgroup=mNameBody transparent
syn region   mVar	contained start=/[%^[:alpha:]]/ end=/[^[:alnum:]]/me=e-1 contains=mName nextgroup=mSubs
syn case ignore
syn region   mIntr	contained start=/\$/ end=/[^[:alnum:]]/me=e-1 contains=mIntrFunc,mSpecialVar
syn case match
syn match   mTagRef	contained /[%^[:alpha:]]/me=e-1 nextgroup=mLabelRef transparent
syn region   mLabelRef  contained start=/[%^[:alpha:]]/ end=/[^[:alnum:]]/re=e-1,he=e-1,me=e-1 contains=mLabel nextgroup=mLabelOffset,mRoutineRef transparent
syn region   mLabelOffset	contained start=/+/ end=/\(\s\|\^\)/me=e-1 contains=@mExpr nextgroup=mRoutineRef transparent
syn region   mRoutineRef	contained start=/\^/ end=/[^[:alnum:]]/me=e-1 contains=mName
syn region   mExternRef	contained start=/&/ end=/[^[:alnum:].]/me=e-1 contains=mSubRef
syn match   mSubRef	contained /\^.\{-}[^[:alnum:]]/ contains=mRoutineRef nextgroup=mActualArgs
syn match   mSubRef	contained /[%[:alpha:]].\{-}[^[:alnum:]]/ contains=mLabel nextgroup=mActualArgs
syn region   mExtr	contained start=/\$\$/ end=/[^[:alnum:]%^]/me=e-1 contains=mTagRef nextgroup=mActualArgs
syn region  mLocal	contained start=/[%^[:alpha:]]/ end=/[^[:alnum:]]/me=e-1 contains=mName nextgroup=mSubs
syn case ignore
"

" Operators
syn match   mOperator	contained "[+\-*/=&#!'\\\]<>?@]"
syn match   mOperator	contained "]]"
syn region  mVRecord	contained start=/[= \t,]</lc=1 end=/>/ contains=mLocalName,","

" Constants
syn region  mString 	contained oneline start=/"/ skip=/""/ excludenl end=/"/ oneline contains=@Spell
syn match   mBadNum	contained /\<0\d\+\>/
syn match   mBadNum	contained /\<\d*\.\d*0\>/
syn match   mNumber	contained /\<\d*\.\d\+\>/
syn match   mNumber	contained /\<\d\+\>/

syn region  mParen	contained oneline start=/(/ end=/)/ contains=@mExpr
syn region  mSubs	contained oneline start=/(/ end=/)/ contains=@mExpr,","
syn region  mActualArgs	contained oneline start=/(/ end=/)/ contains=@mExpr,","

" note: case insensitivity is on, so we MUST use \u \l to match upper or lower case
" Mixed alpha / numeric: EA3LIB
syn match spellingException "\<\w*\d\+\w*\>"    transparent contained containedin=mComment,mString contains=@NoSpell
" All upper: ELIBIX
syn match spellingException "\<\u\+\>"          transparent contained containedin=mComment,mString contains=@NoSpell
" Starting with more than one upper: ADDme
syn match spellingException "\<\u\{2,}\w\+\>"   transparent contained containedin=mComment,mString contains=@NoSpell
" Mixed case with lower-case starting letter: libFn
syn match spellingException "\<\l\+\(\u\|\d\)\+\w*\>" transparent contained containedin=mComment,mString contains=@NoSpell
" Mixed case with upper-case starting letter: "NxtLibFnRou" but not "Dispay"
syn match spellingException "\<\u\+\(\l\|\d\)\+\u\w*\>" transparent contained containedin=mComment,mString contains=@NoSpell
" Ignore things like "*ARB", "$t", "%ZeLIBCM", "^glo"
syn match spellingException "[$*\^%][[:alnum:]]\+" transparent contained containedin=mComment,mString contains=@NoSpell
" Ignore things like "abc(" or "tag^" or "tag^routine"
syn match spellingException "\<\w\+("             transparent contained containedin=mComment,mString contains=@NoSpell
syn match spellingException "\<\w\+\^[[:alnum:]%]\+" transparent contained containedin=mComment,mString contains=@NoSpell

" Keyword definitions -------------------
"-- Commands: specialized for following arguments --
" Goto
syn keyword mGotoCommand	contained g goto
" Do
syn keyword mDoCommand	contained d do
"-- Commands: other ANSI-M compatible --
syn keyword mCommand	contained c close e else f for h halt hang
syn keyword mCommand	contained i if k kill l lock m merge n new q quit
syn keyword mCommand	contained r read s set
syn keyword mCommand	contained tc tcommit tre trestart tro trollback ts tstart
syn keyword mCommand	contained u use w write x xecute
"-- Commands: Implementation specific --
syn keyword mZCommand	contained b break j job o open v view
syn keyword mZCommand	contained za zallocate zb zbreak zd zdeallocate
syn keyword mZCommand	contained zp zprint zk zkill zw zwrite
"-- Commands: GT.M specific --
syn keyword mZCommand	contained zwr
syn keyword mZCommand	contained zcom zcompile zc zcontinue
syn keyword mZCommand	contained zed zedit zg zgoto zh zhelp zl zlink zm zmessage
syn keyword mZCommand	contained zsh zshow zst zstep zsy zsystem ztc ztcommit zts ztstart
syn keyword mZCommand	contained zwi zwithdraw

"-- Intrinsic Functions --
syn keyword mIntrFunc	contained a ascii c char d data e extract f find fn fnumber g get
syn keyword mIntrFunc	contained j justify l length na name n next o order p piece
syn keyword mIntrFunc	contained ql qlength qs qsubscript q query r random re reverse
syn keyword mIntrFunc	contained s select st stack t text tr translate
"-- Intrinsic Functions: Implementation specific --
syn keyword mIntrFunc	contained i increment v view zd zdate zs zsearch zp zprevious
"-- Intrinsic Functions: GT.M --
syn keyword mIntrFunc	contained zm zmessage zparse ztrnlnm
syn keyword mIntrFunc	contained zbitand zbitcount zbitfind zbitget
syn keyword mIntrFunc	contained zbitlen zbitnot zbitor zbitset
syn keyword mIntrFunc	contained zbitstr zbitxor zqgblmod
syn keyword mIntrFunc	contained za zascii zc zchar ze zextract zf zfind
syn keyword mIntrFunc	contained zj zjustify zl zlength zp zpiece ztr ztranslate
syn keyword mIntrFunc	contained zco zconvert zsub zsubstr zw zwidth
syn keyword mIntrFunc	contained zgetjpi zsigproc

"-- Special Variables --
syn keyword mSpecialVar	contained d device ec ecode es estack et etrap
syn keyword mSpecialVar	contained h horolog i io j job k key p principal
syn keyword mSpecialVar	contained q quit st stack s storage sy system t test
syn keyword mSpecialVar	contained tl tlevel tr trestart
syn keyword mSpecialVar	contained x y
"-- Special Variables: Implementation specific--
syn keyword mSpecialVar	contained za zb ze zerror zt ztrap zv zversion
"-- Special Variables: GT.M --
syn keyword mSpecialVar	contained r reference zcmd zcmdline zco zcompile zc zcstatus
syn keyword mSpecialVar	contained zda zdateform zd zdirectory zed zeditor zeo zeof
syn keyword mSpecialVar	contained zg zgbldir zint zinterrupt zini zininterrupt zio
syn keyword mSpecialVar	contained zj zjob zl zlevel zmaxtpti zmaxtptime zmo zmode
syn keyword mSpecialVar	contained zpos zposition zprom zprompt zro zroutines
syn keyword mSpecialVar	contained zso zsource zs zstatus zst zstep zsy zsystem
syn keyword mSpecialVar	contained zte ztexit zyer zyerror
syn keyword mSpecialVar	contained zal zallocstor zch zchset zda zdateform zpatn zpatnumeric
syn keyword mSpecialVar	contained zproc zprocess zq zquit zre zrealstor zus zusedstor

" The default methods for hilighting.  Can be overridden later
hi def link mGotoCommand	Statement
hi def link mDoCommand	Statement
hi def link mCommand	Statement
hi def link mZCommand	Statement
hi def link mIntrFunc	Statement
hi def link mSpecialVar	Statement
hi def link mLineStart	Statement
hi def link mLabel	Function
hi def link mTagRef	Function
hi def link mSubRef	Function
hi def link mExternRef   Function
hi def link mFormalArgs	PreProc
hi def link mDotLevel	PreProc
hi def link mCmdSeg	Special
hi def link mPostCond	Special
hi def link mCmd		Statement
hi def link mArgsSeg	Special
hi def link mExpr	PreProc
hi def link mVar		Identifier
hi def link mParen	Special
hi def link mSubs	Special
hi def link mActualArgs	Special
"Change mIntr to Special to not highlight the "$" in "$tr"
hi def link mIntr	Statement
hi def link mExtr	Function
hi def link mString	String
hi def link mNumber	Number
hi def link mOperator	Special
hi def link mComment	Comment
hi def link mError	Error
hi def link mBadNum	Error
hi def link mBadString	Error
hi def link mBadParen	Error
hi def link mParenError	Error
hi def link mTodo	Todo

let b:current_syntax = "mumps"
