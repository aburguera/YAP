; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- GENERAL PURPOSE VARIABLES -----------------------------------------------

GENFRMCT    DS.B    1                       ; FRAME COUNTER

; --- PLAYER RELATED VARIABLES ------------------------------------------------

; VARIABLES SPECIFIC FOR PLAYER (NOT IN AGENT DATABLOCK)

PLRLIFE     DS.W    1                       ; PLAYER'S LIFE

PLRDBLK                                     ; PLACEHOLDER FOR DATABLOCK

; PLAYER VARIABLES

PLRFACE     DS.W    1                       ; FACE RIGHT OR LEFT
PLRPOSX     DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY     DS.L    1                       ; PLAYER Y POSITION (PIX, FIX. PNT)
PLRSPDY     DS.L    1                       ; PLAYER Y SPEED (PIX, FIX. PNT)

; PLAYER COMMANDS

PLRMOT      DS.B    1                       ; DESIRED MOTION (KBDVAL FORMAT)

; PLAYER PARAMETERS. STORED IN RAM TO REUSE GENERIC AGENT CODE

PLRTYPE     DS.B    1                       ; SET TO FF
PLRFRMS     DS.L    1                       ; MSW LEFT FRAME, LSW RIGHT FRAME
PLRSPDX     DS.W    1                       ; PLAYER X SPEED

; --- MAP RELATED VARIABLES --------------------------------------------------

MAPPOSX     DS.W    1                       ; CURRENT SCREEN X
MAPPOSY     DS.W    1                       ; CURRENT SCREEN Y
MAPSCPTR    DS.L    1                       ; CURRENT SCREEN POINTER
MAPNUMEN    DS.W    1                       ; NUMBER OF LIVING ENEMIES IN SCR
MAPCMPLT    DS.W    MAPWIDTH*MAPHEIGH       ; FLAGS FOR VISITED/COMPLETED ROOM

; --- GAME OVER RELATED VARIABLES --------------------------------------------

GOVCUROF    DS.W    1                       ; CURTAIN OFFSET FOR GAME OVER

; --- ATTRACT MODE RELATED VARIABLES -----------------------------------------

ATRPTR      DS.L    1                       ; POINTER TO CURRENT KEYSTROKE
ATRCTR      DS.W    1                       ; ATTRACT MODE COUNTER
ATRTUTP     DS.L    1                       ; POINTER TO TUTORIAL TEXT

; --- AUDIO RELATED VARIABLES ------------------------------------------------

AUDACCSN    DS.B    1                       ; ACCEPT NEW SOUNDS?
            DS.W    0

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
