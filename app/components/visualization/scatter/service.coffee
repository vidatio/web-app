"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset, options, width, height) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height

        @remove()
        super dataset, options.color, width, height
        @preProcess options

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container("#chart")
            .data(@chartData)
            .type("scatter")
            .id("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .size(10)
            .color("color")
            .width(@width)
            .height(@height)
            .draw()
        , 100
