"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        @remove()
        super dataset, options.color
        @preProcess options

        # we need to wait for angular to finish rendering
        setTimeout =>
            $chart = $("#chart")

            width = $chart.parent().width()
            height = $chart.parent().height() - 40

            d3plus.viz()
            .container("#chart")
            .data(@chartData)
            .type("scatter")
            .id("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .size(10)
            .color("color")
            .width(width)
            .height(height)
            .draw()
        , 0
