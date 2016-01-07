"use strict"

class vidatio.ParallelCoordinates extends vidatio.Visualization
    constructor: (dataset) ->
        console.log "ParallelCoordinates constructor called"

        dataset = [
            [0,-0,0,0,0,3 ]
            [1,-1,1,2,1,6 ]
            [2,-2,4,4,0.5,2]
            [3,-3,9,6,0.33,4]
            [4,-4,16,8,0.25,9]
        ]

        $ ->
            $chart = $("#chart")

            width = $chart.parent().width()
            height = $chart.parent().height()
            $chart.addClass "parcoords"

            chart = d3.parcoords()("#chart").data(dataset)
            chart.width(width).height(height).render().render().ticks(3).createAxes()

            super(dataset, chart)
