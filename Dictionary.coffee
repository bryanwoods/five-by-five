#START:constructor
class Dictionary  
  constructor: (@originalWordList, grid) ->
    @setGrid grid if grid?

  setGrid: (@grid) ->
    @wordList      = @originalWordList.slice(0)
    @wordList      = (word for word in @wordList when word.length <= @grid.size)
    @minWordLength = Math.min.apply Math, (w.length for w in @wordList)
    @usedWords     = []
    for x in [0...@grid.size]
      for y in [0...@grid.size]
        @markUsed word for word in @wordsThroughTile x, y

  markUsed: (str) ->
    if str in @usedWords
      false
    else
      @usedWords.push str
      true

  isWord: (str) -> str in @wordList
  isNewWord: (str) -> str in @wordList and str not in @usedWords

  wordsThroughTile: (x, y) ->
    grid = @grid
    strings = []
    for length in [@minWordLength..grid.size]
      range = length - 1
      addTiles = (func) ->
        strings.push (func(i) for i in [0..range]).join ''
      for offset in [0...length]
        if grid.inRange(x - offset, y) and
           grid.inRange(x - offset + range, y)
          addTiles (i) -> grid.tiles[x - offset + i][y]
        if grid.inRange(x, y - offset) and
           grid.inRange(x, y - offset + range)
          addTiles (i) -> grid.tiles[x][y - offset + i]
        if grid.inRange(x - offset, y - offset) and
           grid.inRange(x - offset + range, y - offset + range)
          addTiles (i) -> grid.tiles[x - offset + i][y - offset + i]
        if grid.inRange(x - offset, y + offset) and
           grid.inRange(x - offset + range, y + offset - range)
          addTiles (i) -> grid.tiles[x - offset + i][y + offset - i]
    str for str in strings when @isWord str

root = exports ? window
root.Dictionary = Dictionary
