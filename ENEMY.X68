; =============================================================================
; ENEMY MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
ENMINIT
; INITIALIZES THE ENEMY
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
;            D1.L HIGH 16 BITS SPEED X. LOW 16 BITS INITIAL X
;            D2.W INITIAL Y
;            D3.L HIGH 16 BIT TYPE, LOW 16 BITS BASE FRAME
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D4,-(A7)
            MOVE.W  D3,AGNFRAOF(A0)         ; STORE BASE FRAME
            CLR.L   D4                      ; THE BASE FRAME IS STORED TWICE
            MOVE.W  D3,D4                   ; WITHIN D4 TO BUILD THE FRAMES FOR
            SWAP    D4                      ; LEFT AND RIGHT LONG, SINCE ENEMS
            MOVE.W  D3,D4                   ; HAVE THE SAME FRAME FOR BOTH.
            MOVE.L  D4,AGNFRMOF(A0)         ; STORE THE LEFT/RIGHT FRAMES LONG
            MOVE.W  D1,AGNPOXOF(A0)         ; WRITE INITIAL X
            MOVE.W  D2,AGNPOYOF(A0)         ; WRITE INTEGER PART OF INITIAL Y
            CLR.W   AGNPOYOF+2(A0)          ; SET DECIMAL PART OF YINI TO 0
            CLR.L   AGNSPYOF(A0)            ; SET INITIAL Y SPEED TO ZERO
            SWAP    D3                      ; PREPARE TYPE
            MOVE.B  D3,AGNTYPOF(A0)         ; STORE TYPE
            CLR.B   AGNMOTOF(A0)            ; TENTATIVELY PUT NO MOTION
            TST.B   D3                      ; CHECK TYPE
            BNE     .CONT                   ; TYPE !=0: ACCEPT MOTION
            MOVE.B  #KBDMSKLF,AGNMOTOF(A0)  ; TYPE ==0: MOTION LEFT
.CONT       SWAP    D3                      ; RESTORE D3
            SWAP    D1                      ; PREPARE X SPEED
            MOVE.W  D1,AGNSPXOF(A0)         ; STORE X SPEED
            SWAP    D1                      ; RESTORE D1
            MOVE.L  (A7)+,D4
            RTS

; -----------------------------------------------------------------------------
ENMUPD
; UPDATES THE ENEMY MOTION
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0/D7/A2,-(A7)
            MOVE.L  A0,A2                   ; PREPARE AGENT DATA BLOCK
            JSR     AGNGRAV                 ; UPDATE GRAVITY
            JSR     AGNMOVE                 ; UPDATE MOTION
            JSR     ENMPLCOL                ; CHECK COLLISION

            MOVE.B  AGNTYPOF(A0),D0         ; SWITCH DEPENDING ON THE TYPE
            SUBQ.B  #1,D0                   ; CHECK TYPE 1
            BEQ     .TYPE1                  ; GO IF TRUE
            SUBQ.B  #1,D0                   ; CHECK TYPE 2
            BEQ     .TYPE2                  ; GO IF TRUE
            SUBQ.B  #1,D0                   ; CHECK TYPE 3
            BEQ     .TYPE3                  ; GO IF TRUE.
            SUBQ.B  #1,D0                   ; CHECK TYPE 4
            BEQ     .TYPE4                  ; GO IF TRUE. TYPE 0 OTHERWISE

; --- TYPE0 ENEMIES MOVE RIGHT-LEFT, CHANGING DIRECTION ON OBSTACLES ----------

.TYPE0      TST.B   D7                      ; CHECK OBSTACLE COLLISION
            BEQ     .END                    ; NO: END
            EOR.B   #KBDMSKLF+KBDMSKRT,AGNMOTOF(A0) ; YES: SWITCH DIRECTION
            BRA     .END

; --- TYPE1 ENEMIES MOVE RIGHT-LEFT-STOP RANDOMLY -----------------------------

