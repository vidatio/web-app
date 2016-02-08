"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset

        # TODO: Add something like this
        # http://stackoverflow.com/questions/23044338/window-resize-directive

        setTimeout( ->
            chart = c3.generate
                bindto: "#chart"
                data:
                    xs:
                        "A": "A_x"
                    columns: dataset,
                    type: "scatter"
                padding:
                    right: 30

            super(dataset, chart)
        , 500)
