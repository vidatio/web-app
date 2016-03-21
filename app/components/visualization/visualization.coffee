"use strict"

class window.vidatio.Visualization

    constructor: (@dataset, @color = "#11DDC6", @width, @height) ->
        vidatio.log.info "Visualization constructor called"
        vidatio.log.debug
            dataset: @dataset
            color: @color
            width: @width
            height: @height

    remove: ->
        vidatio.log.info "Visualization remove called"
        $("#chart").empty()

    # @method preProcess
    # @param {Object} options
    #   @param {String} type
    #   @param {Integer} xColumn
    #   @param {Integer} yColumn
    #   @param {Object} headers
    #       @param {String} headers
    #       @param {String} headers
    preProcess: (options) ->
        vidatio.log.info "Visualization preprocess called"
        vidatio.log.debug
            options: options
        { type, xColumn, yColumn, headers } = options
        @chartData = vidatio.helper.transformToArrayOfObjects @dataset, xColumn, yColumn, type, headers, @color

