# TODO: Adapted parser for use in api
# in einer zelle NaN (usw.) behandeln
# nur noch in zellen nachschauen, in denen in den bisherigen zeilen true (in zelle kommt potentielle coordinate vor) vorkam

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
            ["Salzburg", "41,5%", "47.349", "13.892"]
            ["Wien", "38,5%", "46.841", "12.348"]
            ["Bregenz", "40,5%", "46.323", "11.234"]
            ["Linz", "39,5%", "49.823", "10.348"]
        ]
        indexCoordinates =
            x: 2
            y: 3
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)
        return

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

        dataset = [
            ["47.349,13.892", "Salzburg", "41,5%"]
            ["46.841,12.348", "Wien", "38,5%"]
            ["46.323,11.234", "Bregenz", "40,5%"]
            ["49.823,10.348", "Linz", "39,5%"]
        ]
        indexCoordinates =
            x: 0
            y: 0
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "47,13"]
            ["Gnigl", "41,5%", "48,12"]
            ["Gneis", "41,5%", "49,13"]
        ]
        indexCoordinates =
            x: 2
            y: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Innsbruck", "41,5%", "49,12"]
            ["Salzburg", "41,5%", "49,13"]
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "word,13"]
        ]
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual({})

        dataset = [
            ["Innsbruck", "41,5%", "180° 59' 0'', 180° 1 59.999 W"]
            ["Salzburg", "39,5%", "N 90 59 59.999, 180° 1 59.999 W"]
            ["Gneis", "41,5%", "180° 59' 0'', 180° 1 59.999 W"]
            ["Gnigl", "40,5%", "N 90 59 0, 0° 1 59.999 W"]
        ]
        indexCoordinates =
            x: 2
            y: 3
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

    # should be easier to find coordinates via header then via the complete dataset
    it 'should find the columns of the latitude and longitude in dataset with header', ->

        dataset = [
            ["City", "Content", "Point(Lat,Lng)"]
            ["Innsbruck", "41,5%", "49,12"]
            ["Salzburg", "41,5%", "49,13"]
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "50,13"]
        ]
        indexCoordinates =
            x: 2
            y: 2
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
            ["Innsbruck", "41,5%", "49,12"]
            ["Salzburg", "41,5%", "49,13"]
            ["Innsbruck", "41,5%", "49,11"]
            ["Salzburg", "41,5%", "50,13"]
        ]
        indexCoordinates =
            x: 2
            y: 2
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

        dataset = [
            ["Lat,Lng", "City", "Content"]
            ["49,12", "41,5%", "Innsbruck"]
            ["41,5%", "49,13", "Salzburg"]
            ["41,5%", "49,11", "Innsbruck"]
            ["41,5%", "50,13", "Salzburg"]
        ]
        indexCoordinates =
            x: 0
            y: 0
        expect(@Parser.findCoordinatesColumns(dataset)).toEqual(indexCoordinates)

