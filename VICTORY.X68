; =============================================================================
; VICTORY MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
VICINIT     EQU     GOVINIT
; INITIALIZES THE VICTORY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - USES THE SAME CODE AND VARIABLES THAT GAME OVER. SO, VICINIT
;            IS JUST A PLACEHOLDER FOR GOVINIT.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
VICUPD      EQU     GOVUPD
; UPDATES THE VICTORY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - USES THE SAME CODE AND VARIABLES THAT GAME OVER. SO, VICUPD
;            IS JUST A PLACEHOLDER FOR GOVUPD.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
VICPLOT
; PLOTS THE VICTORY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D7/A0,-(A7)
            MOVE.L  #$00020000,D7
            MOVE.W  (GOVCUROF),D7
            JSR     GENCURT
            TST.W   (GOVCUROF)
            BPL     .END
            LEA     STRBLKVI,A0
            JSR     GENFPLOT
.END        MOVEM.L (A7)+,D7/A0
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
