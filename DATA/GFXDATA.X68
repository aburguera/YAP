; =============================================================================
; GRAPHICS DATA IN THE FORMAT ACCEPTED BY GFX.X68
; PICTURES WERE CREATED IN OPEN OFFICE DRAW USING ONLY BASIC SHAPES AND THE
; COORDINATES WERE MANUALLY EXTRACTED.
; NOT THAT THE COMPLEX AND THE SIMPLIFIED VERSIONS OF TILES AND SPRITES ARE
; HERE AND CONDITIONALLY ASSEMBLED DEPENDING ON THE ASSEMBLER FLAGS IN
; CONST.X68
; =============================================================================

; --- LIST OF POINTERS TO PICTURES --------------------------------------------

GFXLST      DC.L    .NOTHING                ; 0
            DC.L    .BRICK                  ; 1
            DC.L    .BRICK2                 ; 2
            DC.L    .DOOR                   ; 3
            DC.L    .FIREF0                 ; 4
            DC.L    .FIREF1                 ; 5
            DC.L    .FIREF2                 ; 6
            DC.L    .FIREF3                 ; 7
            DC.L    .LAVAF0                 ; 8
            DC.L    .LAVAF1                 ; 9
            DC.L    .LAVAF2                 ; 10
            DC.L    .LAVAF3                 ; 11
            DC.L    .PLR0                   ; 12
            DC.L    .PLR1                   ; 13
            DC.L    .PLL0                   ; 14
            DC.L    .PLL1                   ; 15
            DC.L    .ENEM00                 ; 16
            DC.L    .ENEM01                 ; 17
            DC.L    .ENEM10                 ; 18
            DC.L    .ENEM11                 ; 19
            DC.L    .ENEM20                 ; 20
            DC.L    .ENEM21                 ; 21
            DC.L    .ENEM30                 ; 22
            DC.L    .ENEM31                 ; 23
            DC.L    .ENEM4                  ; 24
            DC.L    .ENEM4                  ; 25
            DC.L    .LOGO                   ; 26


; --- PICTURE DATA ------------------------------------------------------------

.LOGO       DC.W    14,7
            DC.W    1
            DC.B    0,0,0,128
            DC.W    2
            DC.B    0,0,0,255
            DC.W    7,0,0
            DC.W    6,48,80
            DC.W    6,48,160
            DC.W    6,80,160
            DC.W    6,80,80
            DC.W    6,128,0
            DC.W    6,96,0
            DC.W    6,64,48
            DC.W    6,32,0
            DC.W    6,0,0
            DC.W    10,13,5

            DC.W    7,96,160
            DC.W    6,96,80
            DC.W    6,144,0
            DC.W    6,192,0
            DC.W    6,192,160
            DC.W    6,160,160
            DC.W    6,160,96
            DC.W    6,128,96
            DC.W    6,128,160
            DC.W    6,96,160
            DC.W    7,128,80
            DC.W    6,160,80
            DC.W    6,160,32
            DC.W    6,128,80
            DC.W    10,116,140

            DC.W    7,240,32
            DC.W    6,240,80
            DC.W    6,256,80
            DC.W    6,272,64
            DC.W    6,272,48
            DC.W    6,256,32
            DC.W    6,240,32
            DC.W    7,208,160
            DC.W    6,208,0
            DC.W    6,272,0
            DC.W    6,304,32
            DC.W    6,304,80
            DC.W    6,272,112
            DC.W    6,240,112
            DC.W    6,240,160
            DC.W    6,208,160
            DC.W    10,218,150
            DC.W    14,1
            DC.W    0

; --- DETAILED TILES ----------------------------------------------------------

            IFNE    CASDETTL
.NOTHING    DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,128,0,0
            DC.W    5,0,0,31,0
            DC.W    5,0,0,0,15
            DC.W    5,0,15,31,15
            DC.W    5,15,15,15,31
            DC.W    0

.LAVAF0     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,128,255
            DC.W    9,3,26,8,31
            DC.W    4
            DC.B    0,0,64,128
            DC.W    9,15,12,20,17
            DC.W    0

.LAVAF1     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,160,255
            DC.W    9,3,19,8,24
            DC.W    4
            DC.B    0,0,90,128
            DC.W    9,17,5,22,10
            DC.W    0

.LAVAF2     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,196,255
            DC.W    9,3,12,8,17
            DC.W    4
            DC.B    0,0,100,128
            DC.W    9,15,26,20,31
            DC.W    0

.LAVAF3     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,255,255
            DC.W    9,3,5,8,10
            DC.W    4
            DC.B    0,0,128,128
            DC.W    9,17,19,22,24
            DC.W    0

