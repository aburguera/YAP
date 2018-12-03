; =============================================================================
; ENEMY MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
EXPINIT
; INITIALIZES THE EXPLOSION
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
;            D1.W INITIAL X
;            D2.W INITIAL Y
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/D1,-(A7)
            MOVE.B  #$FF,AGNTYPOF(A0)       ; USED AS COUNTER, NOT AS TYPE
            MOVE.W  D1,AGNPOXOF(A0)         ; INITIAL X
            MOVE.W  D2,AGNPOYOF(A0)         ; INITIAL Y
            JSR     UTLRAND                 ; RANDOM VALUE (YSPEED IS RANDOM)
            AND.L   #$000F,D0               ; CONSTRAIN TO RANGE 0-15
            ADD.B   #8,D0                   ; SET RANGE TO 8-23
            NEG.W   D0                      ; SET TO NEGATIVE
            SWAP    D0                      ; CHANGE TO FIXED POINT FORMAT
            MOVE.L  D0,AGNSPYOF(A0)         ; STORE Y SPEED
            JSR     UTLRAND                 ; RANDOM VALUE (X MOTION IS RANDOM)
            MOVE.B  #KBDMSKLF,D1            ; PREPARE LEFT MOTION
            AND.B   #1,D0                   ; 50% CHANCE OF CHANGING TO RIGHT
            BEQ     .STORE
            MOVE.B  #KBDMSKRT,D1
.STORE      MOVE.B  D1,AGNMOTOF(A0)         ; STORE MOTION
            JSR     UTLRAND                 ; RANDOM FOR X SPEED
            AND.W   #$000F,D0               ; CONSTRAIN TO 0-15
            MOVE.W  D0,AGNSPXOF(A0)         ; SET X SPEED
            CLR.B   AGNFRMOF(A0)            ; HERE USED AS STATE, NOT FRAMES.
            MOVEM.L (A7)+,D0/D1
            RTS

; -----------------------------------------------------------------------------
EXPUPD
; UPDATES THE EXPLOSION MOTION
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A2/D7,-(A7)

; --- SWITCH ACCORDING TO STATES ----------------------------------------------

            TST.B   AGNFRMOF(A0)
            BNE     .STATE1

; --- STATE 0: AFFECTED BY GRAVITY --------------------------------------------

.STATE0     SUBQ.B  #1,AGNTYPOF(A0)         ; DECREASE SECURITY COUNTER
            BCS     .DOKILL                 ; AFTER A NUMBER OF ITERATIONS, KILL
            MOVE.L  A0,A2                   ; PREPARE PARAMETER
            JSR     AGNACC                  ; DO ACCELERATION
            MOVE.B  D7,D6
            JSR     AGNMOVE
            OR.B    D6,D7
            TST.B   D7                      ; OBSTACLES TOUCHED?
            BEQ     .DONE                   ; NO: CONTINUE
            MOVE.B  #1,AGNFRMOF(A0)         ; CHANGE TO STATE 1
            MOVE.B  #$FF,AGNTYPOF(A0)       ; RESTART COUNTER
            MOVE.B  D7,AGNTYPOF+1(A0)       ; STORE COLLISION IN UNUSED BYTE
.DONE       MOVEM.L (A7)+,A2/D7
            RTS

; --- STATE 1: SPLASH FIXED TO WALL -------------------------------------------

.STATE1     SUB.B  #16,AGNTYPOF(A0)         ; DECREASE COUNTER/COLOR/SIZE
            BCC     .DONE                   ; COUNTDOWN FINISHED?
.DOKILL     JSR     AGLKILL                 ; YES: KILL THE AGENT
            BRA     .DONE                   ; NO: CONTINUE

; -----------------------------------------------------------------------------
EXPPLOT
; PLOTS THE EXPLOSION
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            MOVE.W  AGNPOXOF(A0),D3         ; GET X COORDINATE
            MOVE.W  AGNPOYOF(A0),D4         ; GET Y COORDINATE

