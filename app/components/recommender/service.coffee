class Recommender
    constructor: ->
        console.info "Recommender constructor called"
        @types = ["numeric", "nominal", "unknown"]

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
            if @isNumeric column
                schema.push @types[0]
            else if @isNominal column
                schema.push @types[1]
            else
                schema.push @types[2]

        return schema

    # @method isNumeric
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells numeric?
    isNumeric: (column) ->
        for key, value of column
            if not isFinite value
                return false
        return true

    # @method isNominal
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells strings?
    isNominal: (column) ->
        for key, value of column
            if isFinite value
                return false
        return true

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

    # @method rotateDataset
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} dataset but rows are now columns and vice versa
    rotateDataset: (dataset) ->
        console.info "Recommender rotateDataset called"
        console.log
            dataset: dataset

        rotatedDataset = []

        dataset.forEach (row, i, dataset) ->
            row.forEach (cell, j, row) ->
                if not rotatedDataset[j]
                    rotatedDataset.push []
                rotatedDataset[j].push cell

        return rotatedDataset

    # @method getRecommendedDiagram
    # @public
    # @param {Array} dataset
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the index of the column for the x value,
    #   the index of the column for the y value
    getRecommendedDiagram: (dataset) ->
        console.info "Recommender getRecommendedDiagram called"
        console.log
            schema: schema
            variances: variances
        xIndex = null
        yIndex = null
        recommendedDiagram = null

        xVariance = 0
        yVariance = 0

        rotatedDataset = @rotateDataset(dataset)

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
        switch type
            when "numeric numeric" then recommendedDiagram = "scatter"
            when "nominal numeric" then recommendedDiagram = "scatter"
            when "numeric nominal" then recommendedDiagram = "scatter"
            when "nominal nominal" then recommendedDiagram = "scatter"

        return {
        recommendedDiagram: recommendedDiagram
        xColumn: xIndex
        yColumn: yIndex
        }
