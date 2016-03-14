"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "Barchart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        @remove
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
            .type("bar")
            .id("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .color("color")
            .width(width)
            .height(height)
            .draw()
        , 0

