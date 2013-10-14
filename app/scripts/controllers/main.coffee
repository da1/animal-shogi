'use strict'

angular.module('animalShogiApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]

    player1 = new Player "player1"
    player2 = new Player "player2"

    $scope.cells = initializeBard(player1, player2)
    $scope.$watch('cells', (newValue, oldValue) ->
        $scope.cells = newValue
    )

    $scope.mode = new Mode()
    $scope.bufferOfOldPosition = new BufferOfOldPosition()

    $scope.turn = new Turn(player1, player2)
    $scope.$watch('turn', (newValue, oldValue) ->
        $scope.turn = newValue
    )

    $scope.move = (pos) ->
        activePlayer = $scope.turn.activePlayer
        if $scope.mode.mode == "putPiece"
            targetPos = $scope.cells[pos]
            targetPiece = $scope.mode.data
            return unless isEmptyCell(targetPos.piece)
            $scope.cells[pos].piece = targetPiece
            activePlayer.put(targetPiece.name)
            $scope.mode.set("", {})
            $scope.turn.turnSwitch()
            return

        if $scope.bufferOfOldPosition.isEnemy()
            return if isEmptyCell($scope.cells[pos])
            return if isEnemyPiece($scope.turn.activePlayer, $scope.cells[pos].piece)
            $scope.bufferOfOldPosition.set(pos)
        else
            buf = $scope.bufferOfOldPosition.get()
            piece = $scope.cells[buf].piece
            if piece.canMove(pos, buf)
                if isEmptyCell($scope.cells[pos].piece)
                    $scope.cells[pos].piece = $scope.cells[buf].piece
                    $scope.cells[buf].piece = emptyPiece()
                else if isEnemyPiece($scope.turn.activePlayer, $scope.cells[pos].piece)
                    enemyPiece = $scope.cells[pos].piece
                    enemyPiece.player = $scope.turn.activePlayer.name
                    $scope.turn.activePlayer.get(enemyPiece)
                    $scope.cells[pos].piece = $scope.cells[buf].piece
                    $scope.cells[buf].piece = emptyPiece()
                $scope.turn.turnSwitch()
            else
                console.log "cannot move", buf, pos
            $scope.bufferOfOldPosition.reset()

    $scope.put = (piece) ->
        return if piece.player != $scope.turn.activePlayer.name
        $scope.mode.set("putPiece", piece)


BOARD_WIDTH = 3
BOARD_HEIGHT = 4

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


emptyPiece = ->
    return new Piece "", ""

isEmptyCell = (piece) ->
    return piece.name == ""

isEnemyPiece = (player, targetPiece) ->
    return player.name != targetPiece.player

initializeBard = (player1, player2) ->
    cells = ({ position: i, piece: emptyPiece() } for i in [0..11])

    cells[0].piece = new Giraffe player2.name
    cells[1].piece = new Lion player2.name
    cells[2].piece = new Elephant player2.name
    cells[4].piece = new Chick player2.name

    cells[11].piece = new Giraffe player1.name
    cells[10].piece = new Lion player1.name
    cells[9].piece  = new Elephant player1.name
    cells[7].piece  = new Chick player1.name
    return cells

class Mode
    constructor: (@mode, @data) ->
    set: (modeName, data) ->
        @mode = modeName
        @data = data

class BufferOfOldPosition
    constructor: (@pos=-1)->
    isEnemy: ->
        return @pos < 0
    reset: ->
        @pos = -1
    set: (pos) ->
        @pos = pos
    get: ->
        return @pos

class Turn
    @players
    @active
    @activePlayer
    constructor:(player1, player2) ->
        @players = [player1, player2]
        @active = 0
        @activePlayer = @players[@active]
    turnSwitch: ->
        @active = if @active == 0 then 1 else 0
        @activePlayer = @players[@active]

class Player
    constructor: (@name, @havePiece) ->
        @havePiece = []
    get: (piece) ->
        @havePiece.push(piece)
    put: (name) ->
        for i in [0..@havePiece.length - 1]
            if @havePiece[i].name == name
                @havePiece.splice(i, 1)
                return


