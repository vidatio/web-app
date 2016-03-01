"use strict"

class vidatio.TimeseriesChart extends vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        super dataset
        @preProcess options

        # handle different date formats and parse them for c3.js charts
        for element in @chartData
            element["date"] = moment(element.x, ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container("#chart")
            .data(@chartData)
            .type("line")
            .id("name")
            .text("name")
            .y("y")
            .x("date")
            .draw()
        , 0
