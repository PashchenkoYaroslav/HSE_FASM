format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
      resStr db 'Result of xor operation equals  : %d',0

      NULL = 0
section '.code' code readable executable
start:
        mov eax, 1101b
        xor eax,1000b
        push eax
        push resStr
        call [printf]
        call[getch]
        push NULL
        call[ExitProcess]

section '.idata'import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
        import kernel,\
               ExitProcess, 'ExitProcess'
        import msvcrt,\
               printf, 'printf',\
               getch,'_getch',\
               scanf,'scanf'