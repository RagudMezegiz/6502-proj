; Print values of zero-page location addresses
.include "zeropage.inc"

.export _get_sp, _get_sreg, _get_regsave, _get_regbank
.export _get_ptr1, _get_ptr2, _get_ptr3, _get_ptr4
.export _get_tmp1, _get_tmp2, _get_tmp3, _get_tmp4

_get_sp:
    lda #sp
    ldx #0
    rts

_get_sreg:
    lda #sreg
    ldx #0
    rts

_get_regsave:
    lda #regsave
    ldx #0
    rts

_get_ptr1:
    lda #ptr1
    ldx #0
    rts

_get_ptr2:
    lda #ptr2
    ldx #0
    rts

_get_ptr3:
    lda #ptr3
    ldx #0
    rts

_get_ptr4:
    lda #ptr4
    ldx #0
    rts

_get_tmp1:
    lda #tmp1
    ldx #0
    rts

_get_tmp2:
    lda #tmp2
    ldx #0
    rts

_get_tmp3:
    lda #tmp3
    ldx #0
    rts

_get_tmp4:
    lda #tmp4
    ldx #0
    rts

_get_regbank:
    lda #regbank
    ldx #0
    rts
