"use strict"

class vidatio.TimeseriesChart extends vidatio.Visualization
    constructor: (dataset, options, width, height) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height

        @remove()
        super dataset, options.color, width, height
        @preProcess options

        # handle different date formats and parse them for c3.js charts
        for element in @chartData
            element[options.headers["x"]] = moment(element[options.headers["x"]], ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container("#chart")
            .data(@chartData)
            .type("line")
            .id("name")
            .text("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .color("color")
            .width(@width)
            .height(@height)
            .draw()
        , 100
