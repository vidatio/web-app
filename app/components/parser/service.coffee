"use strict"

app = angular.module "app.services"

app.service 'ParserService', [ ->
    class Parser
        isCoordinate: (coordinate) ->
            coordinate = String(coordinate).trim()
            if(coordinate == "")
                return
            else
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

        findCoordinatesColumns: (dataset) ->
            dataset = _trimDataset(dataset)

            indicesCoordinates = _findCoordinatesIndicesInHeader.call(this, dataset)
            if(typeof indicesCoordinates.x == "undefined" || typeof indicesCoordinates.y == "undefined")
                indicesCoordinates = _findCoordinatesIndicesInDataset.call(this, dataset)

            return indicesCoordinates

        _maxNumberOfRowsToCheck = 100

        # every coordinate format has a 2d like mapping
        # so we search for x values and y values
        _whiteList =
            "x": [
                "x"
                "lng"
                "longitude"
            ]
            "y": [
                "y"
                "latitude"
            ]

        _trimDataset = (dataset) ->
            tmp = []
            minColumns = 0
            minRows = 0

            # before trim the dataset we have to check the dimensions
            dataset.forEach (row, indexRow) ->
                row.forEach (cell, indexCell) ->
                    if(cell != null && String(cell) != "")
                        if(minRows < indexRow)
                            minRows = indexRow

                        if(minColumns < indexCell)
                            minColumns = indexCell

            # trim dataset with analysed dimensions
            dataset.forEach (row, indexRow) ->
                if(indexRow > minRows)
                    return
                tmp[indexRow] = row.slice(0, minColumns + 1)


            return tmp

        _findCoordinatesIndicesInDataset = (dataset) ->
            matrixPossibleCoordinates = _createMatrix.call(this, dataset, false)

            dataset.forEach (row, indexRow) =>
                row.forEach (cell, indexCell) =>
                    # There can be a single coordinate in a cell like "47.232"
                    if(@isCoordinate(cell))
                        matrixPossibleCoordinates[indexRow][indexCell] = true

                    # When editing the dataset, it can be that the user need time or forgot the fill up latitude or longitude
                    # So we have to ignore it, even if it is inside of the trimed dataset, and set its potential to true
                    # Also if there are rows which are empty (null) we have check the rows before or skip the column and not set it potential to true
                    else if(!cell)
                        dataset.forEach (rowBefore, idx) ->
                            if(rowBefore[indexCell] != null && String(rowBefore[indexCell]) != "")
                                matrixPossibleCoordinates[indexRow][indexCell] = true
                                return
                            if(indexRow == idx)
                                return
                    # But there can also be two coordinates in a single cell like "47.232, 13.854"
                    else
                        # at least we need two separated coordinates
                        potentialCoordinates = cell.split(",")
                        if(potentialCoordinates.length != 2)
                            return
                        # too protocol the existence of two coordinates we use array in one cell of the matrix
                        else if(@isCoordinate(potentialCoordinates[0]) && @isCoordinate(potentialCoordinates[1]))
                            matrixPossibleCoordinates[indexRow][indexCell] = [true, true]

                # we don't have to check the hole dataset, only the first 100 rows for example
                if(indexRow >= _maxNumberOfRowsToCheck)
                    return

            return _getIndicesOfCoordinateColumns(matrixPossibleCoordinates)

        _findCoordinatesIndicesInHeader = (dataset) ->
            indicesCoordinates = {}

            # Because the header is always in the first row, we only search there for coordinate tags
            dataset[0].forEach (cell, index) =>
                # With splitting the column anyway we can check also if there
                # is one or if there are two coordinates in one cell
                String(cell).split(",").forEach (element) =>
                    isCoordinateHeader = _checkWhiteList.call(this, element)
                    if(isCoordinateHeader)
                        indicesCoordinates[isCoordinateHeader] = index

                        if(indicesCoordinates.x != undefined && indicesCoordinates.y != undefined)
                            return

            return indicesCoordinates

        _checkWhiteList = (word) ->
            word = word.trim().toLowerCase()
            result = undefined

            word = word.replace(/\(/g, "").replace(/\)/g, "")
            word = word.replace("point", "").replace("shape", "")

            _whiteList["x"].forEach (item) ->
                if item.toLowerCase().indexOf(word) >= 0
                    result = "x"
                    return

            if(result == undefined)
                _whiteList["y"].forEach (item) ->
                    if item.toLowerCase().indexOf(word) >= 0
                        result = "y"
                        return

            return result

        # @param dataset is used to create a matrix which has the amount of cells row and column wise as the dataset
        _createMatrix = (dataset, initial) ->
            matrix = []
            dataset.forEach (row, indexRow) ->
                matrix.push([])
                row.forEach (column, indexColumn) ->
                    matrix[indexRow][indexColumn] = initial

                if(indexRow >= _maxNumberOfRowsToCheck)
                    return

            return matrix

        # @param matrix the amount of rows and columns of the dataset with a boolean
        #               in each cell if the content is a coordinate like
        _getIndicesOfCoordinateColumns = (matrix) ->
            result = {}

            coordinateColumnIndices = _findPossibleCoordinateColumns(matrix)

            if typeof coordinateColumnIndices == "number"
                result["x"] = result["y"] = coordinateColumnIndices
            else
                # find the two largest numbers and their indices
                largestNumber = -Infinity
                secondLargestNumber = -Infinity
                largestNumberIndex = 0
                secondLargestNumberIndex = 0
                coordinateColumnIndices.forEach (element, index) ->
                    if element > largestNumber
                        largestNumber = element
                        largestNumberIndex = index
                    else if element <= largestNumber && element >= secondLargestNumber
                        secondLargestNumber = element
                        secondLargestNumberIndex = index

                if largestNumberIndex > secondLargestNumberIndex
                    result["x"] = secondLargestNumberIndex
                    result["y"] = largestNumberIndex
                else
                    result["x"] = largestNumberIndex
                    result["y"] = secondLargestNumberIndex

            return result

        _findPossibleCoordinateColumns = (matrix) ->
            columnScores = new Array(matrix[0].length)

            # normal for-loop does not work in CoffeeScript
            index = 0
            while index < columnScores.length
                columnScores[index] = 0
                index++

            # count true values for each column
            # more true values mean that more possible coordinates are found
            separateColumns = true
            combinedColumnIndex = 0
            matrix.forEach (row) ->
                row.forEach (cell, indexColumn) ->
                    if cell == true
                        ++columnScores[indexColumn]

                    # in this case the cell contains an array
                    # this can happen if the coordinates are in the same cell
                    # only return the index (number) with the array, because then the coordinates should be in one cell
                    if cell.length == 2
                        combinedColumnIndex = indexColumn
                        separateColumns = false
                        return

            if separateColumns
                return columnScores
            else
                return combinedColumnIndex



    new Parser
]
