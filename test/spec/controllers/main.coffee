'use strict'

describe 'Controller: MainCtrl', () ->

    # load the controller's module
    beforeEach module 'animalShogiApp'

    MainCtrl = {}
    scope = {}

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        MainCtrl = $controller 'MainCtrl', {
            $scope: scope
        }

    it 'count of cell', () ->
        expect(scope.cells.length).toBe 12
    it 'first mode is gameStart', () ->
        expect(scope.mode.mode).toBe 'gameStart'
    it 'active player is player1', () ->
        expect(scope.turn.activePlayer.name).toBe 'player1'

describe 'Player', () ->
    player = {}
    beforeEach () ->
        chick = new Chick "player"
        player = new Player "player", [chick]

    it 'has is no empty', () ->
        expect(player.havePiece.length).toBe 1
    it 'havePiece is empty', () ->
        player = new Player "player"
        expect(player.havePiece.length).toBe 0

    it 'has Chick', () ->
        expect(player.has('Chick')).toBe true

    it 'has not Lion', () ->
        expect(player.has('Lion')).toBe false

    it 'get', () ->
        player.get(new Elephant "player")
        expect(player.havePiece.length).toBe 2

    it 'put', () ->
        player.put('Chick')
        expect(player.havePiece.length).toBe 0


