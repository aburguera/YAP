; =============================================================================
; ATTRACT MODE MANAGEMENT
;
; TO RECORD A GAME:
; * SET ATRSAVE TO 1 (SEE CONST.X68)
; * PLAY A GAME NORMALLY WITHOUT GAME OVER NOR VICTORY.
; * PRESS FIRE3 (SHIFT) TO RECORD SHOWING TEXT. NOTE THAT TEXTS MUST BE
;   PREDEFINED. SEE STRPAGAT IN STRDATA.X68.
; * PRESS FIRE2 (M) TO END RECORDING.
; * THIS WILL GENERATE A BINARY FILE DATA/KEYSTROK.DAT. WARNING: IF IT ALREADY
;   EXISTS, IT WILL BE OVERWRITTEN. WARNING: THE DATA FOLDER MUST EXIST.
; * NOTE THAT PRESSING FIRE2 (M) TWICE OR MORE MAY PRODUCE A WRONG KEYSTROK.DAT
;
; TO ACTIVATE ATTRACT MODE (SEE THE RECORDED GAME)
; * SET ATRSAVE TO 0 (SEE CONST.X68)
; * JUST WAIT IN THE INTRO SCREEN.
;
; NOTE 1:
; THE RECORDED DATA IS JUST A RLE ENCODED LIST OF KEYSTROKES. EVERY ITEM IN THE
; LIST IS A LONG CONTAINING:
; * HIGH WORD: HIGH BYTE -> RECORDED KBDEDGE. LOW BYTE -> RECORDED KBDVAL
; * LOW WORD : NUMBER OF TIMES THE SAME KBDEDGE,KBDVAL IS REPEADED.
; PLEASE NOTE THAT MORE THAN 65535 REPETITIONS ARE NOT ALLOWED. THUS, DO NOT
; RECORD A GAME IN WHICH YOU ARE MORE THAN APPROX. 20 MINUTES WITH THE SAME
; KEYS PRESSED.
; THE LIST TERMINATOR IS $FFFFFFFF
;
; NOTE 3:
; ATTRACT MODE IS BASICALLY LIKE NORMAL GAME EXCEPT THAT (KBDVAL) AND (KBDEDGE)
; ARE OVERWRITTEN. TAKE INTO ACCOUNT THAT IN A REAL COMPUTER THIS WOULD BE
; NOT POSSIBLE, SINCE KBDVAL AND KBDEDGE ARE SYSTEM VARIABLES AND A USER CODE
; CANNOT OVERWRITE THEM. IN THIS CASE, THE SOLUTION WOULD BE SIMPLE: JUST
; AFTER READING KBDVAL AND KBDEDGE THEY COULD BE COPIED INTO USER MEMORY AND
; USE THESE COPIES INSTEAD OF THE ORIGINAL VALUES.
;
; NOTE 3:
; PLEASE, DO NOT WATCH THE RECORDED GAME WITH ATRSAVE=1. THIS MAY LEAD TO
; INCONSISTENCIES AND UNEXPECTED BEHAVIOR MAY HAPPEN.
;
; NOTE 4:
; PLEASE NOTE THAT THE OPTION TO RECORD THE GAME IS PROVIDED ONLY FOR THE SAKE
; OF COMPLETENESS. AN ACTUAL GAME WOULD NOT PROVIDE THAT OPTION, THAT IS WHY
; ACTIVATING RECORDING CAN ONLY BE DONE AT ASSEMBLY TIME.
; =============================================================================

; -----------------------------------------------------------------------------
ATRINIT
; INITALIZES THE ATTRACT MODE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     UTLINIT                 ; INITIALIZE RANDOMNESS
            CLR.B   (GENFRMCT)
            IFNE    ATRSAVE
            MOVE.L  #ATRNDATA-4,(ATRPTR)
            MOVE.W  #$FFFF,(ATRPRKV)
            MOVE.L  #STRPAGAT,(ATRTUTP)
            ENDC
            IFEQ    ATRSAVE
            MOVE.L  #ATRDATA-4,(ATRPTR)
            CLR.W   (ATRCTR)
            MOVE.L  #STRPAGAT,(ATRTUTP)
            RTS
            ENDC

; -----------------------------------------------------------------------------
ATRUPD
; ATTRACT MODE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

