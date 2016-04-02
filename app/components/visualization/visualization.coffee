"use strict"

class window.vidatio.Visualization

    # @method constructor
    constructor: (@dataset, @color = "#11DDC6", @width, @height, @containerSelector = "#chart") ->

    # @method remove
    remove: ->
        $(@containerSelector).empty()

    # @method preProcess
    # @param {Object} options
    #   @param {String} type
    #   @param {Integer} xColumn
    #   @param {Integer} yColumn
    #   @param {Object} headers
    #       @param {String} headers
    #       @param {String} headers
    preProcess: (options) ->
        { type, xColumn, yColumn, headers } = options
        @chartData = vidatio.helper.transformToArrayOfObjects @dataset, xColumn, yColumn, type, headers, @color

