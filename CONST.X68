; =============================================================================
; USER CONSTANTS
; =============================================================================

; --- CONDITIONAL ASSEMBLY FLAGS ----------------------------------------------

; SET THEM TO ZERO TO REMOVE GRAPHICAL "SUGAR" AND GAIN SPEED IF NECESSARY.

CASSCRBG    EQU     1                       ; DRAW SCREEN BACKGROUND
CASFULMM    EQU     1                       ; FULLY DRAW THE MINIMAP
CASDETTL    EQU     1                       ; USE DETAILED TILES
CASDETSP    EQU     1                       ; USE DETAILED SPRITES

; --- GENERAL PURPOSE CONSTANTS -----------------------------------------------

GENCHRW     EQU     8                       ; WIDTH IN PIXELS OF A TEXT CHAR
GENCHRH     EQU     15                      ; HEIGHT IN PIXELS OF A TEXT CHAR

; --- AUDIO RELATED CONSTANTS -------------------------------------------------

AUDMU1ID    EQU     0                       ; ID OF ATTRACT MODE MUSIC
AUDMU2ID    EQU     1                       ; ID OF GAME OVER MUSIC
AUDMU3ID    EQU     2                       ; ID OF VICTORY MUSIC
AUDJMPID    EQU     3                       ; ID OF JUMP SOUND
AUDSPLID    EQU     4                       ; ID OF SPLASH SOUND
AUDWOAID    EQU     5                       ; ID OF WOAH SOUND
AUDFUNID    EQU     6                       ; ID OF FUNNY SOUND
AUDBNGID    EQU     7                       ; ID OF BOING SOUND
AUDENDID    EQU     $FF                     ; ID TO STOP ALL SOUNDS
AUDMSKLP    EQU     $80                     ; LOOP AUDIO MASK
AUDMSKNL    EQU     $00                     ; NO LOOP AUDIO MASK
AUDACCY     EQU     $FF                     ; ACCEPT PLAYING NEW SOUND
AUDACCN     EQU     $00                     ; DO NOT PLAY NEW SOUND

; --- MAP RELATED CONSTANTS ---------------------------------------------------

MAPINIX     EQU     0                       ; X OF INITIAL SCREEN
MAPINIY     EQU     0                       ; Y OF INITIAL SCREEN
MAPWIDTH    EQU     3                       ; NUMBER OF SCREENS HORIZONTALLY
MAPHEIGH    EQU     3                       ; NUMBER OF SCREENS VERTICALLY
MAPSCRW     EQU     20                      ; TILES PER SCREEN HORIZONTALLY
MAPSCRH     EQU     15                      ; TILES PER SCREEN VERTICALLY
MAPTILEW    EQU     32                      ; SIZE OF TILE, HORIZONTALLY
MAPTILEH    EQU     32                      ; SIZE OF TILE, VERTICALLY
MAPMINCS    EQU     2                       ; PIXELS PER CELL IN MINIMAP
MAPANIM0    EQU     4                       ; ANIMATED TILE 0
MAPANIM1    EQU     8                       ; ANIMATED TILE 1
MAPDOOR     EQU     3                       ; DOOR GRAPHIC ID
MAPFREE     EQU     %00                     ; FREE CELL CODE
MAPDMG      EQU     %01                     ; DAMAGING CELL CODE
MAPOBS      EQU     %10                     ; OBSTACLE CELL
MAPSCRCM    EQU     $00FF                   ; SCREEN COMPLETED
MAPSCRNC    EQU     $0000                   ; SCREEN NOT COMPLETED
MAPSCRVS    EQU     $FF00                   ; SCREEN VISITED
MAPSCRNV    EQU     $0000                   ; SCREEN NOT VISITED

; --- AGENT RELATED CONSTANTS -------------------------------------------------

AGNWIDTH    EQU     32                      ; AGENT WIDTH
AGNHEIGH    EQU     32                      ; AGENT HEIGHT
AGNBBXO     EQU     4                       ; BOUNDING BOX X OFFSET
AGNBBYO     EQU     4                       ; BOUNDING BOX Y OFFSET
AGNGACC     EQU     $0001F000               ; GRAVITY ACCELERATION (FIXED PNT)
AGNJMPSP    EQU     $FFEE0000               ; JUMPING INITIAL SPEED

; --- AGENT DATABLOCK OFFSETS -------------------------------------------------

; OFFSETS TO AGENT VARIABLES

AGNFRAOF    EQU     0                       ; BASE FRAME
AGNPOXOF    EQU     2                       ; X COORD
AGNPOYOF    EQU     4                       ; Y COORD
AGNSPYOF    EQU     8                       ; Y SPEED

; OFFSETS TO AGENT COMMANDS

AGNMOTOF    EQU     12                      ; DESIRED MOTION

; OFFSET TO AGENT PARAMETERS

AGNTYPOF    EQU     13                      ; TYPE
AGNFRMOF    EQU     14                      ; FRAMES FOR LEFT AND RIGHT
AGNSPXOF    EQU     18                      ; X SPEED

; --- PLAYER RELATED CONSTANTS ------------------------------------------------

PLRXINI     EQU     8*32
PLRYINI     EQU     9*32
PLRXSPD     EQU     4                       ; PLAYER HORIZONTAL SPEED
PLRFACER    EQU     12                      ; PLAYER BASE FRAME RIGHT
PLRFACEL    EQU     14                      ; PLAYER BASE FRAME LEFT
PLRFACEU    EQU     16                      ; PLAYER BASE FRAME UP
PLRLIFEI    EQU     255                     ; PLAYER INITIAL LIFE
PLRSCORH    EQU     16                      ; HEIGHT OF THE LIFE BAR
PLRSCORW    EQU     PLRLIFEI                ; WIDTH OF THE LIFE BAR
PLRSCOCF    EQU     $0000FF00               ; INNER BAR COLOR
PLRSCOCP    EQU     $000000FF               ; BORDER COLOR
PLRKILSP    EQU     12                      ; VERTICAL SPEED TO KILL ENEM (INT)

; --- ENEMY RELATED CONSTANTS -------------------------------------------------

ENMDMG      EQU     6                       ; DAMAGE PERFORMED BY ENEMY

; --- EXPLOSION RELATED CONSTANTS ---------------------------------------------

EXPGORE     EQU     10                      ; NUMBER OF BLOOD DROPS

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVCURTW    EQU     8                       ; CURTAIN PART WIDTH

; --- ATTRACT MODE RELATED CONSTANTS ------------------------------------------

ATRSAVE     EQU     0                       ; RECORD GAME? SEE ATTRACT.X68

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE
STAATTR     EQU     3                       ; ATTRACT MODE
STAVICT     EQU     4                       ; VICTORY STATE

; --- AGENT TYPES -------------------------------------------------------------

ENMTYPE     EQU     1
EXPTYPE     EQU     2



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
