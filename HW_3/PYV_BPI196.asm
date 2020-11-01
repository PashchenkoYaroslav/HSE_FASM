format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strNum            db 'Num = %u', 10, 0 ; num output message
        strResult         db 'Calculated successfully! Num = %u, I = %d', 10, 0 ; result output message

        num               dd 1
        i                 dd 1

        cumulativePow     dd 1
        constPow          dd 2
;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) algorithm
        call Calc
; 2) output result
        call OutputResult
finish:
        cinvoke getch ; wait to press key
        invoke ExitProcess, 0 ; kill program
;--------------------------------------------------------------------------
Calc:
        mov ecx, 1
        jmp calcLoop
calcLoop:
        mov [i], ecx

        mov eax, [cumulativePow]
        mov ebx, [constPow]
        mul ebx
        mov [cumulativePow], eax ; we calculates 2^i using temporary variable for previous values

        mov eax, [i]
        mov ebx, [cumulativePow]
        mul ebx
        sub eax, 1
        mov [num], eax ; we calculates new number by i * 2^i - 1

        mov eax, [num]
        add eax, 1
        jle endCalcLoop ; simple check for overflow

        call OutputNum

        mov ecx, [i]  ; do loop
        inc ecx
        jmp calcLoop
endCalcLoop:
        ret
;--------------------------------------------------------------------------
OutputNum:
        cinvoke printf, strNum, [num] ; printf num variable
        ret
;--------------------------------------------------------------------------
OutputResult:
        cinvoke printf, strResult, [num], [i] ; printf num and i variable
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
