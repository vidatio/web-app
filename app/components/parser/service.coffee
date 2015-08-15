"use strict"

app = angular.module "app.services"

app.service 'ParserService', [->
    class Parser
        constructor: ->
        isCoordinate: (coordinate) ->
            coordinate = coordinate.trim()
            return @isCoordinateWGS84DegreeDecimal(coordinate) ||
                    @isCoordinateWGS84DegreeDecimalMinutes(coordinate) ||
                    @isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate) ||
                    @isCoordinateWGS84UTM(coordinate) ||
                    @isCoordinateGaussKrueger(coordinate)

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
        isCoordinateWGS84UTM: (coordinate) ->
            # TODO
            return false

        # R 5435433.633 H 5100411.939
        isCoordinateGaussKrueger: (coordinate) ->
            # TODO
            return false

        findCoordinates: (dataset) ->
            indicesCoordinates = @findCoordinatesInHeader(dataset)

            if(indicesCoordinates.length != 2)
                indicesCoordinates = @findCoordinatesInDataset(dataset)

            return indicesCoordinates

        findCoordinatesInHeader: (dataset) ->
            indicesCoordinates = []

            # Because the header is always in the first row, we only search there for coordinate tags
            dataset[0].forEach (column, index) =>
                # With splitting the column anyway we can check the also if there
                # is one or if there are two coordinates in one cell
                column.split(",").forEach (element) =>
                    if(@checkWhiteList(element))
                        indicesCoordinates.push index

                # TODO: Currently we only support datasets with two coordinates (for example lat, lng)
                if(indicesCoordinates.length == 2)
                    return

            return indicesCoordinates

        # for each
        findCoordinatesInDataset: (dataset) ->
            matrixPossibleCoordinates = @createMatrix(dataset)

            dataset.forEach (row, indexRow) =>
                row.forEach (column, indexColumn) =>
                    # There can be a single coordinate in a cell like "47.232"
                    if(@isCoordinate(column))
                        matrixPossibleCoordinates[indexRow][indexColumn] = true
                        # But there can also be two coordinates in a single cell like "47.232, 13.854"
                    else
                        # at least we need two separated coordinates
                        potentialCoordinates = column.split(",")
                        if(potentialCoordinates.length != 2)
                            return
                            # two protocol the existence of two coordinates we use array in one cell of the matrix
                        else if(@isCoordinate(potentialCoordinates[0]) && @isCoordinate(potentialCoordinates[1]))
                            matrixPossibleCoordinates[indexRow][indexColumn] = [true, true]

                # we don't have to check the hole dataset, only the first 100 rows for example
                if(indexRow >= @maxNumberOfRowsToCheck)
                    return

            return @getIndicesOfCoordinateColumns(matrixPossibleCoordinates)

        whiteList: [
            "lat"
            "latitude"
            "lng"
            "lon"
            "longitude"
            "x"
            "y"
        ]

        checkWhiteList: (word) ->
            word = word.trim().toLowerCase()
            result = false

            word = word.replace(/\(/g, "").replace(/\)/g, "")
            word = word.replace("point", "").replace("shape", "")

            @whiteList.forEach (item) ->
                if item.toLowerCase() == word
                    result = true
                    return

            return result

        maxNumberOfRowsToCheck: 100

        # @param dataset is used to create a matrix which has the amount of cells row and column wise as the dataset
        createMatrix: (dataset) ->
            matrix = []
            dataset.forEach (row, indexRow) =>
                matrix.push([])
                row.forEach (column, indexColumn) =>
                    matrix[indexRow][indexColumn] = false

                if(indexRow >= @maxNumberOfRowsToCheck)
                    return

            return matrix

        # @param matrix the amount of rows and columns of the dataset with a boolean
        #               in each cell if the content is a coordinate like
        getIndicesOfCoordinateColumns: (matrix) ->
            noCoordinateColumn = []
            result = []

            matrix.forEach (row, indexRow) ->
                row.forEach (column, indexColumn) ->
                    # if this column is already as a no-coordinate-column listed we can get to the next row
                    # if there is no further potential column with coordinates we can quite parsing
                    if(noCoordinateColumn.indexOf(indexColumn) >= 0 || noCoordinateColumn.length == row.length)
                        return

                    # if one cell of a column is false the hole column can't be filled with coordinates
                    if(column == false)
                        noCoordinateColumn.push indexColumn

                    else if(column.length == 2)
                        # currently if there are two coordinates (lat and lng) in a cell
                        # we set the first row also two [true, true], so we now later that
                        # we have to push the index of the column twice into result indices
                        if(column[0] == true && column[1] == true)
                            matrix[0][indexColumn] = [true, true]
                        else
                            noCoordinateColumn.push indexColumn

            # each column which has coordinate like content we add them to the result
            matrix[0].forEach (column, indexColumn) ->
                # first push if this column is a coordinate column
                if(noCoordinateColumn.indexOf(indexColumn) < 0)
                    result.push(indexColumn)

                    # second push if there are two coordinates in one cell
                    if(column.length == 2 && matrix[0][indexColumn][0] == true && matrix[0][indexColumn][1] == true)
                        result.push(indexColumn)

            return result

    new Parser
]
