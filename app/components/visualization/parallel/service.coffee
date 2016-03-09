"use strict"

class vidatio.ParallelCoordinates extends vidatio.Visualization
    constructor: (dataset, options) ->
        vidatio.log.info "ParallelCoordinates constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options

        @remove()
        super dataset, options.color
        @preProcess options

        setTimeout =>
            $chart = $("#chart")

            width = $chart.parent().width()
            height = $chart.parent().height() - 60
            $chart.addClass "parcoords"

            d3.parcoords()("#chart")
            .data(@chartData)
            .color(@color)
            .width(width)
            .height(height)
            .render()
            .ticks(3)
            .createAxes()
        , 0

    # we overwrite the parent preProcess method
    preProcess: (options) =>
        vidatio.log.info "ParallelCoordinates preprocess called"
        vidatio.log.debug
            options: options

        # Parallel coordinate chart needs the columns as rows and the values in x direction need to be first
        transposedDataset = vidatio.helper.transposeDataset @dataset
        chartData = vidatio.helper.subsetWithXColumnFirst transposedDataset, options.xColumn, options.yColumn
        @chartData = vidatio.helper.transposeDataset chartData
