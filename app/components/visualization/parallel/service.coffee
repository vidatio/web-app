"use strict"

class vidatio.ParallelCoordinates extends vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "ParallelCoordinates constructor called"
        vidatio.log.debug
            dataset: dataset
            width: width
            height: height
            options: options
            chartSelector: chartSelector

        super dataset, options.color, width, height, chartSelector
        @remove()
        @preProcess options

        setTimeout =>
            $(@containerSelector).addClass "parcoords"
            d3.parcoords()(@containerSelector)
            .data(@chartData)
            .color(@color)
            .width(@width)
            .height(@height)
            .render()
            .ticks(3)
            .createAxes()

            $svg = $("#{@containerSelector} svg")
            fontOptions = "font-family: 'Helvetica Neue'; font-weight: normal;"

            $svg.find(".dimension .axis").each (index, element) ->
                label = $(element).find(".label")
                label.attr "transform", "translate(0, -8) rotate(0)"
                label.attr "style", "font-size: 11px;" + fontOptions

            $svg.find(".dimension:first-child .tick").each (index, element) ->
                text = $(element).find("text")
                text.attr "style", "text-anchor: end; font-size: 12px;" + fontOptions

            $svg.find(".dimension:not(:first-child) .tick").each (index, element) ->
                text = $(element).find("text")
                text.attr "x", Math.abs(Number(text.attr("x")))
                text.attr "style", "text-anchor: start; font-size: 12px;" + fontOptions

                line = $(element).find("line")
                line.attr "x2", Math.abs(Number(line.attr("x2")))

        , 100
