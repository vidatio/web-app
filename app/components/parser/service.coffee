"use strict"

app = angular.module "app.services"

app.service 'ParserService', [
    "HelperService"
    (Helper) ->
        class Parser
            # @method isCoordinate
            # @public
            # @param {All Types} coordinate
            # @return {Boolean}
            isCoordinate: (coordinate) ->
                coordinate = String(coordinate).trim()
                if(coordinate is "")
                    return
                else
                    return @isCoordinateWGS84DegreeDecimal(coordinate) or
                            @isCoordinateWGS84DegreeDecimalMinutes(coordinate) or
                            @isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate) or
                            @isCoordinateWGS84UTM(coordinate) or
                            @isCoordinateGaussKrueger(coordinate)

            # allowed formats: N 90.123456, E 180.123456 to N -90.123456, E -180.123456
            # @method isCoordinateWGS84DegreeDecimal
            # @public
            # @param {String} coordinate
            # @return {Boolean}
            isCoordinateWGS84DegreeDecimal: (coordinate) ->
                coordinate = coordinate.replace(/°/g, "").toLowerCase()

                if coordinate.indexOf("n") >= 0 or coordinate.indexOf("s") >= 0
                    if coordinate.indexOf("n") >= 0
                        coordinate = coordinate.replace("n", "")
                    else if coordinate.indexOf("s") >= 0
                        coordinate = coordinate.replace("s", "")

                    if(coordinate >= 0 and coordinate <= 90)
                        return true
                    else
                        return false
                else if coordinate.indexOf("e") >= 0 or coordinate.indexOf("w") >= 0
                    if coordinate.indexOf("e") >= 0
                        coordinate = coordinate.replace("e", "")
                    else if coordinate.indexOf("w") >= 0
                        coordinate = coordinate.replace("w", "")

                    if coordinate >= 0 and coordinate <= 180
                        return true
                    else
                        return false

                if coordinate >= -180 and coordinate <= 180
                    return true
                else
                    return false

            # allowed formats: N 90° 59.999999,E 180° 59.999999 to N 0° 0, E 0° 0
            # @method isCoordinateWGS84DegreeDecimalMinutes
            # @public
            # @param {String} coordinate
            # @return {Boolean}
            isCoordinateWGS84DegreeDecimalMinutes: (coordinate) ->
                coordinate = coordinate.replace(/°/g, "").toLowerCase()

                if coordinate.indexOf("n") >= 0
                    coordinateParts = coordinate.replace("n", "").trim().split(" ")
                    if coordinateParts.length is 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 90 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                        return true
                    else
                        return false

                else if coordinate.indexOf("s") >= 0
                    coordinateParts = coordinate.replace("s", "").trim().split(" ")
                    if coordinateParts.length is 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 90 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                        return true
                    else
                        return false
                else if coordinate.indexOf("e") >= 0
                    coordinateParts = coordinate.replace("e", "").trim().split(" ")
                    if coordinateParts.length is 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                        return true
                    else
                        return false
                else if coordinate.indexOf("w") >= 0
                    coordinateParts = coordinate.replace("w", "").trim().split(" ")
                    if coordinateParts.length is 2 and coordinateParts[0] >= 0 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                        return true
                    else
                        return false

                coordinateParts = coordinate.trim().split(" ")
                if coordinateParts.length is 2 and coordinateParts[0] >= -180 and coordinateParts[0] <= 180 and coordinateParts[1] >= 0 and coordinateParts[1] < 60
                    return true
                else
                    return false

            # allowed formats: N 90° 59' 59.999999'',E 180° 59' 59.999999'' to N 0° 0, E 0° 0
            # @method isCoordinateWGS84DegreeDecimalMinutesSeconds
            # @public
            # @param {String} coordinate
            # @return {Boolean}
            isCoordinateWGS84DegreeDecimalMinutesSeconds: (coordinate) ->
                coordinate = coordinate.replace(/°/g, "").replace(/'/g, "").toLowerCase()

                if coordinate.indexOf("n") >= 0
                    coordinateParts = coordinate.replace("n", "").trim().split(" ")
                    if coordinateParts.length is 3 and 0 <= coordinateParts[0] <= 90 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                        return true
                    else
                        return false

                else if coordinate.indexOf("s") >= 0
                    coordinateParts = coordinate.replace("s", "").trim().split(" ")
                    if coordinateParts.length is 3 and 0 <= coordinateParts[0] <= 90 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                        return true
                    else
                        return false
                else if coordinate.indexOf("e") >= 0
                    coordinateParts = coordinate.replace("e", "").trim().split(" ")
                    if coordinateParts.length is 3 and 0 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                        return true
                    else
                        return false
                else if coordinate.indexOf("w") >= 0
                    coordinateParts = coordinate.replace("w", "").trim().split(" ")
                    if coordinateParts.length is 3 and 0 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
                        return true
                    else
                        return false

                coordinateParts = coordinate.trim().split(" ")
                if coordinateParts.length is 3 and -180 <= coordinateParts[0] <= 180 and 0 <= coordinateParts[1] <= 59 and 0 <= coordinateParts[2] < 60
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

            # first we try to find coordinates columns via the header
            # if this fails we parse the dataset for coordinates
            # @method findCoordinatesColumns
            # @public
            # @param {Array} dataset
            # @return {Object}
            findCoordinatesColumns: (dataset) ->

                choppedDataset = Helper.cutDataset(dataset)
                unless choppedDataset.length
                    return

                indicesCoordinates = _findCoordinatesIndicesInHeader.call(this, choppedDataset)

                if(!(indicesCoordinates.hasOwnProperty("x") and indicesCoordinates.hasOwnProperty("y") or indicesCoordinates.hasOwnProperty("xy")))
                    indicesCoordinates = _findCoordinatesIndicesInDataset.call(this, choppedDataset)

                return indicesCoordinates

            # @method extractCoordinatesOfOneCell
            # @public
            # @param {String} cell
            # @return {Array}
            extractCoordinatesOfOneCell: (cell) ->
                # TODO: match other than decimal coordinate formats (e.g. N 123° 13.15 )

                # matches the following numbers:
                #    123.45, 123, -123, -123.45
                regex = /(?:-)?(?:\d+)(?:\.\d+)?/g

                coordinates = []
                while((coordinate = regex.exec(cell)) != null)
                    if(@isCoordinate(coordinate[0]))
                        coordinates.push coordinate[0]

                return coordinates

            # +43 923 89012891, +43-923-89012891, +43.923.89012891
            # @method isPhoneNumber
            # @public
            # @param {String} cell
            # @return {Boolean}
            isPhoneNumber: (cell) ->
                regex = /^\+(\d{2})[-. ]?(\d{3})[-. ]?(\d+)[-. ]?(\d*)$/
                return regex.test(cell)

            # @method isMailAddress
            # @public
            # @param {String} cell
            # @return {Boolean}
            isEmailAddress: (cell) ->
                regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
                return regex.test(cell)

            # @method isURL
            # @public
            # @param {String} cell
            # @return {Boolean}
            isURL: (cell) ->
                regex = /^(ftp|http|https):\/\/[^ "]+$/i
                return regex.test(cell)

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
                "xy": [
                    "Geometrie"
                    "Geometry"
                ]

            # @method _findCoordinatesIndicesInDataset
            # @private
            # @param {Array} dataset
            # @return {Object}
            _findCoordinatesIndicesInDataset = (dataset) ->
                matrixPossibleCoordinates = Helper.createMatrix.call(this, dataset, false)

                dataset.forEach (row, indexRow) =>
                    row.forEach (cell, indexCell) =>
                        # There can be a single coordinate in a cell like "47.232"
                        if @isCoordinate(cell)
                            matrixPossibleCoordinates[indexRow][indexCell] = true
                        # But there can also be two coordinates in a single cell like "47.232, 13.854"
                        else if cell
                            # at least we need two separated coordinates
                            potentialCoordinates = cell.split(",")
                            if(potentialCoordinates.length != 2)
                                return
                            # too protocol the existence of two coordinates we use array in one cell of the matrix
                            else if(@isCoordinate(potentialCoordinates[0]) and @isCoordinate(potentialCoordinates[1]))
                                matrixPossibleCoordinates[indexRow][indexCell] = [true, true]

                return _getIndicesOfCoordinateColumns(matrixPossibleCoordinates)

            # @method _findCoordinatesIndicesInHeader
            # @private
            # @param {Array} dataset
            # @return {Object}
            _findCoordinatesIndicesInHeader = (dataset) ->
                indicesCoordinates = {}

                # Because the header is always in the first row, we only search there for coordinate tags
                dataset[0].forEach (cell, index) =>
                    if(indicesCoordinates.hasOwnProperty("x") and indicesCoordinates.hasOwnProperty("y") or indicesCoordinates.hasOwnProperty("xy"))
                        return

                    isCoordinateHeader = _checkWhiteList.call(this, cell)
                    if(isCoordinateHeader)
                        indicesCoordinates[isCoordinateHeader] = index

                return indicesCoordinates

            # @method _checkWhiteList
            # @private
            # @param {String} word
            # @return {String}
            _checkWhiteList = (word) ->
                result = undefined
                word = String(word).trim().toLowerCase()

                _whiteList["x"].forEach (item) ->
                    if item.toLowerCase().indexOf(word) >= 0
                        result = "x"
                        return

                if !result
                    _whiteList["y"].forEach (item) ->
                        if item.toLowerCase().indexOf(word) >= 0
                            result = "y"
                            return

                if !result
                    _whiteList["xy"].forEach (item) ->
                        if item.toLowerCase().indexOf(word) >= 0
                            result = "xy"
                            return

                return result

            # @method _getIndicesOfCoordinateColumns
            # @private
            # @param {matrix} true/false matrix of each cell (true mean the cell contains a coordinate)
            # @return {Object}
            _getIndicesOfCoordinateColumns = (matrix) ->
                result = {}

                [ separateColumns, columnScores ] = _rateColumns(matrix)
                highestScoreIndices = _findHighestScoreIndices(separateColumns, columnScores)

                # the most left column should be per default the longitude (x)
                if highestScoreIndices[0] > highestScoreIndices[1]
                    result["x"] = highestScoreIndices[1]
                    result["y"] = highestScoreIndices[0]
                else if highestScoreIndices[0] < highestScoreIndices[1]
                    result["x"] = highestScoreIndices[0]
                    result["y"] = highestScoreIndices[1]
                else
                    result["xy"] = highestScoreIndices[0]

                return result

            # calculate column scores, which are needed to distinguish the coordinates columns from other columns
            # counts true values and so increases the score of the separate columns
            # @method _rateColumns
            # @private
            # @param {matrix} true/false matrix of each cell (true mean the cell contains a coordinate)
            # @return {Array}
            #       - separateColumns {Boolean} is true if there is only one coordinate in one cell
            #       - columnScores {Array} contains the scores (amount of possible coordinates per column) for all columns
            _rateColumns = (matrix) ->
                columnScores = new Array(matrix[0].length)

                # normal for-loop does not work in CoffeeScript
                index = 0
                while index < columnScores.length
                    columnScores[index] = 0
                    index++

                # count true values for each column
                # more true values mean that more possible coordinates are found
                separateColumns = true
                matrix.forEach (row) ->
                    row.forEach (cell, indexColumn) ->
                        if cell is true
                            ++columnScores[indexColumn]

                        if cell.length is 2
                            separateColumns = false
                            if cell[0] is true
                                ++columnScores[indexColumn]
                            if cell[1] is true
                                ++columnScores[indexColumn]

                return [
                    separateColumns,
                    columnScores
                ]

            # find the two largest numbers and their indices
            # @method _findHighestScoreIndices
            # @private
            # @param {Boolean} separateColumns
            # @param {Array} columnScores
            # @return {Array}
            _findHighestScoreIndices = (separateColumns, columnScores) ->
                largestNumber = -Infinity
                secondLargestNumber = -Infinity
                largestScoreIndex = 0
                secondLargestScoreIndex = 0

                columnScores.forEach (element, index) ->
                    if element > largestNumber
                        secondLargestNumber = largestNumber
                        secondLargestScoreIndex = largestScoreIndex

                        largestNumber = element
                        largestScoreIndex = index
                    else if element <= largestNumber and element > secondLargestNumber and separateColumns
                        secondLargestNumber = element
                        secondLargestScoreIndex = index

                if separateColumns
                    return [largestScoreIndex, secondLargestScoreIndex]
                else
                    return [largestScoreIndex, largestScoreIndex]

        new Parser
]
