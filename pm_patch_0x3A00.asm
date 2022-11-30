START_INIT: equ $7200
START_PERSIST_CODE: equ $E700
HANGUL_FONT_PASTE: equ $580
HANGUL_FONT_NEW: equ $EA60
CONVCODE_TABLE: equ $CAC0

; READ_FROM_DISK function
; -----------------------
; READ_SECTOR_IDX : sector number to read
; READ_SECTOR_CNT : number of sectors to read
; DE register : address to write data read from disk
READ_SECTOR_IDX: equ $2311
READ_SECTOR_CNT: equ $2313
READ_FROM_DISK: equ $2171


; This code should be inserted to offset 0x2200 in disk 6
; 무 투 회 : 0x3A00 ~ 0x5600 in disk 6 will be loaded to memory address 0x7200.
INIT:
    org START_INIT
    db $4F,$4C,$50,$00,$01,$00,$08,$72
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    ; copy data
    ld bc, $200
    ld hl, HANGUL_FONT_DATA
    ld de, HANGUL_FONT_PASTE
    ldir
    ld bc, CONVCODE_TABLE_DATA - HANGUL_FONT_DATA - $200
    ld hl, HANGUL_FONT_DATA + $200
    ld de, HANGUL_FONT_NEW
    ldir
    ld bc, END - START_PERSIST_CODE
    ld hl, PROLOGUE
    ld de, START_PERSIST_CODE
    ldir
    ld bc, PROLOGUE - CONVCODE_TABLE_DATA
    ld hl, CONVCODE_TABLE_DATA
    ld de, CONVCODE_TABLE
    ldir
    ; patch code (hook)
    ld ix, $2A41
    ld de, HOOK_2A41
    ld (ix), $C3
    ld (ix+1), de
;    ld ix, $2F20
;    ld de, HOOK_2F20
;    ld (ix), $C3
;    ld (ix+1), de
    ld ix, $3DD8
    ld de, HOOK_3DD8
    ld (ix), $C3
    ld (ix+1), de
    ld ix, $71A9
    ld de, EPILOGUE_71A9
    ld (ix), $C3
    ld (ix+1), de

    ; patch code (direct)
    ld hl, $2F2C
    ld (hl), $95
    ld hl, $2F33
    ld (hl), $FF

    ; jump to PROLOGUE
    jp START_PERSIST_CODE




