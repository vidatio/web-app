"use strict"

class vidatio.TimeseriesChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset

        # handle different date formats and parse them for c3.js charts
        for element in dataset
            tmp = moment(element.x, ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")
            element["date"] = tmp

        setTimeout(->
            vidatio.log.info "Timeseries chart generation called"

            chart = d3plus.viz()
                .container("#chart")
                .data(dataset)
                .type("line")
                .id("name")
                .text("name")
                .y("y")
                .x("date")
#                .time("YYYY-MM-DD")
                .draw()

            super(dataset, chart)
        , 500)
