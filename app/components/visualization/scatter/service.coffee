"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ScatterPlot constructor called"

        # dataset = [
        #     ['data1', 30, 200, 100, 400, 150, 250]
        #     ['data2', 130, 100, 140, 200, 150, 50]
        # ]

        $ ->
            chart = c3.generate
                bindto: "#chart"
                data:
                    xs:
                        "setosa": "setosa_x"
                        "versicolor": "versicolor_x"
                    columns: dataset,
                    type: "scatter"
                padding:
                    right: 30
                size:
                    width: $("#chart").parent().width()

            super(dataset, chart)