HANGUL_FONT_DATA:
    db $FE,$02,$02,$02,$00,$00,$00,$00,$00,$FE,$00,$00
    db $02,$82,$82,$82,$83,$82,$82,$82,$82,$FA,$02,$00
    db $80,$80,$80,$FE,$00,$00,$00,$10,$10,$FE,$00,$00
    db $02,$82,$82,$82,$82,$82,$82,$82,$82,$FA,$02,$00
    db $02,$FA,$82,$82,$83,$82,$82,$82,$82,$FA,$02,$00
    db $FE,$80,$80,$FE,$00,$00,$00,$10,$10,$FE,$00,$00
    db $FE,$80,$80,$FE,$00,$10,$FE,$80,$80,$80,$80,$FE
    db $FE,$80,$80,$FE,$00,$00,$00,$00,$00,$FE,$00,$00
    db $02,$F2,$12,$12,$13,$F2,$82,$82,$82,$F2,$02,$00
    db $F2,$12,$F2,$83,$82,$F2,$00,$80,$80,$80,$80,$FE
    db $05,$F5,$15,$15,$1D,$F5,$85,$85,$85,$F5,$05,$00
    db $FE,$02,$FE,$80,$FE,$00,$00,$10,$10,$FE,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$70,$D8,$D8,$70
    db $1E,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
    db $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$78
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$60,$30
    db $00,$00,$00,$00,$00,$00,$18,$18,$00,$00,$00,$00
    db $FE,$02,$FE,$80,$FE,$10,$FE,$80,$80,$80,$80,$FE
    db $FE,$02,$FE,$80,$FE,$00,$FE,$10,$10,$10,$10,$00
    db $FE,$02,$FE,$80,$FE,$00,$00,$00,$00,$FE,$00,$00
    db $02,$F2,$12,$12,$12,$F2,$82,$82,$82,$F2,$02,$00
    db $F2,$12,$F2,$82,$82,$F2,$00,$80,$80,$80,$80,$FE
    db $F2,$12,$F2,$82,$82,$F2,$00,$7C,$82,$82,$82,$7C
    db $F2,$92,$92,$93,$92,$F2,$00,$80,$80,$80,$80,$FE
    db $FE,$82,$82,$FE,$00,$FE,$10,$80,$80,$80,$80,$FE
    db $02,$F2,$92,$92,$92,$92,$92,$92,$92,$F2,$02,$00
    db $F2,$92,$92,$92,$92,$F2,$00,$80,$80,$80,$80,$FE
    db $02,$92,$92,$92,$93,$F2,$92,$92,$92,$F2,$02,$00
    db $92,$92,$F2,$96,$92,$F2,$00,$FE,$02,$FE,$80,$FE
    db $05,$95,$95,$95,$9D,$F5,$95,$95,$95,$F5,$05,$00
    db $82,$FE,$82,$FE,$00,$00,$00,$10,$10,$FE,$00,$00
    db $82,$FE,$82,$FE,$00,$10,$FE,$80,$80,$80,$80,$FE
    db $82,$FE,$82,$FE,$00,$FE,$00,$FE,$02,$FE,$80,$FE
    db $02,$92,$92,$92,$92,$F2,$92,$92,$92,$F2,$02,$00
    db $02,$22,$22,$22,$23,$22,$22,$52,$8A,$8A,$02,$00
    db $05,$25,$25,$25,$2D,$25,$25,$55,$8D,$8D,$05,$00
    db $10,$10,$28,$C6,$00,$00,$00,$00,$00,$FE,$00,$00
    db $02,$22,$22,$22,$22,$22,$22,$52,$8A,$8A,$02,$00
    db $22,$22,$22,$22,$52,$8A,$00,$FE,$02,$FE,$80,$FE
    db $02,$62,$92,$92,$93,$92,$92,$92,$92,$62,$02,$00
    db $62,$92,$92,$93,$92,$62,$00,$FE,$02,$FE,$80,$FE
    db $05,$65,$95,$95,$97,$95,$95,$95,$95,$65,$05,$00, $00,$00,$00,$00,$00,$00,$00,$00
    db $05,$65,$95,$95,$9D,$95,$95,$95,$95,$65,$05,$00
    db $62,$92,$92,$62,$02,$02,$43,$42,$42,$FE,$02,$00
    db $7C,$82,$82,$7C,$00,$00,$FE,$28,$28,$28,$28,$00
    db $02,$62,$92,$92,$92,$92,$92,$92,$92,$62,$02,$00
    db $62,$92,$92,$92,$92,$62,$00,$80,$80,$80,$80,$FE
    db $02,$FA,$22,$22,$23,$22,$22,$52,$8A,$8A,$02,$00
    db $05,$FD,$25,$25,$2D,$25,$25,$55,$8D,$8D,$05,$00
    db $02,$72,$FA,$22,$26,$22,$22,$52,$52,$8A,$02,$00
    db $10,$FE,$28,$C6,$00,$00,$00,$00,$00,$FE,$00,$00
    db $02,$F2,$12,$12,$13,$F2,$12,$12,$22,$C2,$02,$00
    db $02,$F2,$12,$13,$12,$F3,$12,$12,$22,$C2,$02,$00
    db $FE,$02,$FE,$02,$00,$00,$00,$10,$10,$FE,$00,$00
    db $FE,$02,$FE,$02,$00,$00,$FE,$10,$10,$10,$10,$00
    db $FE,$02,$FE,$02,$00,$00,$00,$00,$00,$FE,$00,$00
    db $FE,$02,$FE,$02,$00,$FE,$00,$FE,$02,$FE,$80,$FE
    db $02,$F2,$12,$12,$12,$F2,$12,$12,$22,$C2,$02,$00
    db $F2,$12,$F2,$12,$22,$C2,$00,$80,$80,$80,$80,$FE
    db $02,$F2,$82,$82,$83,$F2,$82,$82,$82,$F2,$02,$00
    db $02,$F2,$82,$82,$86,$F2,$82,$82,$82,$F2,$02,$00
    db $F2,$82,$E2,$86,$82,$F2,$00,$80,$80,$80,$80,$FE
    db $FE,$80,$FC,$80,$FE,$00,$00,$00,$00,$FE,$00,$00
    db $02,$FA,$52,$52,$53,$52,$52,$52,$52,$FA,$02,$00
    db $05,$FD,$55,$55,$5D,$55,$55,$55,$55,$FD,$05,$00
    db $FD,$55,$55,$5D,$55,$FD,$00,$80,$80,$80,$80,$FE
    db $02,$62,$F2,$62,$93,$92,$92,$92,$92,$62,$02,$00
    db $05,$65,$F5,$65,$9D,$95,$95,$95,$95,$65,$05,$00
    db $02,$62,$F2,$62,$92,$92,$92,$92,$92,$62,$02,$00

