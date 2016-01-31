"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset

        $ ->
            chart = c3.generate
                bindto: "#chart"
                data:
                    xs:
                        "A": "A_x"
                    columns: dataset,
                    type: "scatter"
                padding:
                    right: 30
                size:
                    width: $("#chart").parent().width()

            super(dataset, chart)
