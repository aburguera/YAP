; =============================================================================
; MAP MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
MAPINIT
; INITALIZES THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.W  #MAPINIX,(MAPPOSX)      ; INIT SCREEN X
            MOVE.W  #MAPINIY,(MAPPOSY)      ; INIT SCREEN Y
            LEA     MAPCMPLT,A0             ; COMPLETED SCREENS FLAGS
            MOVE.W  #MAPWIDTH*MAPHEIGH-1,D0 ; LOOP COUNTER
.LOOP       CLR.W   (A0)+                   ; INITIALLY SCREENS NOT COMPLETED
            DBRA.W  D0,.LOOP
            MOVE.W  #MAPSCRVS,D0            ; FIRST ROOM VISITED
            JSR     MAPDOCOMP               ; ZERO: SET ROOM AS COMPLETED
            JSR     MAPGTSCA                ; GET SCREEN ADDRESS
            JSR     MAPENMDL                ; DELETE ALL ENEMIES
            JSR     MAPENMCR                ; CREATE CURRENT ENEMIES
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
MAPUPD
; UPDATES THE MAP IF PLAYER CHANGES SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D5,-(A7)

            TST.W   (MAPNUMEN)              ; CHECK NUMBER OF ENEMIES
            BNE     .CONT                   ; NOT ZERO? CONTINUE
            MOVE.W  #MAPSCRCM,D0
            JSR     MAPDOCOMP               ; ZERO: SET ROOM AS COMPLETED

.CONT       CMP.W   #MAPTILEW*MAPSCRW-AGNWIDTH-AGNBBXO,(PLRPOSX)
            BGE     .CHGR                   ; IF AT SCREEN RIGHT, CHANGE
            CMP.W   #AGNBBXO,(PLRPOSX)
            BLE     .CHGL                   ; IF AT SCREEN LEFT, CHANGE
            CMP.W   #MAPTILEH*MAPSCRH-AGNHEIGH-AGNBBYO,(PLRPOSY)
            BGE     .CHGD                   ; IF AT SCREEN BOTTOM, CHANGE
            CMP.W   #AGNBBYO,(PLRPOSY)
            BGE     .END                    ; IF NOT AT TOP, END
.CHGU       MOVE.L  #$FFFF0000,D5           ; REQUEST UPWARD SCREEN
            MOVE.L  #MAPTILEH*MAPSCRH-AGNHEIGH-AGNBBYO*2<<16,(PLRPOSY)
            BRA     .DOCHG                  ; AND SET PLAYER Y TO BOTTOM
.CHGR       MOVE.L  #$00000001,D5           ; REQUEST RIGHTWARD SCREEN
            MOVE.W  #AGNBBXO*2,(PLRPOSX)    ; AND SET PLAYER X TO LEFT
            BRA     .DOCHG
.CHGL       MOVE.L  #$0000FFFF,D5           ; REQUEST LEFTWARD SCREEN
            MOVE.W  #MAPTILEW*MAPSCRW-AGNWIDTH-AGNBBXO*2,(PLRPOSX)
            BRA     .DOCHG                  ; AND SET PLAYER X TO RIGHT
.CHGD       MOVE.L  #$00010000,D5           ; REQUEST DOWNWARD SCREEN
            MOVE.L  #AGNBBYO*2<<16,(PLRPOSY) ; AND SET PLAYER Y TO TOP
.DOCHG      JSR     MAPMOVE                 ; DO SCREEN CHANGE REQUEST
            JSR     MAPENMDL                ; DELETE EXISTING ENEMIES
            JSR     MAPENMCR                ; CREATE NEW ENEMIES
.END        MOVE.L  (A7)+,D5
            RTS

; -----------------------------------------------------------------------------
MAPPLOT
; PLOTS THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A2,-(A7)
            MOVEA.L (MAPSCPTR), A2          ; GET SCREEN ADDRESS
            LEA     GFXLST,A0               ; GET GRAPHICS DATA
            MOVE.W  #MAPSCRH-1,D0           ; ROW ITERATOR
            CLR.W   D6                      ; INITIAL Y
.LOOPY      CLR.W   D5                      ; INITIAL X (REINIT AFTER EACH ROW)
            MOVE.W  #MAPSCRW-1,D1           ; COLUMN ITERATOR
