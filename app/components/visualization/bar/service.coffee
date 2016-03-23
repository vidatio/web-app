"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "Barchart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height
            chartSelector: chartSelector

        @remove()
        super dataset, options.color, width, height, chartSelector
        @preProcess options

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus
            .viz()
            .container(@containerSelector)
            .data(@chartData)
            .type("bar")
            .id("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .color("color")
            .width(@width)
            .height(@height)
            .draw()
        , 100

