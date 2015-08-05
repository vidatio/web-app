"use strict"

app = angular.module "app.services"

app.service 'ParserService', [->
    class Parser
        constructor: ->
        isCoordinate: (lat, lng) ->
            return @isCoordinateWGS84DegreeDecimal() ||
                    @isCoordinateWGS84DegreeDecimalMinutes() ||
                    isCoordinateWGS84DegreeDecimalMinutesSeconds ||
                    @isCoordinateWGS84UTM() ||
                    @isCoordinateGaussKrueger()

        # N 90.123456, E 180.123456 to N -90.123456, E -180.123456
        isCoordinateWGS84DegreeDecimal: (coordinate) ->
            coordinate = coordinate.replace(/°/g, "").toLowerCase()

            if coordinate.indexOf("n") >= 0 or coordinate.indexOf("s") >= 0
                if coordinate.indexOf("n") >= 0
                    coordinate = coordinate.replace("n", "")
                else if coordinate.indexOf("s") >= 0
                    coordinate = coordinate.replace("s", "")

                if(coordinate >= 0 && coordinate <= 90)
                    return true
                else
                    return false
            else if coordinate.indexOf("e") >= 0 or coordinate.indexOf("w") >= 0
                if coordinate.indexOf("e") >= 0
                    coordinate = coordinate.replace("e", "")
                else if coordinate.indexOf("w") >= 0
                    coordinate = coordinate.replace("w", "")

                if coordinate >= 0 && coordinate <= 180
                    return true
                else
                    return false

            if coordinate >= -180 && coordinate <= 180
                return true
            else
                return false

        # N 90° 59.999999,E 180° 59.999999 to N 0° 0, E 0° 0
        isCoordinateWGS84DegreeDecimalMinutes: (coordinate) ->
            coordinate = coordinate.replace(/°/g, "").toLowerCase()

            if coordinate.indexOf("n") >= 0
                coordinateParts = coordinate.replace("n", "").trim().split(" ")
                if coordinateParts.length == 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 90 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                    return true
                else
                    return false

            else if coordinate.indexOf("s") >= 0
                coordinateParts = coordinate.replace("s", "").trim().split(" ")
                if coordinateParts.length == 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 90 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                    return true
                else
                    return false
            else if coordinate.indexOf("e") >= 0
                coordinateParts = coordinate.replace("e", "").trim().split(" ")
                if coordinateParts.length == 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                    return true
                else
                    return false
            else if coordinate.indexOf("w") >= 0
                coordinateParts = coordinate.replace("w", "").trim().split(" ")
                if coordinateParts.length == 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                    return true
                else
                    return false

            coordinateParts = coordinate.trim().split(" ")
            if coordinateParts.length == 2 and coordinateParts[0] >= -180 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                return true
            else
                return false

# N 90° 59' 59.999999'',E 180° 59' 59.999999'' to N 0° 0, E 0° 0
        isCoordinateWGS84DegreeDecimalMinutesSeconds: (coordinate) ->
            coordinate = coordinate.replace(/°/g, "").replace(/'/g, "").toLowerCase()

            if coordinate.indexOf("n") >= 0
                coordinateParts = coordinate.replace("n", "").trim().split(" ")
                if coordinateParts.length == 3 and 0 <= coordinateParts[0] <= 90 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                    return true
                else
                    return false

            else if coordinate.indexOf("s") >= 0
                coordinateParts = coordinate.replace("s", "").trim().split(" ")
                if coordinateParts.length == 3 and 0 <= coordinateParts[0] <= 90 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                    return true
                else
                    return false
            else if coordinate.indexOf("e") >= 0
                coordinateParts = coordinate.replace("e", "").trim().split(" ")
                if coordinateParts.length == 3 and 0 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                    return true
                else
                    return false
            else if coordinate.indexOf("w") >= 0
                coordinateParts = coordinate.replace("w", "").trim().split(" ")
                if coordinateParts.length == 3 and 0 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                    return true
                else
                    return false

            coordinateParts = coordinate.trim().split(" ")
            if coordinateParts.length == 3 and -180 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                return true
            else
                return false

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
