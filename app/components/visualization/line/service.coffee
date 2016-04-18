"use strict"

class vidatio.LineChart extends vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height
            chartSelector: chartSelector

        super dataset, options.color, width, height, chartSelector
        @remove()
        @preProcess options

        # handle different date formats and parse them for c3.js charts
        for element in @chartData
            if vidatio.helper.isDate(element[options.headers["x"]])
                element[options.headers["x"]] = moment(element[options.headers["x"]], ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")

        # we need to wait for angular to finish rendering
        setTimeout =>
            d3plus.viz()
            .container(@containerSelector)
            .format
                "text": (text, key) ->
                    key.locale.message = window.vidatio.d3PlusTranslations.message
                    key.locale.error = window.vidatio.d3PlusTranslations.error
                    return text
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
