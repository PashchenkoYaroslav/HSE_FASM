format PE console 4.0
entry start
 
include 'win32ax.inc'
 
section '.text' code readable executable
 
  start:
    cinvoke printf, aszPrompt
    cinvoke scanf, scanfmt, x
    mov eax,    [x]
    cmp eax,    0
    jns @@2
@@1:
    imul    eax
    neg eax
    jmp @@3
@@2:
 
@@3:
    cinvoke printf, aszFmt, [x], eax
    cinvoke printf, aszPressEnter
    invoke  _getch
    invoke  ExitProcess, 0
 
section '.data' data readable writeable
    aszFmt      db  'F(%d)=%d', 0Dh, 0Ah, 0
    aszPrompt   db  'Input x: ', 0
    scanfmt     db  '%d',0
    aszPressEnter   db  0Dh, 0Ah, 0Dh, 0Ah, "Press any key to exit", 0

section '.bss' readable writeable
    Buffer      db  1024 dup(?)
    BufLen      dd  ?
    x       dd  ?
 
section '.idata' import data readable writeable
 
    library kernel32,'KERNEL32.DLL',\
        user32,'USER32.DLL',\
        msvcrt, 'msvcrt.dll'
 
    include 'api\kernel32.inc'
    include 'api\user32.inc'
    import  msvcrt,\
        printf, 'printf',\
        scanf,  'scanf',\
        _getch,'_getch'