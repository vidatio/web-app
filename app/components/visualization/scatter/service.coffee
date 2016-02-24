"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset

        # TODO: Add something like this
        # http://stackoverflow.com/questions/23044338/window-resize-directive

        sample_data = [
            {
                'value': 100
                'weight': .45
                'type': 'alpha'
            }
            {
                'value': 70
                'weight': .60
                'type': 'beta'
            }
            {
                'value': 40
                'weight': -.2
                'type': 'gamma'
            }
            {
                'value': 15
                'weight': .1
                'type': 'delta'
            }
        ]

        setTimeout( ->
            chart = d3plus.viz()
                .container("#chart")
                .data(sample_data)
                .type("scatter")
                .id("type")
                .x("value")
                .y("weight")
                .draw()

            super(dataset, chart)
        , 500)