; --- SWITCH ACCORDING TO STATES ----------------------------------------------

            TST.B   AGNFRMOF(A0)
            BNE     .STATE1

; --- STATE 0: AFFECTED BY GRAVITY --------------------------------------------

            MOVE.L  #$000000FF,D1           ; SET RED COLOR
            MOVE.B  #80,D0
            TRAP    #15                     ; USE IT AS PEN
            ADDQ.B  #1,D0
            TRAP    #15                     ; USE IT AS FILL

            MOVE.W  D3,D1                   ; PREPARE CIRCLE DRAWING COORD.
            MOVE.W  D4,D2
            ADD.W   #AGNWIDTH/8,D1          ; SOME OFFSETS TO MAKE IT SMALLER
            ADD.W   #AGNHEIGH/8,D2          ; THAN OTHER AGENTS.
            ADD.W   #AGNWIDTH-AGNWIDTH/8,D3
            ADD.W   #AGNHEIGH-AGNHEIGH/8,D4
            MOVE.B  #88,D0                  ; PLOT THE CIRCLE
            TRAP    #15
            BRA     .END

; --- STATE 1: SPLASH FIXED TO WALL -------------------------------------------

.STATE1     CLR.L   D1
            MOVE.B  AGNTYPOF(A0),D1         ; SET COLOR ACCORDING TO COUNTER
            MOVE.B  #80,D0                  ; PEN COLOR
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15                     ; FILL COLOR

            MOVE.B  AGNTYPOF+1(A0),D0       ; GET COLLISION BYTE
            ROR.B   #1,D0                   ; CHECK WHERE COLLISION HAPPENED
            BCS     .LEFT                   ; THE WAY IN WHICH IT IS CHECKED
            ROR.B   #1,D0                   ; ASSUMES THE KEY DISTRIBUTION
            BCS     .UP                     ; AS IT IS IN THE ORIGINAL SYSCONST
            ROR.B   #1,D0
            BCS     .RIGHT
            ROR.B   #1,D0
            BCC     .END
.DOWN       ADD.W   #MAPTILEW-MAPTILEW/3,D3 ; IF COLLISION WAS DOWN, FIX BLOOD
            ADD.W   #MAPTILEH+MAPTILEH/3,D4 ; TO DOWN BLOCK
            BRA     .PLOT
.UP         ADD.W   #MAPTILEW-MAPTILEW/3,D3 ; IF COLLISION WAS UP, FIX BLOOD
            SUB.W   #MAPTILEH/3,D4          ; TO UP BLOCK
            BRA     .PLOT
.LEFT       ADD.W   #MAPTILEH-MAPTILEH/3,D4 ; IF COLLISION WAS LEFT, FIX BLOOD
            BRA     .PLOT                   ; TO LEFT BLOCK
.RIGHT      ADD.W   #MAPTILEW+MAPTILEW/2+MAPTILEW/3,D3 ; IF IR WAS RIGHT
            ADD.W   #MAPTILEH-MAPTILEH/3,D4 ; FIX IT TO RIGHT BLOCK

.PLOT       MOVE.W  D3,D1                   ; PREPARE FINAL COORDINATES
            MOVE.W  D4,D2
            SUB.W   #MAPTILEW*2/3,D1
            SUB.W   #MAPTILEH*2/3,D2
            MOVE.B  AGNTYPOF(A0),D0         ; GET COUNTER
            ROR.B   #5,D0                   ; DIVIDE BY 32 (EVERY TWO FRAMES)
            NOT.W   D0                      ; NEGATE (7->0, 6->1, 5->2, ...)
            AND.W   #$0007,D0               ; CONSTRAIN TO 0-7
            ADD.W   D0,D1                   ; USE THE VALUE TO MAKE THE BLOOD
            ADD.W   D0,D2                   ; BECOME SMALLER WITH TIME
            SUB.W   D0,D3
            SUB.W   D0,D4
            MOVE.B  #88,D0
            TRAP    #15
.END        MOVEM.L (A7)+,D0-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
