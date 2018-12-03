; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            CLR.B   (GENFRMCT)              ; CLEAR FRAME COUNTER
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ADDQ.B  #1,(GENFRMCT)           ; INCREASE FRAME COUNTER
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAGOVRI,STAATRI,STAVICI
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU,STAATRU,STAVICU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP,STAATRP,STAVICP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            IFNE    ATRSAVE
            JSR     ATRINIT                 ; ONLY IN ATTRACT RECORD MODE
            ENDC
            JSR     PLRINIT
            BRA     MAPINIT

; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            IFNE    ATRSAVE
            JSR     ATRUPD                  ; ONLY IN ATTRACT RECORD MODE
            ENDC
            TST.W   (PLRLIFE)               ; IS THE PLAYER ALIVE?
            BNE     .CONT                   ; YES: UPDATE EVERYTHING
            MOVE.W  #STAGOVR,(STANEXT)      ; NO: GO TO GAME OVER.
.CONT       JSR     PLRUPD
            JSR     AGLUPD
            BRA     MAPUPD

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     MAPPLOT
            JSR     AGLPLOT
            JSR     PLRPLOT
            IFNE    ATRSAVE
            JSR     ATRPLOT
            ENDC
            RTS

; -----------------------------------------------------------------------------
STAATRI
; ATTRACT MODE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            IFEQ    ATRSAVE
            JSR     ATRINIT                 ; ONLY IN ATTRACT PLAY MODE
            ENDC
            MOVE.B  #AUDMSKLP|AUDMU1ID,D1
            JSR     AUDPLAY                 ; PLAY ATTRACT MUSIC
            MOVE.B  #AUDACCN,(AUDACCSN)     ; REJECT SOUND EFFECTS
            JSR     PLRINIT
            JSR     MAPINIT
            MOVE.L  (A7)+,D1
            RTS

; -----------------------------------------------------------------------------
STAATRU
; ATTRACT MODE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            BTST    #KBDBITF1,(KBDEDGE)     ; CHECK USER INITIATED EXIT
            BNE     .EXIT
            IFEQ    ATRSAVE
            JSR     ATRUPD                  ; ONLY IN ATTRACT PLAY MODE
            ENDC
            BTST    #KBDBITF1,(KBDEDGE)     ; CHECK END OF RECORD
            BNE     .EXIT
            JSR     PLRUPD
            JSR     AGLUPD
            JSR     MAPUPD
            BRA     .END
.EXIT       MOVE.B  #AUDACCY,(AUDACCSN)     ; ALLOW NEW SOUNDS
            MOVE.B  #AUDENDID,D1            ; STOP MUSIC
            JSR     AUDPLAY
            MOVE.W  #STAINTR,(STANEXT)
.END        MOVE.L  (A7)+,D1
            RTS

; -----------------------------------------------------------------------------
STAATRP
; ATTRACT MODE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     STAPLAYP                ; PLOT GAME
            BRA     ATRPLOT                 ; OVERLAY TUTORIAL

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CMP.B   #$FF,(GENFRMCT)
            BNE     .CHKK
            MOVE.W  #STAATTR,(STANEXT)
            RTS
.CHKK       BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.L  D1,-(A7)
            MOVE.B  #AUDMSKNL|AUDFUNID,D1
            JSR     AUDPLAY                 ; PLAY START SOUND
            MOVE.L  (A7)+,D1
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP    EQU     INTPLOT
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR INTPLOT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAGOVRI
; GAME OVER STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            MOVE.B  #AUDMSKLP|AUDMU2ID,D1
            JSR     AUDPLAY                 ; PLAY GAME OVER MUSIC
            MOVE.L  (A7)+,D1
            BRA     GOVINIT

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            TST.W   (GOVCUROF)              ; ARE CURTAINS FULLY CLOSED?
            BMI     .WAIT                   ; YES: DO NOT MOVE THEM MORE
            JSR     GOVUPD                  ; MOVE CURTAINS
            RTS
.WAIT       BTST    #KBDBITF1,(KBDEDGE)     ; IF CLOSED, CHECK FIRE 1
            BEQ     .END                    ; NOT PRESSED: NOTHING
            MOVE.W  #STAINTR,(STANEXT)      ; PRESSED: GO TO INTRO STATE
            MOVE.B  #AUDENDID,D1            ; STOP MUSIC
            JSR     AUDPLAY
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     STAPLAYP                ; PLOT GAME
            BRA     GOVPLOT                 ; PLOT GAME OVER (CURTAIN)

; -----------------------------------------------------------------------------
STAVICI
; VICTORY STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            MOVE.B  #AUDMSKLP|AUDMU3ID,D1
            JSR     AUDPLAY                 ; PLAY VICTORY MUSIC
            MOVE.L  (A7)+,D1
            BRA     VICINIT

; -----------------------------------------------------------------------------
STAVICU
; VICTORY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            TST.W   (GOVCUROF)              ; ARE CURTAINS FULLY CLOSED?
            BMI     .WAIT                   ; YES: DO NOT MOVE THEM MORE
            JSR     VICUPD                  ; MOVE CURTAINS
            RTS
.WAIT       BTST    #KBDBITF1,(KBDEDGE)     ; IF CLOSED, CHECK FIRE 1
            BEQ     .END                    ; NOT PRESSED: NOTHING
            MOVE.W  #STAINTR,(STANEXT)      ; PRESSED: GO TO INTRO STATE
            MOVE.B  #AUDENDID,D1            ; STOP MUSIC
            JSR     AUDPLAY
.END        RTS

; -----------------------------------------------------------------------------
STAVICP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     STAPLAYP                ; PLOT GAME
            BRA     VICPLOT                 ; PLOT VICTORY (CURTAIN)
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
