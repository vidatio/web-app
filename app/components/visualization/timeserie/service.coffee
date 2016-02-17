"use strict"

class vidatio.TimeseriesChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset

        # handle different date formats and parse them for c3.js charts
        for date, index in dataset[0]
            if index != 0
                tmp = moment(date, ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")
                dataset[0][index] = tmp

        setTimeout(->
            vidatio.log.info "Timeseries chart generation called"

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

            super(dataset, chart)
        , 500)
