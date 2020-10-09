format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'Vector size: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]: ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '[%d] = %d', 10, 0

        vec_size     dd 0
        new_vec_size dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 400
        new_vec      rd 400

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) decrease all numbers before first posititive by 5
        call Solve
; 4) vector out
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret

;--------------------------------------------------------------------------
Solve:
        xor ecx, ecx
        xor eax, eax ; FLAG FOR FIRST POSITIVE

        mov ebx, vec
        mov edx, new_vec
        jmp solveLoop
solveLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endSolveLoop
        mov [i], ecx

        jmp checkElement
checkElement:
        mov ecx, [new_vec_size]
        inc ecx
        mov [new_vec_size], ecx

        cmp eax, 0
        jg newElement

        mov ecx, [ebx]
        cmp ecx, 0

        jg flagSet
        jmp newFlaggedElement
flagSet:
        inc eax
        jmp newElement
newFlaggedElement:
        mov ecx, [ebx]
        sub ecx, 5
        mov [edx], ecx
        add edx, 4

        jmp endCheckElement
newElement:
        mov ecx, [ebx]
        mov [edx], ecx
        add edx, 4

        jmp endCheckElement
endCheckElement:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp solveLoop
endSolveLoop:
        ret

;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, new_vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [new_vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'