; --- CONDITIONALLY ASSEMBLED CODE TO RECORD A GAME ---------------------------
; RECORDS A LIST OF KEYSTROKES (KBDVAL AND KBDEDGE), COMPRESSES THEM IN RLE
; AND, WHEN FIRE2 IS PRESSED, SAVES THEM IN THE BINARY FILE KEYSTROK.DAT

            IFNE    ATRSAVE
            MOVEM.L D0-D2/A0-A2,-(A7)
            BTST    #KBDBITF2,(KBDEDGE)     ; SAVE DATA WITH FIRE2
            BNE     .SAVE
            MOVE.L  (ATRPTR),D0
            MOVE.L  D0,A0
            MOVE.B  (KBDEDGE),D0
            ASL.W   #8,D0
            MOVE.B  (KBDVAL),D0             ; D0=$0000EEVV
            CMP.W   (ATRPRKV),D0
            BEQ     .INCCNT                 ; SAME STROKE? INCREASE COUNT
            MOVE.W  D0,(ATRPRKV)
            AND.L   #$0000FFFF,D0           ; DIFFERENT STROKE? ADD TO LIST
            SWAP    D0
            MOVE.W  #1,D0
            ADD.L   #4,A0
            MOVE.L  D0,(A0)
            MOVE.L  A0,D0
            MOVE.L  D0,(ATRPTR)
            BRA     .END
.INCCNT     MOVE.L  (A0),D0
            ADDQ.W  #1,D0
            MOVE.L  D0,(A0)
.END        MOVEM.L (A7)+,D0-D2/A0-A2
            RTS
.SAVE       MOVE.L  (ATRPTR),D2             ; SAVE DATA WHEN REQUESTED
            ADDQ.L  #4,D2
            MOVE.L  D2,(ATRPTR)
            MOVE.L  D2,A0
            MOVE.L  #$FFFFFFFF,(A0)
            MOVE.L  #ATRNDATA,D1
            ADD.L   #4,D2
            SUB.L   D1,D2                   ; SIZE IN BYTES
            MOVE.B  #50,D0
            TRAP    #15                     ; CLOSE ALL FILES
            LEA     .FNAME,A1               ; CREATE FILE
            MOVE.B  #52,D0
            TRAP    #15
            LEA     ATRNDATA,A1             ; WRITE DATA
            MOVE.B  #54,D0
            TRAP    #15
            MOVE.B  #56,D0                  ; CLOSE FILE
            TRAP    #15
            BRA     .END
.FNAME      DC.B    'DATA/KEYSTROK.DAT',0
ATRPRKV     DS.W    1                       ; PREVIOUS KBDVAL
            DS.W    0
ATRNDATA    DS.L    1024                    ; BUFFER TO STORE
            ENDC

; --- CONDITIONALLY ASSEMBLED CODE TO PLAY A RECORDED GAME --------------------
; READS KEYSTROK.DAT AND OVERWRITES KBDVAL AND KBDEDGE ACCORDINGLY.

            IFEQ    ATRSAVE
            MOVEM.L D0-D1/A0,-(A7)
            MOVE.L  (ATRPTR),D0
            MOVE.L  D0,A0                   ; POINTER
            MOVE.W  (ATRCTR),D0             ; GET COUNTER
            BNE     .SUBSTR                 ; NOT ENDED: DECREASE COUNTER
            ADD.L   #4,A0                   ; ENDED: NEXT ITEM
            MOVE.L  (A0),D0                 ; GET ITEM
            MOVE.B  #KBDMSKF1,(KBDEDGE)     ; PROPOSE TERMINATION
            MOVE.B  #KBDMSKF1,(KBDVAL)
            CMP.L   #$FFFFFFFF,D0           ; LAST ONE?
            BEQ     .END
            MOVE.W  D0,(ATRCTR)             ; STORE COUNTER
            MOVE.L  A0,D0
            MOVE.L  D0,(ATRPTR)
.SUBSTR     SUBQ.W  #1,(ATRCTR)             ; DECREASE COUNTER
            MOVE.L  (A0),D0                 ; GET ITEM
            SWAP    D0
            MOVE.B  D0,(KBDVAL)
            ROR.W   #8,D0
            MOVE.B  D0,(KBDEDGE)
.END        MOVEM.L (A7)+,D0-D1/A0
            RTS
            ENDC

; -----------------------------------------------------------------------------
ATRPLOT
; ATTRACT MODE PLOT - PLOTS TUTORIAL TEXTS DURING ATTRACT MODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0,-(A7)
            MOVE.L  (ATRTUTP),D0
            MOVE.L  D0,A0
            MOVE.L  (A0),A0
            MOVE.L  A0,D0
            BEQ     .END
            BTST    #KBDBITF3,(KBDVAL)
            BEQ     .END                    ; NOTHING TO SHOW
            BTST    #KBDBITF3,(KBDEDGE)
            BEQ     .PLOT                   ; NO CHANGE TEXT
.ADVANCE    ADD.L   #4,(ATRTUTP)            ; NEXT TEXT
            BRA     .END
.PLOT       MOVE.L  (ATRTUTP),D0
            MOVE.L  D0,A0
            MOVE.L  (A0),A0                 ; POINTER TO TEXT BLOCK
            JSR     GENFPLOT                ; PLOT TEXT
.END        MOVEM.L (A7)+,D0-D4/A0
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
