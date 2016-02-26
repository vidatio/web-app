"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Barchart constructor called"

        # for the simple barchart dataset the x and y columns are switched (nominal on y axis and ordinal on x axis)
        # TODO: After transposing the dataset x and y are in the wrong order. Needs to be refactored.
        setTimeout( ->
            chart = d3plus
                .viz()
                .container("#chart")
                .data(dataset)
                .type("bar")
                .id("name")
                .x("y")
                .y("x")
                .draw()

            super(dataset, chart)
        , 500)
