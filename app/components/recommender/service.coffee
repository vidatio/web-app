class Recommender
    constructor: ->
        $log.info "Recommender constructor called"

        @types = [ "quantitative", "nominal", "ordinal" ]

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        $log.info "Recommender getSchema called"

    isNumeric: (column) ->
        for key, value of column
            if typeof parseFloat(value) is not "number" || value is not isFinite(value)
                return false

        return true

    isNominal: (column) ->
        for key, value of column
            if typeof value is not "string"
                return false

        return true

    isOrdinal: (column) ->


    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        $log.info "Recommender getRanks called"


    # @method getRecommendedDiagram
    # @public
    # @param {Array} dataset
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the id of the column for the x value,
    #   the id of the column for the y value
    getRecommendedDiagram: (dataset) ->
        $log.info "Recommender getRecommendedDiagram called"
        $log.debug
            schema: schema
            variances: variances

        schema = @getSchema(dataset)
        variances = @getVariances(dataset)