.LOOPX      MOVE.W  (A2)+,D7                ; GET MAP CELL
            IFEQ    CASSCRBG                ; SKIP IF NO BACKGROUND WANTED
            BEQ     .SKIP                   ; IF 00 SKIP TO INCREASE SPEED
            ENDC
            CMP.W   #MAPDOOR,D7
            BEQ     .DOOR                   ; IS IT A DOOR?
            CMP.W   #MAPANIM0,D7            ; IS IT ANIMATED?
            BEQ     .ANIM
            CMP.W   #MAPANIM1,D7
            BNE     .PLOT                   ; IF NOT ANIMATED, PLOT
.ANIM       MOVE.B  (GENFRMCT),D3           ; GET CYCLE COUNTER
            ROR.W   #3,D3                   ; DIV BY 8 TO CHANGE EVERY 8 FRAMES
            AND.W   #3,D3                   ; ANIM PIC HAS 4 FRAMES CONTROLLED
            OR.W    D3,D7                   ; ... BY ITS TWO LSB
.PLOT       JSR     GFXDRIDP                ; DRAW
.SKIP       ADD.W   #MAPTILEW,D5            ; ADD 32 TO X
            DBRA.W  D1,.LOOPX               ; LOOP FOR ALL COLUMNS
            ADD.W   #MAPTILEH,D6            ; ADD 32 TO Y
            ADD.L   #MAPSCRW*(MAPWIDTH*2-2),A2
            DBRA.W  D0,.LOOPY               ; LOOP FOR ALL ROWS
            JSR     MAPMINPL
            MOVEM.L (A7)+,D0-D7/A2
            RTS
.DOOR       TST.W   (MAPNUMEN)              ; ARE THERE ENEMIES?
            BNE     .PLOT                   ; IF SO, PLOT DOOR
            CLR.W   D7
            IFEQ    CASSCRBG                ; SKIP IF NO BACKGROUND WANTER
            BRA     .SKIP                   ; OTHERWISE, BACKGROUND CELL
            ENDC
            IFNE    CASSCRBG                ; PLOT IF BACKGROUND WANTED
            BRA     .PLOT
            ENDC

; -----------------------------------------------------------------------------
MAPMINPL
; PLOTS THE MINIMAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            ; SET COLORS
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #$00000000,D1
            ADDQ.B  #1,D0
            TRAP    #15

            ; DECIDE WHERE TO PLOT THE MINIMAP
            MOVE.W  #MAPTILEH/3,D2          ; TEMPTATIVE INITIAL Y
            MOVE.W  #MAPTILEW/2,D1          ; TEMPTATIVE INITIAL X
            MOVE.W  (PLRPOSX),D3            ; GET PLAYER X POSITION
            CMP.W   #MAPTILEW*MAPSCRW/2,D3  ; COMPARE WITH CENTER
            BGE     .CHKY
            MOVE.W  #MAPTILEW*MAPSCRW-MAPTILEW/2-MAPWIDTH*MAPSCRW*MAPMINCS,D1
.CHKY       MOVE.W  (PLRPOSY),D3            ; GET PLAYER Y POSITION
            CMP.W   #MAPTILEH*MAPSCRH/2,D3  ; COMPARE WITH CENTER
            BGE     .STOREINI
            MOVE.W  #MAPTILEH*MAPSCRH-MAPTILEH/3-MAPHEIGH*MAPSCRH*MAPMINCS,D2
.STOREINI   MOVE.W  D1,D7                   ; D7 STORES THE INITIAL COORDINATES
            SWAP    D7                      ; HIGH 16 BITS: X
            MOVE.W  D2,D7                   ; LOW 16 BITS: Y

            ; DRAW BOUNDING RECTANGLE

            EXG     D1,D6
            MOVE.L  #$0000FF00,D1
            MOVE.B  #80,D0
            TRAP    #15
            EXG     D1,D6
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #MAPWIDTH*MAPSCRW*MAPMINCS,D3
            ADD.W   #MAPHEIGH*MAPSCRH*MAPMINCS,D4
            MOVE.B  (GENFRMCT),D5
            ROR.B   #1,D5
            AND.W   #$0007,D5
            SUB.W   D5,D1
            SUB.W   D5,D2
            ADD.W   D5,D3
            ADD.W   D5,D4
            MOVE.B  #87,D0
            TRAP    #15

            ; DRAW MINIMAP
            IFNE    CASFULMM                ; ONLY IF FULL MINIMAP WANTED
            LEA     MAPDATA,A0
            MOVE.W  D7,D2                   ; INITIAL Y
            MOVE.W  #MAPHEIGH*MAPSCRH-1,D5  ; ROW ITERATOR
.LOOPY      SWAP    D7
            MOVE.W  D7,D1                   ; INITIAL X
            SWAP    D7
            MOVE.W  #MAPWIDTH*MAPSCRW-1,D6  ; COLUMN ITERATOR
