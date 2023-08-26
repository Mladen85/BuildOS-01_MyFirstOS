org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A     ; new line macro


;
; FAT12 header (https://wiki.osdev.org/FAT)
;
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'   ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880         ; 2880 * 512 = 1440k
bdb_media_descriptor_type:  db 0F0h         ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9            ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0            ; 0x00 floppy, 0x80 hdd
                            db 0            ; reserved
ebr_signature:              db 29
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter, 4 bytes
ebr_volume_label:           db 'My OS      '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '   ; 8 bytes, padded with spaces

;
; Code goes here
;

start:
    jmp main


;
; Prints a string to the screen
; Params:
;   - ds:si pointers to string
;
puts:
    ; save registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
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

    ; read something from floppy disk
    ; BIOS should set dl to drive number
    mov [ebr_drive_number], dl

    mov ax, 1           ; LBA = 1, second sector from disk
    mov cl, 1           ; 1 sector to read
    mov bx, 0x7E00      ; data should be after the bootloader
    call disk_read

    ; print hello world message
    mov si, msg_hello
    call puts

    cli                         ; disable interrupts, this way CPU can't get out of "halt" state
    hlt


;
; Error handlers
;

floppy_error:
    mov si, msg_read_failed
    call puts
    jmp wait_key_and_reboot

wait_key_and_reboot:
    mov ah, 0
    int 16h                             ; wait for key press
    jmp 0FFFFh:0                        ; jump to beginning of BIOS, should reboot

.halt:
    cli                                 ; disable interrupts, this way CPU can't get out of "halt" state
    halt


;
; Disk routines
;

;
; Converts an LBA address to a CHSaddress
; Parameters:
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5 ]: sector number
;   - cx [bits 6-15]:  cylinder
;   - dh: head
;

lba_to_chs:

    push ax
    push dx

    xor dx, dx          ; dx = 0
    div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack

    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx          ; dx = 0
    div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dl = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6                           ; 
    or cl, ah                           ; put upper 2 bits of cylinder in cl

    pop ax
    mov dl, al                          ; restore dl
    pop ax
    ret


;
; Reads sectors from disk
; Parameters:
;   - ax: LBA address
;   - cl: number of sectors to read (up to 128)
;   - dl: drive number
;   - es:bx: memory address where to store read data
;
disk_read:

    push ax                             ; save registers we will modify
    push bx
    push cx
    push dx
    push di

    push cx                             ; temporarily save cl (number of sectors to read)
    call lba_to_chs                     ; compute CHS
    pop ax                              ; al = number of sectors to read

    mov ah, 02h
    ; documentation for floppy disk recomend ro read three times since
    ;   floppy disks are unreliable
    mov di, 3                           ; retry count

.retry:
    pusha                               ; save all registers, we don't know what BIOS modifies
    stc                                 ; set carry flag,some BIOS'es don't set it
    int 13h                             ; (call interupt 13h) carry flag cleard = success
    jnc .done                           ; jump if carry flag not set
    
    ; read failed
    popa                                ; restore all registers
    call disk_reset                     ; restore floppy controler

    dec di                              ; decrement count
    test di, di
    jnz .retry                          ; if di is not zero (jump not zero)

.fail:
    ; all attempts are exhausted
    jmp floppy_error

.done:
    popa

    pop di                             ; restore registers after disk_read
    pop dx
    pop cx
    pop bx
    pop ax
    ret


;
; Resets disk controller
; Parameters:
;   - dl: drive number
;
disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc floppy_error
    popa
    ret


msg_hello:              db 'Hello world!', ENDL, 0
msg_read_failed:        db 'Read from disk failed!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
