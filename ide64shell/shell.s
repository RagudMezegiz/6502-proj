; Shell program
; Options:
;   X: convert decimal number to hexadecimal and print.
;        16-bit unsigned integer is assumed.  Overflow is
;        neither checked nor handled.
;   D: convert hexadecimal number to decimal and print.
;        16-bit unsigned integer is assumed.  Overflow is
;        neither checked nor handled.
.include "c64.inc"
.include "cbm_kernal.inc"
.include "zeropage.inc"

LASTF = $FF
WARMST := $E37B

; Start routine - get first character of shell comand
    ldy #0
    lda (TXTPTR),Y
    cmp #'x'        ; if command is 'x', print hex conversion of decimal number
    beq hex_convert
    cmp #'d'        ; if command is 'd', print decimal conversion of hex number
    beq dec_convert
done:
    lda LASTF
    sta DEVNUM
    jmp WARMST

; Decimal to hex conversion routine
hex_convert:
    iny             ; skip any spaces between the X and the number
    lda (TXTPTR),Y
    beq done
    cmp #' '
    beq hex_convert
    jsr dec2bin     ; convert from decimal to binary in ptr1
    ldy #0
    ldx ptr1+1
    lda ptr1
    jsr hex_out     ; print hexadecimal to output
    jmp done

; Hex to decimal conversion routine
dec_convert:
    iny             ; skip any spaces between the D and number
    lda (TXTPTR),Y
    beq done
    cmp #' '
    beq dec_convert
    jsr hex2bin     ; convert from hexadecimal to binary in ptr1
    ldx ptr1+1
    lda ptr1
    jsr bin2bcd     ; convert from binary to BCD
    jsr hex_out     ; print to output
    jmp done

; ASCII decimal to binary conversion routine
; Input: (TXTPTR),Y points to first character of ASCII number in decimal format
; Output: ptr1 contains 2-byte binary number
dec2bin:
    lda #0      ; zero out the result
    sta ptr1
    sta ptr1+1
@next_digit:
    lda (TXTPTR),Y  ; load digit
    beq dec_return  ; null terminator - done
    ldx #0
    lda #10
    jsr mul_16x16   ; multiply by 10
    lda (TXTPTR),Y  ; re-load digit, since multiply killed accumulator
    and #$0F        ; mask off ASCII bits
    clc
    adc ptr1        ; add
    sta ptr1
    lda ptr1+1
    adc #0
    sta ptr1+1
    iny
    jmp @next_digit
dec_return:
    rts

; ASCII hex to binary conversion routine
; Input: (TXTPTR),Y points to first character of ASCII number in hex format
; Output: ptr1 contains 2-byte binary number
hex2bin:
    lda #0      ; zero out the result
    sta ptr1
    sta ptr1+1
@next_digit:
    lda (TXTPTR),Y  ; load digit
    beq hex_return  ; null terminator - done
    ldx #0
    lda #16
    jsr mul_16x16   ; multiply by 16
    lda (TXTPTR),Y  ; reload digit, since multiply killed accumulator
    cmp #'9'        ; handle A-F input
    beq :+
    bcc :+
    sbc #7
:   and #$0F        ; mask off ASCII
    clc
    adc ptr1        ; add
    sta ptr1
    lda ptr1+1
    adc #0
    sta ptr1+1
    iny
    jmp @next_digit
hex_return:
    rts

; Binary to BCD conversion routine
; Input: A:X contains 2-byte binary number
; Output: A:X:Y contains 3-byte BCD number
bin2bcd:
    sta ptr1    ; save input in ptr1
    stx ptr1+1
    lda #0      ; zero temp holding area
    sta tmp1
    sta tmp2
    sta tmp3
    php         ; save processor status (for decimal mode flag)
    sed         ; set decimal
    ldx #16     ; 16-bits of input
    ; shift input left 1
:   asl ptr1
    rol ptr1+1
    ; Multiply output by 2 by adding it to itself.
    ; The carry bit from the shift is also added to the low byte,
    ; which will accumulate the result.
    lda tmp1
    adc tmp1
    sta tmp1
    lda tmp2
    adc tmp2
    sta tmp2
    lda tmp3
    adc tmp3
    sta tmp3
    dex
    bne :-
    plp         ; restore processor status (former decimal mode flag)
    lda tmp1    ; move from temp to output
    ldx tmp2
    ldy tmp3
    rts

; Print hexadecimal output
; Input: A:X:Y contains 3-byte number.  Printing of Y is skipped
;          if it is zero.
; Output: none
hex_out:
    pha         ; save A
    tya         ; highest byte
    beq :+      ; skip printing
    jsr print_a
:   txa         ; middle byte
    jsr print_a
    pla         ; lo byte
    jsr print_a
    lda #$0D
    jsr CHROUT
    rts

; Print the accumulator as a two-digit hex number.
; If the number is in BCD format, it will print correctly
; as a decimal number.
print_a:
    pha         ; save original value
    lsr         ; shift high nibble to low
    lsr
    lsr
    lsr
    jsr xdigit
    jsr CHROUT
    pla         ; restore original value
    and #$0F    ; mask off high nibble
    jsr xdigit
    jsr CHROUT
    rts
    
; Convert a single-digit binary number to its ASCII equivalent in hex.
xdigit:
    ora #$30
    cmp #'9'
    beq :+
    bcc :+
    adc #6
:   rts

; Multiplication of ptr1 by X:A.
; Inputs: ptr1 contains 16-bit number, A:X contains lo:hi byte of second number
; Outputs: ptr1 contains same number multiplied by A:X
; Mangles: A, X, ptr2, ptr3
mul_16x16:
    sta ptr3    ; store A:X in ptr3
    stx ptr3+1
    lda ptr1    ; copy ptr1 to ptr2
    sta ptr2
    lda ptr1+1
    sta ptr2+1
    lda #0      ; zero result
    sta ptr1
    sta ptr1+1
    
    ; Performing 16 shift-add combinations - 1 per bit in result
    ; If ptr3 low bit is set, add ptr2 to result
    ldx #16
:   lsr ptr3+1  ; shift ptr3 right one
    ror ptr3    ; lsb in carry
    bcc :+      ; skip the add
    lda ptr1
    clc
    adc ptr2
    sta ptr1
    lda ptr1+1
    adc ptr2+1
    sta ptr1+1
:   asl ptr2    ; shift ptr2 left one
    rol ptr2+1
    dex
    bne :--
    rts
    
