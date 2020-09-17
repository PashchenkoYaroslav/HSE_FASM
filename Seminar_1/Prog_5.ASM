format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        formatStr db '%s', 0
        formatNum db '%s', 0

        name rd 2

        wn db 'What is your name? ',0
        hi db 'Nice to meet you, %s!', 0
        NULL=0

section '.code' code readable executable
start:
        push wn
        call[printf]

        push name
        push formatStr
        call[scanf]

        push name
        push hi
        call[printf]
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