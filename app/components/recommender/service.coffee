class Recommender
    constructor: ->
        $log.info "Recommender constructor called"

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        $log.info "Recommender getSchema called"

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