.TYPE1      MOVE.B  (GENFRMCT),D7
            AND.B   #$1F,D7
            BNE     .END                    ; CHANGE MOTION EVERY 32 FRAMES
            JSR     UTLRAND
            CMP.W   #85,D0                  ; 33% CHANCE OF STOPPING
            BLE     .STOP
            CMP     #170,D0                 ; 33% CHANCE OF MOVING LEFT
            BLE     .LEFT
.RIGHT      MOVE.B  #KBDMSKRT,AGNMOTOF(A0)  ; 33% CHANCE OF MOVING RIGHT
            BRA     .END
.LEFT       MOVE.B  #KBDMSKLF,AGNMOTOF(A0)
            BRA     .END
.STOP       CLR.B   AGNMOTOF(A0)
            BRA     .END

; --- TYPE2 ENEMIES FOLLOW PLAYER X AND JUMP ON OBSTACLE ----------------------

.TYPE2      AND.B   #~KBDMSKUP,AGNMOTOF(A0) ; REMOVE JUMP COMMAND IF ANY

            MOVE.B  (GENFRMCT),D0           ; TAKE DECISION EVERY 32 FRAMES
            AND.B   #$1F,D0
            BNE     .END
            TST.L   AGNSPYOF(A0)            ; CHECK VERTICAL SPEED
            BNE     .END                    ; DO NOT CHANGE MIND DURING JUMP
            CLR.B   AGNMOTOF(A0)            ; CLEAR ALL MOTION COMMANDS
            TST.B   D7                      ; TOUCHING OBSTACLE?
            BEQ     .GOMOTION               ; NO: MOVE
            OR.B    #KBDMSKUP,AGNMOTOF(A0)  ; ISSUE JUMP COMMAND
.GOMOTION   MOVE.W  (PLRPOSX),D7            ; GET PLAYER X
            ADD.W   #AGNWIDTH/2,D7          ; COMPUTE CENTRAL X OF PLAYER
            MOVE.W  AGNPOXOF(A0),D0         ; GET ENEMY X
            ADD.W   #AGNWIDTH/2,D0          ; COMPUTE CENTRAL X OF ENEMY
            CMP.W   D7,D0                   ; COMPARE THEM
            BGE     .T2LEFT                 ; IF XENEM>XPLAYER GO LEFT
            OR.B    #KBDMSKRT,AGNMOTOF(A0)  ; ISSUE MOVE RIGHT COMMAND
            BRA     .END
.T2LEFT     OR.B    #KBDMSKLF,AGNMOTOF(A0)  ; ISSUE MOVE LEFT COMMANT
            BRA     .END

; --- TYPE3 ENEMIES ARE TYPE2 IF PLAYER IS CLOSE. OTHERWISE, STOP -------------

.TYPE3      JSR     .PLRCLOSE               ; IS THE PLAYER CLOSE?
            TST.B   D0
            BNE     .TYPE2                  ; IF SO, TYPE 2
            CLR.B   AGNMOTOF(A0)            ; OTHERWISE, STOP ENEMY
            BRA     .END

; --- TYPE4 JUMPS IF PLAYER CLOSE. STOPS OTHERWISE ----------------------------

.TYPE4      JSR     .PLRCLOSE               ; IS THE PLAYER CLOSE?
            TST.B   D0
            BNE     .T4JUMP                 ; IF SO, JUMP
            CLR.B   AGNMOTOF(A0)            ; OTHERWISE, STOP
            BRA     .END
.T4JUMP     CLR.B   AGNMOTOF(A0)            ; CANCEL JUMP
            MOVE.B  (GENFRMCT),D7
            AND.B   #$0F,D7
            BNE     .END                    ; TRY JUMP EVERY 16 CYCLES
            MOVE.B  #KBDMSKUP,AGNMOTOF(A0)  ; PREPARE JUMP COMMAND
            BRA     .END

.END        MOVEM.L (A7)+,D0/D7/A2
            RTS

; --- HELPER FUNCTION COMPUTING IF THE PLAYER IS CLOSE TO THE ENEMY -----------

