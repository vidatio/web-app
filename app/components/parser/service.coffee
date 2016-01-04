"use strict"

class Parser
    # first we try to find coordinates columns via the header
    # if this fails we parse the dataset for coordinates
    # @method findCoordinatesColumns
    # @public
    # @param {Array} dataset
    # @return {Object}
    findCoordinatesColumns: (dataset) ->
        console.info "ParserService findCoordinatesColumns called"
        console.log
            message: "ParserService findCoordinatesColumns called"
            dataset: dataset

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
        console.info "ParserService extractCoordinatesOfOneCell called"
        console.log
            message: "ParserService extractCoordinatesOfOneCell called"
            cell: cell

        # TODO: match other than decimal coordinate formats (e.g. N 123° 13.15 )

        # matches the following numbers:
        #    123.45, 123, -123, -123.45
        regex = /(?:-)?(?:\d+)(?:\.\d+)?/g

        coordinates = []
        while((coordinate = regex.exec(cell)) != null)
            if(Helper.isCoordinate(coordinate[0]))
                coordinates.push coordinate[0]

        return coordinates

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
        console.info "ParserService _findCoordinatesIndicesInDataset called"
        console.log
            message: "ParserService _findCoordinatesIndicesInDataset called"
            dataset: dataset

        matrixPossibleCoordinates = Helper.createMatrix.call(this, dataset, false)

        dataset.forEach (row, indexRow) ->
            row.forEach (cell, indexCell) ->
                # There can be a single coordinate in a cell like "47.232"
                if Helper.isCoordinate(cell)
                    matrixPossibleCoordinates[indexRow][indexCell] = true
                    # But there can also be two coordinates in a single cell like "47.232, 13.854"
                else if cell
                    # at least we need two separated coordinates
                    potentialCoordinates = cell.split(",")
                    if(potentialCoordinates.length != 2)
                        return
                        # too protocol the existence of two coordinates we use array in one cell of the matrix
                    else if(Helper.isCoordinate(potentialCoordinates[0]) and Helper.isCoordinate(potentialCoordinates[1]))
                        matrixPossibleCoordinates[indexRow][indexCell] = [true, true]

        return _getIndicesOfCoordinateColumns(matrixPossibleCoordinates)

    # @method _findCoordinatesIndicesInHeader
    # @private
    # @param {Array} dataset
    # @return {Object}
    _findCoordinatesIndicesInHeader = (dataset) ->
        console.info "ParserService _findCoordinatesIndicesInHeader called"
        console.log
            message: "ParserService _findCoordinatesIndicesInHeader called"
            dataset: dataset

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
        console.info "ParserService _checkWhiteList called"
        console.log
            message: "ParserService _checkWhiteList called"
            word: word

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
        console.info "ParserService _getIndicesOfCoordinateColumns called"
        console.log
            message: "ParserService _getIndicesOfCoordinateColumns called"
            matrix: matrix

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
        console.info "ParserService _rateColumns called"
        console.log
            message: "ParserService _rateColumns called"
            matrix: matrix

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
        console.info "ParserService _findHighestScoreIndices called"
        console.log
            message: "ParserService _findHighestScoreIndices called"
            separateColumns: separateColumns
            columnScores: columnScores

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

window.Parser = new Parser()