.LOOPX      MOVE.W  (A0)+,D0                ; CHECK CURRENT CELL
            BEQ     .SKIP                   ; EMPTY CELL? NO PLOT
            CMP.W   #2,D0
            BLE     .BRCOL
            CMP.W   #3,D0
            BEQ     .SKIP
.RDCOL      MOVE.L  D1,-(A7)
            MOVE.L  #$000000FF,D1           ; SET RED COLOR
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #$000000FF,D1
            ADDQ.B  #1,D0
            TRAP    #15
            MOVE.L  (A7)+,D1
            BRA     .DRAW
.BRCOL      MOVE.L  D1,-(A7)
            MOVE.L  #0<<16+50<<8+100,D1     ; SET BROWN COLOR
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #0<<16+102<<8+153,D1
            ADDQ.B  #1,D0
            TRAP    #15
            MOVE.L  (A7)+,D1
.DRAW       MOVE.W  D1,D3                   ; DRAW CELL
            MOVE.W  D2,D4
            ADD.W   #MAPMINCS,D3
            ADD.W   #MAPMINCS,D4
            MOVE.B  #87,D0
            TRAP    #15
.SKIP       ADD.W   #MAPMINCS,D1            ; NEXT CELL X COORDINATE
            DBRA.W  D6,.LOOPX               ; LOOP FOR ALL COLUMNS
            ADD.W   #MAPMINCS,D2            ; NEXT CELL Y COORDINATE
            DBRA.W  D5,.LOOPY
            ENDC
            IFEQ    CASFULMM                ; IF NO FULL MM, SET COLOR
            MOVE.L  #0<<16+50<<8+100,D1     ; SET BROWN COLOR
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #0<<16+102<<8+153,D1
            ADDQ.B  #1,D0
            TRAP    #15
            ENDC

            ; COVER NOT VISITED SCREENS
            LEA     MAPCMPLT,A0             ; COMPLETED SCREENS DATA
            MOVE.W  D7,D2                   ; INITIAL Y
            MOVE.W  #MAPHEIGH-1,D5          ; ROW ITERATOR
.LOOPY2     SWAP    D7
            MOVE.W  D7,D1                   ; INITIAL X
            SWAP    D7
            MOVE.W  #MAPWIDTH-1,D6          ; COLUMN ITERATOR
.LOOPX2     MOVE.B  #87,D0
            MOVE.W  (A0)+,D3                ; GET VALUE
            AND.W   #MAPSCRVS,D3            ; VISITED?
            BEQ     .CONT2                  ; NO: COVER IT
            ADDQ.W  #3,D0                   ; YES: PLOT OUTLINE ONLY
.CONT2      MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #MAPSCRW*MAPMINCS,D3
            ADD.W   #MAPSCRH*MAPMINCS,D4
            TRAP    #15
.SKIP2      ADD.W   #MAPSCRW*MAPMINCS,D1
            DBRA.W  D6,.LOOPX2
            ADD.W   #MAPSCRH*MAPMINCS,D2
            DBRA.W  D5,.LOOPY2

            ; PLOT PLAYER
            MOVE.L  #$00009900,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #$0000FF00,D1
            ADDQ.B  #1,D0
            TRAP    #15
            MOVE.W  D7,D4                   ; INITIAL Y
            SWAP    D7
            MOVE.W  D7,D3                   ; INITIAL X
            SWAP    D7
            MOVE.W  (MAPPOSX),D1
            MULU    #MAPSCRW*MAPMINCS,D1    ; SCREEN INITIAL COORDINATE X
            ADD.L   D3,D1
            MOVE.W  (MAPPOSY),D2
            MULU    #MAPSCRH*MAPMINCS,D2    ; SCREEN INITIAL COORDINATE Y
            ADD.L   D4,D2
            MOVE.W  (PLRPOSX),D3
            ROR.W   #4,D3                   ; ASSUMES MAPMINCS=8 AND AGNW=32
            AND.L   #$00000FFF,D3
            MOVE.W  (PLRPOSY),D4
            ROR.W   #4,D4                   ; ASSUMES MAPMINCS=8 AND AGNH=32
            AND.L   #$00000FFF,D4

            MOVE.B  (GENFRMCT),D5
            ROR.B   #3,D5
            AND     #3,D5
            ADD.L   D3,D1
            ADD.L   D4,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #MAPMINCS,D3
            ADD.W   #MAPMINCS,D4
            SUB.W   D5,D1
            SUB.W   D5,D2
            ADD.W   D5,D3
            ADD.W   D5,D4
            MOVE.B  #88,D0
            TRAP    #15
            RTS

