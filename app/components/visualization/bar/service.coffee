"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Barchart constructor called"

        setTimeout( ->
            chart = d3plus
                .viz()
                .container("#chart")
                .data(dataset)
                .type("bar")
                .id("name")
                .x("x")
                .y("y")
                .draw()

            super(dataset, chart)
        , 500)
