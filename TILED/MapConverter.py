import os
import sys
import math
import tmx

class MapConverter:
    def _global_to_local(self,globalRow,globalCol):
        screenRow=math.floor(globalRow/self._screenRows)
        screenCol=math.floor(globalCol/self._screenCols)
        localRowPix=int((globalRow-screenRow*self._screenRows)*self._tileSize)
        localColPix=int((globalCol-screenCol*self._screenCols)*self._tileSize)
        screenRow=int(screenRow)
        screenCol=int(screenCol)
        return [screenRow,screenCol,localRowPix,localColPix]

    def _load(self,fileName,mapCols,mapRows,screenCols,screenRows,firstEnem,tileSize,enemSpeeds):
        self._tmxMap=tmx.TileMap.load(fileName)
        self._baseName=os.path.splitext(os.path.basename(fileName))[0]
        self._screenRows=screenRows
        self._screenCols=screenCols
        self._mapRows=mapRows
        self._mapCols=mapCols
        self._firstEnem=firstEnem
        self._tileSize=tileSize
        self._enemSpeeds=enemSpeeds
        if mapRows!=self._tmxMap.height or mapCols!=self._tmxMap.width:
            sys.exit('[ERROR] TMX MAP HAS NOT THE SPECIFIED SIZE')
        if not((mapRows/screenRows).is_integer() and (mapCols/screenCols).is_integer()):
            sys.exit('[ERROR] MAP AND SCREEN SIZES ARE NOT CONSISTENT')

    def _process(self):
        self._mapData=[]
        self._enemData=[]
        for rowIndex in range(self._mapRows):
            for colIndex in range(self._mapCols):
                curValue=self._tmxMap.layers[0].tiles[colIndex+rowIndex*self._mapCols].gid-1
                if curValue<self._firstEnem:
                    self._mapData.append(curValue)
                else:
                    self._mapData.append(0)
                    [screenRow,screenCol,localRowPix,localColPix]=self._global_to_local(rowIndex,colIndex)
                    baseFrame=int(int(curValue) & 0xFFFE)
                    theType=int((baseFrame-self._firstEnem)/2)
                    self._enemData.append([screenRow,screenCol,self._enemSpeeds[theType],localRowPix,localColPix,theType,baseFrame])

    def _save(self):
        mainHeader='; =============================================================================\n; THIS FILE HAS BEEN GENERATED BY MAPCONVERTER.PY FROM A TILED MAP.\n; =============================================================================\n\n'
        mapDataHeader='; -----------------------------------------------------------------------------\n; MAPDATA IS A RAW MATRIX STORED ROW BY ROW REPRESENTING THE WHOLE MAP. EACH\n; CELL IS A GRAPHIC ID.\n; -----------------------------------------------------------------------------\n\n'
        enemDataHeader='; -----------------------------------------------------------------------------\n; ENEMDATA STORES, FOR EACH ENEMY IN THE MAP:\n; - A LONG STATING SCREEN X (HIGH WORD) AND Y (LOW WORD) WHERE IS THE ENEMY.\n; - THE DATA TO PASS TO D1,D2 AND D3 IN ENEMINIT\n; - A LONG FFFFFFFF IS USED AS TERMINATOR.\n; -----------------------------------------------------------------------------\n\n'
        with open(self._baseName+'.X68','w') as outFile:
            outFile.write(mainHeader)
            outFile.write(mapDataHeader)
            curLine='MAPDATA     DC.W    '
            for mapCell in self._mapData:
                curLine+='$%02x,' % int(mapCell)
                if len(curLine)>76:
                    outFile.write(curLine[:-1]+'\n')
                    curLine='            DC.W    '
            if len(curLine.strip())>4:
                outFile.write(curLine)

            outFile.write('\n'+enemDataHeader)
            curPrefix='ENMDATA     DC.L    '
            for curEnem in self._enemData:
                xScreen=curEnem[1]
                yScreen=curEnem[0]
                theSpeed=curEnem[2]
                xEnem=curEnem[4]
                yEnem=curEnem[3]
                theType=curEnem[5]
                baseFrame=curEnem[6]
                outFile.write(curPrefix+'$%08X' % int((xScreen & 0xFFFF)<<16 | (yScreen & 0xFFFF))+'\n')
                outFile.write('            DC.L    '+'$%08X' % int((theSpeed & 0xFFFF)<<16 | (xEnem & 0xFFFF))+'\n')
                outFile.write('            DC.W    '+'$%04X' % int((yEnem & 0xFFFF))+'\n')
                outFile.write('            DC.L    '+'$%08X' % int((theType & 0xFFFF)<<16 | (baseFrame & 0xFFFF))+'\n\n')
                curPrefix='            DC.L    '
            outFile.write('            DC.L    $FFFFFFFF')

    def __init__(self,fileName,mapCols,mapRows,screenCols,screenRows,firstEnem,tileSize,enemSpeeds):
        self._load(fileName,mapCols,mapRows,screenCols,screenRows,firstEnem,tileSize,enemSpeeds)
        self._process()
        self._save()

MapConverter('MAPDATA.tmx',60,45,20,15,16,32,[4,4,3,3,4])