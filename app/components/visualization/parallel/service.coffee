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
            parcoordsData = [{"test" : @chartData[0][0], "aber": @chartData[0][1]}]
            $(@containerSelector).addClass "parcoords"
            d3.parcoords()(@containerSelector)
            .data(parcoordsData)
            .color(@color)
            .width(@width)
            .height(@height)
            .render()
            .ticks(3)
            .createAxes()

            $svg = $("#{@containerSelector} svg")
            $svg.find(".dimension:not(:first-child) .tick").each (index, element) ->
                text = $(element).find("text")
                text.attr "x", Math.abs(Number(text.attr("x")))
                text.attr "style", "text-anchor: start;"

                line = $(element).find("line")
                line.attr "x2", Math.abs(Number(line.attr("x2")))

        , 100

    # we overwrite the parent preProcess method
    preProcess: (options) =>
        vidatio.log.info "ParallelCoordinates preprocess called"
        vidatio.log.debug
            options: options

        # Parallel coordinate chart needs the columns as rows and the values in x direction need to be first
        transposedDataset = vidatio.helper.transposeDataset @dataset
        chartData = vidatio.helper.subsetWithXColumnFirst transposedDataset, options.xColumn, options.yColumn
        @chartData = vidatio.helper.transposeDataset chartData
