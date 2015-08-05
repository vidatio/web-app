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

    xit 'should find columns of the latitude and longitude in dataset', ->
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
    xit 'should find the columns of the latitude and longitude in dataset with header', ->
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
