"use strict"

app = angular.module "app.services"

app.service 'ParserService', [->
    class Parser
        constructor: ->
        isCoordinate: (lat, lng) ->
            return @isCoordinateWGS84DegreeDecimal() ||
                    @isCoordinateWGS84DegreeDecimalMinutes() ||
                    @isCoordinateWGS84DegreeMinutesSeconds ||
                    @isCoordinateWGS84UTM() ||
                    @isCoordinateGaussKrueger()

        # N 90.123456, E 180.123456 to N -90.123456, E -180.123456
        isCoordinateWGS84DegreeDecimal: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        # N 180° 59.999999,E 180° 59.999999 to N 0° 0, E 0° 0
        isCoordinateWGS84DegreeDecimalMinutes: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        # N 180° 59' 59.999999'',E 180° 59' 59.999999'' to N 0° 0, E 0° 0
        isCoordinateWGS84DegreeMinutesSeconds: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        # 60X 448304 5413670 to 1C 0000000 0000000
        isCoordinateWGS84UTM: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        # R 5435433.633 H 5100411.939
        isCoordinateGaussKrueger: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        findCoordinates: (dataset) ->
            indicesCoordinates = @findCoordinatesInHeader(dataset)
            if(indicesCoordinates.length == 2)
                indicesCoordinates = @findCoordinatesInDataset(dataset)

            return indicesCoordinates

        findCoordinatesInHeader: (dataset) ->
            indicesCoordinates = []
            # search in potential column header for coordinates
            dataset.forEach (element, index) ->
                if(element.indexOf("Lat") >= 0)
                    indicesCoordinates.push [0, index]

                if(element.indexOf("Lng") >= 0)
                    indicesCoordinates.push [0, index]

                if(indicesCoordinates.length == 2)
                    return
            return indicesCoordinates

        findCoordinatesInDataset: (dataset) ->
            indicesCoordinates = []

            # search in dataset for coordinates
            dataset.forEach (row, index) ->
                row.forEach (column, index) ->

            return indicesCoordinates

    new Parser
]
