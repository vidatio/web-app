"use strict"

class window.vidatio.Visualization

    constructor: (@dataset, @chart) ->
        vidatio.log.info "Visualization constructor called"
        vidatio.log.debug
            dataset: @dataset
            chart: @chart

    getChart: ->
        vidatio.log.info "Visualization getChart called"
        return @chart

    # TODO: Implement Data-binding
    updateDataset: (dataset) ->
        $log.info "Visualization updateDataset called"
        @dataset = dataset