.PLRCLOSE   MOVE.W  (PLRPOSX),D0
            ADD.W   #AGNWIDTH/2,D0
            SUB.W   AGNPOXOF(A0),D0
            BPL     .CLSCONT
            NEG.W   D0
.CLSCONT    CMP.W   #AGNWIDTH*4,D0
            BGT     .CLSNO
            MOVE.W  (PLRPOSY),D0
            ADD.W   #AGNHEIGH/2,D0
            SUB.W   AGNPOYOF(A0),D0
            BPL     .CLSCONT2
            NEG.W   D0
.CLSCONT2   CMP.W   #AGNWIDTH*4,D0
            BGT     .CLSNO
            MOVE.B  #$FF,D0
            RTS
.CLSNO      CLR.B   D0
            RTS

; -----------------------------------------------------------------------------
ENMPLOT
; PLOTS THE ENEMY
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  A2,-(A7)
            MOVE.L  A0,A2                   ; GET AGENT POINTER
            JSR     AGNPLOT                 ; PLOT THE AGENT
            MOVE.L  (A7)+,A2
            RTS

; -----------------------------------------------------------------------------
ENMPLCOL
; CHECKS ENEMY-PLAYER COLLISION AND SUBSTRACTS LIFE IF NECESSARY
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - THIS SUBROUTINE CHECKS AND MODIFIES PLAYER DATA.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7,-(A7)
            MOVE.W  (PLRPOSX),D0
            MOVE.W  (PLRPOSY),D1
            MOVE.W  AGNPOXOF(A0),D2
            MOVE.W  AGNPOYOF(A0),D3
            MOVE.W  #AGNWIDTH,D4
            MOVE.W  D4,D5
            MOVE.W  #AGNHEIGH,D6
            MOVE.W  D6,D7
            JSR     UTLCHCOL                ; CHECK COLLISION
            TST.B   D0                      ; IS THERE COLLISION?
            BEQ     .END                    ; NO: EXIT
            MOVE.W  (PLRSPDY),D0            ; IS PLAYER Y SPEED NEGATIVE?
            BMI     .DODAMAGE               ; YES: DAMAGE PLAYER
            CMP.W   #PLRKILSP,D0            ; IS IT LARGER THAN LIMIT TO KILL?
            BLT     .DODAMAGE               ; NO: DAMAGE PLAYER
            JSR     ENMEXPLO                ; YES: JUMPED OVER ENEMY. KILL IT.
            MOVE.L  #AGNJMPSP,(PLRSPDY)     ; FORCE PLAYER JUMP
            SUBQ.W  #1,(MAPNUMEN)           ; AND REDUCE ENEMY COUNT
            BRA     .END
.DODAMAGE   MOVE.W  #-ENMDMG,D0
            JSR     PLRADDLF
.END        MOVEM.L (A7)+,D0-D7
            RTS


; -----------------------------------------------------------------------------
ENMEXPLO
; EXPLODES THE ENEMY BY REMOVING FROM THE AGENT LIST AND ADDING SEVERAL
; EXPLOSIONS IN THE AGENT LIST.
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3,-(A7)
            MOVE.W  AGNPOXOF(A0),D1         ; GET X TO LOCATE EXPLOSIONS
            MOVE.W  AGNPOYOF(A0),D2         ; GET Y TO LOCATE EXPLOSIONS
            LEA     EXPINIT,A1              ; GET INIT SUBROUTINE
            LEA     EXPUPD,A2               ; GET UPDATE SUBROUTINE
            LEA     EXPPLOT,A3              ; GET PLOT SUBROUTINE
            MOVE.L  #EXPTYPE,D0             ; GET TYPE
            MOVE.W  #EXPGORE-1,D3           ; CREATE EXPGORE EXPLOSIONS
.LOOP       JSR     AGLADD                  ; ADD EXPLOSION
            DBRA.W  D3,.LOOP
            JSR     AGLKILL                 ; KILL THE ENEMY
            MOVE.B  #AUDMSKNL|AUDSPLID,D1   ; JUMP SOUND EFFECT
            JSR     AUDPLAY
            MOVEM.L (A7)+,D0-D3
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
