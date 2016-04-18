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
