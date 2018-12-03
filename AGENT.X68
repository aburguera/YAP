; =============================================================================
; AGENT MANAGEMENT - CODE SHARED BY PLAYER AND ENEMIES
;
; AN AGENT DATA BLOCK HAS THE FOLLOWING STRUCTURE.
; PROVIDED NAMES REFERS TO THE OFFSET (SEE CONST.X68) TO ACCESS THE FIELD.
;
; * VARIABLES. VALUES THAT THE AGENT CAN CHANGE DURING EXECUTION
;   - AGNFRAOF (WORD) THE GRAPHIC ID IF THE BASE FRAME TO PLOT. ONLY TWO FRAME
;                     ANIMATIONS ARE ALLOWED, THE SECOND FRAME BEING THIS ONE
;                     PLUS ONE.
;   - AGNPOXOF (WORD) THE X POSITION IN PIXELS.
;   - AGNPOYOF (LONG) THE Y POSITION IN PIXELS. FIXED POINT 16.16
;   - AGNSPYOF (LONG) THE Y SPEED IN PIXELS PER FRAME. FIXED POINT 16.16
;
; * COMMANDS. VALUES PROVIDED TO THE AGENT FOR IT TO ACT ACCORDING TO THEM
; OFFSETS TO AGENT COMMANDS
;   - AGNMOTOF (BYTE) DESIRED MOTION IN THE SAME FORMAT THAT KBDVAL
;
; * PARAMETERS. VALUES FIXED FOR A GIVEN AGENT
;   - AGNTYPOF (BYTE) SUBTYPE OF THE AGENT. THIS ALLOWS A SECOND CATEGORIZATION
;                     OTHER THAN THE ONE PROVIDED BY THE OWNER.
;   - AGNFRMOF (LONG) FRAME TO SHOW WHEN THE AGENT MOVES LEFT (HIGH WORD) AND
;                     RIGHT (LOW WORD)
; =============================================================================

; -----------------------------------------------------------------------------
AGNGRAV
; APPLIES GRAVITY TO AGENT.
; INPUT    - A2 POINTER TO AGENT DATA BLOCK
; OUTPUT   - THE AGENT DATA IS PROPERLY UPDATED
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D4/D7,-(A7)
            JSR     AGNACC                  ; ACCELERATE
            AND.B   #KBDMSKUP|KBDMSKDN,D7   ; FILTER UP/DOWN ONLY
            TST.B   D7                      ; OBSTACLES TOUCHED?
            BEQ     .END                    ; NO: END
            BTST    #KBDBITUP,D7            ; OBSTACLE UP?
            BNE     .ADJTOP                 ; YES: ADJUST Y COORDINATE
.ADJBOT     CLR.L   AGNSPYOF(A2)            ; SPEED TO ZERO
            BRA     .END
.ADJTOP     MOVE.L  #1,AGNSPYOF(A2)         ; SET SPEED CLOSE TO ZERO
.END        MOVEM.L (A7)+,D4/D7
            RTS

; -----------------------------------------------------------------------------
AGNACC
; APPLIES VERTICAL ACCELERATION TO AN AGENT AND CHECKS OBSTACLES UP AND DOWN.
; INPUT    - A2 POINTER TO AGENT DATA BLOCK
; OUTPUT   - D7.B = 0        -> NO COLLISION
;            D7.B = KBDMSKUP -> TOP COLLISION
;            D7.B = KBDMSKDN -> BOTTOM COLLISION
; MODIFIES - D4,D7
; -----------------------------------------------------------------------------
            MOVEM.L D4-D6,-(A7)
            ADD.L   #AGNGACC,AGNSPYOF(A2)   ; ACCELERATE
            MOVE.L  AGNPOYOF(A2),D4         ; Y COORDINATE
            ADD.L   AGNSPYOF(A2),D4         ; PROPOSE NEW Y
            MOVE.W  AGNPOXOF(A2),D5         ; GET X
            MOVE.L  D4,D6                   ; COPY Y
            SWAP    D6                      ; GET INTEGER PART OF Y
            JSR     AGNOBSV                 ; CHECK OBSTACLES TOP
            TST.B   D7                      ; ARE THERE?
            BNE     .ADJTOP                 ; YES: STATE OBSTACLES TOP
            ADD.W   #AGNHEIGH,D6            ; GO TO AGENT DOWN PART
            JSR     AGNOBSV                 ; CHECK OBSTACLES
            TST.B   D7                      ; ARE THERE?
            BEQ     .STORE                  ; NO: STATE NO OBSTACLES
            MOVE.B  #KBDMSKDN,D7            ; STATE OBSTACLES DOWN
