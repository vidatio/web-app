"use strict"

class window.vidatio.Recommender
    constructor: ->
        vidatio.log.info "Recommender constructor called"
        @recommendedDiagram = null
        @thresholdPC = 500
        @thresholdBar = 10

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        vidatio.log.info "Recommender getSchema called"
        vidatio.log.debug JSON.stringify
            dataset: dataset

        schema = []

        dataset.forEach (column) =>
            schema.push @getColumnType column

        return schema

    # @method getColumnType
    # @public
    # @param {Array} column
    # @return {Array} type, types of the column
    getColumnType: (column) ->
        type = []

        if vidatio.helper.isCoordinateColumn column
            type.push "coordinate"
        if vidatio.helper.isDateColumn column
            type.push "date"
        if vidatio.helper.isNominalColumn column
            type.push "nominal"
        if vidatio.helper.isNumericColumn column
            type.push "numeric"

        return type

    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        vidatio.log.info "Recommender getVariances called"
        vidatio.log.debug JSON.stringify
            dataset: dataset

        variances = []

        dataset.forEach (column, idx, array) ->
            differentValues = {}
            column.forEach (cell, idx, array) ->
                differentValues[cell] = true

            count = 0
            for own key of differentValues
                count++

            variances.push count / column.length

        return variances

    # @method run
    # @public
    # @param {Array} dataset
    # @param {Array} header
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the index of the column for the x value,
    #   the index of the column for the y value
    # OR {error} Message with occurred error
    run: (dataset = [], header = []) ->
        vidatio.log.info "Recommender run called"
        vidatio.log.debug
            dataset: dataset
            header: header

        if dataset.length < 1 or dataset[0].length < 2
            message = "not enough dimensions"
            return {error: message}

        xIndex = null
        yIndex = null
        xVariance = null
        yVariance = null
        nominalIdx = null
        @recommendedDiagram = null

        # We can recognize geo datasets via headers
        # Se we first check the header
        coordinateIndices = vidatio.geoParser.checkHeader(header)
        if coordinateIndices.hasOwnProperty("x") and coordinateIndices.hasOwnProperty("y")
            xIndex = coordinateIndices.x
            yIndex = coordinateIndices.y
            @recommendedDiagram = "map"

        # For other datasets and geo datasets without headers
        # We classify the columns the the content
        else
            subset = vidatio.helper.getSubset dataset
            transposedDataset = vidatio.helper.transposeDataset subset

            schema = @getSchema(transposedDataset)
            variances = @getVariances(transposedDataset)

            for variance, index in variances
                if variance > xVariance

                    if xIndex?
                        yIndex = xIndex
                        yVariance = xVariance

                    xIndex = index
                    xVariance = variance

                else if variance > yVariance
                    yIndex = index
                    yVariance = variance

            nominalIdx = xIndex if "nominal" in schema[xIndex]
            nominalIdx = yIndex if "nominal" in schema[yIndex]

            uniqueNominals = {}
            for row in dataset
                if row[nominalIdx] in uniqueNominals
                    continue

                uniqueNominals[row[nominalIdx]] = true

                numberOfNominals = Object.keys(uniqueNominals).length
                if numberOfNominals > @thresholdBar
                    break

            # After checking the header or/and classify the columns
            # we have to decide which diagram type we want to recommend
            if ("numeric" in schema[xIndex] and "numeric" in schema[yIndex]) or ("nominal" in schema[xIndex] and "nominal" in schema[yIndex])
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else
                    @recommendedDiagram = "scatter"

            if "nominal" in schema[xIndex] and "numeric" in schema[yIndex]
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else if numberOfNominals > @thresholdBar
                    @recommendedDiagram = "scatter"
                else
                    @recommendedDiagram = "bar"

            if "numeric" in schema[xIndex] and "nominal" in schema[yIndex]
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else if numberOfNominals > @thresholdBar
                    @recommendedDiagram = "scatter"
                else
                    @recommendedDiagram = "bar"

                tmp = xIndex
                xIndex = yIndex
                yIndex = tmp

            if "date" in schema[xIndex] and "numeric" in schema[yIndex]
                @recommendedDiagram = "timeseries"

            if "numeric" in schema[xIndex] and "date" in schema[yIndex]
                @recommendedDiagram = "timeseries"
                tmp = xIndex
                xIndex = yIndex
                yIndex = tmp

            if @recommendedDiagram is null
                if schema[xIndex] > 0 and schema[xIndex] > 0 and dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else
                    @recommendedDiagram = "scatter"

        result =
            type: @recommendedDiagram
            xColumn: xIndex
            yColumn: yIndex
