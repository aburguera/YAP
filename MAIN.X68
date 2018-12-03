; =============================================================================
; TITLE    : YAP: YET ANOTHER PLATFORMER
; AUTHOR   : ANTONI BURGUERA
; CREATION : 2-DEC-2018
; =============================================================================

            OPT     MEX

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; USER CONSTANTS
            INCLUDE "UTIL.X68"              ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "GENERAL.X68"           ; GENERAL PURPOSE, GAME RELATED
            INCLUDE "AUDIO.X68"             ; AUDIO MANAGEMENT
            INCLUDE "GFX.X68"               ; GRAPHICS MANAGEMENT
            INCLUDE "MAP.X68"               ; MAP MANAGEMENT
            INCLUDE "AGENT.X68"             ; AGENT MANAGEMENT
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "ENEMY.X68"             ; ENEMY MANAGEMENT
            INCLUDE "EXPLO.X68"             ; EXPLOSION MANAGEMENT
            INCLUDE "GOVER.X68"             ; GAME OVER MANAGEMENT
            INCLUDE "ATTRACT.X68"           ; ATTRACT MODE MANAGEMENT
            INCLUDE "INTRO.X68"             ; INTRO (TITLE) MANAGEMENT
            INCLUDE "VICTORY.X68"           ; VICTORY MANAGEMENT
            INCLUDE "STATES.X68"            ; GAME STATES MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT

; --- DATA INCLUDES -----------------------------------------------------------

            INCLUDE "DATA/GFXDATA.X68"      ; GRAPHICS DATA
            INCLUDE "DATA/MAPDATA.X68"      ; MAP DATA
            INCLUDE "DATA/STRDATA.X68"      ; STRING DATA
            IFEQ    ATRSAVE                 ; ONLY IF NOT SAVING
ATRDATA     INCBIN  'DATA/KEYSTROK.DAT'     ; RECORDED DATA (FOR ATTRACT MODE)
            DS.W    0
            ENDC

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM CODE
            JSR     STAINIT                 ; INITIALIZE GAME STATE
            JSR     AUDINIT                 ; INITIALIZE THE AUDIO MANAGER

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD                  ; UPDATE DEPENDING ON THE STATE

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     STAPLOT                 ; PLOT DEPENDING ON THE STATE
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"            ; SYSTEM VARIABLES
            INCLUDE "VAR.X68"               ; GAME VARIABLES
            END    START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
