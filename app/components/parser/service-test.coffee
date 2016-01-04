# TODO: Adapted parser for use in api
# in einer zelle NaN (usw.) behandeln
# nur noch in zellen nachschauen, in denen in den bisherigen zeilen true (in zelle kommt potentielle coordinate vor) vorkam
# TEST extractCoordinatesFromOneCell
# Implement GaussKrueger and UTM

"use strict"

describe "Service Parser", ->
    beforeEach ->
        @Parser = window.Parser

    xit 'should find columns of the latitude and longitude in dataset', ->
        dataset = [
            ["Salzburg", "41,5%", "47.349", "13.892"]
            ["Wien", "38,5%", "46.841", "12.348"]
            ["Bregenz", "40,5%", "46.323", "11.234"]
            ["Linz", "39,5%", "49.823", "10.348"]
        ]
        indexCoordinates =
            x: 2
            y: 3
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["47.349", "13.892", "Salzburg", "41,5%"]
            ["46.841", "12.348", "Wien", "38,5%"]
            ["46.323", "11.234", "Bregenz", "40,5%"]
            ["49.823", "10.348", "Linz", "39,5%"]
        ]
        indexCoordinates =
            x: 0
            y: 1
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

    xit 'should find coordinates (which are stored in one column) in the dataset', ->
        dataset = [
            ["47.349,13.892", "Salzburg", "41,5%"]
            ["46.841,12.348", "Wien", "38,5%"]
            ["46.323,11.234", "Bregenz", "40,5%"]
            ["49.823,10.348", "Linz", "39,5%"]
        ]
        indexCoordinates =
            xy: 0
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "47,13"]
            ["Gnigl", "41,5%", "48,12"]
            ["Gneis", "41,5%", "49,13"]
        ]
        indexCoordinates =
            xy: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)


        dataset = [
            ["Innsbruck", "41,5%", "49,12"]
            ["Salzburg", "41,5%", "49,13"]
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "word,13"]
        ]
        indexCoordinates =
            xy: 2

        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "180° 59' 0 me'', 180° 1 59.999 W"]
            ["Salzburg", "39,5%", "N 90 59 59.999, 180° 1 59.999 W"]
            ["Gneis", "41,5%", "180° 59' 0'', 180° 1 59.999 W"]
            ["Gnigl", "40,5%", "N 90 59 0, 0° 1 59.999 W"]
        ]
        indexCoordinates =
            xy: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            [null, "13", "47", null]
            [null, "13", "47", null]
            ["11", "13", "47", "48"]
            ["12", "13", "47", null]
        ]
        indexCoordinates =
            x: 1
            y: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["10", "13", "47", null]
            [null, null, null, "18"]
            ["11", "11", "test", "48"]
            ["12", "13", "47", null]
        ]
        indexCoordinates =
            x: 0
            y: 1
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["test", "13", "47", null]
            ["test", "12", "48", null]
            [null, "11", "49", null]
            [null, null, "49", "12"]
            [null, null, "49", "12"]
        ]
        indexCoordinates =
            x: 1
            y: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

    # should be easier to find coordinates via header then via the complete dataset
    xit 'should find the columns of the latitude and longitude in dataset with header', ->
        dataset = [
            ["City", "Content", "GEOMETRIE"]
            ["Innsbruck", "41,5%", "POINT (49 12)"]
            ["Salzburg", "41,5%", "POINT (49 12)"]
            ["Innsbruck", "41,5%", "POINT (49 12)"]
            ["Salzburg", "41,5%", "POINT (49 12)"]
        ]
        indexCoordinates =
            xy: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["City", "Content", "Lat", "Lng"]
            ["Salzburg", "41,5%", "47", "13"]
            ["Wien", "38,5%", "46.841", "12.348"]
            ["Bregenz", "40,5%", "46.323", "11.234"]
        ]
        indexCoordinates =
            x: 3
            y: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["City", "Content", "Lat,Lng"]
            ["Salzburg", "41,5%", "47,13"]
            ["Wien", "38,5%", "46.841,12.348"]
            ["Bregenz", "40,5%", "46.323,11.234"]
        ]
        indexCoordinates =
            xy: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

    xit 'should extract the coordinates from one cell', ->
        cell = "42.23 23.902 180.001 21 test"
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("42.23")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("23.902")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("21")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).not.toContain("180.001")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).not.toContain("test")

        cell = "46.323,11.234"
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("46.323")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("11.234")