; -----------------------------------------------------------------------------
MAPDOCOMP
; STORES THE CURRENT SCREEN AS COMPLETED/VISITED
; INPUT    - D0.W   VALUE TO OR WITH EXISTING VALUE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A0,-(A7)
            JSR     MAPGTFLA                ; GET THE ADDRESS
            OR.W    D0,(A0)                 ; MARK AS COMPLETED/VISITED
            MOVEM.L (A7)+,A0
            RTS

; -----------------------------------------------------------------------------
MAPGTFLA
; GETS THE ADDRESS OF THE CURRENT SCREEN IN THE COMPLETED SCREENS LIST
; INPUT    - NONE
; OUTPUT   - A0 ADDRESS
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.W  (MAPPOSY),D0            ; GET SCREEN Y
            MULU    #MAPWIDTH*2,D0          ; * SCREENS PER ROW * 2 (WORDS)
            MOVE.W  (MAPPOSX),D1            ; GET SCREEN X
            ASL.W   #1,D1                   ; * 2 (WORDS)
            ADD.W   D1,D0                   ; ADD BOTH OFFSETS
            LEA     MAPCMPLT,A0             ; GET DATA ADDRESS
            LEA     (A0,D0.W),A0            ; GET THE OFFSETTED ADDRESS
            MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
MAPMOVE
; CHANGE SCREEN
; INPUT    - D5.L   16 HIGH BITS AMOUNT TO MOVE VERT, 16 BITS LOW HOR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            ADD.W   D5,(MAPPOSX)            ; MOVE HORIZONTALLY
            SWAP.W  D5
            ADD.W   D5,(MAPPOSY)            ; MOVE VERTICALLY
            SWAP.W  D5                      ; RESTORE D5
            CMP.W   #MAPWIDTH,(MAPPOSX)     ; X OUT OF MAP?
            BGE     .WIN                    ; YES: WIN
            JSR     MAPGTSCA                ; GET SCREEN ADDRESS
            MOVE.W  #MAPSCRVS,D0
            JSR     MAPDOCOMP
.END        MOVE.W  (A7)+,D0
            RTS
.WIN        MOVE.W  #STAVICT,(STANEXT)      ; GO TO VICTORY STATE!
            BRA     .END

; -----------------------------------------------------------------------------
MAPGTSCA
; GETS THE INITIAL ADDRESS OF THE CURRENT SCREEN
; INPUT    - NONE
; OUTPUT   - NONE. UPDATES (MAPSCPTR)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A2,-(A7)
            LEA     MAPDATA,A2              ; GET BASE MAP ADDRESS
            MOVE.W  (MAPPOSY),D0            ; GET SCREEN Y
            MULU    #MAPSCRH*MAPSCRW*MAPWIDTH*2,D0 ; COMPUTE Y OFFSET
            ADD.L   D0,A2                   ; ADD Y OFFSET
            MOVE.W  (MAPPOSX),D0            ; GET SCREEN Y
            MULU    #MAPSCRW*2,D0           ; COMPUTE X OFFSET
            ADD.L   D0,A2                   ; ADD IT
            MOVE.L  A2,(MAPSCPTR)           ; STORE IT
            MOVEM.L (A7)+,D0/A2
            RTS

; -----------------------------------------------------------------------------
MAPGTTIL
; GETS THE TILE IN THE SPECIFIED (PIXELWISE) COORDINATES
; INPUT    - D5.W X COORDINATE
;            D6.W Y COORDINATE
; OUTPUT   - D7.W TILE ID
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D5-D6/A0,-(A7)
            ASR.W   #5,D6                   ; Y/=MAPTILEH. VALID IF MAPTILEH=32
            ASR.W   #4,D5                   ; X=2*(X/MAPTILEW) IF MAPTILEW=32
            AND.L   #$0000FFFE,D5           ; CLEAR LSB
            MULU    #MAPSCRW*MAPWIDTH*2,D6  ; COMPUTE Y OFFSET
            ADD.L   D5,D6                   ; ADD X OFFSET
            MOVE.L  (MAPSCPTR), A0          ; GET BASE SCREEN ADDR
            ADD.L   D6,A0                   ; GET ADDRESS
            MOVE.W  (A0),D7                 ; OUTPUT TO D7
            MOVEM.L (A7)+,D5-D6/A0
            RTS

