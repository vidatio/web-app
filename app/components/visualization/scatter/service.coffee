"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset

        # TODO: Add something like this
        # http://stackoverflow.com/questions/23044338/window-resize-directive

        setTimeout( ->
            chart = d3plus.viz()
                .container("#chart")
                .data(dataset)
                .type("scatter")
                .id("name")
                .x("x")
                .y("y")
                .size(10)
                .draw()

            super(dataset, chart)
        , 500)
