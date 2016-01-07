"use strict"

class window.vidatio.Visualization

    constructor: (@dataset, @chart) ->
        console.log "Visualization constructor called"

    getChart: ->
        console.log "Visualization getChart called"
        return @chart
