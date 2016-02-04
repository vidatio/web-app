"use strict"

class vidatio.LineChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "LineChart constructor called"

        setTimeout( ->
            vidatio.log.info "LineChart generation called"

            chart = c3.generate
                bindto: "#chart"
                data:
                    x: "x"
                    columns: dataset
                axis:
                    x:
                        type: "timeseries",
                        tick:
                            format: "%Y-%m-%d"
                padding:
                    right: 30
                size:
                    width: $("#chart").parent().width()

            super(dataset, chart)
        , 500)
