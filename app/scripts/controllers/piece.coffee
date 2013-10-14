BOARD_WIDTH = 3
BOARD_HEIGHT = 4

isTryArea = (player, index) ->
    if player == 0
        return 0 <= index < BOARD_WIDTH
    if player == 1
        end = BOARD_WIDTH * BOARD_HEIGHT - 1
        start = end - BOARD_WIDTH
        return start <= index < end
    return false

class Piece
    constructor: (@name, @player) ->
    canMove:(newPos, oldPos) ->
        return false if newPos < 0
        return false if newPos >= BOARD_WIDTH * BOARD_HEIGHT
        return true

class Giraffe extends Piece
    constructor: (@player) ->
        super "き", @player
    canMove:(newPos, oldPos) ->
        newXY = toXY(newPos)
        oldXY = toXY(oldPos)
        return false unless adjacentWidthByObj(newXY, oldXY) || adjacentHeightByObj(newXY, oldXY)
        super newPos, oldPos

class Lion extends Piece
    constructor: (@player) ->
        super "ら", @player
    canMove:(newPos, oldPos) ->
        newXY = toXY(newPos)
        oldXY = toXY(oldPos)
        return false unless adjacentWidthByObj(newXY, oldXY) || adjacentHeightByObj(newXY, oldXY) || adjacentSkewByObj(newXY, oldXY)
        super newPos, oldPos

class Elephant extends Piece
    constructor: (@player) ->
        super "ぞ", @player
    canMove:(newPos, oldPos) ->
        newXY = toXY(newPos)
        oldXY = toXY(oldPos)
        return false unless adjacentSkewByObj(newXY, oldXY)
        super newPos, oldPos

class Chick extends Piece
    constructor: (@player) ->
        super "ひ", @player
    canMove:(newPos, oldPos) ->
        if @player == "player1"
            return false if newPos != oldPos - BOARD_WIDTH
        if @player == "player2"
            return false if newPos != oldPos + BOARD_WIDTH
        super newPos, oldPos
    grow: ->
        return new Chicken @player

class Chicken extends Piece
    constructor: (@player) ->
        super "に", @player
    canMove:(newPos, oldPos) ->
        newXY = toXY(newPos)
        oldXY = toXY(oldPos)
        if adjacentHeightByObj(newXY, oldXY) || adjacentWidthByObj(newXY, oldXY)
            return super newPos, oldPos
        if @player == "player1"
            return false unless Math.abs(newXY.x - oldXY.x) == 1 && newXY.y - oldXY.y == -1
        if @player == "player2"
            return false unless Math.abs(newXY.x - oldXY.x) == 1 && newXY.y - oldXY.y == 1
        super newPos, oldPos
    ungrow: ->
        return new Chick @player

adjacentWidth = (x1,y1, x2,y2) ->
    return x1 == x2 && Math.abs(y1 - y2) == 1

adjacentHeight = (x1,y1, x2,y2) ->
    return y1 == y2 && Math.abs(x1 - x2) == 1

adjacentSkew = (x1,y1, x2,y2) ->
    return Math.abs(x1 - x2) == 1 && Math.abs(y1 - y2) == 1

adjacentWidthByObj = (p1, p2) ->
    return adjacentWidth(p1.x, p1.y, p2.x, p2.y)

adjacentHeightByObj = (p1, p2) ->
    return adjacentHeight(p1.x, p1.y, p2.x, p2.y)

adjacentSkewByObj = (p1, p2) ->
    return adjacentSkew(p1.x, p1.y, p2.x, p2.y)

toXY = (pos) ->
    return { x: pos % BOARD_WIDTH, y:Math.floor(pos/BOARD_WIDTH) }

initializeBard = (player1, player2) ->
    size = BOARD_WIDTH * BOARD_HEIGHT - 1
    cells = ({ position: i, piece: emptyPiece() } for i in [0..size])

    cells[0].piece = new Giraffe player2.name
    cells[1].piece = new Lion player2.name
    cells[2].piece = new Elephant player2.name
    cells[4].piece = new Chick player2.name

    cells[11].piece = new Giraffe player1.name
    cells[10].piece = new Lion player1.name
    cells[9].piece  = new Elephant player1.name
    cells[7].piece  = new Chick player1.name
    return cells

