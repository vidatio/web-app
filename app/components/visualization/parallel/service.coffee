"use strict"

app = angular.module "app.services"

app.service "ParallelCoordinatesService", [
    "$log"
    "$timeout"
    ($log, $timeout) ->
        class ParallelCoordinates
            constructor: (@dataset) ->
                $log.info "ParallelCoordinatesService constructor called"

                dataset = [
                    [0,-0,0,0,0,3 ]
                    [1,-1,1,2,1,6 ]
                    [2,-2,4,4,0.5,2]
                    [3,-3,9,6,0.33,4]
                    [4,-4,16,8,0.25,9]
                ]

                $chart = $("#chart")
                $content = $(".content").first()
                $chart.addClass("parcoords")

                width = $content.width()
                height = $content.height()

                @chart = d3.parcoords()("#chart").data(dataset)
                @chart.width(300).height(200).render().render().ticks(3).createAxes()

            getChart: ->
                return @chart
]
