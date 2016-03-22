"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        super dataset, options.color
        @preProcess options

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container(@containerSelector)
            .data(@chartData)
            .type("scatter")
            .id("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .size(10)
            .color("color")
            .draw()
        , 0
