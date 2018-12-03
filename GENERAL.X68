; =============================================================================
; GENERAL SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
GENCURT
; PLOTS A CURTAIN
; INPUT    - D7.L MSW: CHANNEL (00=R, 01=G; 10=B),LSW: DISTANCE TO CENTER
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7,-(A7)
            MOVE.W  #SCRWIDTH,D6
            SUB.W   D7,D6
            ASR.W   #3,D6                   ; D6=NUMBER OF ITERATIONS
            SUBQ.W  #1,D6                   ; PREPARE FOR DBRA
            CLR.L   D5                      ; D5=COLOR
            MOVE.W  #SCRWIDTH/2,D1
            ADD.W   D7,D1                   ; D1=XINI
            CLR.W   D2                      ; D2=YINI
            MOVE.W  #SCRHEIGH,D4            ; D4=YEND

.LOOP       SWAP    D7
            TST.B   D7
            BEQ     .RED
            CMP.B   #1,D7
            BEQ     .GREEN
.BLUE       ADD.L   #$000F0000,D5           ; UPDATE BLUE GRADATION
            AND.L   #$00FF0000,D5
            BRA     .CONT0
.RED        ADD.L   #$0000000F,D5           ; UPDATE RED GRADATION
            AND.L   #$000000FF,D5
            BRA     .CONT0
.GREEN      ADD.L   #$00000F00,D5           ; UPDATE GREEN GRADATION
            AND.L   #$0000FF00,D5
.CONT0      SWAP    D7
            EXG     D1,D5
            MOVE.B  #80,D0
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0
            TRAP    #15                     ; SET FILL COLOR
            EXG     D1,D5

            MOVE.W  D1,D3
            ADD.W   #8,D3
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW BAR

            MOVEM.L D1/D3,-(A7)             ; DRAW THE SYMMETRIC BAR.
            SUB.W   #SCRWIDTH/2,D1
            MOVE.W  #SCRWIDTH/2,D3
            SUB.W   D1,D3
            MOVE.W  D3,D1
            SUB.W   #8,D3
            TRAP    #15
            MOVEM.L (A7)+,D1/D3

            MOVE.W  D3,D1                   ; PREPARE NEXT X
            DBRA.W  D6,.LOOP
            MOVEM.L (A7)+,D0-D7
            RTS

; -----------------------------------------------------------------------------
GENCENTX
; GIVEN A WIDTH (PIXELS), OUTPUTS THE X MARGINS TO HAVE IT CENTERED ON SCREEN.
; INPUT    - D3.W WIDTH
; OUTPUT   - D1.W XINI, D3.W XEND
; MODIFIES - ONLY OUTPUT
; -----------------------------------------------------------------------------
            MOVE.W  #SCRWIDTH,D1
            SUB.W   D3,D1
            ASR.W   #1,D1                   ; D1: XINI
            ADD.W   #SCRWIDTH,D3
            ASR.W   #1,D3                   ; D3: XEND
            RTS

; -----------------------------------------------------------------------------
GENCENTY
; GIVEN A HEIGHT (PIXELS), OUTPUTS THE Y MARGINS TO HAVE IT CENTERED ON SCREEN.
; INPUT    - D4.W HEIGHT
; OUTPUT   - D2.W YINI, D4.W YEND
; MODIFIES - ONLY OUTPUT
; -----------------------------------------------------------------------------
            MOVE.W  #SCRHEIGH,D2
            SUB.W   D4,D2
            ASR.W   #1,D2                   ; D2: YINI
            ADD.W   #SCRHEIGH,D4
            ASR.W   #1,D4                   ; D4: YEND
            RTS

