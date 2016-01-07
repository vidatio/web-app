"use strict"

class vidatio.LineChart extends vidatio.Visualization
    constructor: (dataset) ->
        console.log "LineChart constructor called"

        # dataset = [
        #     ['data1', 30, 200, 100, 400, 150, 250]
        #     ['data2', 130, 100, 140, 200, 150, 50]
        # ]

        $ ->
            chart = c3.generate
                bindto: "#chart"
                data:
                    columns: dataset
                padding:
                    right: 30
                size:
                    width: $("#chart").parent().width()

            super(dataset, chart)
