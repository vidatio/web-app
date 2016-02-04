"use strict"

class vidatio.ParallelCoordinates extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "ParallelCoordinates constructor called"

        setTimeout( ->
            $chart = $("#chart")

            width = $chart.parent().width()
            height = $chart.parent().height()
            $chart.addClass "parcoords"

            chart = d3.parcoords()("#chart").data(dataset)
            chart.width(width).height(height).render().render().ticks(3).createAxes()

            super(dataset, chart)
        , 500)