.BRICK      DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,51,102
            DC.W    8,3,0,31,12
            DC.W    8,0,15,14,28
            DC.W    8,17,15,31,28
            DC.W    4
            DC.B    0,0,102,153
            DC.W    8,5,2,31,12
            DC.W    8,0,17,14,28
            DC.W    8,19,17,31,28
            DC.W    0

.BRICK2     DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,51,102
            DC.W    8,3,0,29,29
            DC.W    4
            DC.B    0,0,102,153
            DC.W    8,6,3,29,29
            DC.W    0

.DOOR       DC.W    4
            DC.B    0,255,0,0
            DC.W    8,6,5,25,26
            DC.W    8,1,0,30,6
            DC.W    8,1,25,30,31
            DC.W    4
            DC.B    0,153,0,0
            DC.W    8,0,0,5,6
            DC.W    8,6,6,11,25
            DC.W    8,0,25,5,31
            DC.W    4
            DC.B    0,255,51,51
            DC.W    8,26,0,31,6
            DC.W    8,21,6,25,25
            DC.W    8,26,25,31,31
            DC.W    0

.FIREF0     DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28,31,31
            DC.W    9,0,25,5,31
            DC.W    9,10,25,15,31
            DC.W    9,21,25,26,31
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,5,25,10,31
            DC.W    9,15,25,21,31
            DC.W    9,26,25,31,31
            DC.W    4
            DC.B    0,153,255,255
            DC.W    9,1,25,2,27
            DC.W    9,11,25,12,27
            DC.W    9,21,25,23,27
            DC.W    0

.FIREF1     DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28-12,31,31
            DC.W    9,0,25-12,5,31-12
            DC.W    9,10,25-12,15,31-12
            DC.W    9,21,25-12,26,31-12
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,5,25-12,10,31-12
            DC.W    9,15,25-12,21,31-12
            DC.W    9,26,25-12,31,31-12
            DC.W    4
            DC.B    0,153,255,255
            DC.W    9,1,25-12,2,27-12
            DC.W    9,11,25-12,12,27-12
            DC.W    9,21,25-12,23,27-12
            DC.W    0

.FIREF2     DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28-12*2,31,31
            DC.W    9,0,25-12*2,5,31-12*2
            DC.W    9,10,25-12*2,15,31-12*2
            DC.W    9,21,25-12*2,26,31-12*2
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,5,25-12*2,10,31-12*2
            DC.W    9,15,25-12*2,21,31-12*2
            DC.W    9,26,25-12*2,31,31-12*2
            DC.W    4
            DC.B    0,153,255,255
            DC.W    9,1,25-12*2,2,27-12*2
            DC.W    9,11,25-12*2,12,27-12*2
            DC.W    9,21,25-12*2,23,27-12*2
            DC.W    0

.FIREF3     EQU     .FIREF1
            ENDC

; --- SIMPLIFIED TILES --------------------------------------------------------

            IFEQ    CASDETTL
.NOTHING    DC.W    4
            DC.B    0,0,0,0
            DC.W    8,0,0,31,31
            DC.W    0

.LAVAF0     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,255,255
            DC.W    12,14,26,19,31
            DC.W    0

.LAVAF1     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,255,255
            DC.W    12,14,19,19,24
            DC.W    0

.LAVAF2     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,255,255
            DC.W    12,14,12,19,17
            DC.W    0

.LAVAF3     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,255,255
            DC.W    12,14,5,19,10
            DC.W    0

.BRICK      DC.W    4
            DC.B    0,0,102,153
            DC.W    8,0,0,31,31
            DC.W    0

.BRICK2     DC.W    4
            DC.B    0,0,51,102
            DC.W    8,0,0,31,31
            DC.W    0

.DOOR       DC.W    4
            DC.B    0,255,0,0
            DC.W    8,0,0,31,31
            DC.W    0

.FIREF0     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28,31,31
            DC.W    0

.FIREF1     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28-12,31,31
            DC.W    0

.FIREF2     DC.W    4
            DC.B    0,0,0,255
            DC.W    8,0,28-12*2,31,31
            DC.W    0

.FIREF3     EQU     .FIREF1
            ENDC

; --- DETAILED SPRITES --------------------------------------------------------

            IFNE    CASDETSP
.PLR0       DC.W    4
            DC.B    0,0,51,255
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,0,153,255
            DC.W    9,2,2,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,14,6,23,15
            DC.W    9,26,6,31,12
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,20,9,23,12
            DC.W    9,29,9,31,11
            DC.W    9,16,20,23,26
            DC.W    0

.PLR1       DC.W    4
            DC.B    0,0,51,255
            DC.W    9,0,3,31,31
            DC.W    4
            DC.B    0,0,153,255
            DC.W    9,2,5,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,14,9,23,19
            DC.W    9,26,9,31,16
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,20,12,23,15
            DC.W    9,29,12,31,14
            DC.W    9,16,20,25,26
            DC.W    0

