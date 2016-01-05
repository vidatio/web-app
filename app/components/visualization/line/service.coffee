"use strict"

app = angular.module "app.services"

app.service "LineChartService", [
    "$log"
    "$timeout"
    ($log, $timeout) ->
        class LineChart
            constructor: (@dataset) ->
                $log.info "LineChartService constructor called"

                ###
                columns: [
                    ["data1", 30, 200, 100, 400, 150, 250]
                    ["data2", 130, 100, 140, 200, 150, 50]
                ]
                ###

                $timeout =>
                    @chart = c3.generate
                        bindto: "#chart"
                        data:
                            columns: @dataset,
                        padding:
                            right: 30

            getChart: ->
                return @chart
]
