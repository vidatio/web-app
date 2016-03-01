"use strict"

class window.vidatio.Visualization

    constructor: (@dataset) ->
        vidatio.log.info "Visualization constructor called"
        vidatio.log.debug
            dataset: @dataset

    remove: ->
        vidatio.log.info "Visualization remove called"
        $("#chart").empty()

    preProcess: (options) ->
        vidatio.log.info "Visualization preprocess called"
        vidatio.log.debug
            options: options
        { type, xColumn, yColumn, headers } = options
        @chartData = vidatio.helper.transformToArrayOfObjects @dataset, xColumn, yColumn, type, headers