; -----------------------------------------------------------------------------
GENFPLOT
; PLOTS TEXT CENTERED ON SCREEN
; INPUT    - A0 ZERO-TERMINATED LIST OF POINTERS TO STRINGS
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - THIS COULD BE OPTIMIZED IN (AT LEAST) TWO WAYS:
;            * STORING THE LENGTH OF THE STRINGS DURING THE FIRST LOOP TO
;              AVOID COMPUTING THEM AGAIN TO PRINT THEM.
;            * UNLESS TEXTS ARE TO BE GENERATED DYNAMICALLY (WHICH IS NOT THE
;              CASE IN THE EXAMPLE GAME), THE COORDINATES COULD HAVE BEEN
;              COMPUTED IN ASSEMBLY TIME AND PASSED AS PARAMETERS TO THIS
;              SUBROUTINE.
;            THESE OPTIMIZATIONS HAVE NOT BEEN DONE BECAUSE:
;            * THE PARTS OF THE PROGRAM IN WHICH THIS CODE IS CALLED ARE NOT
;              PARTICULARLY TIME CONSTRAINED.
;            * THE PROPER WAY TO COMPUTE THIS STUFF IN ASSEMBLY TIME WOULD BE
;              TO WRITE A SCRIPT IN ANOTHER LANGUAGE (I.E. PYTHON) TO PROCESS
;              THE STRINGS AND COMPUTE THE PARAMETERS, AND THIS IS SUPPOSED TO
;              BE AN EXAMPLE OF ASSEMBLY LANGUAGE.
; -----------------------------------------------------------------------------

            MOVEM.L D0-D7/A0-A2,-(A7)
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #80,D0
            TRAP    #15                     ; PEN COLOR TO WHITE
            CLR.L   D1
            ADDQ.B  #1,D0
            TRAP    #15                     ; SET FILL TO BLACK

            MOVE.L  A0,A2                   ; COPY A0 FOR FURTHER USE
            CLR.W   D4                      ; INIT ITEMS IN LIST
            CLR.W   D3                      ; INIT MAX STR LENGTH

.LOOP0      TST.L   (A2)                    ; IS END OF LIST?
            BEQ     .END0                   ; YES: DONE
            ADDQ.W  #1,D4                   ; ADD 1 TO ITEM COUNT
            MOVE.L  (A2)+,A1                ; GET STRING AND ADVANCE IN LIST
            JSR     UTLSTRLN                ; GET STRING LENGTH
            CMP.W   D3,D0                   ; COMPUTE THE MAX LENGTH
            BLE     .LOOP0
            MOVE.W  D0,D3                   ; MAX LENGTH WILL BE IN D3
            BRA     .LOOP0

.END0       ADD.W   #2,D3                   ; ADD HOR MARGIN (2 CHAR)
            MULU    #GENCHRW,D3             ; GET WIDTH IN PIXELS
            MOVE.W  D4,D7                   ; REMEMBER NUMBER OF ITEMS
            ADD.W   #2,D4                   ; ADD VERT MARGIN (2 CHAR)
            MULU    #GENCHRH,D4             ; GET HEIGHT IN PIXELS
            JSR     GENCENTX                ; GET X OF BOUNDING BOX
            JSR     GENCENTY                ; GET Y OF BOUNDING BOX

            MOVE.B  #87,D0                  ; DRAW BOUNDING BOX
            TRAP    #15

.LOOP1      ADD.W   #GENCHRH,D2             ; GO ONE LINE DOWN
            TST.L   (A0)                    ; TEST. STRANGELY, IT SEEMS THAT
            BEQ     .END                    ; THE FOLLOWING MOVE DON'T DO IT.
            MOVE.L  (A0)+,A1                ; GET STRING POINTER
            BEQ     .END
            JSR     UTLSTRLN                ; GET STRING LENGTH
            MULU    #GENCHRW,D0             ; GET LENGTH IN PIXELS
            MOVE.W  D0,D3
            JSR     GENCENTX                ; GET XINI IN D1
            MOVE.B  #95,D0
            TRAP    #15                     ; PRINT THE STRING
            BRA     .LOOP1

.END        MOVEM.L (A7)+,D0-D7/A0-A2
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