; -----------------------------------------------------------------------------
MAPGTCOD
; GETS THE CODE OF THE SPECIFIED (PIXELWISE) COORDINATES.
; INPUT    - D5.W X COORDINATE
;            D6.W Y COORDINATE
; OUTPUT   - D7.B CODE:
;            %00 FREE (MAPFREE)
;            %01 DAMAGING BLOCK (MAPDMG)
;            %10 OBSTACLE (MAPOBS)
;            %11 LADDER (MAPLAD)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CMP.W   #MAPTILEW*MAPSCRW,D5
            BGE     .OBST                   ; RIGHT SIDE IS OBSTACLE
            BTST    #15,D5
            BNE     .OBST                   ; LEFT SIDE IS OBSTACLE
            CMP.W   #MAPTILEH*MAPSCRH,D6
            BGE     .OBST                   ; BOTTOM IS OBSTACLE
            BTST    #15,D6
            BNE     .OBST                   : TOP IS OBSTACLE
            JSR     MAPGTTIL
            TST.W   D7
            BEQ     .FREE                   ; ID=0 -> CODE 00
            CMP.B   #2,D7
            BLE     .OBST                   ; ID=1 OR 2 -> CODE 10
            CMP.B   #3,D7
            BEQ     .DOOR                   ; ID=3 -> DOOR
.DMG        MOVE.B  #MAPDMG,D7              ; ID>=4 -> DAMAGING
            RTS
.DOOR       TST.W   (MAPNUMEN)
            BNE     .OBST                   ; IF STILL ENEMIES, CLOSED DOOR
.FREE       MOVE.B  #MAPFREE,D7
.END        RTS
.OBST       MOVE.B  #MAPOBS,D7
            RTS

; -----------------------------------------------------------------------------
MAPENMCR
; CREATES ENEMIES FOR THE CURRENT SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - THE ADOPTED DATA STRUCTURE FOR ENEMIES LEADS TO SLOW CREATION OF
;            ENEMIES SINCE THE WHOLE LIST HAS TO BE TRAVERSED. THIS IS ALMOST
;            UNNOTICEABLE FOR SMALL MAPS, AND EVEN IN LARGE MAPS MAY BE NE-
;            GLECTABLE BECAUSE THEY ARE CREATED DURING THE SCREEN CHANGE.
;            HOWEVER, IT COULD BE IMPROVED BY INDEXING DATA PER SCREEN, FOR
;            EXAMPLE.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5/A0-A1,-(A7)
            CLR.W   D5                      ; ENEMY COUNTER
            JSR     MAPGTFLA
            MOVE.W  (A0),D0                 ; GET FLAG
            AND.W   #MAPSCRCM,D0            ; CHECK IF SCREEN ALREADY COMPLETED
            BNE     .END                    ; YES: DO NOT PUT ENEMIES AGAIN
            MOVE.W  (MAPPOSX),D4            ; FORMAT CURRENT SCREEN DATA
            SWAP    D4
            MOVE.W  (MAPPOSY),D4
            LEA     ENMDATA,A0              ; GET ENEMY LIST
.LOOP       MOVE.L  (A0),D1                 ; GET DATA
            CMP.L   #$FFFFFFFF,D1           ; TERMINATOR REACHED?
            BEQ     .END                    ; IF SO, EXIT
            CMP.L   D1,D4                   ; ENEMY IN CURRENT SCREEN
            BNE     .NEXT
            ADDQ.W  #1,D5                   ; COUNT ENEMIES
            MOVE.L  4(A0),D1
            MOVE.W  8(A0),D2
            MOVE.L  10(A0),D3
            LEA     ENMINIT,A1
            LEA     ENMUPD,A2
            LEA     ENMPLOT,A3
            MOVE.W  #ENMTYPE,D0
            JSR     AGLADD
.NEXT       ADD.L   #14,A0                  ; GO TO NEXT ENEMY
            BRA     .LOOP
.END        MOVE.W  D5,(MAPNUMEN)           ; STORE THE NUMBER OF ENEMIES
            MOVEM.L (A7)+,D0-D5/A0-A1
            RTS

; -----------------------------------------------------------------------------
MAPENMDL
; DELETES ALL ENEMIES AND EXPLOSIONS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.W  #EXPTYPE,D0
            JSR     .DOKILL
            MOVE.W  #ENMTYPE,D0
            JSR     .DOKILL
            CLR.W   (MAPNUMEN)
            MOVEM.L (A7)+,D0/A0
            RTS
.DOKILL     JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .END
            JSR     DMMFREE
            JSR     DMMNEXTO
            BRA     .LOOP
.END        RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
