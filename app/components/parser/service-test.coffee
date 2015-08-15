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

    it 'should recognize wgs84 degree decimal coordinates correctly', ->

        # with leading sign
        coordinate = "0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "-180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with classification at the front
        coordinate = "N 0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "N 90"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "S 0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "S 90"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E 0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E 180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with classification at the end
        coordinate = "0 N"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90 N"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 S"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90 S"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 E"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180 E"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 W"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180 W"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with degree symbol
        coordinate = "0°"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "-180°"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 180°"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180° W"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # without space between classification and decimal number
        coordinate = "N0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "N90"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0S"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90S"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E0"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0W"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180W"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        coordinate = "181"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "-181"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "N -90"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "N 91"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "S -90"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "S 91"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "E -180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "E 181"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "W -180"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "W 181"
        expect(@Parser.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()

    it 'should recognize wgs84 degree decimal minutes coordinates correctly', ->
        coordinate = "180 59"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "E180 59"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "N 90 0"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "W 180° 59.999"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "180° 59.999 W"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()

        coordinate = "180"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "181W 59.999"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "W 0° 60"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "S 90° 61"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()

    it 'should recognize wgs84 degree decimal minutes seconds coordinates correctly', ->
        coordinate = "180° 59' 0''"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "E180 59 50"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "N 90 59 59.999"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "180° 1 59.999 W"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()

        coordinate = "180 59"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "180 59.1 50"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "180° 59.1 50"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "S 180° 59 60"
        expect(@Parser.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()

    it 'should find columns of the latitude and longitude in dataset', ->
        dataset = [
            ["Salzburg", "41,5%", "47", "13"]
            ["Wien", "39,5%", "46", "12"]
        ]
        indexCoordinates = [
            2
            3
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            2
            2
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "test,13"]
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual([])

        dataset = [
            ["Innsbruck", "41,5%", "180° 59' 0'', 180° 1 59.999 W"]
            ["Salzburg", "41,5%", "N 90 59 59.999, 180° 1 59.999 W"]
        ]
        indexCoordinates = [
            2
            2
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

    # should be easier to find coordinates via header then via the complete dataset
    it 'should find the columns of the latitude and longitude in dataset with header', ->
        dataset = [
            ["City", "Content", "Lat", "Lng"]
            ["Salzburg", "41,5%", "47", "13"]
        ]
        indexCoordinates = [
            2
            3
        ]
        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["City", "Content", "Lat,Lng"]
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            2
            2
        ]

        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["City", "Content", "Point(Lat,Lng)"]
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            2
            2
        ]

        dataset = [
            ["City", "Content", "Point(Lat,Lng)"]
            ["Salzburg", "41,5%", "47,13"]
        ]
        indexCoordinates = [
            2
            2
        ]

        expect(@Parser.findCoordinates(dataset)).toEqual(indexCoordinates)

    it 'should have a attribute for the max row checks set', ->
        expect(@Parser.maxNumberOfRowsToCheck).toBeDefined()
        expect(@Parser.maxNumberOfRowsToCheck).toEqual(Number(@Parser.maxNumberOfRowsToCheck))

    it 'should have a whitelist for the possible coordinate tags in a dataset header', ->
        expect(@Parser.whiteList).toBeDefined()
        expect(@Parser.whiteList).toContain("latitude")
        expect(@Parser.whiteList).toContain("longitude")

    it 'should create a matrix according to a dataset', ->
        dataset = [
            ["City", "Content", "Point(Lat,Lng)"]
            ["Salzburg", "41,5%", "47,13"]
        ]

        result = [
            [false, false, false]
            [false, false, false]
        ]
        expect(@Parser.createMatrix(dataset)).toEqual(result)

        result = [
            [true, true, true]
            [true, true, true]
        ]
        expect(@Parser.createMatrix(dataset)).not.toEqual(result)

    # Notice: this test is obsolete because it is already included in the "findCoordinates" tests
    # but it shows the process of receiving the indices of the coordinates
    it 'should get the coordinate indices of a true/false matrix', ->
        matrix = [
            [false, true, false, true, false, true, false]
            [false, false, false, true, false, true, true]
            [false, true, false, true, false, true, false]
            [false, true, false, true, false, true, true]
        ]
        expect(@Parser.getIndicesOfCoordinateColumns(matrix)).toEqual([3, 5])

        matrix = [
            [false, [false, true], [true, true], false, true, false]
            [false, [true, false], [true, true], false, false, true]
            [false, [false, true], [true, true], false, true, false]
            [false, [true, false], [true, true], false, true, true]
        ]
        expect(@Parser.getIndicesOfCoordinateColumns(matrix)).toEqual([2, 2])