CONVCODE_TABLE_DATA:
    db $89,$76,$8A,$49,$8A,$8B,$8A,$CD,$8A,$D7,$8B,$54,$8B,$56,$8B,$85
    db $8B,$F1,$8B,$F3,$8C,$58,$8C,$6D,$8C,$6E,$8C,$6E,$8C,$6E,$8C,$6E
    db $8C,$6E,$8C,$6F,$8C,$87,$8C,$A1,$8C,$AC,$8C,$AE,$8C,$B3,$8C,$B6
    db $8D,$4D,$8D,$6B,$8D,$6D,$8D,$78,$8D,$9A,$8D,$A1,$8D,$B6,$8D,$B9
    db $8D,$BA,$8D,$EF,$8E,$87,$8E,$BA,$8F,$59,$8F,$62,$8F,$66,$8F,$C4
    db $8F,$C9,$8F,$D4,$90,$40,$90,$6C,$90,$AD,$90,$CA,$90,$CC,$90,$D8
    db $91,$45,$92,$52,$92,$97,$92,$A9,$92,$BA,$92,$D8,$92,$EB,$93,$48
    db $93,$4B,$93,$4F,$93,$51,$93,$57,$93,$6C,$93,$6E,$93,$AC,$93,$C2
    db $93,$E2,$93,$E4,$94,$6E,$94,$8C,$94,$F5,$FF,$FF




; Restore the original code and jump to it
PROLOGUE:
    org START_PERSIST_CODE
    ld hl, READ_SECTOR_IDX
    ld de, $4D8
    ld (hl), de
    ld hl, READ_SECTOR_CNT
    ld de, $0E
    ld (hl), de
    ld de, START_INIT
    call READ_FROM_DISK
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    jp START_INIT + 8 ; entrypoint offset

HOOK_2A41:
    cp $80
    jp c, $2A47
    cp $BF
    jr nc, FONT_NEW
    sub $15
    jp $2A47
FONT_NEW:
    sub $BF
    ld l, $0C
    call $2068 ; f(){ hl = a * l }
    ld de, HANGUL_FONT_NEW
    add hl, de
    ld de, $0C23
    ld bc, $0C
    ldir
    ret

;HOOK_2F20:
;    ld b, $00
;    cp $20
;    jr c, END_2F20
;    inc b
;END_2F20:
;    ld a, b
;    ld ($2FF8), a
;    ret

HOOK_3DD8:
    ld a, $FF
    ld de, hl
    push ix
    ld ix, CONVCODE_TABLE
LOOP_3DD8:
    inc a
    ld h, (ix)
    ld l, (ix+1)
    inc ix
    inc ix
    sub hl, de
    jr c, LOOP_3DD8
    add a, $95
    ld (iy), a
    inc iy
    pop ix
    jp $3DED

EPILOGUE_71A9:
    push af
    push bc
    push de
    push hl
    push ix
    push iy

    ; restore font
    ld hl, READ_SECTOR_IDX
    ld de, $4C0
    ld (hl), de
    ld hl, READ_SECTOR_CNT
    ld de, $04
    ld (hl), de
    ld de, $0100
    call READ_FROM_DISK

    ; restore code (hook)
    ld ix, $2A41
    ld (ix), $D6
    ld (ix+1), $20
    ld (ix+2), $FE

    ld ix, $3DD8
    ld (ix), $11
    ld (ix+1), $40
    ld (ix+2), $83

    ld ix, $71A9
    ld (ix), $3E
    ld (ix+1), $0D
    ld (ix+2), $0E

    ; restore code (direct)
    ld hl, $2F2C
    ld (hl), $A0
    ld hl, $2F33
    ld (hl), $E0

    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ld a, $0D
    ld c, $01
    jp $71AD
END: