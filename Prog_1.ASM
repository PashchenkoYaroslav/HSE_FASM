format PE console
entry start
 
include 'win32a.inc'
 
;======================================
section '.data' data readable writeable
;======================================
 
hello_newline    db "Hello World!",10,0
 
;=======================================
section '.code' code readable executable
;=======================================
 
start:
 
        ccall   [printf],hello_newline
        ccall   [getchar]
        stdcall [ExitProcess],0
 
;====================================
section '.idata' import data readable
;====================================
 
library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'
 
import  kernel,\
        ExitProcess,'ExitProcess'
 
import  msvcrt,\
        printf,'printf',\
        getchar,'_fgetchar'