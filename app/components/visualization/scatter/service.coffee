"use strict"

class window.vidatio.ScatterPlot extends window.vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "ScatterPlot constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height
            chartSelector: chartSelector

        super dataset, options.color, width, height, chartSelector
        @remove()
        @preProcess options

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
            .type("scatter")
            .id("id")
            .text("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .size(10)
            .color("color")
            .width(@width)
            .height(@height)
            .draw()
        , 100
