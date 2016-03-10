"use strict"

class window.vidatio.Helper
    constructor: ->
        vidatio.log.info "HelperService constructor called"
        @rowLimit = 30

    # remove cells without values
    # @method trimDataset
    # @public
    # @param {Array} dataset
    # @return {Array}
    trimDataset: (dataset) ->
        vidatio.log.info "HelperService trimDataset called"
        vidatio.log.debug
            message: "HelperService trimDataset called"
            dataset: dataset

        tmp = []

        topRow = undefined
        leftCell = Infinity
        rightCell = -Infinity
        bottomRow = -Infinity

        dataset.forEach (row, indexRow) ->
            row.forEach (cell, indexCell) ->
                if cell
                    if typeof topRow == 'undefined'
                        topRow = indexRow
                    if leftCell > indexCell
                        leftCell = indexCell
                    if bottomRow < indexRow
                        bottomRow = indexRow
                    if rightCell < indexCell
                        rightCell = indexCell

        dataset.forEach (row, indexRow) ->
            if indexRow < topRow or indexRow > bottomRow
                return
            tmp.push row.slice(leftCell, rightCell + 1)

        return tmp

    # cut out specified amount of rows
    # @method cutDataset
    # @public
    # @param {Array} dataset
    # @return {Array}
    getSubset: (dataset) ->
        vidatio.log.info "HelperService getSubset called"
        vidatio.log.debug
            message: "HelperService getSubset called"
            dataset: dataset

        tmp = []
        for element, index in dataset
            if index is @rowLimit
                break
            tmp.push element

        return tmp

    # @method transposeDataset
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} dataset but rows are now columns and vice versa
    transposeDataset: (dataset) ->
        vidatio.log.info "Helper transposeDataset called"
        vidatio.log.debug
            dataset: dataset

        transposedDataset = []

        dataset.forEach (row, i, dataset) ->
            if row?
                row.forEach (cell, j, row) ->
                    if not transposedDataset[j]
                        transposedDataset.push []
                    transposedDataset[j].push cell

        return transposedDataset

    # @method trimDataset
    # @public
    # @param {Array} dataset is used to create a matrix which has the the same dimensions as the dataset
    # @param {Number} initial value of each cell
    # @return {Array}
    createMatrix: (dataset, initial) ->
        vidatio.log.info "HelperService createMatrix called"
        vidatio.log.debug
            message: "HelperService createMatrix called"
            dataset: dataset
            initial: initial

        matrix = []
        dataset.forEach (row, indexRow) ->
            matrix.push([])
            row.forEach (column, indexColumn) ->
                matrix[indexRow][indexColumn] = initial

        return matrix

    dateToString: (date) ->
        vidatio.log.info "HelperService dateToString called"
        vidatio.log.debug
            message: "HelperService dateToString called"
            date: date

        yyyy = date.getFullYear().toString()
        mm = (date.getMonth() + 1).toString()
        dd = date.getDate().toString()
        hh = date.getHours().toString()
        min = date.getMinutes().toString()
        sec = date.getSeconds().toString()
        return dd + "-" + mm + "-" + yyyy + "_" + hh + "-" + min + "-" + sec

    # @method isNumber
    # @public
    # @param {All Types} value
    # @return {Boolean}
    isNumber: (value) ->
        return typeof value is "number" and isFinite(value)

    # @method isNumeric
    # @description checks if a value is numeric.
    # @param {Mixed} n
    # @return {Boolean}
    isNumeric: (value) ->
        return (!isNaN(parseFloat(value)) && isFinite(value))

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
                    @isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)

    # allowed formats: N 90.123456, E 180.123456 to N -90.123456, E -180.123456
    # TODO: But not without N or E
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

    # @method isCoordinateColumn
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells coordinates?
    isCoordinateColumn: (column) ->
        for key, value of column
            if not @isCoordinate value
                return false
        return true

    # @method isDateColumn
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells are date?
    isDateColumn: (column) ->
        for key, value of column
            if not @isDate value
                return false
        return true

    # @method isNumericColumn
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells numeric?
    isNumericColumn: (column) ->
        for key, value of column
            if not @isNumeric value
                return false
        return true

    # @method isNominalColumn
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells strings?
    isNominalColumn: (column) ->
        for key, value of column
            if isFinite value
                return false
        return true

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

    # @method isDate
    # @description possible formats:
    #   YYYY.MM.DD
    #   YYYY-MM-DD
    #   YYYY/MM/DD
    #   DD.MM.YYYY
    #   DD-MM-YYYY
    #   DD/MM/YYYY
    #   MM.DD.YYYY
    #   MM-DD-YYYY
    #   MM/DD/YYYY
    # @public
    # @param {String} cell
    # @return {Boolean}
    isDate: (cell) ->
        YYYYMMDD = /^\d{4}[\/\-.](0?[1-9]|1[012])[\/\-.](0?[1-9]|[12][0-9]|3[01])$/
        DDMMYYYY = /^(0?[1-9]|[12][0-9]|3[01])[\/\-.](0?[1-9]|1[012])[\/\-.]\d{4}$/
        MMDDYYYY = /^(0?[1-9]|1[012])[\/\-.](0?[1-9]|[12][0-9]|3[01])[\/\-.]\d{4}$/
        return YYYYMMDD.test(cell) or DDMMYYYY.test(cell) or MMDDYYYY.test(cell)

    # @method transformToArrayOfObjects
    # @description This method transforms the dataset from a 2 dimensional Array to an Array of Objects, which is needed by D3plus
    #               xColumn, yColumn and visualizationType
    # @public
    # @param {Array} dataset
    # @param {Number} xColumn
    # @param {Number} yColumn
    # @param {String} visualizationType
    # @return {Array}
    # TODO pass names of header if available to use as default keys for x and y in visualization
    transformToArrayOfObjects: (dataset, xColumn, yColumn, visualizationType, headers, color) ->
        unless dataset or xColumn or yColumn or visualizationType
            return

        transformedDataset = []
        { x: xHeader, y: yHeader } = headers

        dataset.forEach (row) =>
            x = if @isNumeric row[xColumn] then parseFloat row[xColumn] else row[xColumn]
            y = if @isNumeric row[yColumn] then parseFloat row[yColumn] else row[yColumn]

            dataItem = {}
            dataItem[xHeader] = x
            dataItem[yHeader] = y

            dataItem["color"] = color

            if visualizationType is "bar" or visualizationType is "scatter"
                dataItem["name"] = y
            else if visualizationType is "timeseries"
                dataItem["name"] = "Line 1"

            transformedDataset.push dataItem

        transformedDataset

    # @method subsetWithXColumnFirst
    # @description This method is used to get a subset with 2 columns. The data has to be in a format like it is used by D3.parcoords,
    #               which is that each column is an Array: eg [ [ Col1Value1, Col1Value2 ], [ Col2Value1, Col2Value2 ] ]
    # @public
    # @param {Array} dataset
    # @param {Number} xColumn
    # @param {Number} yColumn
    # @return {Array}
    subsetWithXColumnFirst: (dataset, xColumn, yColumn) ->
        unless dataset or xColumn or yColumn
            return

        subset = []
        subset.push dataset[xColumn]
        subset.push dataset[yColumn]

        subset

    # @method isDiagramPossible
    # @description This method checks if the current column type selection is possible with a given diagram.
    # @public
    # @param {Array} xColumnTypes
    # @param {Array} yColumnTypes
    # @param {String} yColumnType
    # @return {Boolean}
    isDiagramPossible: (xColumnTypes, yColumnTypes, diagramType) ->
        vidatio.log.info "HelperService isDiagramPossible called"
        vidatio.log.debug
            xColumnTypes: xColumnTypes
            yColumnTypes: yColumnTypes
            diagramType: diagramType

        if not xColumnTypes? or not yColumnTypes?
            return false

        switch diagramType
            when "scatter"
                if "numeric" not in yColumnTypes or "numeric" not in xColumnTypes
                    return false
            when "map"
                break
            when "parallel"
                break

            when "bar"
                if "numeric" not in yColumnTypes
                    return false

            when "timeseries"
                if "date" not in xColumnTypes or "numeric" not in yColumnTypes
                    return false

        return true

# the input-field width automatically resizes according to a users' input
$.fn.textWidth = (text, font) ->
    if !$.fn.textWidth.fakeEl
        $.fn.textWidth.fakeEl = $("<span>").hide().appendTo(document.body)
    $.fn.textWidth.fakeEl.text(text or @val() or @text()).css "font", font or @css("font")
    $.fn.textWidth.fakeEl.width()
