"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        super dataset
        @preProcess options

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container("#chart")
            .data(@chartData)
            .type("scatter")
            .id("name")
            .x("x")
            .y("y")
            .size(10)
            .draw()
        , 0
