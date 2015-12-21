class Recommender
    constructor: ->
        console.info "Recommender constructor called"

        @types = [ "quantitative", "nominal", "ordinal" ]

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        console.info "Recommender getSchema called"
        console.log
            dataset: dataset

        schema = []
        columns = []

        dataset.forEach (row, i, dataset) ->
            row.forEach (cell, j, row) ->
                if(columns[j])
                    columns[j].push(cell)
                else
                    columns.push([])

        columns.forEach (column) =>
            console.log(column)
            if(@isNumeric(column))
                schema.push("numeric")
            else if @isNominal(column)
                schema.push("nominal")
            else
                schema.push("unknown")

        return schema

    # @method isNumeric
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells numeric?
    isNumeric: (column) ->
        for key, value of column
            console.log(typeof value)
            console.log(value is not isFinite(value))
            if typeof parseFloat(value) is not "number" || value is not isFinite(value)
                return false
        return true

    # @method isNominal
    # @public
    # @param {Array} column with all cells
    # @return {Boolean} are all cells strings?
    isNominal: (column) ->
        for key, value of column
            if typeof value is not "string"
                return false
        return true

    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        console.info "Recommender getVariances called"

    # @method getRecommendedDiagram
    # @public
    # @param {Array} dataset
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the id of the column for the x value,
    #   the id of the column for the y value
    getRecommendedDiagram: (dataset) ->
        console.info "Recommender getRecommendedDiagram called"
        console.log
            schema: schema
            variances: variances

        schema = @getSchema(dataset)
        variances = @getVariances(dataset)
