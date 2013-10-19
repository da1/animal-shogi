'use strict'

angular.module('animalShogiApp')
  .controller 'MainCtrl', ($scope) ->
    player1 = new Player "player1"
    player2 = new Player "player2"

    $scope.cells = initializeBard(player1, player2)
    $scope.$watch 'cells', (newValue, oldValue) ->
        $scope.cells = newValue

    $scope.mode = new Mode "gameStart"

    $scope.turn = new Turn(player1, player2)
    $scope.$watch 'turn', (newValue, oldValue) ->
        $scope.turn = newValue

    $scope.action = "番です"

    $scope.move = (pos) ->
        switch $scope.mode.mode
            when "gameEnd" then ''
            when "gameStart" then gameStart $scope, pos
            when "choicePieceInHand" then choicePieceInHand $scope, pos
            when "choicePieceOnBoard" then choicePieceOnBoard $scope, pos
            else console.log "unkown mode", $scope.mode.mode

    $scope.put = (piece) ->
        switch $scope.mode.mode
            when "gameEnd", "choicePieceInHand", "choicePieceOnBoard" then ''
            when "gameStart"
                return if piece.player != $scope.turn.activePlayer.name
                $scope.mode.set("choicePieceInHand", piece)
            else console.log "unkown mode", $scope.mode.mode

gameStart = ($scope, pos) ->
    return if isEmptyCell($scope.cells[pos])
    return if isEnemyPiece($scope.turn.activePlayer, $scope.cells[pos].piece)
    $scope.mode.set("choicePieceOnBoard", pos)

choicePieceOnBoard = ($scope, pos) ->
    activePlayer = $scope.turn.activePlayer
    buf = $scope.mode.data
    piece = $scope.cells[buf].piece
    if piece.canMove(pos, buf)
        if isEmptyCell($scope.cells[pos].piece)
            $scope.cells[pos].piece = $scope.cells[buf].piece
            $scope.cells[buf].piece = emptyPiece()
        else if isEnemyPiece($scope.turn.activePlayer, $scope.cells[pos].piece)
            enemyPiece = $scope.cells[pos].piece
            enemyPiece.player = $scope.turn.activePlayer.name
            if enemyPiece.constructor.name is 'Chicken'
                enemyPiece = enemyPiece.ungrow()

            $scope.turn.activePlayer.get(enemyPiece)
            $scope.cells[pos].piece = $scope.cells[buf].piece
            $scope.cells[buf].piece = emptyPiece()

        if piece.constructor.name is 'Chick'
            if isTryArea $scope.turn.active, pos
                chicken = piece.grow()
                $scope.cells[pos].piece = chicken

        lionPos = -1
        lionPos = pos if piece.constructor.name is 'Lion'
        if checkYouWin(activePlayer, lionPos, $scope.turn, $scope.cells)
            $scope.action = "勝ちです"
            $scope.mode.set("gameEnd", activePlayer.name)
            return
        else
            $scope.action = "番です"
            $scope.turn.turnSwitch()
    else
        console.log "cannot move", buf, pos
    $scope.mode.set("gameStart", "")

choicePieceInHand = ($scope, pos) ->
    activePlayer = $scope.turn.activePlayer
    targetPos = $scope.cells[pos]
    targetPiece = $scope.mode.data
    return unless isEmptyCell(targetPos.piece)

    $scope.cells[pos].piece = targetPiece
    activePlayer.put(targetPiece.constructor.name)
    $scope.mode.set("gameStart", "")
    $scope.turn.turnSwitch()
    return

emptyPiece = ->
    return new Piece "", ""

isEmptyCell = (piece) ->
    return piece.name == ""

isEnemyPiece = (player, targetPiece) ->
    return player.name != targetPiece.player

checkYouWin = (player, lionPos, turn, cells) ->
    return true if player.has('Lion')
    if lionPos >= 0
        if isTryArea(turn.active, lionPos)
            for i in [-4, -3, -2, -1, 1, 2, 3, 4]
                index = lionPos + i
                continue if index < 0
                continue if index > 12
                piece = cells[index].piece
                continue if isEmptyCell(piece)
                if isEnemyPiece(player, piece)
                    return false if piece.canMove(lionPos, index)
            return true
    return false

class Mode
    # gameStart
    # choicePieceOnBoard
    # choicePieceInHand
    # gameEnd
    constructor: (@mode, @data) ->
    set: (modeName, data) ->
        @mode = modeName
        @data = data

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
        @havePiece = [] unless @havePiece
    get: (piece) ->
        @havePiece.push(piece)
    put: (name) ->
        for i in [0..@havePiece.length - 1]
            if @havePiece[i].constructor.name == name
                @havePiece.splice(i, 1)
                return
    has: (className) ->
        findPiece = _.find(@havePiece, (p) ->
            p.constructor.name == className
        )
        return findPiece?


