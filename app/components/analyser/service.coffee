class Analyser
    constructor: ->
        $log.info "Analyser constructor called"

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        $log.info "Analyser getSchema called"

    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        $log.info "Analyser getRanks called"

    # @method getRecommendedDiagram
    # @public
    # @param {Array} schema of the dataset
    # @param {Array} variances each column
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the id of the column for the x value,
    #   the id of the column for the y value
    getRecommendedDiagram: (schema, variances) ->
        $log.info "Analyser getRecommendedDiagram called"
        $log.debug
            schema: schema
            variances: variances



