org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A     ; new line macro


start:
    jmp main

;
; Prints a string to screen.
; Params:
;   - ds:si pointers to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interupt
    mov bh, 0x00        ; set page number to zero
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0           ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory
                        ; if we set stack at the end of OS, it would overwrite OS from end towards begining
    ; print message
    mov si, msg_hello
    call puts
    
    hlt

.halt:
    jmp .halt



msg_hello: db 'Hello world!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h