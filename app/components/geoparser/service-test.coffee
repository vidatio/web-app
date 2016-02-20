# TODO: Adapted parser for use in api
# in einer zelle NaN (usw.) behandeln
# nur noch in zellen nachschauen, in denen in den bisherigen zeilen true (in zelle kommt potentielle coordinate vor) vorkam
# Implement GaussKrueger and UTM

"use strict"

describe "Service GeoParser", ->
    beforeEach ->
        @Parser = new window.vidatio.GeoParser()

    it 'should find columns of the latitude and longitude in dataset', ->
        header = ["Salzburg", "41,5%", "47.349", "13.892"]
        result = {}
        expect(@Parser.checkHeader(header)).toEqual(result)

        header = ["City", "Content", "GEOMETRIE"]
        result =
            xy: 2
        expect(@Parser.checkHeader(header)).toEqual(result)

        header = ["City", "Content", "Lat", "Lng"]
        result =
            x: 3
            y: 2
        expect(@Parser.checkHeader(header)).toEqual(result)

        header = ["City", "X", "Y", "Name"]
        result =
            x: 1
            y: 2
        expect(@Parser.checkHeader(header)).toEqual(result)

    it 'should extract the coordinates from one cell', ->
        cell = "42.23 23.902 180.001 21 test"
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("42.23")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("23.902")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("21")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).not.toContain("180.001")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).not.toContain("test")

        cell = "46.323,11.234"
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("46.323")
        expect(@Parser.extractCoordinatesOfOneCell(cell)).toContain("11.234")
