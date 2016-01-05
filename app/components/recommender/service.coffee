"use strict"

class Recommender
    constructor: ->
        console.info "Recommender constructor called"
        @types = ["numeric", "nominal", "unknown", "coordinate", "date"]

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        console.info "Recommender getSchema called"
        console.log
            dataset: dataset

        schema = []

        dataset.forEach (column) =>
            if Helper.isCoordinateColumn column
                schema.push @types[3]
            else if Helper.isDateColumn column
                schema.push @types[4]
            else if Helper.isNumericColumn column
                schema.push @types[0]
            else if Helper.isNominalColumn column
                schema.push @types[1]
            else
                schema.push @types[2]

        return schema

    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        console.info "Recommender getVariances called"
        console.log JSON.stringify
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

    # @method getRecommendedDiagram
    # @public
    # @param {Array} dataset
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the index of the column for the x value,
    #   the index of the column for the y value
    getRecommendedDiagram: (dataset = []) ->
        console.info "Recommender getRecommendedDiagram called"
        console.log
            schema: schema
            variances: variances

        xIndex = null
        yIndex = null
        recommendedDiagram = null

        xVariance = 0
        yVariance = 0

        rotatedDataset = Helper.rotateDataset(dataset)

        schema = @getSchema(rotatedDataset)
        variances = @getVariances(rotatedDataset)

        for variance, index in variances
            if variance > xVariance
                xIndex = index
                xVariance = variance

            else if variance > yVariance
                yIndex = index
                yVariance = variance

        type = schema[xIndex] + " " + schema[yIndex]
        console.log type
        switch type
            when "numeric numeric" then recommendedDiagram = "scatter"
            when "nominal numeric" then recommendedDiagram = "scatter"
            # "numeric nominal" --> if distinct dataset  --> bar else scatter
            when "numeric nominal" then recommendedDiagram = "scatter"
            # "nominal nominal" --> if length of dataset > X --> parallel coordinates else scatter
            when "nominal nominal" then recommendedDiagram = "scatter"
            when "unknown unknown" then recommendedDiagram = undefined
            else recommendedDiagram = "scatter"

        return {
            recommendedDiagram: recommendedDiagram
            xColumn: xIndex
            yColumn: yIndex
        }

window.Recommender = new Recommender()
