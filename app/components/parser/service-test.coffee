"use strict"

describe "Service Parser", ->
    beforeEach ->
        module "app"
        inject (ParserService, $injector) ->
            @injector = $injector
            @Parser = ParserService

    it 'should be defined and included', ->
        expect(@Parser).toBeDefined()
        expect(@injector.has("ParserService"))

    it 'should recognize wgs84 decimal degree coordinates correctly', ->

        coordinate = "0"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "-180"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "180"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "N 0"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "N 90"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "S 0"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "S 90"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "E 0"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "E 180"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "W 0"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()
        coordinate = "W 180"
        expect(@Parser.isCoordinate(coordinate)).toBeTruthy()

        coordinate = "181"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "-181"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "N -90"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "N 91"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "S -90"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "S 91"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "E -180"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "E 181"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "W -180"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()
        coordinate = "W 181"
        expect(@Parser.isCoordinate(coordinate)).toBeFalsy()

    it 'should find columns of the latitude and longitude in dataset', ->
        dataset = [
            ["Salzburg", "41,5%", "47", "13"]
        ]
        indexCoordinates = [
            [0,2]
            [0,3]
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            [0,2]
            [0,2]
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

    # should be easier to find coordinates via header then via the complete dataset
    it 'should find the columns of the latitude and longitude in dataset with header', ->
        dataset = [
            ["City", "Content", "Lat", "Lng"]
            ["Salzburg", "41,5%", "47", "13"]
        ]
        indexCoordinates = [
            [0,2]
            [0,3]
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["City", "Content", "POINT(Lat, Lng)"]
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            [0,2]
            [0,2]
        ]

        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)
