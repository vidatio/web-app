"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "Barchart constructor called"
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
            d3plus
            .viz()
            .container(@containerSelector)
            .data(@chartData)
            .type("bar")
            .id("id")
            .text("name")
            .x(options.headers["x"])
            .y(options.headers["y"])
            .color("color")
            .width(@width)
            .height(@height)
            .format
                "text": (text, key) ->
                    key.locale.error = window.d3PlusTranslations.error
                    return text
            .draw()
        , 100
