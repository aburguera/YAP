; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #PLRXINI,(PLRPOSX)      ; INITIAL X
            MOVE.L  #PLRYINI<<16,(PLRPOSY)  ; INITIAL Y CONVERTED TO FIX. PNT.
            CLR.L   (PLRSPDY)               ; INITIAL Y SPEED
            MOVE.W  #PLRFACER,(PLRFACE)     ; LOOKING RIGHT
            MOVE.W  #PLRXSPD,(PLRSPDX)      ; X SPEED WHEN MOVING
            MOVE.L  #PLRFACEL<<16+PLRFACER,(PLRFRMS) ; PREPARE GRAPHIC FRAME DATA
            CLR.B   (PLRMOT)                ; NO DESIRED MOTION
            MOVE.W  #PLRLIFEI,(PLRLIFE)     ; INITIAL LIFE
            MOVE.B  #$FF,(PLRTYPE)          ; FIXED TYPE
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/D5/D6/A2,-(A7)
            LEA     PLRDBLK,A2              ; GET PLAYER DATA BLOCK
            MOVE.B  (KBDVAL),D0             ; PREPARE MOTION COMMAND BY
            AND.B   #(KBDMSKLF+KBDMSKRT),D0 ; USING LEFT AND RIGHT FROM KBDVAL
            OR.B    (KBDEDGE),D0            ; AND UP FROM KBDEDGE.
            MOVE.B  D0,(PLRMOT)
            JSR     AGNGRAV                 ; UPDATE GRAVITY
            JSR     AGNMOVE                 ; MOVE HORIZONTALLY
            MOVE.B  (GENFRMCT),D0           ; INCREASE LIFE EVERY 16 CYCLES
            AND.B   #$07,D0
            BNE     .END
            MOVE.W  #1,D0
            JSR     PLRADDLF
            MOVE.W  (PLRPOSX),D5
            MOVE.W  (PLRPOSY),D6
            ADD.W   #AGNWIDTH/2, D5
            ADD.W   #AGNHEIGH/2,D6
            JSR     MAPGTCOD                ; PLAYER TOUCHES DAMAGING BLOCK?
            CMP.B   #MAPDMG,D7
            BNE     .END
            MOVE.W  #-ENMDMG,D0             ; YES: DAMAGE
            JSR     PLRADDLF
.END        MOVEM.L (A7)+,D0/D5/D6/A2
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER AND ITS LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D4/A2,-(A7)

            CMP.W   #PLRKILSP,(PLRSPDY)     ; CHECK VERTICAL SPEED
            BLT     .NOAURA                 ; BELOW LETHAL SPEED? CONTINUE
            MOVE.L  #$000000FF,D1           ; OTHERWISE  PLOT AURA.
            MOVE.B  #80,D0                  ; FIRST SET COLORS TO RED
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15

            MOVE.W  (PLRPOSX),D1            ; COMPUTE AURA COORDINATES
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            SUBQ.W  #AGNBBXO*2,D1
            SUB.W   #AGNBBYO*3,D2
            ADD.W   #AGNWIDTH+AGNBBXO,D3
            ADD.W   #AGNHEIGH+AGNBBYO*2,D4
            MOVE.B  #88,D0
            TRAP    #15                     ; PLOT THE AURA

.NOAURA     LEA     PLRDBLK,A2              ; GET AGENT POINTER
            JSR     AGNPLOT                 ; PLOT THE AGENT

            CLR.L   D1                      ; SET INITIAL PEN AND FILL COLORS
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #PLRSCOCP,D1
            ADDQ.B  #1,D0
            TRAP    #15

            MOVE.W  #SCRHEIGH-PLRSCORH*2+PLRSCORH/2,D2 ; DYNAMICALLY COMPUTE LIFE BAR
            CMP.W   #SCRHEIGH/2,(PLRPOSY)   ; Y POSITION
            BLT     .CONT                   ; DECIDE IF BAR ON TOP OR BOTTOM
            MOVE.W  #PLRSCORH-PLRSCORH/2,D2
.CONT       MOVE.W  D2,D4
            ADD.W   #PLRSCORH,D4
            MOVE.B  #92,D0                  ; SET TRANSPARENT MODE (OR)
            MOVE.B  #10,D1
            TRAP    #15
            MOVE.W  #(SCRWIDTH-PLRSCORW)/2,D1
            MOVE.W  #(SCRWIDTH+PLRSCORW)/2,D3
            MOVE.B  #87,D0                  ; DRAW OUTER BAR
            TRAP    #15
            MOVE.B  #92,D0                  ; RETURN TO NORMAL MODE
            MOVE.B  #4,D1
            TRAP    #15
            MOVE.L  #PLRSCOCF,D1            ; DEFINE LIFE COLORS
            MOVE.B  #81,D0
            TRAP    #15
            CLR.L   D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  #SCRWIDTH/2,D1          ; PLOT LIFE
            MOVE.W  (PLRLIFE),D3
            ASR.W   #1,D3
            SUB.W   D3,D1
            ADD.W   #SCRWIDTH/2,D3
            MOVE.B  #87,D0
            TRAP    #15

            MOVEM.L  (A7)+,D0-D4/A2
            RTS


; -----------------------------------------------------------------------------
PLRADDLF
; ADDS/SUBSTRACTS LIFE TO THE PLAYER
; INPUT    - D0.W   AMOUNT TO ADD/SUBSTRACT
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST    #15,D0                  ; IS IT NEGATIVE?
            BEQ     .CONT                   ; NO: OK
            MOVE.W  D1,-(A7)
            MOVE.B  #AUDMSKNL|AUDWOAID,D1   ; DAMAGE SOUND EFFECT
            JSR     AUDPLAY
            MOVE.W  (A7)+,D1
.CONT       ADD.W   D0,(PLRLIFE)
            CMP.W   #PLRLIFEI,(PLRLIFE)
            BGE     .TOMAX
            BTST    #15,(PLRLIFE)
            BNE     .TOMIN
            RTS
.TOMAX      MOVE.W  #PLRLIFEI,(PLRLIFE)
            RTS
.TOMIN      CLR.W   (PLRLIFE)
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
