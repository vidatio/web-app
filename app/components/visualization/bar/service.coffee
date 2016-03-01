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

            super(dataset, @chart)
        , 500)

    updateDataset: (dataset) ->
        vidatio.log.info "Barchart updateDataset called"
        vidatio.log.debug
            dataset: dataset

        @chart.load
            columns: dataset
