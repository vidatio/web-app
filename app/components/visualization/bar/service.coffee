"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Barchart constructor called"

        $ ->
            chart = c3.generate
                bindto: "#chart"
                data:
                    columns: dataset,
                    type: "bar"
                bar: width: ratio: 0.5
                padding:
                    right: 30
                size:
                    width: $("#chart").parent().width()

            super(dataset, chart)