.ADJBOT     AND.L   #~(MAPTILEH-1)<<16,D4   ; IF OBST TOUCHED, ALIGN Y TO IT
            BRA     .STORE
.ADJTOP     MOVE.B  #KBDMSKUP,D7            ; STATE OBSTACLES UP
            AND.L   #~(MAPTILEH-1)<<16,D4   ; IF OBSTACLE TOUCHED, ALIGN THE
            ADD.L   #MAPTILEH<<16,D4        ; INT PART OF Y TO IT
.STORE      MOVE.L  D4,AGNPOYOF(A2)         ; STORE Y
            MOVEM.L (A7)+,D4-D6
            RTS

; -----------------------------------------------------------------------------
AGNMOVE
; MOVES THE AGENT HORIZONTALLY
; INPUT    - A2 POINTER TO AGENT DATA BLOCK
; OUTPUT   - D7 CONTAINS KBDMASKLF OR KBDMASKRT DEPENDING ON THE AGENT COLLI-
;               LEFT OR RIGHT RESPECTIVELY.
;            AGENT DATA IS PROPERLY UPDATED
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7,-(A7)
            CLR.B   7*4+3(A7)               ; CLEAR COPY OF D7
            MOVE.B  AGNMOTOF(A2),D0         ; GET MOTION
            MOVE.L  AGNFRMOF(A2),D1         ; GET BASE FRAMES
            BTST    #KBDBITLF,D0
            BNE     .TRYLEFT                ; IF MOTION LEFT WANTED, GO FOR IT
.KBDRT      BTST    #KBDBITRT,D0
            BNE     .TRYRIGHT               ; IF MOTION RIGHT WANTED, LET'S GO
.KBDUP      AND.B   #KBDMSKUP,D0
            BEQ     .END                    ; IF NO UP, END. OTHERWISE, JUMP
            TST.L   AGNSPYOF(A2)
            BNE     .END                    ; IF JUMPING/FALLING, BAN JUMP
            MOVE.B  #AUDMSKNL|AUDBNGID,D1   ; BOING SOUND EFFECT
            CMP.B   #$FF,AGNTYPOF(A2)       ; CHECK IF IT IS THE PLAYER
            BNE     .PLAYSND                ; PLAY BOING FOR ENEMIES
            MOVE.B  #AUDMSKNL|AUDJMPID,D1   ; CHANGE TO JUMP SOUND FOR PLAYER
.PLAYSND    JSR     AUDPLAY
            MOVE.L  #AGNJMPSP,AGNSPYOF(A2)  ; INITIAL JUMP SPEED
.END        MOVEM.L (A7)+,D0-D7
            RTS
.TRYLEFT    SWAP    D1
            MOVE.W  D1,AGNFRAOF(A2)         ; STORE LEFT FRAME
            MOVE.W  AGNPOYOF(A2),D6         ; GET INT PART OF Y
            MOVE.W  AGNPOXOF(A2),D5         ; GET X
            SUB.W   AGNSPXOF(A2),D5         ; PROPOSE NEW POSITION
            JSR     AGNOBSH                 ; CHECK OBSTACLES
            TST.B   D7
            BEQ     .STOL                   ; IF NOT, STORE
.ADJLEFT    AND.W   #~(MAPTILEW-1),D5       ; ELSE, ADJUST TO BLOCK
            ADD.W   #MAPTILEW,D5
            OR.B    #KBDMSKLF,7*4+3(A7)     ; STORE LEFT IN COPY OF D7
.STOL       MOVE.W  D5,AGNPOXOF(A2)         ; STORE POSITION
            BRA     .KBDRT
.TRYRIGHT   MOVE.W  D1,AGNFRAOF(A2)         ; STORE RIGHT FRAME
            MOVE.W  AGNPOYOF(A2),D6         ; GET INT PART OF Y
            MOVE.W  AGNPOXOF(A2),D4         ; GET X
            ADD.W   AGNSPXOF(A2),D4         ; PROPOSE NEW POSITION
            MOVE.W  D4,D5
            ADD.W   #AGNWIDTH,D5
            JSR     AGNOBSH                 ; CHECK OBSTACLES
            TST.B   D7
            BEQ     .STOR                   ; IF NOT, STORE