.PLL0       DC.W    4
            DC.B    0,0,51,255
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,2,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,8,6,17,15
            DC.W    9,0,6,5,12
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,8,9,11,12
            DC.W    9,0,9,2,11
            DC.W    9,8,20,15,26
            DC.W    0

.PLL1       DC.W    4
            DC.B    0,0,51,255
            DC.W    9,0,3,31,31
            DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,5,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,8,9,17,19
            DC.W    9,0,9,5,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,8,12,11,15
            DC.W    9,0,12,2,14
            DC.W    9,6,20,15,26
            DC.W    0

.ENEM00     DC.W    4
            DC.B    0,0,0,204
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,102,102,255
            DC.W    9,2,2,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,6,20,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,17,9,20,12
            DC.W    0

.ENEM01     DC.W    4
            DC.B    0,0,0,204
            DC.W    9,0,9,31,31
            DC.W    4
            DC.B    0,102,102,255
            DC.W    9,2,12,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,14,20,23
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,11,17,14,20
            DC.W    0

.ENEM10     DC.W    4
            DC.B    0,0,204,0
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,102,255,102
            DC.W    9,2,2,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,6,20,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,17,9,20,12
            DC.W    0

.ENEM11     DC.W    4
            DC.B    0,0,204,0
            DC.W    9,0,9,31,31
            DC.W    4
            DC.B    0,102,255,102
            DC.W    9,2,12,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,14,20,23
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,11,17,14,20
            DC.W    0

.ENEM20     DC.W    4
            DC.B    0,0,204,0
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,102,255,102
            DC.W    8,2,2,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,6,20,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,17,9,20,12
            DC.W    0

.ENEM21     DC.W    4
            DC.B    0,0,204,0
            DC.W    8,0,9,31,31
            DC.W    4
            DC.B    0,102,255,102
            DC.W    8,2,12,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,14,20,23
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,11,17,14,20
            DC.W    0

.ENEM30     DC.W    4
            DC.B    0,0,51,102
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,102,153
            DC.W    8,2,2,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,6,20,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,17,9,20,12
            DC.W    0

.ENEM31     DC.W    4
            DC.B    0,0,51,102
            DC.W    8,0,9,31,31
            DC.W    4
            DC.B    0,0,102,153
            DC.W    8,2,12,29,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,11,14,20,23
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,11,17,14,20
            DC.W    0

.ENEM4      DC.W    4
            DC.B    0,0,51,255
            DC.W    8,0,0,31,31
            DC.W    4
            DC.B    0,0,153,255
            DC.W    8,2,2,29,31
            DC.W    0
            ENDC

; --- SIMPLIFIED SPRITES ------------------------------------------------------

            IFEQ    CASDETSP
.PLR0       DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,14,6,23,15
            DC.W    9,26,6,31,12
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,20,9,23,12
            DC.W    9,29,9,31,11
            DC.W    0

.PLR1       DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,3,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,14,9,23,19
            DC.W    9,26,9,31,16
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,20,12,23,15
            DC.W    9,29,12,31,14
            DC.W    0

.PLL0       DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,0,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,8,6,17,15
            DC.W    9,0,6,5,12
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,8,9,11,12
            DC.W    9,0,9,2,11
            DC.W    0

.PLL1       DC.W    4
            DC.B    0,0,153,255
            DC.W    9,0,3,31,31
            DC.W    4
            DC.B    0,255,255,255
            DC.W    9,8,9,17,19
            DC.W    9,0,9,5,15
            DC.W    4
            DC.B    0,0,0,0
            DC.W    9,8,12,11,15
            DC.W    9,0,12,2,14
            DC.W    0

.ENEM00     DC.W    4
            DC.B    0,102,102,255
            DC.W    9,0,0,31,31
            DC.W    0

.ENEM01     DC.W    4
            DC.B    0,102,102,255
            DC.W    9,0,12,31,31
            DC.W    0

.ENEM10     DC.W    4
            DC.B    0,102,255,102
            DC.W    9,0,0,31,31
            DC.W    0

.ENEM11     DC.W    4
            DC.B    0,102,255,102
            DC.W    9,0,12,31,31
            DC.W    0

.ENEM20     DC.W    4
            DC.B    0,102,255,102
            DC.W    8,0,0,31,31
            DC.W    0

.ENEM21     DC.W    4
            DC.B    0,102,255,102
            DC.W    8,0,12,31,31
            DC.W    0

.ENEM30     DC.W    4
            DC.B    0,0,102,153
            DC.W    8,0,0,31,31
            DC.W    0

.ENEM31     DC.W    4
            DC.B    0,0,102,153
            DC.W    8,0,12,31,31
            DC.W    0

.ENEM4      DC.W    4
            DC.B    0,0,153,255
            DC.W    8,0,0,31,31
            DC.W    0
            ENDC
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
