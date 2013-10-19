describe 'Piece', () ->
    beforeEach module 'Piece'

    describe 'Piece', () ->
        piece = new Piece 'player1'

        it "canMove", () ->
            expect(piece.canMove(-1, 0)).toBe false
            expect(piece.canMove(12, 11)).toBe false

    describe 'Giraffe', () ->
        giraffe = new Giraffe 'player1'

        it "canMove", () ->
            oldPos = 7
            for newPos in [4, 8, 6, 10]
                expect(giraffe.canMove(newPos, oldPos)).toBe true
            for newPos in [3, 5, 9, 11]
                expect(giraffe.canMove(newPos, oldPos)).toBe false

            expect(giraffe.canMove(7, 1)).toBe false
            expect(giraffe.canMove(2, 3)).toBe false

    describe 'Lion', () ->
        lion = new Lion 'player1'

        it "canMove", () ->
            oldPos = 7
            for newPos in [3, 4, 5, 6, 8, 9, 10, 11]
                expect(lion.canMove(newPos, oldPos)).toBe true

            expect(lion.canMove(7, 1)).toBe false
            expect(lion.canMove(2, 3)).toBe false

    describe 'Elephant', () ->
        elephant = new Elephant 'player1'

        it "canMove", () ->
            oldPos = 7
            for newPos in [4, 8, 6, 10]
                expect(elephant.canMove(newPos, oldPos)).toBe false
            for newPos in [3, 5, 9, 11]
                expect(elephant.canMove(newPos, oldPos)).toBe true

            expect(elephant.canMove(2, 6)).toBe false
            expect(elephant.canMove(2, 3)).toBe false

    describe 'Chick', () ->
        describe 'Player1', () ->
            chick = new Chick 'player1'
            oldPos = 7
            for newPos in [3, 5, 6, 8, 9, 10, 11]
                it "canMove #{oldPos} -> #{newPos}", () ->
                    expect(chick.canMove(newPos, oldPos)).toBe false

            it "canMove 7 -> 4", () ->
                expect(chick.canMove(4, 7)).toBe true
            it "canMove 7 -> 1", () ->
                expect(chick.canMove(1, 7)).toBe false

        describe 'Player2', () ->
            chick = new Chick 'player2'
            oldPos = 7
            for newPos in [3, 4, 5, 6, 8, 9, 11]
                it "#{oldPos} -> #{newPos}", () ->
                    expect(chick.canMove(newPos, oldPos)).toBe false

            it "canMove 7 -> 10", () ->
                expect(chick.canMove(10, 7)).toBe true
            it "canMove 7 -> 1", () ->
                expect(chick.canMove(7, 1)).toBe false

    describe 'Chicken', () ->
        describe 'Player1', () ->
            chicken = new Chicken 'player1'
            oldPos = 7
            for newPos in [3, 4, 5, 6, 8, 10]
                it "canMove #{oldPos} -> #{newPos}", () ->
                    expect(chicken.canMove(newPos, oldPos)).toBe true

            it "canMove 7 -> 9", () ->
                expect(chicken.canMove(9, 7)).toBe false
            it "canMove 7 -> 11", () ->
                expect(chicken.canMove(11, 7)).toBe false

        describe 'Player2', () ->
            chicken = new Chicken 'player2'
            oldPos = 7
            for newPos in [4, 6, 8, 9, 10, 11]
                it "canMove #{oldPos} -> #{newPos}", () ->
                    expect(chicken.canMove(newPos, oldPos)).toBe true

            it "canMove 7 -> 3", () ->
                expect(chicken.canMove(3, 7)).toBe false
            it "canMove 7 -> 5", () ->
                expect(chicken.canMove(5, 7)).toBe false