.ADJRIGHT   AND.W   #~(MAPTILEW-1),D4       ; ADJUST TO BLOCK
            OR.B  #KBDMSKRT,7*4+3(A7)       ; STORE RIGHT IN COPY OF D7
.STOR       MOVE.W  D4,AGNPOXOF(A2)         ; STORE POSITION
            BRA     .KBDUP

; -----------------------------------------------------------------------------
AGNOBSV
; CHECKS OBSTACLES AT (X+OFF,Y) AND (X+W-O,Y)
; INPUT    - D5.W   X COORDINATE
;            D6.W   Y COORDINATE
; OUTPUT   - D7 = $FF OBSTACLES, $00 NO OBSTACLES
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D4-D5,-(A7)             ; STORE REGISTERS
            CLR.B   D4                      ; TEMPORARY OUTPUT
            ADD.W   #AGNBBXO,D5             ; X OFFSET TO AVOID DETECT LEFT
            JSR     MAPGTCOD                ; GET TILE ID
            AND.B   #MAPOBS,D7              ; IS OBSTACLE?
            BNE     .OBST                   ; YES: STATE IT
            ADD.W   #AGNWIDTH-2*AGNBBXO,D5  ; X TO THE RIGHT PART
            JSR     MAPGTCOD                ; GET TILE ID?
            AND.B   #MAPOBS,D7              ; IS OBSTACLE?
            BEQ     .END                    ; NO: STATE IT
.OBST       MOVE.B  #$FF,D4                 ; YES: PREPARE OUTPUT $FF
.END        MOVE.B  D4,D7                   ; OUTPUT PREPARED VALUE
            MOVEM.L (A7)+,D4-D5             ; RESTORE REGISTERS
            RTS

; -----------------------------------------------------------------------------
AGNOBSH
; CHECKS OBSTACLES AT (X,Y+OFF) AND (X,Y+H-O)
; INPUT    - D5.W   X COORDINATE
;            D6.W   Y COORDINATE
; OUTPUT   - D7 = $FF OBSTACLES, $00 NO OBSTACLES
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D4/D6,-(A7)             ; STORE REGISTERS
            CLR.B   D4                      ; TEMPORARY OUTPUT
            ADD.W   #AGNBBYO,D6             ; Y OFFSET TO AVOID DETECT TOP
            JSR     MAPGTCOD                ; GET TILE ID
            AND.B   #MAPOBS,D7              ; IS OBSTACLE?
            BNE     .OBST                   ; YES: STATE IT
            ADD.W   #AGNHEIGH-2*AGNBBYO,D6  ; Y TO THE BOTTOM PART
            JSR     MAPGTCOD                ; GET TILE ID?
            AND.B   #MAPOBS,D7              ; IS OBSTACLE?
            BEQ     .END                    ; NO: STATE IT
.OBST       MOVE.B  #$FF,D4                 ; YES: PREPARE OUTPUT $FF
.END        MOVE.B  D4,D7                   ; OUTPUT PREPARED VALUE
            MOVEM.L (A7)+,D4/D6             ; RESTORE REGISTERS
            RTS

; -----------------------------------------------------------------------------
AGNPLOT
; PLOTS THE AGENT
; INPUT    - A2 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ONLY WORKS WITH TWO-FRAME ANIMATIONS WHOSE FIRST FRAME IS AT AN
;            EVEN ADDRESS.
; -----------------------------------------------------------------------------
            MOVEM.L D0/D5-D7/A0,-(A7)
            MOVE.W  AGNPOXOF(A2),D5         ; GET AGENT X
            MOVE.W  AGNPOYOF(A2),D6         ; GET AGENT Y (INTEGER PART)
            MOVE.W  AGNFRAOF(A2),D7         ; GET AGENT BASE FRAME
            LEA     GFXLST,A0               ; GET GRAPHICS DATA
            MOVE.B  (GENFRMCT),D0           ; GET OFFSET
            LSR.B   #3,D0
            AND     #1,D0
            OR.B    D0,D7                   ; ADD OFFSET
            JSR     GFXDRIDP                ; PLOT
            MOVEM.L (A7)+,D0/D5-D7/A0
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
