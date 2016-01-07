"use strict"

class window.vidatio.Visualization

    constructor: (@dataset, @chart) ->
        console.log "visualization constructor"

    getChart: ->
        console.log "visualization getChart"
        return @chart
