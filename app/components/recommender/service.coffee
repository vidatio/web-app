"use strict"

class window.vidatio.Recommender
    constructor: ->
        vidatio.log.info "Recommender constructor called"
        @recommendedDiagram = null
        @types = ["numeric", "nominal", "unknown", "coordinate", "date"]

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        vidatio.log.info "Recommender getSchema called"
        vidatio.log.debug
            dataset: dataset

        schema = []

        dataset.forEach (column) =>
            if vidatio.helper.isCoordinateColumn column
                schema.push @types[3]
            else if vidatio.helper.isDateColumn column
                schema.push @types[4]
            else if vidatio.helper.isNumericColumn column
                schema.push @types[0]
            else if vidatio.helper.isNominalColumn column
                schema.push @types[1]
            else
                schema.push @types[2]

        return schema

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
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the index of the column for the x value,
    #   the index of the column for the y value
    run: (dataset = []) ->
        vidatio.log.info "Recommender getRecommendedDiagram called"
        vidatio.log.debug
            dataset: dataset

        xIndex = null
        yIndex = null
        @recommendedDiagram = null

        xVariance = 0
        yVariance = 0

        transposedDataset = vidatio.helper.transposeDataset(dataset)

        schema = @getSchema(transposedDataset)
        variances = @getVariances(transposedDataset)

        for variance, index in variances
            if variance > xVariance
                xIndex = index
                xVariance = variance

            else if variance > yVariance
                yIndex = index
                yVariance = variance

        type = schema[xIndex] + " " + schema[yIndex]
        switch type
            when "numeric numeric" then @recommendedDiagram = "scatter"
            when "nominal numeric" then @recommendedDiagram = "scatter"
            # "numeric nominal" --> if distinct dataset  --> bar else scatter
            when "numeric nominal" then @recommendedDiagram = "scatter"
            # "nominal nominal" --> if length of dataset > X --> parallel coordinates else scatter
            when "nominal nominal" then @recommendedDiagram = "scatter"
            when "coordinate coordinate" then @recommendedDiagram = "map"

        return {
            recommendedDiagram: @recommendedDiagram
            xColumn: xIndex
            yColumn: yIndex
        }
