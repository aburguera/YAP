# YAP - Yet Another Platformer

![Yet Another Platformer](https://github.com/aburguera/YAP/blob/master/YAP.PNG)

A basic platformer videogame coded in MC68000 assembly language using the EASy68K environment. It is aimed at providing students an example of medium complexity code.

* [Video of game with full specs](https://youtu.be/aAjG8LMOUrw)
* [Video of game with basic graphics](https://youtu.be/BzZwJ6aa8wY)

## Executing the game

This game is coded in MC68000 language but it relies on the graphics, sound and file system simulated by EASy68K. If you want to play the game you need the EASy68K assembler and simulator available at www.easy68k.com.

To play the game just open MAIN.X68 from the EASy68K editor and run it.

## Editing the game

Aside of modifying the code itself, which requires MC68000 and EASy68K knowledge, this program is provided with some basic editing capabilities.

### Changing graphics quality

Given the particular way in which EASy68K implements the graphic system, this game may be particularly slow in some computers. If this is your case, please open CONST.X68 and set to zero the conditional assembly flags. Just search the configuration that better suits your computer.

### Editing the map

The map is defined in DATA/MAPDATA.X68 and has two parts: the map itself and the enemies definition. Comments in DATA/MAPDATA.X68 are self-explanatory and will let you understand how the mapa is coded.

However, if you want to easily experiment, you can use the provided TILED interface. TILED is a map editor that can be downloaded in www.mapeditor.org. With TILED you can open and graphically edit the provided DATA/MAPDATA.tmx.

Then, you can execute the provided Python script (MapConverter.py). This script will create a new MAPDATA.X68 that can be used to overwrite DATA/MAPDATA.X68. Please note that in order to execute MapConverter.py you have to install this library: https://pypi.org/project/tmx/

### Recording a game

The game implements an attract mode which is, basically, the ability to reproduce a game automatically by means of pre-recorded key presses. By default, the attract mode is a tutorial. However, you can record your own game as follows.

First, open CONST.X68 and set ATRSAVE to 1. Then execute the game and play. When you want to stop recording just press M. Nothing will happen, but you can now stop the game. Please note that if you win or reach a game over condition, the game will not be properly saved.

Pressing M will create the file DATA/KEYSTROK.DAT. Please note that the existing KEYSTROK.DAT will be overwritten.

To see the recorded game, just change ATRSAVE back to 0, execute the game again and wait in the title screen until the recorded game begins.

### Changing the game behavior

The source code is fully commented so that you can figure out how it works.

## Troubleshooting

A substantial loss of speed may appear in some computers due to graphics. In some cases, running the game in a laptop relying on battery will lead to an extremely slow game whilst running the game in the same laptop connected to A/C will run at the correct speed. If the games runs really slow in your computer, please change the graphics quality as described above.

Attract mode may not work properly if a long game is recorded. I will be terribly honest here: it is because a bug. If you found where the bug is, please let me know.

## Credits

Game design, graphics and coding:

* Antoni Burguera Burguera

Music and sound effects:

* Slime Splash: Mike Koenig. http://soundbible.com/1097-Slime-Splash.html
* Jump: snottyboy. http://soundbible.com/1343-Jump.html
* Woah male. Sound Explorer. http://soundbible.com/1984-Woah-Male.html
* Funny voices. Daniel Simon. http://soundbible.com/2152-Funny-Voices.html
* Cartoon hoop. http://soundbible.com/85-Cartoon-Hop.html
* Lunge game (music). https://www.dl-sounds.com/royalty-free/lounge-game2/
* Rindu sad flute (music). https://www.dl-sounds.com/royalty-free/rindu-sad-flute/
* Victory (music). https://www.dl-sounds.com/royalty-free/victorious/
