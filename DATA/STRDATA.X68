; =============================================================================
; TEXT DATA
; =============================================================================

; -----------------------------------------------------------------------------
; TITLE STRINGS
; -----------------------------------------------------------------------------

STRTIT0     DC.B    'YET ANOTHER PLATFORMER',0
STRTIT1     DC.B    'PRESS FIRE1 TO START',0
STRTIT2     DC.B    'WAIT TO SEE TUTORIAL',0
            DS.W    0

; -----------------------------------------------------------------------------
; GAME OVER TEXT BLOCK AND STRINGS.
; A TEXT BLOCK IS A LIST OF POINTERS TO STRINGS.
; -----------------------------------------------------------------------------

STRBLKGV    DC.L    .STR0,.STR1,0
.STR0       DC.B    'GAME OVER',0
.STR1       DC.B    'PUSH FIRE1 TO TRY AGAIN',0
            DS.W    0

; -----------------------------------------------------------------------------
; VICTORY TEXT BLOCK
; -----------------------------------------------------------------------------

STRBLKVI    DC.L    .STR0,.STR1,.STR2,.STR3,.STR4,.STR5,.STR6,.STR7,.STR8,0
.STR0       DC.B    'YOU WON!',0
.STR1       DC.B    'ALTHOUGH YOUR VICTORY MEANS',0
.STR2       DC.B    'THAT YOU EXTERMINATED A FULL',0
.STR3       DC.B    'WORLD OF CUTE ONE-EYED CREATURES,',0
.STR4       DC.B    'ALTHOUGH YOUR VICTORY IS CLEARLY',0
.STR5       DC.B    'A DELIBERATED GENOCIDE...',0
.STR6       DC.B    'IT WAS A TINY WORLD. JUST NINE SCREENS.',0
.STR7       DC.B    'I HOPE THIS MAKES YOU FEEL COMFORTABLE.',0
.STR8       DC.B    'I HOPE YOU CAN SLEEP AT NIGHT.',0
            DS.W    0

; -----------------------------------------------------------------------------
; TUTORIAL BOOK, BLOCKS AND STRINGS.
; A BOOK IS A LIST OF TEXT BLOCKS. THE FIRST PAGE IS DUPLICATED SINCE THE
; RECORDED KBDEDGE IS USED TO ADVANCE, SO ADVANCING COMES BEFORE SHOWING.
; -----------------------------------------------------------------------------

STRPAGAT    DC.L    .STD0,.STD0,.STD1,.STD2,.STD3,.STD4,.STD5,.STD6,.STD7,.STD8
            DC.L    .STD9,.STDA,.STDB,.STDC,.STDD,.STDE,0
.STD0       DC.L    .STR00,.STR01,0
.STD1       DC.L    .STR10,.STR11,.STR12,.STR13,0
.STD2       DC.L    .STR20,0
.STD3       DC.L    .STR30,.STR31,0
.STD4       DC.L    .STR40,.STR41,.STR42,.STR43,.STR44,.STR45,.STR46,0
.STD5       DC.L    .STR50,.STR51,.STR52,.STR53,.STR54,.STR55,.STR56,.STR57,0
.STD6       DC.L    .STR60,.STR61,0
.STD7       DC.L    .STR70,.STR71,.STR72,0
.STD8       DC.L    .STR80,.STR81,0
.STD9       DC.L    .STR90,.STR91,0
.STDA       DC.L    .STRA0,0
.STDB       DC.L    .STRB0,0
.STDC       DC.L    .STRC0,0
.STDD       DC.L    .STRD0,0
.STDE       DC.L    .STRE0,.STRE1,0
.STR00      DC.B    'USE LEFT AND RIGHT',0
.STR01      DC.B    'TO MOVE THE PLAYER',0
            DS.W    0
.STR10      DC.B    'BE CAREFUL! THEY MAY LOOK CUTE',0
.STR11      DC.B    'BUT THEY ARE THE BAD GUYS!',0
.STR12      DC.B    'IF THEY TOUCH YOU',0
.STR13      DC.B    'THEY WILL HARM YOU',0
            DS.W    0
.STR20      DC.B    'PRESS UP TO JUMP',0
            DS.W    0
.STR30      DC.B    'LIFE RECOVERS SLOWLY BY ITSELF',0
.STR31      DC.B    'WATCH THE LIFE BAR',0
            DS.W    0
.STR40      DC.B    'WHEN YOU REACH THE ',0
.STR41      DC.B    'CRITICAL FALLING SPEED',0
.STR42      DC.B    'A FLAME APPEARS AROUND YOU.',0
.STR43      DC.B    'BEFORE YOU ASK, THE ANSWER IS NO.',0
.STR44      DC.B    'THIS IS NOT A SUPERPOWER.',0
.STR45      DC.B    'SUPERPOWERS DO NOT EXIST.',0
.STR46      DC.B    'IT IS FRICTION WITH AIR.',0
            DS.W    0
.STR50      DC.B    'JUMP OVER AN ENEMY',0
.STR51      DC.B    'WITH CRITICAL SPEED',0
.STR52      DC.B    'AND YOU WILL KILL IT.',0
.STR53      DC.B    'BEWARE: THERE WILL BE BLOOD.',0
.STR54      DC.B    'TONS OF BLOOD.',0
.STR55      DC.B    'THIS GAME IS NOT FOR KIDS.',0
.STR56      DC.B    'IT IS FUCKING REALISTIC.',0
.STR57      DC.B    'NOT LIKE MARIO.',0
            DS.W    0
.STR60      DC.B    'KILL ALL THE ENEMIES IN ONE SCREEN',0
.STR61      DC.B    'TO OPEN THE DOOR',0
            DS.W    0
.STR70      DC.B    'WATCH THE MINI-MAP.',0
.STR71      DC.B    'YOU CAN SEE A MINIATURE VERSION',0
.STR72      DC.B    'OF THE VISITED SCREENS.',0
            DS.W    0
.STR80      DC.B    'HMMM... WHAT IS THAT RED LIQUID?',0
.STR81      DC.B    'IT MAY BE... RED WINE? RED COCA COLA?',0
            DS.W    0
.STR90      DC.B    'GLUP GLUP',0
.STR91      DC.B    'NO. IT DOES NOT TASTE GOOD.',0
            DS.W    0
.STRA0      DC.B    'NO ALCOHOL. NOT WINE.',0
            DS.W    0
.STRB0      DC.B    'HOT. NOT COCA COLA.',0
            DS.W    0
.STRC0      DC.B    'REALLY HOT!',0
            DS.W    0
.STRD0      DC.B    'DAMN! IT IS LAVA! BETTER DO NOT TOUCH IT.',0
            DS.W    0
.STRE0      DC.B    'ENJOY THE GAME!',0
.STRE1      DC.B    'ENJOY THE POWER OF ASSEMBLY LANGUAGE!',0
            DS.W    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
